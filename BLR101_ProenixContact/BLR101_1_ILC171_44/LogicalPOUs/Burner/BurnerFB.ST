(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Burner
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK BurnerFB

(*Group:Default*)


VAR
	TON_Overtime :	TON;
END_VAR


VAR_IN_OUT
	Brn_strct :	Brnr;
END_VAR


VAR
	AlarmFeedback :	BOOL;
	RunManual :	BOOL;
	RunAuto :	BOOL;
	COM :	BOOL;
	EnableMotorAuto :	BOOL;
END_VAR


VAR_INPUT
	Cycle :	Cycle;
	SetOvertime :	TIME;
END_VAR


VAR
	AlarmBlock :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: BurnerFB
IEC_LANGUAGE: ST
*)
	(*Alarm Feedback processing*)
TON_Overtime(IN:=Brn_strct.CW.Enable and 
	((Brn_strct.SW.COM and not Brn_strct.SW.RUN) or
	(not Brn_strct.SW.COM and Brn_strct.SW.RUN)),PT:=SetOvertime);

if TON_Overtime.Q then
	AlarmFeedback:=true;
end_if;
if not Brn_strct.CW.ExtraEn and Brn_strct.SW.COM then
	AlarmBlock:= true;
end_if;

if AlarmFeedback or Brn_strct.CW.ExtraAlarm or AlarmBlock then
	Brn_strct.SW.AlarmAccum:= true;
end_if;

if Brn_strct.CW.ACK then
	AlarmFeedback:=false;
	AlarmBlock:= false;
	Brn_strct.SW.AlarmAccum:= false;
end_if;
	
	(*Auto/Manual mode selection*)
if Brn_strct.CW.EnableAuto then 
	Brn_strct.SW.Auto:= true;
elsif Brn_strct.CW.DisableAuto then
	Brn_strct.SW.Auto:= false;
end_if;



Brn_strct.SW.ManOK:= not Brn_strct.SW.AlarmAccum and Brn_strct.CW.AuxON and
	Brn_strct.CW.Enable and not Brn_strct.SW.Auto;

Brn_strct.SW.AutoOK:= not Brn_strct.SW.AlarmAccum and Brn_strct.CW.AuxON and
	Brn_strct.CW.Enable and Brn_strct.SW.Auto and Cycle.SW.Running;


	(*Manual mode activation*)
if Brn_strct.CW.ManStart then
	RunManual:=true;
end_if;
if Brn_strct.CW.ManStop or not Brn_strct.SW.ManOK then
	RunManual:=false;
end_if;

	(*Auto mode activation*)
RunAuto:= (Cycle.CW.PulseStart or RunAuto) and Brn_strct.SW.AutoOK and
	Brn_strct.SW.Auto;

	(*Set command for start*)
COM:=((RunManual and Brn_strct.SW.ManOK) or (RunAuto and Brn_strct.SW.AutoOK and
	Brn_strct.CW.AutoON));

Brn_strct.SW.COM:=COM and not Brn_strct.CW.SimEn;



	(*SP limatation*)
if Brn_strct.Sys.MaxSP > 100.0 then
	Brn_strct.Sys.MaxSP:=100.0;
elsif Brn_strct.Sys.MaxSP < 0.0 then
	Brn_strct.Sys.MaxSP:=0.0;
end_if;

if Brn_strct.Sys.MinSP > 100.0 then
	Brn_strct.Sys.MinSP:=100.0;
elsif Brn_strct.Sys.MinSP < 0.0 then
	Brn_strct.Sys.MinSP:=0.0;
end_if;

if Brn_strct.Sys.MinSP > Brn_strct.Sys.MaxSP then
	Brn_strct.Sys.MinSP:=Brn_strct.Sys.MaxSP;
end_if;

if Brn_strct.Sys.ManSP > Brn_strct.Sys.MaxSP then
	Brn_strct.Sys.ManSP:=Brn_strct.Sys.MaxSP;
elsif Brn_strct.Sys.ManSP < Brn_strct.Sys.MinSP then
	Brn_strct.Sys.ManSP:=Brn_strct.Sys.MinSP;
end_if;

if Brn_strct.Sys.AutoSP > Brn_strct.Sys.MaxSP then
	Brn_strct.Sys.AutoSP:=Brn_strct.Sys.MaxSP;
elsif Brn_strct.Sys.AutoSP < Brn_strct.Sys.MinSP then
	Brn_strct.Sys.AutoSP:=Brn_strct.Sys.MinSP;
end_if;


	(*Status processing*)
if Brn_strct.SW.AlarmAccum then													(*Alarm*)
	Brn_strct.Sys.Status:=word#2;
elsif not Brn_strct.CW.ExtraEn then												(*Blocking*)
	Brn_strct.Sys.Status:=word#4;
elsif Brn_strct.SW.COM then														(*Working*)
	Brn_strct.Sys.Status:=word#1;
else																			(*Stoped*)
	Brn_strct.Sys.Status:=word#0;
end_if;

Brn_strct.CW.EnableAuto:=false;
Brn_strct.CW.DisableAuto:=false;
Brn_strct.CW.ManStart:=false;
Brn_strct.CW.ManStop:=false;
Brn_strct.CW.ACK:=false;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK