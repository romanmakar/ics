(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Motor
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MotorFB

(*Group:Default*)


VAR
    TON_Overtime :	TON;
END_VAR


VAR_IN_OUT
    Mot_strct :	Mot;
END_VAR


VAR
    AlarmFeedback :	BOOL;
    RunManual :	BOOL;
    RunAuto :	BOOL;
    COM :	BOOL;
END_VAR


VAR_INPUT
    Cycle :	Cycle;
    SetOvertime :	TIME;
END_VAR


VAR_OUTPUT
    FreqValue :	REAL;
END_VAR


VAR
    AlarmBlock :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MotorFB
IEC_LANGUAGE: ST
*)
    (*Alarm Feedback processing*)
TON_Overtime(IN:=Mot_strct.CW.Enable and
    (Mot_strct.SW.COM and not Mot_strct.SW.RUN) or
    (not Mot_strct.SW.COM and Mot_strct.SW.RUN),PT:=SetOvertime);

if TON_Overtime.Q then
    AlarmFeedback:=true;
end_if;

if not Mot_strct.CW.ExtraEn and Mot_strct.SW.COM then
    AlarmBlock:= true;
end_if;

if AlarmFeedback or Mot_strct.CW.ExtraAlarm or AlarmBlock then
    Mot_strct.SW.AlarmAccum:= true;
end_if;

if Mot_strct.CW.ACK then
    Mot_strct.SW.AlarmAccum:= false;
    AlarmFeedback:=false;
    AlarmBlock:= false;
end_if;

    
    (*Auto/Manual mode selection*)
if Mot_strct.CW.EnableAuto then 
    Mot_strct.SW.Auto:= true;
elsif Mot_strct.CW.DisableAuto then
    Mot_strct.SW.Auto:= false;
end_if;


Mot_strct.SW.ManOK:= not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON and
    Mot_strct.CW.Enable and not Mot_strct.SW.Auto;

Mot_strct.SW.AutoOK:= not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON and
    Mot_strct.CW.Enable and Mot_strct.SW.Auto and Cycle.SW.Running;


    (*Manual mode activation*)
if Mot_strct.CW.ManStart then
    RunManual:=true;
end_if;
if Mot_strct.CW.ManStop or not Mot_strct.SW.ManOK then
    RunManual:=false;
end_if;

    (*Auto mode activation*)
RunAuto:= (Cycle.CW.PulseStart or RunAuto) and Mot_strct.SW.AutoOK and
    Mot_strct.SW.Auto;

    (*Set command for start*)
COM:=((RunManual and Mot_strct.SW.ManOK) or (RunAuto and Mot_strct.SW.AutoOK and
    Mot_strct.CW.AutoON));

Mot_strct.SW.COM:=COM and not Mot_strct.CW.SimEn;



    (*Frequency limatation*)
if Mot_strct.MaxFreq > 50.0 then
    Mot_strct.MaxFreq:=50.0;
elsif Mot_strct.MaxFreq < 0.0 then
    Mot_strct.MaxFreq:=0.0;
end_if;

if Mot_strct.MinFreq > 50.0 then
    Mot_strct.MinFreq:=50.0;
elsif Mot_strct.MinFreq < 0.0 then
    Mot_strct.MinFreq:=0.0;
end_if;

if Mot_strct.MinFreq > Mot_strct.MaxFreq then
    Mot_strct.MinFreq:=Mot_strct.MaxFreq;
end_if;

if Mot_strct.ManFreq > Mot_strct.MaxFreq then
    Mot_strct.ManFreq:=Mot_strct.MaxFreq;
elsif Mot_strct.ManFreq < Mot_strct.MinFreq then
    Mot_strct.ManFreq:=Mot_strct.MinFreq;
end_if;

if Mot_strct.AutoFreq > Mot_strct.MaxFreq then
    Mot_strct.AutoFreq:=Mot_strct.MaxFreq;
elsif Mot_strct.AutoFreq < Mot_strct.MinFreq then
    Mot_strct.AutoFreq:=Mot_strct.MinFreq;
end_if;

if RunAuto and not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON then
    FreqValue:=Mot_strct.AutoFreq;
elsif not Mot_strct.SW.AlarmAccum and RunManual then
    FreqValue:=Mot_strct.ManFreq;
else
    FreqValue:=0.0;
end_if;

    (*Status processing*)
if Mot_strct.SW.AlarmAccum then													(*Alarm*)
    Mot_strct.Status:=word#2;
elsif not Mot_strct.CW.ExtraEn then												(*Blocking*)
    Mot_strct.Status:=word#4;
elsif Mot_strct.SW.COM then														(*Working*)
    Mot_strct.Status:=word#1;
else																			(*Stoped*)
    Mot_strct.Status:=word#0;
end_if;

Mot_strct.CW.EnableAuto:=false;
Mot_strct.CW.DisableAuto:=false;
Mot_strct.CW.ManStart:=false;
Mot_strct.CW.ManStop:=false;
Mot_strct.CW.ACK:=false;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
