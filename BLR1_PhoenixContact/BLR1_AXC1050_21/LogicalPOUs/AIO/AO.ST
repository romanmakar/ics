(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: AIO
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM AO

(*Group:NewGroup*)


VAR
    AXL_ANALOG_OUT_1 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A07_OUT0 :	INT;
    BK_PnioDataValid :	BOOL;
    A07_IN0 :	INT;
END_VAR


VAR
    OUT1_Valid :	BOOL;
    OUT1_Status :	WORD;
    AXL_ANALOG_OUT_2 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A07_IN1 :	INT;
    A07_OUT1 :	INT;
END_VAR


VAR
    OUT2_Status :	WORD;
    OUT2_Valid :	BOOL;
    AXL_ANALOG_OUT_3 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A07_IN2 :	INT;
    A07_OUT2 :	INT;
    M :	MOTOR;
END_VAR


VAR
    OUT3_Valid :	BOOL;
    OUT3_Status :	WORD;
    AXL_ANALOG_OUT_4 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A07_OUT3 :	INT;
END_VAR


VAR
    OUT4_Valid :	BOOL;
    OUT4_Status :	WORD;
    AXL_ANALOG_OUT_5 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A07_IN4 :	INT;
END_VAR


VAR
    OUT5_Valid :	BOOL;
    OUT5_Status :	WORD;
    AXL_ANALOG_OUT_6 :	AXL_ANALOG_OUT_V1_00;
    AXL_ANALOG_OUT_7 :	AXL_ANALOG_OUT_V1_00;
    AXL_ANALOG_OUT_8 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A116_IN0 :	INT;
    A116_OUT0 :	INT;
END_VAR


VAR
    OUT6_Valid :	BOOL;
    OUT6_Status :	WORD;
END_VAR


VAR_EXTERNAL
    A116_IN1 :	INT;
    A116_OUT1 :	INT;
END_VAR


VAR
    OUT7_Valid :	BOOL;
    OUT7_Status :	WORD;
END_VAR


VAR_EXTERNAL
    A116_IN2 :	INT;
    A116_OUT2 :	INT;
END_VAR


VAR
    OUT8_Valid :	BOOL;
    OUT8_Status :	WORD;
    AXL_ANALOG_OUT_9 :	AXL_ANALOG_OUT_V1_00;
    AXL_ANALOG_OUT_10 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A116_IN3 :	INT;
END_VAR


VAR
    OUT9_Valid :	BOOL;
    OUT9_Status :	WORD;
END_VAR


VAR_EXTERNAL
    A116_IN4 :	INT;
    A116_OUT4 :	INT;
END_VAR


VAR
    OUT10_Valid :	BOOL;
    OUT10_Status :	WORD;
    AXL_ANALOG_OUT_11 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A116_IN5 :	INT;
    A116_OUT5 :	INT;
END_VAR


VAR
    OUT11_Valid :	BOOL;
    OUT11_Status :	WORD;
    AXL_ANALOG_OUT_12 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A116_IN6 :	INT;
    A116_OUT6 :	INT;
END_VAR


VAR
    OUT12_Valid :	BOOL;
    OUT12_Status :	WORD;
    AXL_ANALOG_OUT_13 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A116_IN7 :	INT;
    A116_OUT7 :	INT;
END_VAR


VAR
    OUT13_Valid :	BOOL;
    OUT13_Status :	WORD;
    AXL_ANALOG_OUT_14 :	AXL_ANALOG_OUT_V1_00;
END_VAR


VAR_EXTERNAL
    A117_IN0 :	INT;
    A117_OUT0 :	INT;
END_VAR


VAR
    OUT14_Valid :	BOOL;
    OUT14_Status :	WORD;
END_VAR


VAR_EXTERNAL
    M_AUX :	MOTOR_MISC;
END_VAR


VAR
    Blrs1_SetPower :	REAL;
    Blrs2_SetPower :	REAL;
END_VAR


VAR_EXTERNAL
    A07_IN3 :	INT;
    A07_OUT4 :	INT;
    A116_OUT3 :	INT;
END_VAR


VAR
    PmpA2_SetDose :	REAL;
    PmpA3_SetDose :	REAL;
    PmpA11_SetDose :	REAL;
    PmpA12_SetDose :	REAL;
    test :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AO
IEC_LANGUAGE: ST
*)

(*============================================================================*)	
    (*Boilers 1.x set power*)
(*============================================================================*)
AXL_ANALOG_OUT_1(rValue:= Blrs1_SetPower,
    rLimitLow:= 0.0,
    rLimitHigh:= 100.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A07_IN0,
    xPnioDataValid:= true);

A07_OUT0:=AXL_ANALOG_OUT_1.iAnalogOut;
OUT1_Valid:=AXL_ANALOG_OUT_1.xValid;
OUT1_Status:=AXL_ANALOG_OUT_1.wStatus;

(*============================================================================*)	
    (*Boilers 2.x set power*)
(*============================================================================*)
AXL_ANALOG_OUT_2(rValue:= Blrs2_SetPower,
    rLimitLow:= 0.0,
    rLimitHigh:= 100.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A07_IN1,
    xPnioDataValid:= true);

A07_OUT1:=AXL_ANALOG_OUT_2.iAnalogOut;
OUT2_Valid:=AXL_ANALOG_OUT_2.xValid;
OUT2_Status:=AXL_ANALOG_OUT_2.wStatus;

