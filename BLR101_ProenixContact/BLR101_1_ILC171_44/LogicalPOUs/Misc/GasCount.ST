(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Miscellaneous
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM GasCount

(*Group:Default*)


VAR
	Tick :	BOOL;
	TickCount :	INT;
	GasCounterPulse :	R_TRIG;
END_VAR


VAR_EXTERNAL
	GasCntPls :	BOOL;
END_VAR


VAR
	TicksNum :	REAL;
	GasFlow :	REAL;
	FlowPerTick :	REAL;
END_VAR


VAR_EXTERNAL
	Boiler :	Blr;
END_VAR


(*@KEY@: WORKSHEET
NAME: GasCount
IEC_LANGUAGE: ST
*)
Tick:= not Tick;

if Tick then
	TickCount:= TickCount + 1;
	Tick:= false;
end_if; 

if TickCount > 6000 then
	TickCount:= 0;
	TicksNum:= 0.0;
end_if;

GasCounterPulse(CLK:=GasCntPls);

if GasCounterPulse.Q then
	TicksNum:= int_to_real(TickCount);
	TickCount:= 0;
end_if;

GasFlow:= (360000.0 * TicksNum) / (TicksNum * TicksNum + 1.0);
Boiler.Brn1.AI[3].RealValue:= GasFlow;
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
