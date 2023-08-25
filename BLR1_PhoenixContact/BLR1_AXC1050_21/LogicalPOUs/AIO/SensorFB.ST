(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: AIO.FB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SensorFB

(*Group:Default*)


VAR_IN_OUT
    Snsr_strct :	SNSR;
END_VAR


VAR
    RealValue :	REAL;
    bar_kgf :	REAL;
END_VAR


VAR_IN_OUT
    Buff :	SNSR_BUFF;
END_VAR


VAR
    SumValue :	REAL;
    y :	INT;
    INIT :	BOOL;
    FltrValue :	REAL;
    x :	INT;
END_VAR


VAR_OUTPUT
    Event :	SNSR_EVENT;
END_VAR


VAR_IN_OUT
    Aux_strct :	SNSR_MISC;
END_VAR


VAR_EXTERNAL
    TICK_100MS_PLS :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SensorFB
IEC_LANGUAGE: ST
*)

(*============================================================================*)
(*Fault operation & converting PIW to real value*)
(*============================================================================*)
IF (Snsr_strct.PIW < 0) OR (Snsr_strct.PIW > Snsr_strct.ADC_Range) OR
    Snsr_strct.CW.ExtFault OR (Snsr_strct.DiagCode > word#16#8000) THEN         (*Snsr_strct Failed*)
    Snsr_strct.SW.Fault:= TRUE;
    RealValue:= 0.0;
ELSE                                                                            (*Snsr_strct OK*)
    IF Snsr_strct.ADC_Range <= 0 THEN
        Snsr_strct.ADC_Range:= 1;
    END_IF;
    Snsr_strct.SW.Fault:= FALSE;
    RealValue:= (Snsr_strct.Ymax - Snsr_strct.Ymin) * bar_kgf *
        INT_TO_REAL(Snsr_strct.PIW) / INT_TO_REAL(Snsr_strct.ADC_Range) +
        Snsr_strct.Ymin ;	
END_IF;

(*============================================================================*)
(*Converting from bar to kgf/sm2*)
(*============================================================================*)
IF Snsr_strct.CW.bar_kgf THEN
    bar_kgf:= 1.0197;
ELSE
    bar_kgf:= 1.0;
END_IF;	

(*============================================================================*)
(*SMA filter operation*)
(*============================================================================*)
IF INIT THEN
    IF TICK_100MS_PLS THEN
        Aux_strct.SamplingTickCount:= Aux_strct.SamplingTickCount + 1;
    END_IF;
ELSE
    Aux_strct.SamplingTickCount:= 0;
END_IF;

IF Snsr_strct.CW.FltrEn THEN
    IF NOT INIT THEN                                                            (*Initialization*)
        FOR y:= 0 TO 9 DO
            Buff[y]:= RealValue;
            SumValue:= SumValue + Buff[y];
        END_FOR;
        INIT:= TRUE;
    ELSE
        IF Aux_strct.SamplingTickCount >= (Snsr_strct.SamplingTime * 10) THEN   (*Buffer shIFting AND changing last element*)
            FOR y:= 0 TO 8 DO
                x:= y + 1;
                Buff[y]:= Buff[x];
            END_FOR;
            Buff[9]:= RealValue;
            SumValue:= SumValue + RealValue - Buff[0];
            Aux_strct.SamplingTickCount:= 0;											
        END_IF;
        FltrValue:= SumValue / 10.0;
    END_IF;
ELSE
    INIT:= FALSE;
    SumValue:= 0.0;
    FltrValue:= 0.0;  
END_IF;	

(*============================================================================*)
(*Snsr_strct output values states*)
(*============================================================================*)
IF Snsr_strct.CW.SimEn THEN                                                     (*Simulated output value*)						
    Snsr_strct.RealValue:= Snsr_strct.SimValue;
ELSIF Snsr_strct.CW.FltrEn THEN                                                 (*Filtered output value*)
    Snsr_strct.RealValue:= FltrValue;
ELSE                                                                            (*Real output value*)
    Snsr_strct.RealValue:= RealValue;
END_IF;

Snsr_strct.IntValue:= REAL_TO_INT(Snsr_strct.RealValue * 100.0);

(*============================================================================*)
(*Limits operation*)
(*============================================================================*)
IF Snsr_strct.CW.LimEn THEN
    IF (Snsr_strct.RealValue > (Snsr_strct.HH + (Snsr_strct.DeadBand / 2.0))) and
        not Snsr_strct.SW.HH_alarm  THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.HHTopDelayCount:= Aux_strct.HHTopDelayCount + 1;
        END_IF;
        IF Aux_strct.HHTopDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.HH_alarm:= true;
        END_IF;
    ELSE
        Aux_strct.HHTopDelayCount:= 0;
    END_IF;


    IF (Snsr_strct.RealValue < (Snsr_strct.HH - (Snsr_strct.DeadBand / 2.0))) and
        Snsr_strct.SW.HH_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.HHBotDelayCount:= Aux_strct.HHBotDelayCount + 1;
        END_IF;
        IF Aux_strct.HHBotDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.HH_alarm:= false;
        END_IF;
    ELSE
        Aux_strct.HHBotDelayCount:= 0;
    END_IF;


    IF (Snsr_strct.RealValue > (Snsr_strct.HL + (Snsr_strct.DeadBand / 2.0))) and
        not Snsr_strct.SW.HL_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.HLTopDelayCount:= Aux_strct.HLTopDelayCount + 1;
        END_IF;
        IF Aux_strct.HLTopDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.HL_alarm:= true;
        END_IF;
    ELSE
        Aux_strct.HLTopDelayCount:= 0;
    END_IF;


    IF (Snsr_strct.RealValue < (Snsr_strct.HL - (Snsr_strct.DeadBand / 2.0))) and
        Snsr_strct.SW.HL_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.HLBotDelayCount:= Aux_strct.HLBotDelayCount + 1;
        END_IF;
        IF Aux_strct.HLBotDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.HL_alarm:= false;
        END_IF;
    ELSE
        Aux_strct.HLBotDelayCount:= 0;
    END_IF;
    

    IF (Snsr_strct.RealValue < (Snsr_strct.LH - (Snsr_strct.DeadBand / 2.0))) and
        not Snsr_strct.SW.LH_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.LHTopDelayCount:= Aux_strct.LHTopDelayCount + 1;
        END_IF;
        IF Aux_strct.LHTopDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.LH_alarm:= true;
        END_IF;
    ELSE
        Aux_strct.LHTopDelayCount:= 0;
    END_IF;


    IF (Snsr_strct.RealValue > (Snsr_strct.LH + (Snsr_strct.DeadBand / 2.0))) and
        Snsr_strct.SW.LH_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.LHBotDelayCount:= Aux_strct.LHBotDelayCount + 1;
        END_IF;
        IF Aux_strct.LHBotDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.LH_alarm:= false;
        END_IF;
    ELSE
        Aux_strct.LHBotDelayCount:= 0;
    END_IF;


    IF (Snsr_strct.RealValue < (Snsr_strct.LL - (Snsr_strct.DeadBand / 2.0))) and
        not Snsr_strct.SW.LL_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.LLTopDelayCount:= Aux_strct.LLTopDelayCount + 1;
        END_IF;
        IF Aux_strct.LLTopDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.LL_alarm:= true;
        END_IF;
    ELSE
        Aux_strct.LLTopDelayCount:= 0;
    END_IF;


    IF (Snsr_strct.RealValue > (Snsr_strct.LL + (Snsr_strct.DeadBand / 2.0))) and
        Snsr_strct.SW.LL_alarm THEN
        IF TICK_100MS_PLS THEN
            Aux_strct.LLBotDelayCount:= Aux_strct.LLBotDelayCount + 1;
        END_IF;
        IF Aux_strct.LLBotDelayCount > (Snsr_strct.LimDelay * 10) THEN
            Snsr_strct.SW.LL_alarm:= false;
        END_IF;
    ELSE
        Aux_strct.LLBotDelayCount:= 0;
    END_IF;

ELSE
    Aux_strct.HHTopDelayCount:= 0;
    Aux_strct.HHBotDelayCount:= 0;

    Aux_strct.HLTopDelayCount:= 0;
    Aux_strct.HLBotDelayCount:= 0;

    Aux_strct.LHTopDelayCount:= 0;
    Aux_strct.LHBotDelayCount:= 0;

    Aux_strct.LLTopDelayCount:= 0;
    Aux_strct.LLBotDelayCount:= 0;

    Snsr_strct.SW.HH_alarm:= FALSE;
    Snsr_strct.SW.HL_alarm:= FALSE;
    Snsr_strct.SW.LH_alarm:= FALSE;
    Snsr_strct.SW.LL_alarm:= FALSE;
END_IF;

    
(*============================================================================*)
(*Sensor Pulse Events*)
(*============================================================================*)

Event.Fault:= false;
IF Snsr_strct.SW.Fault and not Aux_strct.EVENT_1 THEN
    Event.Fault:= true;
    Aux_strct.EVENT_1:= true;
ELSIF not Snsr_strct.SW.Fault THEN
    Aux_strct.EVENT_1:= false;
END_IF;

Event.HH:= false;
IF Snsr_strct.SW.HH_alarm and not Aux_strct.EVENT_2 THEN
    Event.HH:= true;
    Aux_strct.EVENT_2:= true;
ELSIF not Snsr_strct.SW.HH_alarm THEN
    Aux_strct.EVENT_2:= false;
END_IF;

Event.HL:= false;
IF Snsr_strct.SW.HL_alarm and not Aux_strct.EVENT_3 THEN
    Event.HL:= true;
    Aux_strct.EVENT_3:= true;
ELSIF not Snsr_strct.SW.HL_alarm THEN
    Aux_strct.EVENT_3:= false;
END_IF;

Event.LH:= false;
IF Snsr_strct.SW.LH_alarm and not Aux_strct.EVENT_4 THEN
    Event.LH:= true;
    Aux_strct.EVENT_4:= true;
ELSIF not Snsr_strct.SW.LH_alarm THEN
    Aux_strct.EVENT_4:= false;
END_IF;

Event.LL:= false;
IF Snsr_strct.SW.LL_alarm and not Aux_strct.EVENT_5 THEN
    Event.LL:= true;
    Aux_strct.EVENT_5:= true;
ELSIF not Snsr_strct.SW.LL_alarm THEN
    Aux_strct.EVENT_5:= false;
END_IF;


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