(*============================================================================*)	
    (*UZ5100 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_3(rValue:= M_AUX[8].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A07_IN2,
    xPnioDataValid:= true);

A07_OUT2:=AXL_ANALOG_OUT_3.iAnalogOut;
OUT3_Valid:=AXL_ANALOG_OUT_3.xValid;
OUT3_Status:=AXL_ANALOG_OUT_3.wStatus;

(*============================================================================*)	
    (*UZ5200 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_4(rValue:= M_AUX[9].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A07_IN3,
    xPnioDataValid:= true);

A07_OUT3:=AXL_ANALOG_OUT_4.iAnalogOut;
OUT4_Valid:=AXL_ANALOG_OUT_4.xValid;
OUT4_Status:=AXL_ANALOG_OUT_4.wStatus;

(*============================================================================*)	
    (*UZ5300 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_5(rValue:= M_AUX[10].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A07_IN4,
    xPnioDataValid:= true);

A07_OUT4:=AXL_ANALOG_OUT_5.iAnalogOut;
OUT5_Valid:=AXL_ANALOG_OUT_5.xValid;
OUT5_Status:=AXL_ANALOG_OUT_5.wStatus;

(*============================================================================*)	
    (*UZ3100 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_6(rValue:= M_AUX[5].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN0,
    xPnioDataValid:= true);

A116_OUT0:=AXL_ANALOG_OUT_6.iAnalogOut;
OUT6_Valid:=AXL_ANALOG_OUT_6.xValid;
OUT6_Status:=AXL_ANALOG_OUT_6.wStatus;

(*============================================================================*)	
    (*UZ3200 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_7(rValue:= M_AUX[6].SetValue
    ,rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN1,
    xPnioDataValid:= true);

A116_OUT1:=AXL_ANALOG_OUT_7.iAnalogOut;
OUT7_Valid:=AXL_ANALOG_OUT_7.xValid;
OUT7_Status:=AXL_ANALOG_OUT_7.wStatus;

(*============================================================================*)	
    (*UZ3300 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_8(rValue:= M_AUX[7].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN2,
    xPnioDataValid:= true);

A116_OUT2:=AXL_ANALOG_OUT_8.iAnalogOut;
OUT8_Valid:=AXL_ANALOG_OUT_8.xValid;
OUT8_Status:=AXL_ANALOG_OUT_8.wStatus;

(*============================================================================*)	
    (*UZ6100 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_9(rValue:= M_AUX[11].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN3,
    xPnioDataValid:= true);

A116_OUT3:=AXL_ANALOG_OUT_9.iAnalogOut;
OUT9_Valid:=AXL_ANALOG_OUT_9.xValid;
OUT9_Status:=AXL_ANALOG_OUT_9.wStatus;

(*============================================================================*)	
    (*UZ6200 set frequency*)
(*============================================================================*)
AXL_ANALOG_OUT_10(rValue:= M_AUX[12].SetValue,
    rLimitLow:= 0.0,
    rLimitHigh:= 50.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN4,
    xPnioDataValid:= true);

A116_OUT4:=AXL_ANALOG_OUT_10.iAnalogOut;
OUT10_Valid:=AXL_ANALOG_OUT_10.xValid;
OUT10_Status:=AXL_ANALOG_OUT_10.wStatus;

(*============================================================================*)	
    (*A2 dose pump set capacity*)
(*============================================================================*)
AXL_ANALOG_OUT_11(rValue:= PmpA2_SetDose,
    rLimitLow:= 0.0,
    rLimitHigh:= 100.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN5,
    xPnioDataValid:= true);

A116_OUT5:=AXL_ANALOG_OUT_11.iAnalogOut;
OUT11_Valid:=AXL_ANALOG_OUT_11.xValid;
OUT11_Status:=AXL_ANALOG_OUT_11.wStatus;

(*============================================================================*)	
    (*A3 dose pump set capacity*)
(*============================================================================*)
AXL_ANALOG_OUT_12(rValue:= PmpA3_SetDose,
    rLimitLow:= 0.0,
    rLimitHigh:= 100.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN6,
    xPnioDataValid:= true);

A116_OUT6:=AXL_ANALOG_OUT_12.iAnalogOut;
OUT12_Valid:=AXL_ANALOG_OUT_12.xValid;
OUT12_Status:=AXL_ANALOG_OUT_12.wStatus;

(*============================================================================*)	
    (*A11 dose pump set capacity*)
(*============================================================================*)
AXL_ANALOG_OUT_13(rValue:= PmpA11_SetDose,
    rLimitLow:= 0.0,
    rLimitHigh:= 100.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A116_IN7,
    xPnioDataValid:= true);

A116_OUT7:=AXL_ANALOG_OUT_13.iAnalogOut;
OUT13_Valid:=AXL_ANALOG_OUT_13.xValid;
OUT13_Status:=AXL_ANALOG_OUT_13.wStatus;

(*============================================================================*)	
    (*A12 dose pump set capacity*)
(*============================================================================*)
AXL_ANALOG_OUT_14(rValue:= PmpA12_SetDose,
    rLimitLow:= 0.0,
    rLimitHigh:= 100.0,
    iRange:= 3,
    iSubstitute:= 0,
    iAnalogIn:= A117_IN0,
    xPnioDataValid:= true);

A117_OUT0:=AXL_ANALOG_OUT_14.iAnalogOut;
OUT14_Valid:=AXL_ANALOG_OUT_14.xValid;
OUT14_Status:=AXL_ANALOG_OUT_14.wStatus;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
