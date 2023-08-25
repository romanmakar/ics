(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: VLVS.FB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK ValveFB

(*Group:Default*)


VAR
    Fb_Alrm_Tmr :    TON;
END_VAR


VAR_IN_OUT
    Vlv_strct :    VLV;
    Aux_strct :    VLV_MISC;
END_VAR


VAR
    AlrmNotMove :    BOOL;
    AlrmSQ :    BOOL;
    RunManual :    BOOL;
    RunAuto :    BOOL;
    COM_Open :    BOOL;
    COM_Close :    BOOL;
END_VAR


VAR_INPUT
    Cycle :    CCL;
END_VAR


VAR
    NotMove_Alrm_Tmr :    TON;
    AlrmFeedBack :    BOOL;
    AlarmBlock :    BOOL;
END_VAR


VAR_EXTERNAL
    TICK_1S_PLS :    BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: ValveFB
IEC_LANGUAGE: ST
*)

IF TICK_1S_PLS and not Aux_strct.AuxFlag THEN
    Aux_strct.Tick_1S:= TRUE;
END_IF;
Aux_strct.AuxFlag:= TICK_1S_PLS;

(*============================================================================*)
    (*Alarm Feedback processing*)
(*============================================================================*)
IF Vlv_strct.CW.Enable and (Aux_strct.COM_Close or Aux_strct.COM_Open) and
    not Vlv_strct.SW.RUN THEN
    IF Aux_strct.Tick_1S THEN
        Aux_strct.FbAlarmTickCount:= Aux_strct.FbAlarmTickCount + 1;
    END_IF;
ELSE
    Aux_strct.FbAlarmTickCount:= 0;
END_IF;

IF Vlv_strct.CW.Enable and ((Aux_strct.COM_Close and not Vlv_strct.SW.Closed) or
    (Aux_strct.COM_Open and not Vlv_strct.SW.Opened)) THEN
    IF Aux_strct.Tick_1S THEN
        Aux_strct.MoveAlarmTickCount:= Aux_strct.MoveAlarmTickCount + 1;
    END_IF;
ELSE
    Aux_strct.MoveAlarmTickCount:= 0;
END_IF;

IF Aux_strct.FbAlarmTickCount >= 3 THEN
    Aux_strct.AlarmFeedBack:= TRUE;
    Aux_strct.FbAlarmTickCount:= 0;
END_IF;

IF Aux_strct.MoveAlarmTickCount >= Aux_strct.SetOvertime THEN 
    Aux_strct.AlarmNotMove:= TRUE;
    Aux_strct.MoveAlarmTickCount:= 0;
END_IF;

IF (not Vlv_strct.CW.ExtraEn and (Aux_strct.COM_Open or Aux_strct.COM_Close)) THEN
    Aux_strct.AlarmBlock:= TRUE;
END_IF;

IF Vlv_strct.SW.Opened and Vlv_strct.SW.Closed THEN
    Aux_strct.AlarmSQ:=TRUE;
END_IF;


Vlv_strct.SW.AlarmAccum:= Aux_strct.AlarmNotMove or Aux_strct.AlarmSQ or
    Aux_strct.AlarmFeedBack or Vlv_strct.CW.ExtraAlarm; 


IF Vlv_strct.CW.ACK THEN
    Vlv_strct.SW.AlarmAccum:=FALSE;
    Aux_strct.AlarmFeedBack:=FALSE;
    Aux_strct.AlarmSQ:=FALSE;
    Aux_strct.AlarmnotMove:=FALSE;
    Aux_strct.AlarmBlock:= FALSE;
END_IF;

(*============================================================================*)
    (*Auto/Manual mode selection*)
(*============================================================================*)
IF Vlv_strct.CW.AutoMode THEN
    Vlv_strct.SW.ManAuto:= TRUE;
END_IF;
IF Vlv_strct.CW.ManMode THEN
    Vlv_strct.SW.ManAuto:= FALSE;
END_IF;


Vlv_strct.SW.ManOK:=not Vlv_strct.SW.AlarmAccum and Vlv_strct.CW.AuxON and
    Vlv_strct.CW.Enable and not Vlv_strct.SW.ManAuto;

Vlv_strct.SW.AutoOK:= not Vlv_strct.SW.AlarmAccum and Vlv_strct.CW.AuxON and
    Vlv_strct.CW.Enable and Vlv_strct.SW.ManAuto;

(*============================================================================*)
    (*Manual mode activation*)
(*============================================================================*)
IF Vlv_strct.CW.ManOpen or Vlv_strct.CW.ManClose THEN
    Vlv_strct.SW.RunManual:=TRUE;
END_IF;

IF Vlv_strct.CW.Stop or not Vlv_strct.SW.ManOK THEN
    Vlv_strct.SW.RunManual:=FALSE;
END_IF;

(*============================================================================*)
    (*Auto mode activation*)
(*============================================================================*)
Vlv_strct.SW.RunAuto:= Vlv_strct.SW.AutoOK and Cycle.SW.Running;

(*============================================================================*)
    (*Set command for start*)
(*============================================================================*)
Aux_strct.COM_Open:=((Vlv_strct.CW.AutoOpen and Vlv_strct.SW.RunAuto and
    Vlv_strct.SW.AutoOK) or ((Vlv_strct.CW.ManOpen or Aux_strct.COM_Open) and
    Vlv_strct.SW.RunManual and Vlv_strct.SW.ManOK)) and
    not Aux_strct.COM_Close and not Vlv_strct.SW.Opened;

Aux_strct.COM_Close:=((Vlv_strct.CW.AutoClose and Vlv_strct.SW.RunAuto and
    Vlv_strct.SW.AutoOK) or ((Vlv_strct.CW.ManClose or Aux_strct.COM_Close) and
    Vlv_strct.SW.RunManual and Vlv_strct.SW.ManOK)) and
    not Aux_strct.COM_Open and not Vlv_strct.SW.Closed;

Vlv_strct.SW.COM_Open:=Aux_strct.COM_Open and not Vlv_strct.CW.SimEn;
Vlv_strct.SW.COM_Close:=Aux_strct.COM_Close and not Vlv_strct.CW.SimEn;    

(*============================================================================*)
    (*Status processing*)
(*============================================================================*)
IF Vlv_strct.SW.AlarmAccum THEN
    Vlv_strct.Status:=word#4;
elsIF not Vlv_strct.CW.ExtraEn THEN
    Vlv_strct.Status:=word#8;
elsIF Vlv_strct.SW.Opened THEN
    Vlv_strct.Status:=word#1;
elsIF Vlv_strct.SW.Closed THEN
    Vlv_strct.Status:=word#2;
ELSE
    Vlv_strct.Status:=word#0;
END_IF;


Vlv_strct.CW.AutoMode:=FALSE;
Vlv_strct.CW.ManMode:=FALSE;
Vlv_strct.CW.ManOpen:=FALSE;
Vlv_strct.CW.Stop:=FALSE;
Vlv_strct.CW.ManClose:=FALSE;
Vlv_strct.CW.ACK:=FALSE;
Aux_strct.Tick_1S:= FALSE;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
