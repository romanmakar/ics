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

(*Group:Default*)


VAR
	i :	INT;
	A13_Param :	IL_AO_2_UI_Para_V1_02;
	j :	INT;
END_VAR


VAR_EXTERNAL
	M_AUX :	MOTOR_MISC;
END_VAR


VAR
	arrParamA13 :	ANL_ARR_Para_1_2;
	A13_Com :	IL_AO_2_UI_V1_02;
	A13_Ready :	BOOL;
	A13_Err :	BOOL;
	A13_DiagCode :	WORD;
	A13_AddDiagCode :	WORD;
	A13_arrDiag :	ANL_ARR_Diag_1_2;
END_VAR


VAR_EXTERNAL
	A13_ProcIn :	ANL_ARR_W_1_4;
	A13_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A13_CH1_Diag :	IL_AO_2_UI_Diag_V1_01;
	A13_CH2_Diag :	IL_AO_2_UI_Diag_V1_01;
	A13_CH1_Err :	BOOL;
	A13_CH1_ErrCode :	WORD;
	A13_CH2_Err :	BOOL;
	A13_CH2_ErrCode :	WORD;
	A14_Param :	IL_AO_2_UI_Para_V1_02;
	arrParamA14 :	ANL_ARR_Para_1_2;
	A14_Com :	IL_AO_2_UI_V1_02;
	A14_Ready :	BOOL;
	A14_Err :	BOOL;
	A14_DiagCode :	WORD;
	A14_AddDiagCode :	WORD;
	A14_arrDiag :	ANL_ARR_Diag_1_2;
END_VAR


VAR_EXTERNAL
	A14_ProcIn :	ANL_ARR_W_1_4;
	A14_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A14_CH1_Diag :	IL_AO_2_UI_Diag_V1_01;
	A14_CH1_Err :	BOOL;
	A14_CH1_ErrCode :	WORD;
	A16_Param :	IL_AO_2_UI_Para_V1_02;
	arrParamA16 :	ANL_ARR_Para_1_2;
	A16_Com :	IL_AO_2_UI_V1_02;
	A16_Ready :	BOOL;
	A16_Err :	BOOL;
	A16_DiagCode :	WORD;
	A16_AddDiagCode :	WORD;
	A16_arrDiag :	ANL_ARR_Diag_1_2;
END_VAR


VAR_EXTERNAL
	A16_ProcIn :	ANL_ARR_W_1_4;
	A16_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A16_CH1_Diag :	IL_AO_2_UI_Diag_V1_01;
	A16_CH1_Err :	BOOL;
	A16_CH1_ErrCode :	WORD;
	A16_CH2_Diag :	IL_AO_2_UI_Diag_V1_01;
	A16_CH2_Err :	BOOL;
	A16_CH2_ErrCode :	WORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: AO
IEC_LANGUAGE: ST
*)
(*========================================================================================*)	
	(*A13 module parametrization*)
(*========================================================================================*)
for i:= 1 to 2 do
	j:= i - 1;
	A13_Param(iChannelNo:= i,iRange:= 2,rHiLim:= 50.0,rLoLim:= 0.0,rSetValue:= M_AUX[j].SetValue,arrParameter:= arrParamA13);
	arrParamA13:= A13_Param.arrParameter;
end_for;

(*========================================================================================*)
	(*A13 module communication*)
(*========================================================================================*)
A13_Com(xActivate:= true,iSelectCH:= 3,arrParameter:= arrParamA13,arrProcIN:= A13_ProcIn);
	A13_Ready			:=	A13_Com.xReady;
	A13_Err				:=	A13_Com.xError;
	A13_DiagCode		:=	A13_Com.wDiagCode;
	A13_AddDiagCode		:=	A13_Com.wAddDiagCode;
	A13_arrDiag			:=	A13_Com.arrDiag;
	A13_ProcOut			:=	A13_Com.arrProcOUT;

(*========================================================================================*)
	(*A13 module diagnostic*)
