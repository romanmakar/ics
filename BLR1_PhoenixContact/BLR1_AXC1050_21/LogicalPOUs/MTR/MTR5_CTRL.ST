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
PROGRAM MTR5_CTRL

(*Group:Default*)


VAR
    RunPmpNum :    INT;
    TmpWTMax :    UDINT;
    TmpWTMin :    UDINT;
    TmpIndMax :    INT;
    TmpIndMin :    INT;
    i :    INT;
    StartPmpReq :    BOOL;
    StopPmpReq :    BOOL;
    Stage :    INT;
END_VAR


VAR_EXTERNAL
    CCL :    CYCLE;
END_VAR


VAR
    StartReqTmr :    TON;
    StopReqTmr :    TON;
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
NAME: MTR5_CTRL
IEC_LANGUAGE: ST
*)
(*============================================================================*)
(*Work time sorting*)
(*Number of working pumps evaluation*)
(*PID min and max limits determination*)
(*============================================================================*)
SysNum:= 3;                                                                     (*Sequence number of cycle in cycles array (regulator in reg. array)*)
LoInd:= 8;                                                                      (*First number of pump in pumps array used here*)
HiInd:= 10;                                                                     (*Last number of pump in pumps array used here*)
RunPmpNum:= 0;
RGLTR[SysNum].LL:= 50.0;
RGLTR[SysNum].LH:= 0.0;

(*============================================================================*)
FOR i:= LoInd TO HiInd do

    IF M[i].SW.AutoOK and M[i].SW.RUN THEN                                      (*Working pump number determination*)
        RunPmpNum:= RunPmpNum + 1;                    

        IF M[i].MaxFreq > RGLTR[SysNum].LH  THEN                                (*Assign pumps max. freq TO RGLTR. hight limit*)
            RGLTR[SysNum].LH:= M[i].MaxFreq;
        END_IF;

        IF M[i].MinFreq < RGLTR[SysNum].LL THEN                                 (*Assign pumps min. freq TO RGLTR. low limit*)
            RGLTR[SysNum].LL:= M[i].MinFreq;
        END_IF;
    END_IF;

    IF not M[i].SW.AutoOK THEN                                                  (*Reset auTO command IF not auto*)
        M[i].CW.AutoON:= false;
    END_IF;

    M[i].AutoFreq:= RGLTR[SysNum].Y / 10.0;                                      (*Assign pumps min. freq TO RGLTR. low limit*)

(*============================================================================*)
    (*Pumps Dry motion*)
(*============================================================================*)
    j:= i * 2 - 16;

    M_AUX[i].CT1_ON:= (AI[j].RealValue <= 0.5) and M[i].SW.RUN and not M_AUX[i].DryMoveFault;

    IF M_AUX[i].CT1 > 5 THEN
        M_AUX[i].DryMoveFault:= true;
    END_IF;

    M_AUX[i].CT2_ON:= (AI[j].RealValue >= 1.0) and M_AUX[i].DryMoveFault;

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
    (*Start/Stop conditions*)
