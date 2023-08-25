(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ALRM
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM ALRM_CTRL

(*Group:Default*)


VAR_EXTERNAL
    WarnWord :	WRN;
    Cycle :	CCL;
END_VAR


VAR
    AlarmSound :	BOOL;
    AlarmLight :	BOOL;
    AlarmSoundOFF :	BOOL;
END_VAR


VAR_EXTERNAL
    ACK :	BOOL;
END_VAR


VAR
    AlarmPLS :	R_TRIG;
    SnsrLimAlarm :	BOOL;
    WarnBlink :	Blink;
    WarnBlinkFallEdge :	F_TRIG;
    i :	INT;
END_VAR


VAR_EXTERNAL
    ALARM_HL :	BOOL;
    ALARM_HA :	BOOL;
    M :	MOTOR;
    V :	VALVE;
    MBTCP_Data :	MB_TCP_ARR_W_0_7167;
    M_AUX :	MOTOR_MISC;
END_VAR


(*@KEY@: WORKSHEET
NAME: ALRM_CTRL
IEC_LANGUAGE: ST
*)

Cycle.SW.ALARM:= M[0].SW.AlarmAccum or
                M[1].SW.AlarmAccum or
                M[2].SW.AlarmAccum or
                M[3].SW.AlarmAccum or
                M[4].SW.AlarmAccum or
                M[5].SW.AlarmAccum or
                M[6].SW.AlarmAccum or
                M[7].SW.AlarmAccum or
                M[8].SW.AlarmAccum or
                M[8].SW.AlarmAccum or
                M[10].SW.AlarmAccum or
                M[11].SW.AlarmAccum or
                M[12].SW.AlarmAccum or
                V[0].SW.AlarmAccum or
                V[1].SW.AlarmAccum or
                V[2].SW.AlarmAccum;

if ACK then
    for i:= 0 to 19 do
        M[i].CW.ACK:= true;
        M_AUX[i].DryMoveFault:= false;
        V[i].CW.ACK:= true;
    end_for;
    Cycle.CW.ACK:=false;
    MBTCP_Data[0].X4:=false;
end_if;


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