(*========================================================================================*)
A13_CH1_Diag(iChannelNo:= 1,arrDiag:=A13_arrDiag);
A13_CH1_Err				:=	A13_CH1_Diag.xError;
A13_CH1_ErrCode			:=	A13_CH1_Diag.wErrorCode;
A13_arrDiag				:=	A13_CH1_Diag.arrDiag;

A13_CH2_Diag(iChannelNo:= 2,arrDiag:=A13_arrDiag);
A13_CH2_Err				:=	A13_CH2_Diag.xError;
A13_CH2_ErrCode			:=	A13_CH2_Diag.wErrorCode;
A13_arrDiag				:=	A13_CH2_Diag.arrDiag;




(*========================================================================================*)	
	(*A14 module parametrization*)
(*========================================================================================*)
A14_Param(iChannelNo:= 1,iRange:= 2,rHiLim:= 50.0,rLoLim:= 0.0,rSetValue:= M_AUX[2].SetValue,arrParameter:= arrParamA14);
	arrParamA14:= A14_Param.arrParameter;

(*========================================================================================*)
	(*A14 module communication*)
(*========================================================================================*)
A14_Com(xActivate:= true,iSelectCH:= 1,arrParameter:= arrParamA14,arrProcIN:= A14_ProcIn);
	A14_Ready			:=	A14_Com.xReady;
	A14_Err				:=	A14_Com.xError;
	A14_DiagCode		:=	A14_Com.wDiagCode;
	A14_AddDiagCode		:=	A14_Com.wAddDiagCode;
	A14_arrDiag			:=	A14_Com.arrDiag;
	A14_ProcOut			:=	A14_Com.arrProcOUT;

(*========================================================================================*)
	(*A14 module diagnostic*)
(*========================================================================================*)
A14_CH1_Diag(iChannelNo:= 1,arrDiag:=A14_arrDiag);
A14_CH1_Err				:=	A14_CH1_Diag.xError;
A14_CH1_ErrCode			:=	A14_CH1_Diag.wErrorCode;
A14_arrDiag				:=	A14_CH1_Diag.arrDiag;



(*========================================================================================*)	
	(*A16 module parametrization*)
(*========================================================================================*)
for i:= 1 to 2 do
	j:= i + 2;
	A16_Param(iChannelNo:= i,iRange:= 2,rHiLim:= 50.0,rLoLim:= 0.0,rSetValue:= M_AUX[j].SetValue,arrParameter:= arrParamA16);
	arrParamA16:= A16_Param.arrParameter;
end_for;

(*========================================================================================*)
	(*A16 module communication*)
(*========================================================================================*)
A16_Com(xActivate:= true,iSelectCH:= 3,arrParameter:= arrParamA16,arrProcIN:= A16_ProcIn);
	A16_Ready			:=	A16_Com.xReady;
	A16_Err				:=	A16_Com.xError;
	A16_DiagCode		:=	A16_Com.wDiagCode;
	A16_AddDiagCode		:=	A16_Com.wAddDiagCode;
	A16_arrDiag			:=	A16_Com.arrDiag;
	A16_ProcOut			:=	A16_Com.arrProcOUT;

(*========================================================================================*)
	(*A16 module diagnostic*)
(*========================================================================================*)
A16_CH1_Diag(iChannelNo:= 1,arrDiag:=A16_arrDiag);
A16_CH1_Err				:=	A16_CH1_Diag.xError;
A16_CH1_ErrCode			:=	A16_CH1_Diag.wErrorCode;
A16_arrDiag				:=	A16_CH1_Diag.arrDiag;

A16_CH2_Diag(iChannelNo:= 2,arrDiag:=A16_arrDiag);
A16_CH2_Err				:=	A16_CH2_Diag.xError;
A16_CH2_ErrCode			:=	A16_CH2_Diag.wErrorCode;
A16_arrDiag				:=	A16_CH2_Diag.arrDiag;













(*@KEY@: END_WORKSHEET *)
END_PROGRAM
