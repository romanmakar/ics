(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MTRS
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM MTR6_CTRL

(*Group:Default*)


VAR
    RunPmpNum :    INT;
    TmpWTMax :    UDINT;
    TmpWTMin :    UDINT;
    TmpIndMax :    INT;
    TmpIndMin :    INT;
    i :    INT;
    StartPmpReq :    BOOL;
    STOpPmpReq :    BOOL;
    Stage :    INT;
END_VAR


VAR_EXTERNAL
    CCL :    CYCLE;
END_VAR


VAR
    StartReqTmr :    TON;
    STOpReqTmr :    TON;
    OverClckTmr :    TON;
    ReleaseTmr :    TON;
    TmpFreq :    REAL;
END_VAR


VAR_EXTERNAL
    M :    MOTOR;
    RGLTR :    REGULATOR;
    M_AUX :    MOTOR_MISC;
    MBTCP_Data :    MB_TCP_ARR_W_0_7167;
    AI :    SENSOR;
END_VAR


VAR
    MainPID :    FPID;
    TmpRotation :    BOOL;
    j :    INT;
END_VAR


VAR_EXTERNAL
    M_EVENT :    MOTOR_EVENT;
END_VAR


VAR
    TmpPmpAlarm :    BOOL;
    SysNum :    INT;
    LoInd :    INT;
    HiInd :    INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MTR6_CTRL
IEC_LANGUAGE: ST
*)
(*============================================================================*)
(*Work time sorting*)
(*Number of working pumps evaluation*)
(*PID min and max limits determination*)
(*============================================================================*)
SysNum:= 4;                                                                     (*Sequence number of cycle in cycles array (regulaTOr in reg. array)*)
LoInd:= 11;                                                                     (*First number of pump in pumps array used here*)
HiInd:= 12;                                                                     (*Last number of pump in pumps array used here*)
RunPmpNum:= 0;
RGLTR[SysNum].LL:= 50.0;
RGLTR[SysNum].LH:= 0.0;

(*============================================================================*)
FOR i:= LoInd TO HiInd DO

    IF M[i].SW.AuTOOK and M[i].SW.RUN THEN                                       (*Working pump number determination*)
        RunPmpNum:= RunPmpNum + 1;                    

        IF M[i].MaxFreq > RGLTR[SysNum].LH  THEN                                (*Assign pumps max. freq TO RGLTR. hight limit*)
            RGLTR[SysNum].LH:= M[i].MaxFreq;
        END_IF;

        IF M[i].MinFreq < RGLTR[SysNum].LL THEN                                 (*Assign pumps min. freq TO RGLTR. low limit*)
            RGLTR[SysNum].LL:= M[i].MinFreq;
        END_IF;
    END_IF;

    IF not M[i].SW.AuTOOK THEN                                                  (*Reset auTO command IF not auTO*)
        M[i].CW.AuTOON:= false;
    END_IF;

    M[i].AuTOFreq:= RGLTR[SysNum].Y / 10.0;                                     (*Assign pumps min. freq TO RGLTR. low limit*)

(*============================================================================*)
(*Pumps Dry motion*)
(*============================================================================*)

    M_AUX[i].CT1_ON:= (AI[70].RealValue <= 0.5) and M[i].SW.RUN and not M_AUX[i].DryMoveFault;

    IF M_AUX[i].CT1 > 5 THEN
        M_AUX[i].DryMoveFault:= true;
    END_IF;

    M_AUX[i].CT2_ON:= (AI[70].RealValue >= 1.0) and M_AUX[i].DryMoveFault;

    IF M_AUX[i].CT2 > 60 THEN
        M_AUX[i].DryMoveFault:= false;
    END_IF;

(*============================================================================*)
(*Alarm action*)
(*============================================================================*)
    IF M[i].SW.ManAuTO and M_EVENT[i].AlarmAccum THEN
        TmpPmpAlarm:= true;
    END_IF;
END_FOR;
(*============================================================================*)



(*============================================================================*)
(*Set rotation command*)
(*============================================================================*)
IF CCL[SysNum].CW.Rotation THEN
    CCL[SysNum].SW.RotationON:= true;
    CCL[SysNum].CW.Rotation:= false;
END_IF;

