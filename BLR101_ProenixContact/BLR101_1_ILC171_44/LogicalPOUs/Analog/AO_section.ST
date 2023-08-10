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
PROGRAM AO_section

(*Group:Default*)


VAR
	AO0_Ch1_Param :	IL_AO_2_UI_Para_V1_02;
	AO0_Ch2_Param :	IL_AO_2_UI_Para_V1_02;
	AO0_Com :	IL_AO_2_UI_V1_02;
	AO0_Ch2_Diag :	IL_AO_2_UI_Diag_V1_01;
END_VAR


VAR_EXTERNAL
	Boiler :	Blr;
	BrnrSP :	REAL;
END_VAR


VAR
	arrParamAO0 :	ANL_ARR_Para_1_2;
	xAO0_Ready :	BOOL;
	xAO0_Err :	BOOL;
	wAO0_Diag :	WORD;
	wAO0_AddDiag :	WORD;
END_VAR


VAR_EXTERNAL
	arrProcInAO0 :	ANL_ARR_W_1_4;
	arrProcOutAO0 :	ANL_ARR_W_1_4;
END_VAR


VAR
	arrDiagAO0 :	ANL_ARR_Diag_1_2;
	AO0_Ch1_Diag :	IL_AO_2_UI_Diag_V1_01;
	xAO0_Ch1_Diag_Err :	BOOL;
	wAO0_Ch1_Diag_ErrCode :	WORD;
	xAO0_Ch2_Diag_Err :	BOOL;
	wAO0_Ch2_Diag_ErrCode :	WORD;
END_VAR


VAR_EXTERNAL
	ExhsrSP :	REAL;
END_VAR


VAR
	AO1_Ch1_Param :	IL_AO_2_UI_Para_V1_02;
	AO1_Ch2_Param :	IL_AO_2_UI_Para_V1_02;
	AO1_Com :	IL_AO_2_UI_V1_02;
	AO1_Ch1_Diag :	IL_AO_2_UI_Diag_V1_01;
	AO1_Ch2_Diag :	IL_AO_2_UI_Diag_V1_01;
	arrParamAO1 :	ANL_ARR_Para_1_2;
END_VAR


VAR_EXTERNAL
	arrProcInAO1 :	ANL_ARR_W_1_4;
	arrProcOutAO1 :	ANL_ARR_W_1_4;
END_VAR


VAR
	arrDiagAO1 :	ANL_ARR_Diag_1_2;
	xAO1_Ready :	BOOL;
	xAO1_Err :	BOOL;
	wAO1_Diag :	WORD;
	wAO1_AddDiag :	WORD;
	xAO1_Ch1_Diag_Err :	BOOL;
	wAO1_Ch1_Diag_ErrCode :	WORD;
	xAO1_Ch2_Diag_Err :	BOOL;
	wAO1_Ch2_Diag_ErrCode :	WORD;
END_VAR


VAR_EXTERNAL
	RecPmpSP :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: AO_section
IEC_LANGUAGE: ST
*)
	
	(*AO0 module parametrization*)
(*Burner Setpoint assignment*)
AO0_Ch1_Param(iChannelNo:=int#1,iRange:=int#4,rHiLim:=100.0,rLoLim:=0.0,
	rSetValue:=BrnrSP,arrParameter:=arrParamAO0);
	arrParamAO0:=AO0_Ch1_Param.arrParameter;

(*Exhauser FC Setpoint assignment*)
AO0_Ch2_Param(iChannelNo:=int#2,iRange:=int#2,rHiLim:=50.0,rLoLim:=0.0,
	rSetValue:=ExhsrSP,arrParameter:=arrParamAO0);
	arrParamAO0:=AO0_Ch2_Param.arrParameter;
	
	(*AO0 module communication*)
AO0_Com(xActivate:=true,iSelectCH:=int#3,arrParameter:=arrParamAO0,
	arrProcIN:=arrProcInAO0);
	xAO0_Ready:=AO0_Com.xReady;
	xAO0_Err:=AO0_Com.xError;
	wAO0_Diag:=AO0_Com.wDiagCode;
	wAO0_AddDiag:=AO0_Com.wAddDiagCode;
	arrDiagAO0:=AO0_Com.arrDiag;
	arrProcOutAO0:=AO0_Com.arrProcOUT;

	(*AO0 module diagnostic*)
AO0_Ch1_Diag(iChannelNo:=int#1,arrDiag:=arrDiagAO0);
	xAO0_Ch1_Diag_Err:=AO0_Ch1_Diag.xError;
	wAO0_Ch1_Diag_ErrCode:=AO0_Ch1_Diag.wErrorCode;
	arrDiagAO0:=AO0_Ch1_Diag.arrDiag;
AO0_Ch2_Diag(iChannelNo:=int#2,arrDiag:=arrDiagAO0);
	xAO0_Ch2_Diag_Err:=AO0_Ch2_Diag.xError;
	wAO0_Ch2_Diag_ErrCode:=AO0_Ch2_Diag.wErrorCode;
	arrDiagAO0:=AO0_Ch2_Diag.arrDiag;


	(*AO1 module parametrization*)
(*Recirculation Pump Setpoint assignment*)
AO1_Ch1_Param(iChannelNo:=int#1,iRange:=int#2,rHiLim:=50.0,rLoLim:=0.0,
	rSetValue:=RecPmpSP,arrParameter:=arrParamAO1);
	arrParamAO1:=AO1_Ch1_Param.arrParameter;

(*Reserve*)
AO1_Ch2_Param(iChannelNo:=int#2,iRange:=int#4,rHiLim:=100.0,rLoLim:=0.0,
	(*rSetValue:=,*)arrParameter:=arrParamAO1);
	arrParamAO1:=AO1_Ch2_Param.arrParameter;
	
	(*AO1 module communication*)
AO1_Com(xActivate:=true,iSelectCH:=int#1,arrParameter:=arrParamAO1,
	arrProcIN:=arrProcInAO1);
	xAO1_Ready:=AO1_Com.xReady;
	xAO1_Err:=AO1_Com.xError;
	wAO1_Diag:=AO1_Com.wDiagCode;
	wAO1_AddDiag:=AO1_Com.wAddDiagCode;
	arrDiagAO1:=AO1_Com.arrDiag;
	arrProcOutAO1:=AO1_Com.arrProcOUT;

	(*AO1 module diagnostic*)
AO1_Ch1_Diag(iChannelNo:=int#1,arrDiag:=arrDiagAO1);
	xAO1_Ch1_Diag_Err:=AO1_Ch1_Diag.xError;
	wAO1_Ch1_Diag_ErrCode:=AO1_Ch1_Diag.wErrorCode;
	arrDiagAO1:=AO1_Ch1_Diag.arrDiag;
AO1_Ch2_Diag(iChannelNo:=int#2,arrDiag:=arrDiagAO1);
	xAO1_Ch2_Diag_Err:=AO1_Ch2_Diag.xError;
	wAO1_Ch2_Diag_ErrCode:=AO1_Ch2_Diag.wErrorCode;
	arrDiagAO1:=AO1_Ch2_Diag.arrDiag;
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