(*============================================================================*)
StartReqTmr(IN:=(((RGLTR[SysNum].Y / 10.0) >= (RGLTR[SysNum].LH - 2.0)) and
    (RGLTR[SysNum].ActVal < RGLTR[SysNum].SP) and not StartPmpReq and 
    CCL[SysNum].SW.Running),PT:=t#60s);                                         (*Start auxiliary pump condition*)

StopReqTmr(IN:=(((RGLTR[SysNum].Y / 10.0) <= (RGLTR[SysNum].LL + 1.0)) and 
    RGLTR[SysNum].ActVal >= RGLTR[SysNum].SP) and not StopPmpReq and
    CCL[SysNum].SW.Running),PT:=t#60s);                                         (*Stop pump condition*)

(*============================================================================*)
    (*Cycle handling*)
(*============================================================================*)
IF CCL[SysNum].SW.Running THEN
    IF (StartReqTmr.Q or (RunPmpNum < 1) or TmpPmpAlarm) and (Stage = 0) THEN   (*Stage route: 1 >> 2 >> 5 >> 0*)
        Stage:= 1;
        IF TmpPmpAlarm THEN
            TmpPmpAlarm:= false;
        END_IF;
    ELSIF CCL[SysNum].SW.RotationON and (RunPmpNum > 0) and (Stage = 0) THEN    (*Stage route: 3 >> 1 >> 2 >> 4 >> 5 >> 0*)
        TmpRotation:= true;
        Stage:= 3;
    ELSIF StopReqTmr.Q and (Stage = 0) THEN                                     (*Stage route: 3 >> 4 >> 5 >> 0*)
        Stage:= 3;
    END_IF;
ELSE
    StartPmpReq:= false;
    StopPmpReq:= false;
    TmpFreq:= 0.0;
    CCL[3].SW.RotationON:= false;
    TmpRotation:= false;
    Stage:= 0;
    TmpPmpAlarm:= false;
    
    FOR i:= LoInd TO HiInd do
        M[i].CW.AutoON:= false;
    END_FOR;
END_IF;

OverClckTmr(IN:=StartPmpReq and not OverClckTmr.Q,PT:=t#3s);                    (*Overclocking pulse timer*)
ReleaseTmr(IN:=StopPmpReq and not ReleaseTmr.Q,PT:=t#3s);                       (*Releasing pulse timer*)

CASE Stage OF
    
    0:  StartPmpReq:= false;
        StopPmpReq:= false;
        TmpPmpAlarm:= false;
        CCL[3].SW.RotationON:= false;
        TmpRotation:= false;
        TmpFreq:= 0.0;

    1:  StartPmpReq:= true;                                                     (*Determ. higher work time*)
        TmpWTMin:= udint#0;
        TmpIndMin:= 0;
        FOR i:= LoInd TO HiInd do
            IF M_AUX[i].Seconds >= TmpWTMin THEN    
                TmpWTMin:= M_AUX[i].Seconds;                                    (*Assign. higher work time TO temporary var.*)    
            END_IF;
        END_FOR;

        FOR i:= LoInd TO HiInd do
            IF M[i].SW.AutoOK and not M[i].SW.RUN THEN                          (*Determ. lowest work time pump*)
                IF M_AUX[i].Seconds <= TmpWTMin THEN
                    TmpWTMin:= M_AUX[i].Seconds;
                    TmpIndMin:= i;                                              (*Determ. lowest work time pump index*)
                END_IF;
            END_IF;
        END_FOR;
        IF (TmpIndMin < LoInd) and (TmpIndMin > HiInd) THEN
            Stage:= 5;
        ELSE
            M[TmpIndMin].CW.AutoON:= true;                                      (*Start lowest work time pump*)
            TmpFreq:= M[TmpIndMin].MinFreq;                                     (*with min. frequency*)
            Stage:= 2;
        END_IF;

    2:  M[TmpIndMin].AutoFreq:= TmpFreq;                                        (*Overclocking new pump*)
        IF OverClckTmr.Q THEN
            TmpFreq:= TmpFreq + 1.0;
        ELSIF M[TmpIndMin].AutoFreq >= (RGLTR[SysNum].Y / 10.0)  THEN
            StartPmpReq:= false;
            IF TmpRotation THEN
                Stage:= 4;
            ELSE
                Stage:= 5;
            END_IF;
        END_IF;
        
    3:  TmpWTMax:= udint#0;                                                     (*Determ. highest work time pump*)
        TmpIndMax:= 0;
        FOR i:= LoInd TO HiInd DO 
            IF M[i].SW.AutoOK and M[i].SW.RUN THEN
                IF M_AUX[i].Seconds >= TmpWTMax THEN
                    TmpWTMax:= M_AUX[i].Seconds;
                    TmpIndMax:= i;
                END_IF;
            END_IF;
        END_FOR;
        IF TmpRotation THEN
            Stage:= 1;
        ELSE
            TmpFreq:= RGLTR[SysNum].Y / 10.0;
            Stage:= 4;
        END_IF;

    4:  StopPmpReq:= true;                                                      (*Releasing highest work time pump*)
        M[TmpIndMax].AutoFreq:= TmpFreq;
        IF ReleaseTmr.Q THEN
            TmpFreq:= TmpFreq - 1.0;
        ELSIF M[TmpIndMax].AutoFreq <= M[TmpIndMax].MinFreq THEN
            M[TmpIndMax].CW.AutoON:= false;
            StopPmpReq:= false;
            Stage:= 5;
            TmpFreq:= 0.0;
        END_IF;

    5:  StartPmpReq:= false;
        StopPmpReq:= false;
        TmpPmpAlarm:= false;
        CCL[SysNum].SW.RotationON:= false;
        TmpRotation:= false;
        TmpFreq:= 0.0;
        Stage:= 0;
END_CASE;


(*============================================================================*)
    (*Main PID*)
(*============================================================================*)
RGLTR[SysNum].ActVal:= AI[7].RealValue - AI[6].RealValue;
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
