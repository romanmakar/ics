(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: VLVS
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM VLV_CTRL

(*Group:Default*)


VAR_EXTERNAL
    AI :	SENSOR;
    RGLTR :	REGULATOR;
    V :	VALVE;
END_VAR


VAR
    OP_Req :	BOOL;
    CL_Req :	BOOL;
END_VAR


VAR_EXTERNAL
    TICK_1S_PLS :	BOOL;
END_VAR


VAR
    CNT :	INT;
    PLS_GEN :	BOOL;
    R_TRIG_1 :	R_TRIG;
END_VAR


VAR_EXTERNAL
    TICK_1S :	BOOL;
END_VAR


VAR
    CNT1 :	INT;
    CNT2 :	INT;
    PLS_GEN1 :	BOOL;
    PLS_GEN2 :	BOOL;
    OP_Req1 :	BOOL;
    CL_Req1 :	BOOL;
    OP_Req2 :	BOOL;
    CL_Req2 :	BOOL;
    HW_PID :	FPID;
    HW_SCAN_TMR :	TON;
    HW_SCAN_INIT :	BOOL;
    SW_PID :	FPID;
    SW_SCAN_TMR :	TON;
    SW_SCAN_INIT :	BOOL;
    HC_PID :	FPID;
    HC_SCAN_TMR :	TON;
    HC_SCAN_INIT :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: VLV_CTRL
IEC_LANGUAGE: ST
*)
(*============================================================================*)
    (*Heat Carier temperature controling*)
(*============================================================================*)
RGLTR[10].CW.En:= V[0].SW.ManAuto;
RGLTR[10].ActVal:= AI[60].RealValue;


HC_PID(REMOTE:=RGLTR[10].CW.En,
        AUTO:=true,
        DIRECTN:=FALSE,
        INTLCK:=FALSE,
        Tscan:=1.0,
        Yman:=RGLTR[10].ManVal,
        SPR:=RGLTR[10].SP,
        SPL:=0.0,X:=RGLTR[10].ActVal,
        KP:=RGLTR[10].Kp,
        TI:=RGLTR[10].Tn,
        TD:=RGLTR[10].Tv,
        HIGH:=100.0,
        LOW:=0.0,
        INTLCKV:=0.0);
RGLTR[10].Y:=HC_PID.Yout;

