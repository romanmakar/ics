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
PROGRAM TICK_100MS

(*Group:Default*)


VAR
	RS_1 :	RS;
	R_TRIG_1 :	R_TRIG;
END_VAR


VAR_EXTERNAL
	TICK_100MS :	BOOL;
	TICK_100MS_PLS :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: TICK_100MS
IEC_LANGUAGE: ST
*)
RS_1(SET:= not TICK_100MS,RESET1:=TICK_100MS);
TICK_100MS:=RS_1.Q1;

R_TRIG_1(CLK:=TICK_100MS);
TICK_100MS_PLS:=R_TRIG_1.Q;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
