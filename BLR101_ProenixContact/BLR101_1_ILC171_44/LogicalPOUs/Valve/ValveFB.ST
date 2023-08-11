(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Valve
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ValveFB

(*Group:Default*)


VAR
    Fb_Alrm_Tmr :	TON;
END_VAR


VAR_IN_OUT
    Vlv_strct :	Vlv;
END_VAR


VAR
    AlrmNotMove :	BOOL;
    AlrmSQ :	BOOL;
    RunManual :	BOOL;
    RunAuto :	BOOL;
    COM_Open :	BOOL;
    COM_Close :	BOOL;
END_VAR


VAR_INPUT
    SetOvertime :	TIME;
    Cycle :	Cycle;
END_VAR


VAR
    NotMove_Alrm_Tmr :	TON;
    AlrmFeedBack :	BOOL;
    AlarmBlock :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ValveFB
IEC_LANGUAGE: ST
*)
    (*Alarm processing*)
Fb_Alrm_Tmr(IN:=Vlv_strct.CW.Enable and (COM_Close or COM_Open) and not
    Vlv_strct.SW.RUN, PT:=t#3s);

NotMove_Alrm_Tmr(IN:=Vlv_strct.CW.Enable and
    ((COM_Close and not Vlv_strct.SW.Closed) or
    (COM_Open and not Vlv_strct.SW.Opened)),PT:=SetOvertime);

if Fb_Alrm_Tmr.Q then
    AlrmFeedBack:=true;
end_if;

if NotMove_Alrm_Tmr.Q then 
    AlrmNotMove:=true;
end_if;

if (not Vlv_strct.CW.ExtraEn and (Vlv_strct.SW.COM_Open or Vlv_strct.SW.COM_Close)) then
    AlarmBlock:= true;
end_if;

if Vlv_strct.SW.Opened and Vlv_strct.SW.Closed then
    AlrmSQ:=true;
end_if;

if AlrmNotMove or AlrmSQ or AlrmFeedBack or Vlv_strct.CW.ExtraAlarm then
    Vlv_strct.SW.AlarmAccum:=true; 
end_if;

if Vlv_strct.CW.ACK then
    Vlv_strct.SW.AlarmAccum:=false;
    AlrmFeedBack:=false;
    AlrmSQ:=false;
    AlrmnotMove:=false;
    AlarmBlock:= false;
end_if;

    (*Auto/Manual mode selection*)
if Vlv_strct.CW.EnableAuto then
    Vlv_strct.SW.Auto:= true;
end_if;
if Vlv_strct.CW.DisableAuto then
    Vlv_strct.SW.Auto:= false;
end_if;


Vlv_strct.SW.ManOK:=not Vlv_strct.SW.AlarmAccum and Vlv_strct.CW.AuxON and
    Vlv_strct.CW.Enable and not Vlv_strct.SW.Auto;

Vlv_strct.SW.AutoOK:= not Vlv_strct.SW.AlarmAccum and Vlv_strct.CW.AuxON and
    Vlv_strct.CW.Enable and Vlv_strct.SW.Auto and Cycle.SW.Running;


    (*Manual mode activation*)
if Vlv_strct.CW.ManOpen or Vlv_strct.CW.ManClose then
    RunManual:=true;
end_if;

if Vlv_strct.CW.Stop or not Vlv_strct.SW.ManOK then
    RunManual:=false;
end_if;

    (*Auto mode activation*)
RunAuto:= (Cycle.CW.PulseStart or RunAuto) and Vlv_strct.SW.AutoOK and
    Vlv_strct.SW.Auto;

    (*Set command for start*)
COM_Open:=((Vlv_strct.CW.AutoOpen and RunAuto and Vlv_strct.SW.AutoOK) or
    ((Vlv_strct.CW.ManOpen or COM_Open) and RunManual and Vlv_strct.SW.ManOK)) and not
    COM_Close and not Vlv_strct.SW.Opened;

COM_Close:=((Vlv_strct.CW.AutoClose and RunAuto and Vlv_strct.SW.AutoOK) or
    ((Vlv_strct.CW.ManClose or COM_Close) and RunManual and Vlv_strct.SW.ManOK)) and not
    COM_Open and not Vlv_strct.SW.Closed;

Vlv_strct.SW.COM_Open:=COM_Open and not Vlv_strct.CW.SimEn;
Vlv_strct.SW.COM_Close:=COM_Close and not Vlv_strct.CW.SimEn;	


    (*Status processing*)
if Vlv_strct.SW.AlarmAccum then
    Vlv_strct.Status:=word#4;
elsif not Vlv_strct.CW.ExtraEn then
    Vlv_strct.Status:=word#8;
elsif Vlv_strct.SW.Opened then
    Vlv_strct.Status:=word#1;
elsif Vlv_strct.SW.Closed then
    Vlv_strct.Status:=word#2;
else
    Vlv_strct.Status:=word#0;
end_if;

Vlv_strct.CW.EnableAuto:=false;
Vlv_strct.CW.DisableAuto:=false;
Vlv_strct.CW.ManOpen:=false;
Vlv_strct.CW.Stop:=false;
Vlv_strct.CW.ManClose:=false;
Vlv_strct.CW.ACK:=false;

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
