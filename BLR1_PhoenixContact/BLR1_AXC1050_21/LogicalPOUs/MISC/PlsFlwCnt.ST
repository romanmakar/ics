(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MISC.FB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK PlsFlwCnt

(*Group:Default*)


VAR
	Tick :	BOOL;
	TickCount :	INT;
	TicksNum :	REAL;
	CounterPulse :	R_TRIG;
END_VAR


VAR_INPUT
	Pls :	BOOL;
	PulseWeight :	REAL;
END_VAR


VAR_OUTPUT
	Flow :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: PlsFlwCnt
IEC_LANGUAGE: ST
*)
Tick:= not Tick;

IF Tick THEN
	TickCount:= TickCount + 1;
	Tick:= false;
END_IF; 

IF TickCount > 6000 THEN
	TickCount:= 0;
	TicksNum:= 0.0;
	Flow:= 0.0;
END_IF;

CounterPulse(CLK:= Pls);

IF CounterPulse.Q THEN
	TicksNum:= int_to_real(TickCount);
	TickCount:= 0;
	Flow:= (PulseWeight * 360000.0) / (TicksNum + 1.0);
END_IF;



(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
