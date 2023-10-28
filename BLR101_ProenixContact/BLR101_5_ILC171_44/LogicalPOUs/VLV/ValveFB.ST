(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: VLV.FB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ValveFB

(*Group:Default*)


VAR
	Fb_Alrm_Tmr :	TON;
END_VAR


VAR_IN_OUT
	Vlv_strct :	VLV;
	Aux_strct :	VLV_MISC;
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
	Cycle :	CCL;
END_VAR


VAR
	NotMove_Alrm_Tmr :	TON;
	AlrmFeedBack :	BOOL;
	AlarmBlock :	BOOL;
END_VAR


VAR_EXTERNAL
	TICK_1S_PLS :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ValveFB
IEC_LANGUAGE: ST
*)

if TICK_1S_PLS and not Aux_strct.AuxFlag then
	Aux_strct.Tick_1S:= true;
end_if;
Aux_strct.AuxFlag:= TICK_1S_PLS;

(*========================================================================================*)
	(*Alarm Feedback processing*)
(*========================================================================================*)
if Vlv_strct.CW.Enable and (Aux_strct.COM_Close or Aux_strct.COM_Open) and not Vlv_strct.SW.RUN then
	if Aux_strct.Tick_1S then
		Aux_strct.FbAlarmTickCount:= Aux_strct.FbAlarmTickCount + 1;
	end_if;
else
	Aux_strct.FbAlarmTickCount:= 0;
end_if;

if Vlv_strct.CW.Enable and ((Aux_strct.COM_Close and not Vlv_strct.SW.Closed) or (Aux_strct.COM_Open and not Vlv_strct.SW.Opened)) then
	if Aux_strct.Tick_1S then
		Aux_strct.MoveAlarmTickCount:= Aux_strct.MoveAlarmTickCount + 1;
	end_if;
else
	Aux_strct.MoveAlarmTickCount:= 0;
end_if;

if Aux_strct.FbAlarmTickCount >= 3 then
	Aux_strct.AlarmFeedBack:= true;
	Aux_strct.FbAlarmTickCount:= 0;
end_if;

if Aux_strct.MoveAlarmTickCount >= Aux_strct.SetOvertime then 
	Aux_strct.AlarmNotMove:= true;
	Aux_strct.MoveAlarmTickCount:= 0;
end_if;

if (not Vlv_strct.CW.ExtraEn and (Aux_strct.COM_Open or Aux_strct.COM_Close)) then
	Aux_strct.AlarmBlock:= true;
end_if;

if Vlv_strct.SW.Opened and Vlv_strct.SW.Closed then
	Aux_strct.AlarmSQ:=true;
end_if;


Vlv_strct.SW.AlarmAccum:= Aux_strct.AlarmNotMove or Aux_strct.AlarmSQ or Aux_strct.AlarmFeedBack or Vlv_strct.CW.ExtraAlarm; 


if Vlv_strct.CW.ACK then
	Vlv_strct.SW.AlarmAccum:=false;
	Aux_strct.AlarmFeedBack:=false;
	Aux_strct.AlarmSQ:=false;
	Aux_strct.AlarmnotMove:=false;
	Aux_strct.AlarmBlock:= false;
end_if;

(*========================================================================================*)
	(*Auto/Manual mode selection*)
(*========================================================================================*)
if Vlv_strct.CW.AutoMode then
	Vlv_strct.SW.ManAuto:= true;
end_if;
if Vlv_strct.CW.ManMode then
	Vlv_strct.SW.ManAuto:= false;
end_if;


Vlv_strct.SW.ManOK:=not Vlv_strct.SW.AlarmAccum and Vlv_strct.CW.AuxON and Vlv_strct.CW.Enable and not Vlv_strct.SW.ManAuto;
Vlv_strct.SW.AutoOK:= not Vlv_strct.SW.AlarmAccum and Vlv_strct.CW.AuxON and Vlv_strct.CW.Enable and Vlv_strct.SW.ManAuto and Cycle.SW.Running;

(*========================================================================================*)
	(*Manual mode activation*)
(*========================================================================================*)
if Vlv_strct.CW.ManOpen or Vlv_strct.CW.ManClose then
	Vlv_strct.SW.RunManual:=true;
end_if;

if Vlv_strct.CW.Stop or not Vlv_strct.SW.ManOK then
	Vlv_strct.SW.RunManual:=false;
end_if;

(*========================================================================================*)
	(*Auto mode activation*)
(*========================================================================================*)
Vlv_strct.SW.RunAuto:= Vlv_strct.SW.AutoOK and Vlv_strct.SW.ManAuto;

(*========================================================================================*)
	(*Set command for start*)
(*========================================================================================*)
Aux_strct.COM_Open:=((Vlv_strct.CW.AutoOpen and Vlv_strct.SW.RunAuto and Vlv_strct.SW.AutoOK) or ((Vlv_strct.CW.ManOpen or Aux_strct.COM_Open) and Vlv_strct.SW.RunManual and Vlv_strct.SW.ManOK)) and not Aux_strct.COM_Close and not Vlv_strct.SW.Opened;
Aux_strct.COM_Close:=((Vlv_strct.CW.AutoClose and Vlv_strct.SW.RunAuto and Vlv_strct.SW.AutoOK) or ((Vlv_strct.CW.ManClose or Aux_strct.COM_Close) and Vlv_strct.SW.RunManual and Vlv_strct.SW.ManOK)) and not Aux_strct.COM_Open and not Vlv_strct.SW.Closed;

Vlv_strct.SW.COM_Open:=Aux_strct.COM_Open and not Vlv_strct.CW.SimEn;
Vlv_strct.SW.COM_Close:=Aux_strct.COM_Close and not Vlv_strct.CW.SimEn;	

(*========================================================================================*)
	(*Status processing*)
(*========================================================================================*)
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

Vlv_strct.CW.AutoMode:=false;
Vlv_strct.CW.ManMode:=false;
Vlv_strct.CW.ManOpen:=false;
Vlv_strct.CW.Stop:=false;
Vlv_strct.CW.ManClose:=false;
Vlv_strct.CW.ACK:=false;
Aux_strct.Tick_1S:= false;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