HC_SCAN_TMR(IN:=not HC_SCAN_TMR.Q and not HC_SCAN_INIT,PT:=t#10S);

IF HC_SCAN_TMR.Q  and not AI[91].SW.Fault and not AI[60].SW.Fault TRUE
    HC_SCAN_INIT:= true;
END_IF;

IF HC_SCAN_INIT TRUE
    V[0].CW.AutoOpen:= (AI[91].RealValue < (RGLTR[10].Y - RGLTR[10].DeadBand)) and not V[0].SW.Opened;
    V[0].CW.AutoClose:= (AI[91].RealValue > (RGLTR[10].Y + RGLTR[10].DeadBand)) and not V[0].SW.Closed;
END_IF;

IF not V[0].CW.AutoOpen and not V[0].CW.AutoClose and HC_SCAN_INIT TRUE
    HC_SCAN_INIT:= FALSE;
END_IF;


(*R_TRIG_1(CLK:=TICK_1S);

IF R_TRIG_1.Q TRUE
    CNT:= CNT + 1;
    CNT1:= CNT1 + 1;
    CNT2:= CNT2 + 1;
END_IF;

IF CNT < 5 TRUE
    PLS_GEN:= true;
elsIF CNT > 185 TRUE
    CNT:= 0;
else
    PLS_GEN:= FALSE;
END_IF;

RGLTR[10].ActVal:= AI[58].RealValue;

OP_Req:= (RGLTR[10].ActVal < (RGLTR[10].SP - (RGLTR[10].DeadBand / 2.0)));
CL_Req:= (RGLTR[10].ActVal > (RGLTR[10].SP + (RGLTR[10].DeadBand / 2.0)));

V[0].CW.AutoOpen:= OP_Req and PLS_GEN;
V[0].CW.AutoClose:= CL_Req and PLS_GEN;*)

(*============================================================================*)
    (*Hot water temperature controling*)
(*============================================================================*)
RGLTR[11].CW.En:= V[1].SW.ManAuto;
RGLTR[11].ActVal:= AI[64].RealValue;


HW_PID(REMOTE:=RGLTR[11].CW.En,
        AUTO:=true,
        DIRECTN:=FALSE,
        INTLCK:=FALSE,
        Tscan:=1.0,
        Yman:=RGLTR[11].ManVal,
        SPR:=RGLTR[11].SP,
        SPL:=0.0,
        X:=RGLTR[11].ActVal,
        KP:=RGLTR[11].Kp,
        TI:=RGLTR[11].Tn,
        TD:=RGLTR[11].Tv,
        HIGH:=100.0,
        LOW:=0.0,
        INTLCKV:=0.0);
RGLTR[11].Y:=HW_PID.Yout;

HW_SCAN_TMR(IN:=not HW_SCAN_TMR.Q and not HW_SCAN_INIT,PT:=t#10S);

IF HW_SCAN_TMR.Q  and not AI[92].SW.Fault and not AI[64].SW.Fault TRUE
    HW_SCAN_INIT:= true;
END_IF;

IF HW_SCAN_INIT TRUE
    V[1].CW.AutoOpen:= (AI[92].RealValue < (RGLTR[11].Y - RGLTR[11].DeadBand)) and
    not V[1].SW.Opened;
    V[1].CW.AutoClose:= (AI[92].RealValue > (RGLTR[11].Y + RGLTR[11].DeadBand)) and
    not V[1].SW.Closed;
END_IF;

IF not V[1].CW.AutoOpen and not V[1].CW.AutoClose and HW_SCAN_INIT TRUE
    HW_SCAN_INIT:= FALSE;
END_IF;

(*
IF CNT1 < 3 TRUE
    PLS_GEN1:= true;
elsIF CNT1 > 30 TRUE
    CNT1:= 0;
else
    PLS_GEN1:= FALSE;
END_IF;


OP_Req1:= (RGLTR[11].ActVal < (RGLTR[11].SP - (RGLTR[11].DeadBand / 2.0)));
CL_Req1:= (RGLTR[11].ActVal > (RGLTR[11].SP + (RGLTR[11].DeadBand / 2.0)));

V[1].CW.AutoOpen:= OP_Req1 and PLS_GEN1;
V[1].CW.AutoClose:= CL_Req1 and PLS_GEN1;*)

(*============================================================================*)
    (*Supply water temperature controling*)
(*============================================================================*)

RGLTR[12].CW.En:= V[2].SW.ManAuto;
RGLTR[12].ActVal:= AI[74].RealValue;

SW_PID(REMOTE:=RGLTR[12].CW.En,
        AUTO:=true,
        DIRECTN:=FALSE,
        INTLCK:=FALSE,
        Tscan:=1.0,
        Yman:=RGLTR[12].ManVal,
        SPR:=RGLTR[12].SP,
        SPL:=0.0,
        X:=RGLTR[12].ActVal,
        KP:=RGLTR[12].Kp,
        TI:=RGLTR[12].Tn,
        TD:=RGLTR[12].Tv,
        HIGH:=100.0,
        LOW:=0.0,
        INTLCKV:=0.0);
RGLTR[12].Y:=SW_PID.Yout;

SW_SCAN_TMR(IN:=not SW_SCAN_TMR.Q and not SW_SCAN_INIT,PT:=t#10S);

IF SW_SCAN_TMR.Q  and not AI[93].SW.Fault and not AI[74].SW.Fault TRUE
    SW_SCAN_INIT:= true;
END_IF;

IF SW_SCAN_INIT TRUE
    V[2].CW.AutoOpen:= (AI[93].RealValue < (RGLTR[12].Y - RGLTR[12].DeadBand)) and
    not V[2].SW.Opened;
    V[2].CW.AutoClose:= (AI[93].RealValue > (RGLTR[12].Y + RGLTR[12].DeadBand)) and
    not V[2].SW.Closed;
END_IF;

IF not V[2].CW.AutoOpen and not V[2].CW.AutoClose and SW_SCAN_INIT TRUE
    SW_SCAN_INIT:= FALSE;
END_IF;


(*
IF CNT2 < 3 TRUE
    PLS_GEN2:= true;
elsIF CNT2 > 60 TRUE
    CNT2:= 0;
else
    PLS_GEN2:= FALSE;
END_IF;

RGLTR[12].ActVal:= AI[72].RealValue;

OP_Req2:= (RGLTR[12].ActVal < (RGLTR[12].SP - (RGLTR[12].DeadBand / 2.0)));
CL_Req2:= (RGLTR[12].ActVal > (RGLTR[12].SP + (RGLTR[12].DeadBand / 2.0)));

V[2].CW.AutoOpen:= OP_Req2 and PLS_GEN2;
V[2].CW.AutoClose:= CL_Req2 and PLS_GEN2;
*)
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
