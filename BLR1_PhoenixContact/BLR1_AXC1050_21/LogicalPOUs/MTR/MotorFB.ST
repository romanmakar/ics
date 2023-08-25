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

IF TICK_1S_PLS and not Aux_strct.AuxFlag THEN
    Aux_strct.Tick_1S:= true;
END_IF;
Aux_strct.AuxFlag:= TICK_1S_PLS;

(*============================================================================*)
    (*Alarm Feedback processing*)
(*============================================================================*)
IF Mot_strct.CW.Enable and ((Aux_strct.COM and not Mot_strct.SW.RUN) or (not Aux_strct.COM and Mot_strct.SW.RUN)) THEN
    IF Aux_strct.Tick_1S THEN
        Aux_strct.AlrmTickCount:= Aux_strct.AlrmTickCount + 1;
    END_IF;
ELSE
    Aux_strct.AlrmTickCount:= 0;
END_IF;

IF Aux_strct.AlrmTickCount >= Aux_strct.SetOvertime THEN
    Aux_strct.AlarmFeedback:=true;
    Aux_strct.AlrmTickCount:= 0;
END_IF;

IF not Mot_strct.CW.ExtraEn and Aux_strct.COM THEN
    Aux_strct.AlarmBlock:= true;
END_IF;

Mot_strct.SW.AlarmAccum:= Aux_strct.AlarmFeedback or Mot_strct.CW.ExtraAlarm or Aux_strct.AlarmBlock;

IF Mot_strct.CW.ACK THEN
    Aux_strct.AlarmFeedback:=false;
    Aux_strct.AlarmBlock:= false;
END_IF;

(*============================================================================*)	
    (*Auto/Manual mode selection*)
(*============================================================================*)
IF Mot_strct.CW.AutoMode THEN 
    Mot_strct.SW.ManAuto:= true;
ELSIF Mot_strct.CW.ManMode THEN
    Mot_strct.SW.ManAuto:= false;
END_IF;

Mot_strct.SW.ManOK:= not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON and
    Mot_strct.CW.Enable and not Mot_strct.SW.ManAuto;
Mot_strct.SW.AutoOK:= not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON and
    Mot_strct.CW.Enable and Mot_strct.SW.ManAuto;

(*============================================================================*)
    (*Manual mode activation*)
(*============================================================================*)

IF Mot_strct.CW.ManStop or not Mot_strct.SW.ManOK THEN
    Mot_strct.SW.RunManual:=false;
ELSIF Mot_strct.CW.ManStart THEN
    Mot_strct.SW.RunManual:=true;
END_IF;

(*============================================================================*)
    (*Auto mode activation*)
(*============================================================================*)
Mot_strct.SW.RunAuto:= Mot_strct.SW.AutoOK and Cycle.SW.Running;

(*============================================================================*)
    (*Set command for start*)
(*============================================================================*)
Aux_strct.COM:=((Mot_strct.SW.RunManual and Mot_strct.SW.ManOK) or
    (Mot_strct.SW.RunAuto and Mot_strct.SW.AutoOK and Mot_strct.CW.AutoON));
Mot_strct.SW.COM:=Aux_strct.COM and not Mot_strct.CW.SimEn;

(*============================================================================*)
    (*Frequency limatation*)
(*============================================================================*)
Mot_strct.MaxFreq:= LIMIT(0.0, Mot_strct.MaxFreq, 50.0);
Mot_strct.MinFreq:= LIMIT(0.0, Mot_strct.MinFreq, Mot_strct.MaxFreq);	
Mot_strct.ManFreq:= LIMIT(Mot_strct.MinFreq, Mot_strct.ManFreq, Mot_strct.MaxFreq);
Mot_strct.AutoFreq:= LIMIT(Mot_strct.MinFreq, Mot_strct.AutoFreq, Mot_strct.MaxFreq);

IF Mot_strct.SW.RunAuto and not Mot_strct.SW.AlarmAccum and Mot_strct.CW.AuxON THEN
    Aux_strct.SetValue:=Mot_strct.AutoFreq;
ELSIF not Mot_strct.SW.AlarmAccum and Mot_strct.SW.RunManual THEN
    Aux_strct.SetValue:=Mot_strct.ManFreq;
ELSE
    Aux_strct.SetValue:=0.0;
END_IF;

(*============================================================================*)
    (*Work time counter*)
(*============================================================================*)
IF Mot_strct.SW.COM and Aux_strct.Tick_1S THEN
    Aux_strct.Seconds:= Aux_strct.Seconds + udint#1;
END_IF;

Aux_strct.Minutes:= Aux_strct.Seconds / udint#60;
Aux_strct.Hours:= Aux_strct.Seconds / udint#3600;
Aux_strct.Days:= Aux_strct.Seconds / udint#86400;

(*============================================================================*)
    (*Aux time counters*)
(*============================================================================*)
IF Aux_strct.CT1_ON and Aux_strct.Tick_1S THEN
    Aux_strct.CT1:= Aux_strct.CT1 + 1;
ELSIF not Aux_strct.CT1_ON THEN
    Aux_strct.CT1:= 0;
END_IF; 

IF Aux_strct.CT2_ON and Aux_strct.Tick_1S THEN
    Aux_strct.CT2:= Aux_strct.CT2 + 1;
ELSIF not Aux_strct.CT2_ON THEN
    Aux_strct.CT2:= 0;
END_IF; 

(*============================================================================*)
    (*Status processing*)
(*============================================================================*)
IF Mot_strct.SW.AlarmAccum THEN                                                 (*Alarm*)
    Mot_strct.Status:=word#2;
ELSIF not Mot_strct.CW.ExtraEn THEN                                             (*Blocking*)
    Mot_strct.Status:=word#4;
ELSIF Mot_strct.SW.COM THEN                                                     (*Working*)
    Mot_strct.Status:=word#1;
ELSE                                                                            (*Stopped*)
    Mot_strct.Status:=word#0;
END_IF;

Mot_strct.CW.AutoMode:=false;
Mot_strct.CW.ManMode:=false;
Mot_strct.CW.ManStart:=false;
Mot_strct.CW.ManStop:=false;
Mot_strct.CW.ACK:=false;
Aux_strct.Tick_1S:= false;

(*============================================================================*)
(*Motor Pulse Events*)
(*============================================================================*)

Event.AlarmAccum:= false;
IF Mot_strct.SW.AlarmAccum and not Aux_strct.EVENT_1 THEN
    Event.AlarmAccum:= true;
    Aux_strct.EVENT_1:= true;
ELSIF not Mot_strct.SW.AlarmAccum THEN
    Aux_strct.EVENT_1:= false;
END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
