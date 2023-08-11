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
FUNCTION_BLOCK REAL_TO_MB

(*Group:Default*)


VAR
    ReSyBasic_RealToIEEEV10_1 :	ReSyBasic_RealToIEEEV10;
END_VAR


VAR_INPUT
    IN_Val :	REAL;
END_VAR


VAR
    ValMantLow :	BYTE;
    ValMantMid :	BYTE;
    ValMantHigh :	BYTE;
    ValExp :	BYTE;
    ReSyBasic_ByteToWordV01_1 :	ReSyBasic_ByteToWordV01;
    ReSyBasic_ByteToWordV01_2 :	ReSyBasic_ByteToWordV01;
END_VAR


VAR_OUTPUT
    LoWord :	WORD;
    HiWord :	WORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: REAL_TO_MB
IEC_LANGUAGE: ST
*)

        (*Converting REAL to BYTE*)
ReSyBasic_RealToIEEEV10_1(IN_LX_DisablePou:= false,IN_LR_Value:= IN_Val);
ValMantLow:=ReSyBasic_RealToIEEEV10_1.OUT_LB_ValueMantissaLow;
ValMantMid:=ReSyBasic_RealToIEEEV10_1.OUT_LB_ValueMantissaMiddle;
ValMantHigh:=ReSyBasic_RealToIEEEV10_1.OUT_LB_ValueMantissaHigh;
ValExp:=ReSyBasic_RealToIEEEV10_1.OUT_LB_ValueExponent;

        (*Converting Low BYTEs to WORD*)
ReSyBasic_ByteToWordV01_1(IN_LX_DisablePou:=false,
    IN_LB_ValueHigh:=ValMantMid,
    IN_LB_ValueLow:=ValMantLow);

LoWord:=ReSyBasic_ByteToWordV01_1.OUT_LW_Value;

        (*Converting High BYTEs to WORD*)
ReSyBasic_ByteToWordV01_2(IN_LX_DisablePou:=false,
    IN_LB_ValueHigh:=ValExp,
    IN_LB_ValueLow:=ValMantHigh);
    
HiWord:=ReSyBasic_ByteToWordV01_2.OUT_LW_Value;

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