(*============================================================================*)
(*Start/STOp conditions*)
(*============================================================================*)
StartReqTmr(IN:=(((RGLTR[SysNum].Y / 10.0) >= (RGLTR[SysNum].LH - 1.0)) and
    (RGLTR[SysNum].ActVal < RGLTR[SysNum].SP) and not StartPmpReq and
    CCL[SysNum].SW.Running),PT:=t#60s);                                         (*Start auxiliary pump condition*)

STOpReqTmr(IN:=(((RGLTR[SysNum].Y / 10.0) <= (RGLTR[SysNum].LL + 1.0)) and
	(RGLTR[SysNum].ActVal >= RGLTR[SysNum].SP) and not STOpPmpReq and
	CCL[SysNum].SW.Running),PT:=t#60s);    										(*STOp pump condition*)

(*============================================================================*)
(*Cycle handling*)
(*============================================================================*)
IF CCL[SysNum].SW.Running THEN
    IF (StartReqTmr.Q or (RunPmpNum < 1) or TmpPmpAlarm) and (Stage = 0) THEN   (*Stage route: 1 >> 2 >> 0*)
        Stage:= 1;
        IF TmpPmpAlarm THEN
            TmpPmpAlarm:= false;
        END_IF;
    elsIF CCL[SysNum].SW.RotationON and (RunPmpNum > 0) and (Stage = 0) THEN    (*Stage route: 3 >> 1 >> 2 >> 4 >> 0*)
        TmpRotation:= true;
        Stage:= 3;
    elsIF STOpReqTmr.Q and (Stage = 0) THEN                                     (*Stage route: 3 >> 4 >> 0*)
        Stage:= 3;
    END_IF;
else
    StartPmpReq:= false;
    STOpPmpReq:= false;
    TmpFreq:= 0.0;
    CCL[SysNum].SW.RotationON:= false;
    TmpRotation:= false;
    Stage:= 0;
    TmpPmpAlarm:= false;
    
    FOR i:= LoInd TO HiInd DO
        M[i].CW.AuTOON:= false;
    END_FOR;
END_IF;

OverClckTmr(IN:=StartPmpReq and not OverClckTmr.Q,PT:=t#3s);                    (*Overclocking pulse timer*)
ReleaseTmr(IN:=STOpPmpReq and not ReleaseTmr.Q,PT:=t#3s);                       (*Releasing pulse timer*)

CASE Stage OF
    
    0:  StartPmpReq:= false;
        STOpPmpReq:= false;
        TmpPmpAlarm:= false;
        CCL[SysNum].SW.RotationON:= false;
        TmpRotation:= false;
        TmpFreq:= 0.0;

    1:  StartPmpReq:= true;                                                     (*Determ. higher work time*)
        TmpWTMin:= udint#0;
        TmpIndMin:= 0;
        FOR i:= LoInd TO HiInd DO
            IF M_AUX[i].Seconds >= TmpWTMin THEN    
                TmpWTMin:= M_AUX[i].Seconds;                                    (*Assign. higher work time TO temporary var.*)    
            END_IF;
        END_FOR;

        FOR i:= LoInd TO HiInd DO
            IF M[i].SW.AuTOOK and not M[i].SW.RUN THEN                          (*Determ. lowest work time pump*)
                IF M_AUX[i].Seconds <= TmpWTMin THEN
                    TmpWTMin:= M_AUX[i].Seconds;
                    TmpIndMin:= i;                                              (*Determ. lowest work time pump index*)
                END_IF;
            END_IF;
        END_FOR;
        IF (TmpIndMin < LoInd) and (TmpIndMin > HiInd) THEN
            Stage:= 5;
        else
            M[TmpIndMin].CW.AuTOON:= true;                                      (*Start lowest work time pump*)
            TmpFreq:= M[TmpIndMin].MinFreq;                                     (*with min. frequency*)
            Stage:= 2;
        END_IF;

    2:  M[TmpIndMin].AuTOFreq:= TmpFreq;                                        (*Overclocking new pump*)
        IF OverClckTmr.Q THEN
            TmpFreq:= TmpFreq + 1.0;
        elsIF M[TmpIndMin].AuTOFreq >= (RGLTR[SysNum].Y / 10.0)  THEN
            StartPmpReq:= false;
            IF TmpRotation THEN
                Stage:= 4;
            else
                Stage:= 5;
            END_IF;
        END_IF;
        
    3:  TmpWTMax:= udint#0;                                                     (*Determ. highest work time pump*)
        TmpIndMax:= 0;
        FOR i:= LoInd TO HiInd DO 
            IF M[i].SW.AuTOOK and M[i].SW.RUN THEN
                IF M_AUX[i].Seconds >= TmpWTMax THEN
                    TmpWTMax:= M_AUX[i].Seconds;
                    TmpIndMax:= i;
                END_IF;
            END_IF;
        END_FOR;
        IF TmpRotation THEN
            Stage:= 1;
        else
            TmpFreq:= RGLTR[SysNum].Y / 10.0;
            Stage:= 4;
        END_IF;

    4:  STOpPmpReq:= true; 		                                                (*Releasing highest work time pump*)
        M[TmpIndMax].AuTOFreq:= TmpFreq;
        IF ReleaseTmr.Q THEN
            TmpFreq:= TmpFreq - 1.0;
        elsIF M[TmpIndMax].AuTOFreq <= M[TmpIndMax].MinFreq THEN
            M[TmpIndMax].CW.AuTOON:= false;
            STOpPmpReq:= false;
            Stage:= 5;
            TmpFreq:= 0.0;
        END_IF;

    5:  StartPmpReq:= false;
        STOpPmpReq:= false;
        TmpPmpAlarm:= false;
        CCL[SysNum].SW.RotationON:= false;
        TmpRotation:= false;
        TmpFreq:= 0.0;
        Stage:= 0;
END_CASE;


(*============================================================================*)
(*Main PID*)
(*============================================================================*)
RGLTR[SysNum].ActVal:= AI[71].RealValue - AI[70].RealValue;
MainPID(REMOTE:=CCL[SysNum].SW.Running,
        AUTO:=true,
        DIRECTN:=false,
        INTLCK:=(RunPmpNum <= 0),
        Tscan:=1.0,
        Yman:=RGLTR[SysNum].ManVal,
        SPR:=(RGLTR[SysNum].SP * 100.0),
        SPL:=0.0,
        X:=(RGLTR[SysNum].ActVal * 100.0),
        KP:=RGLTR[SysNum].Kp,
        TI:=RGLTR[SysNum].Tn,
        TD:=RGLTR[SysNum].Tv,
        HIGH:=(RGLTR[SysNum].LH * 10.0),
        LOW:=(RGLTR[SysNum].LL * 10.0),
        INTLCKV:=0.0);
RGLTR[SysNum].Y:=MainPID.Yout;

(*============================================================================*)
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
