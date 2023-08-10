(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MB
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK MB_TO_REAL

(*Group:Default*)


VAR
	ReSyBasic_IEEEToRealV10_1 :	ReSyBasic_IEEEToRealV10;
	ReSyBasic_WordToByteV01_1 :	ReSyBasic_WordToByteV01;
	ReSyBasic_WordToByteV01_2 :	ReSyBasic_WordToByteV01;
END_VAR


VAR_INPUT
	IN_LoWord :	WORD;
	IN_HiWord :	WORD;
END_VAR


VAR
	ValMantMid :	BYTE;
	ValMantLow :	BYTE;
	ValExp :	BYTE;
	ValMantHigh :	BYTE;
END_VAR


VAR_OUTPUT
	Float :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_TO_REAL
IEC_LANGUAGE: ST
*)

		(*Converting Low WORD to Low BYTEs*)
ReSyBasic_WordToByteV01_1(IN_LX_DisablePou:=false,IN_LW_1:=IN_LoWord);
ValMantMid:=ReSyBasic_WordToByteV01_1.OUT_LB_High;
ValMantLow:=ReSyBasic_WordToByteV01_1.OUT_LB_Low;

		(*Converting High WORD to High BYTEs*)
ReSyBasic_WordToByteV01_2(IN_LX_DisablePou:=false,IN_LW_1:=IN_HiWord);
ValExp:=ReSyBasic_WordToByteV01_2.OUT_LB_High;
ValMantHigh:=ReSyBasic_WordToByteV01_2.OUT_LB_Low;

		(*Converting BYTEs to REAL*)
ReSyBasic_IEEEToRealV10_1(IN_LX_DisablePou:=false,
	IN_LB_ValueMantissaLow:=ValMantLow,
	IN_LB_ValueMantissaMiddle:=ValMantMid,
	IN_LB_ValueMantissaHigh:=ValMantHigh,
	IN_LB_ValueExponent:=ValExp);
	
Float:=ReSyBasic_IEEEToRealV10_1.OUT_LR_Value;

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
