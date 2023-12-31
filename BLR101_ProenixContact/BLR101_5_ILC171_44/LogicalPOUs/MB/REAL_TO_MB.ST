(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MB.FB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK REAL_TO_MB

(*Group:Default*)


VAR_OUTPUT
	LoWord :	WORD;
	HiWord :	WORD;
END_VAR


VAR_INPUT
	IN :	REAL;
END_VAR


VAR
	SYS_RealTo_IEEE_1_1 :	SYS_RealTo_IEEE_1;
	IEEE :	SYS_ARR_B_1_4;
END_VAR


(*@KEY@: WORKSHEET
NAME: REAL_TO_MB
IEC_LANGUAGE: ST
*)

SYS_RealTo_IEEE_1_1(rValue:=IN);
IEEE:=SYS_RealTo_IEEE_1_1.arrIEEE_Float;

LoWord.B0:= IEEE[1];
LoWord.B1:= IEEE[2];
HiWord.B0:= IEEE[3];
HiWord.B1:= IEEE[4];
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
