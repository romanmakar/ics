(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MTRS.FB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MotorFB

(*Group:Default*)


VAR_IN_OUT
	Mot_strct :	MTR;
	Aux_strct :	MTR_MISC;
END_VAR


VAR_INPUT
	Cycle :	CCL;
END_VAR


VAR_EXTERNAL
	TICK_1S_PLS :	BOOL;
END_VAR


VAR_OUTPUT
	Event :	MTR_EVENT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MotorFB
IEC_LANGUAGE: ST
*)

if TICK_1S_PLS and not Aux_strct.AuxFlag then
	Aux_strct.Tick_1S:= true;
end_if;
Aux_strct.AuxFlag:= TICK_1S_PLS;

(*========================================================================================*)
	(*Alarm Feedback processing*)
(*========================================================================================*)
if Mot_strct.CW.Enable and ((Aux_strct.COM and not Mot_strct.SW.RUN) or (not Aux_strct.COM and Mot_strct.SW.RUN)) then
	if Aux_strct.Tick_1S then
		Aux_strct.AlrmTickCount:= Aux_strct.AlrmTickCount + 1;
	end_if;
else
	Aux_strct.AlrmTickCount:= 0;
end_if;

if Aux_strct.AlrmTickCount >= Aux_strct.SetOvertime then
	Aux_strct.AlarmFeedback:=true;
	Aux_strct.AlrmTickCount:= 0;
end_if;

if not Mot_strct.CW.ExtraEn and Aux_strct.COM then
	Aux_strct.AlarmBlock:= true;
end_if;

Mot_strct.SW.AlarmAccum:= Aux_strct.AlarmFeedback or Mot_strct.CW.ExtraAlarm or Aux_strct.AlarmBlock;

if Mot_strct.CW.ACK then
	Aux_strct.AlarmFeedback:=false;
	Aux_strct.AlarmBlock:= false;
end_if;

(*========================================================================================*)	
	(*Auto/Manual mode selection*)
(*========================================================================================*)
if Mot_strct.CW.AutoMode then 
	Mot_strct.SW.ManAuto:= true;
elsif Mot_strct.CW.ManMode then
	Mot_strct.SW.ManAuto:= false;
end_if;

Mot_strct.SW.ManOK:= not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON and Mot_strct.CW.Enable and not Mot_strct.SW.ManAuto;
Mot_strct.SW.AutoOK:= not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON and Mot_strct.CW.Enable and Mot_strct.SW.ManAuto;

(*========================================================================================*)
	(*Manual mode activation*)
(*========================================================================================*)

if Mot_strct.CW.ManStop or not Mot_strct.SW.ManOK then
	Mot_strct.SW.RunManual:=false;
elsif Mot_strct.CW.ManStart then
	Mot_strct.SW.RunManual:=true;
end_if;

(*========================================================================================*)
	(*Auto mode activation*)
(*========================================================================================*)
Mot_strct.SW.RunAuto:= Mot_strct.SW.AutoOK and Cycle.SW.Running;

(*========================================================================================*)
	(*Set command for start*)
(*========================================================================================*)
Aux_strct.COM:=((Mot_strct.SW.RunManual and Mot_strct.SW.ManOK) or (Mot_strct.SW.RunAuto and Mot_strct.SW.AutoOK and Mot_strct.CW.AutoON));
Mot_strct.SW.COM:=Aux_strct.COM and not Mot_strct.CW.SimEn;

(*========================================================================================*)
	(*Frequency limatation*)
(*========================================================================================*)
Mot_strct.MaxFreq:= LIMIT(0.0, Mot_strct.MaxFreq, 50.0);
Mot_strct.MinFreq:= LIMIT(0.0, Mot_strct.MinFreq, Mot_strct.MaxFreq);	
Mot_strct.ManFreq:= LIMIT(Mot_strct.MinFreq, Mot_strct.ManFreq, Mot_strct.MaxFreq);
Mot_strct.AutoFreq:= LIMIT(Mot_strct.MinFreq, Mot_strct.AutoFreq, Mot_strct.MaxFreq);

if Mot_strct.SW.RunAuto and not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON then
	Aux_strct.SetValue:=Mot_strct.AutoFreq;
elsif not Mot_strct.SW.AlarmAccum and Mot_strct.SW.RunManual then
	Aux_strct.SetValue:=Mot_strct.ManFreq;
else
	Aux_strct.SetValue:=0.0;
end_if;

(*========================================================================================*)
	(*Work time counter*)
(*========================================================================================*)
if Mot_strct.SW.COM and Aux_strct.Tick_1S then
	Aux_strct.Seconds:= Aux_strct.Seconds + udint#1;
end_if;

Aux_strct.Minutes:= Aux_strct.Seconds / udint#60;
Aux_strct.Hours:= Aux_strct.Seconds / udint#3600;
Aux_strct.Days:= Aux_strct.Seconds / udint#86400;

(*========================================================================================*)
	(*Aux time counters*)
(*========================================================================================*)
if Aux_strct.CT1_ON and Aux_strct.Tick_1S then
	Aux_strct.CT1:= Aux_strct.CT1 + 1;
elsif not Aux_strct.CT1_ON then
	Aux_strct.CT1:= 0;
end_if; 

if Aux_strct.CT2_ON and Aux_strct.Tick_1S then
	Aux_strct.CT2:= Aux_strct.CT2 + 1;
elsif not Aux_strct.CT2_ON then
	Aux_strct.CT2:= 0;
end_if; 

(*========================================================================================*)
	(*Status processing*)
(*========================================================================================*)
if Mot_strct.SW.AlarmAccum then											(*Alarm*)
	Mot_strct.Status:=word#2;
elsif not Mot_strct.CW.ExtraEn then										(*Blocking*)
	Mot_strct.Status:=word#4;
elsif Mot_strct.SW.COM then												(*Working*)
	Mot_strct.Status:=word#1;
else																	(*Stoped*)
	Mot_strct.Status:=word#0;
end_if;

Mot_strct.CW.AutoMode:=false;
Mot_strct.CW.ManMode:=false;
Mot_strct.CW.ManStart:=false;
Mot_strct.CW.ManStop:=false;
Mot_strct.CW.ACK:=false;
Aux_strct.Tick_1S:= false;

(*================================================================================================*)
(*Motor Pulse Events*)
(*================================================================================================*)

Event.AlarmAccum:= false;
if Mot_strct.SW.AlarmAccum and not Aux_strct.EVENT_1 then
	Event.AlarmAccum:= true;
	Aux_strct.EVENT_1:= true;
elsif not Mot_strct.SW.AlarmAccum then
	Aux_strct.EVENT_1:= false;
end_if;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
