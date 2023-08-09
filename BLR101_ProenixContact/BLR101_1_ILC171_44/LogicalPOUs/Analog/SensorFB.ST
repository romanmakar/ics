(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Analog
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SensorFB

(*Group:Default*)


VAR_IN_OUT
	Snsr_strct :	Snsr;
END_VAR


VAR
	RealValue :	REAL;
	bar_kgf :	REAL;
	CycTmr :	TON;
	Buff :	Snsr_Buff;
	SumValue :	REAL;
	y :	INT;
	INIT :	BOOL;
	FltrValue :	REAL;
	x :	INT;
	tonHHTopDelay :	TON;
	tonHHBotDelay :	TON;
	tonHLTopDelay :	TON;
	tonHLBotDelay :	TON;
	tonLHTopDelay :	TON;
	tonLHBotDelay :	TON;
	tonLLTopDelay :	TON;
	tonLLBotDelay :	TON;
	plsHH :	R_TRIG;
	plsHL :	R_TRIG;
	plsLH :	R_TRIG;
	plsLL :	R_TRIG;
END_VAR


VAR_OUTPUT
	SnsrPLS :	Snsr_PLS;
END_VAR


(*@KEY@: WORKSHEET
NAME: SensorFB
IEC_LANGUAGE: ST
*)

	(*Fault operation*)
IF (Snsr_strct.PIW < 0) OR (Snsr_strct.PIW > Snsr_strct.ADC_Range) OR Snsr_strct.CW.ExtFault (*OR (Snsr_strct.DiagCode <> word#8000)*) THEN		(*Snsr_strct Failed*)
	Snsr_strct.SW.Fault:= TRUE;
	RealValue:= 0.0;
ELSE                                                                    					(*Snsr_strct OK*)
	IF Snsr_strct.ADC_Range <= 0 THEN
		Snsr_strct.ADC_Range:= 1;
	END_IF;
	Snsr_strct.SW.Fault:= FALSE;
	RealValue:= Snsr_strct.k * bar_kgf * INT_TO_REAL(Snsr_strct.PIW) / INT_TO_REAL(Snsr_strct.ADC_Range) + Snsr_strct.b;	
END_IF;

	(*Converting from bar to kgf/sm2*)
IF Snsr_strct.CW.bar_kgf THEN
	bar_kgf:= 1.0197;
ELSE
	bar_kgf:= 1.0;
END_IF;	


	(*SMA filter operation*)
CycTmr(IN:= NOT CycTmr.Q AND INIT, PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.SamplingTime * 1000)));		(*Sample puls generator*)
IF Snsr_strct.CW.FltrEn THEN
	IF NOT INIT THEN																					(*Initialization*)
		FOR y:= 0 TO 9 DO
			Buff[y]:= RealValue;
			SumValue:= SumValue + Buff[y];
		END_FOR;
		INIT:= TRUE;
	ELSE
		IF CycTmr.Q THEN																				(*Buffer shifting and changing last element*)
			FOR y:= 0 TO 8 DO
				x:= y + 1;
				Buff[y]:= Buff[x];
			END_FOR;
			Buff[9]:= RealValue;
			SumValue:= SumValue + RealValue - Buff[0];											
		END_IF;
		FltrValue:= SumValue / 10.0;
	END_IF;
ELSE
	INIT:= FALSE;
	SumValue:= 0.0;
	FltrValue:= 0.0;  
END_IF;	

	(*Snsr_strct output values states*)
IF Snsr_strct.CW.SimEn THEN															(*Simulated output value*)						
	Snsr_strct.RealValue:= Snsr_strct.SimValue;
ELSIF Snsr_strct.CW.FltrEn THEN														(*Filtered output value*)
	Snsr_strct.RealValue:= FltrValue;
ELSE																				(*Real output value*)
	Snsr_strct.RealValue:= RealValue;
END_IF;

Snsr_strct.IntValue:= REAL_TO_INT(Snsr_strct.RealValue * 10.0);

	(*Limits operation*)
IF Snsr_strct.CW.LimEn THEN

	tonHHTopDelay(IN:= Snsr_strct.RealValue >= (Snsr_strct.HH + (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonHHTopDelay.Q THEN
		Snsr_strct.SW.HH_alarm:= TRUE;
	END_IF;
	plsHH(CLK:= tonHHTopDelay.Q);
	SnsrPLS.HH_PLS:=plsHH.Q;

	tonHHBotDelay(IN:= Snsr_strct.RealValue <= (Snsr_strct.HH - (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonHHBotDelay.Q THEN
		Snsr_strct.SW.HH_alarm:= FALSE;
	END_IF;
	
	tonHLTopDelay(IN:= Snsr_strct.RealValue >= (Snsr_strct.HL + (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonHLTopDelay.Q THEN
		Snsr_strct.SW.HL_alarm:= TRUE;
	END_IF;
	plsHL(CLK:= tonHLTopDelay.Q);
	SnsrPLS.HL_PLS:=plsHL.Q;
	
	tonHLBotDelay(IN:= Snsr_strct.RealValue <= (Snsr_strct.HL - (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonHLBotDelay.Q THEN
		Snsr_strct.SW.HL_alarm:= FALSE;
	END_IF;
	
	tonLHTopDelay(IN:= Snsr_strct.RealValue <= (Snsr_strct.LH - (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonLHTopDelay.Q THEN
		Snsr_strct.SW.LH_alarm:= TRUE;
	END_IF;
	plsLH(CLK:= tonLHTopDelay.Q);
	SnsrPLS.LH_PLS:=plsLH.Q;
	
	tonLHBotDelay(IN:= Snsr_strct.RealValue >= (Snsr_strct.LH + (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonLHBotDelay.Q THEN
		Snsr_strct.SW.LH_alarm:= FALSE;
	END_IF;
	
	tonLLTopDelay(IN:= Snsr_strct.RealValue <= (Snsr_strct.LL - (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonLLTopDelay.Q THEN
		Snsr_strct.SW.LL_alarm:= TRUE;
	END_IF;
	plsLL(CLK:= tonLLTopDelay.Q);
	SnsrPLS.LL_PLS:=plsLL.Q;
	
	tonLLBotDelay(IN:= Snsr_strct.RealValue >= (Snsr_strct.LL + (Snsr_strct.DeadBand / 2.0)), PT:= DINT_TO_TIME(INT_TO_DINT(Snsr_strct.LimDelay * 1000)));
	IF tonLLBotDelay.Q THEN
		Snsr_strct.SW.LL_alarm:= FALSE;
	END_IF;
ELSE
		Snsr_strct.SW.HH_alarm:= FALSE;
		Snsr_strct.SW.HL_alarm:= FALSE;
		Snsr_strct.SW.LH_alarm:= FALSE;
		Snsr_strct.SW.LL_alarm:= FALSE;
END_IF;

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
