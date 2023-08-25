(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MISC
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM TimeTicks

(*Group:Default*)


VAR
	ton100MS :	TON;
	pls100MS :	R_TRIG;
	ton1S :	TON;
	pls1S :	R_TRIG;
END_VAR


VAR_EXTERNAL
	TICK_100MS :	BOOL;
	TICK_1S :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TimeTicks
IEC_LANGUAGE: ST
*)

(*================================================================================================*)
(*100ms tick*)
(*================================================================================================*)
ton100MS(IN:= not ton100MS.Q ,PT:= t#100ms);
pls100MS(CLK:= ton100MS.Q);
TICK_100MS:= pls100MS.Q;


(*================================================================================================*)
(*1s tick*)
(*================================================================================================*)
ton1S(IN:=not ton1S.Q,PT:= t#1s);
pls1S(CLK:= ton1S.Q);
TICK_1S:=pls1S.Q;


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
