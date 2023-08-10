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
PROGRAM AI_section

(*Group:Default*)


VAR
	P_gas_fb :	SensorFB;
END_VAR


VAR_EXTERNAL
	Boiler :	Blr;
END_VAR


VAR
	T_out_fb :	SensorFB;
	P_out_fb :	SensorFB;
	P_pmp_in_fb :	SensorFB;
	P_pmp_out_fb :	SensorFB;
	P_internal_fb :	SensorFB;
	P_exhsr_in_fb :	SensorFB;
	F_hc_fb :	SensorFB;
	P_in_fb :	SensorFB;
	T_smoke_fb :	SensorFB;
	T_in_fb :	SensorFB;
	AI0_Ch1_Param :	IL_AI_4_UI_Para_V1_03;
	AI0_Ch2_Param :	IL_AI_4_UI_Para_V1_03;
	AI0_Ch3_Param :	IL_AI_4_UI_Para_V1_03;
	AI0_Ch4_Param :	IL_AI_4_UI_Para_V1_03;
	udtParamAI0 :	ANL_udt_Para_1_5;
	AI0_Com :	IL_AI_4_UI_Com_V1_04;
END_VAR


VAR_EXTERNAL
	arrProcInAI0 :	ANL_ARR_W_1_4;
	arrProcOutAI0 :	ANL_ARR_W_1_4;
END_VAR


VAR
	udtStatusAI0 :	ANL_udt_Status_1_5;
	xAI0_Ready :	BOOL;
	xAI0_Err :	BOOL;
	wAI0_Diag :	WORD;
	AI0_Ch1_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI0_Ch2_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI0_Ch3_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI0_Ch4_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI1_Ch1_Param :	IL_AI_4_UI_Para_V1_03;
	AI1_Ch2_Param :	IL_AI_4_UI_Para_V1_03;
	AI1_Ch3_Param :	IL_AI_4_UI_Para_V1_03;
	AI1_Ch4_Param :	IL_AI_4_UI_Para_V1_03;
	AI1_Com :	IL_AI_4_UI_Com_V1_04;
	AI1_Ch1_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI1_Ch2_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI1_Ch3_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI1_Ch4_Diag :	IL_AI_4_UI_Diag_V1_03;
	udtParamAI1 :	ANL_udt_Para_1_5;
END_VAR


VAR_EXTERNAL
	arrProcInAI1 :	ANL_ARR_W_1_4;
	arrProcOutAI1 :	ANL_ARR_W_1_4;
END_VAR


VAR
	udtStatusAI1 :	ANL_udt_Status_1_5;
	xAI1_Ready :	BOOL;
	xAI1_Err :	BOOL;
	wAI1_Diag :	WORD;
	AI2_Ch1_Param :	IL_AI_4_UI_Para_V1_03;
	AI2_Ch2_Param :	IL_AI_4_UI_Para_V1_03;
	AI2_Ch3_Param :	IL_AI_4_UI_Para_V1_03;
	AI2_Ch4_Param :	IL_AI_4_UI_Para_V1_03;
	AI2_Com :	IL_AI_4_UI_Com_V1_04;
	AI2_Ch1_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI2_Ch2_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI2_Ch3_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI2_Ch4_Diag :	IL_AI_4_UI_Diag_V1_03;
	udtParamAI2 :	ANL_udt_Para_1_5;
END_VAR


VAR_EXTERNAL
	arrProcInAI2 :	ANL_ARR_W_1_4;
	arrProcOutAI2 :	ANL_ARR_W_1_4;
END_VAR


VAR
	udtStatusAI2 :	ANL_udt_Status_1_5;
	xAI2_Ready :	BOOL;
	xAI2_Err :	BOOL;
	wAI2_Diag :	WORD;
	AI3_Ch1_Param :	IL_AI_4_UI_Para_V1_03;
	AI3_Ch2_Param :	IL_AI_4_UI_Para_V1_03;
	AI3_Ch3_Param :	IL_AI_4_UI_Para_V1_03;
	AI3_Ch4_Param :	IL_AI_4_UI_Para_V1_03;
	AI3_Com :	IL_AI_4_UI_Com_V1_04;
	AI3_Ch1_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI3_Ch2_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI3_Ch3_Diag :	IL_AI_4_UI_Diag_V1_03;
	AI3_Ch4_Diag :	IL_AI_4_UI_Diag_V1_03;
	udtParamAI3 :	ANL_udt_Para_1_5;
END_VAR


VAR_EXTERNAL
	arrProcInAI3 :	ANL_ARR_W_1_4;
	arrProcOutAI3 :	ANL_ARR_W_1_4;
END_VAR


VAR
	udtStatusAI3 :	ANL_udt_Status_1_5;
	wAI3_Diag :	WORD;
	xAI3_Err :	BOOL;
	xAI3_Ready :	BOOL;
	BrnrFeedback_fb :	SensorFB;
END_VAR


VAR_EXTERNAL
	BrnrFeedback :	Snsr;
END_VAR


VAR
	ExhsrFeedback_fb :	SensorFB;
END_VAR


VAR_EXTERNAL
	ExhsrFeedback :	Snsr;
END_VAR


VAR
	ExhsrGatePos_fb :	SensorFB;
END_VAR


VAR_EXTERNAL
	ExhsrGatePos :	Snsr;
END_VAR


VAR
	RecPmpFeedback_fb :	SensorFB;
END_VAR


VAR_EXTERNAL
	RecPmpFeedback :	Snsr;
	T_in_PLS :	Snsr_PLS;
	T_out_PLS :	Snsr_PLS;
	T_smoke_PLS :	Snsr_PLS;
	P_in_PLS :	Snsr_PLS;
	P_out_PLS :	Snsr_PLS;
	P_gas_PLS :	Snsr_PLS;
	P_internal_PLS :	Snsr_PLS;
	P_exhsr_in_PLS :	Snsr_PLS;
	F_hc_PLS :	Snsr_PLS;
	P_pmp_in_PLS :	Snsr_PLS;
	P_pmp_out_PLS :	Snsr_PLS;
END_VAR


(*@KEY@: WORKSHEET
NAME: AI_section
IEC_LANGUAGE: ST
*)
	
	(*AI0 module parametrization*)
AI0_Ch1_Param(iChannel:=int#1,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[0].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI0);
	udtParamAI0:=AI0_Ch1_Param.udtPara;

AI0_Ch2_Param(iChannel:=int#2,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[1].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI0);
	udtParamAI0:=AI0_Ch2_Param.udtPara;

AI0_Ch3_Param(iChannel:=int#3,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[3].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI0);
	udtParamAI0:=AI0_Ch3_Param.udtPara;

AI0_Ch4_Param(iChannel:=int#4,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[10].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI0);
	udtParamAI0:=AI0_Ch4_Param.udtPara;
	
	(*AI0 module communication*)
AI0_Com(xActivate:=true,bSelect:=byte#16#0F,xVoltage:=false,
	udtPara:=udtParamAI0,arrProcIn:=arrProcInAI0);
	xAI0_Ready:=AI0_Com.xReady;
	xAI0_Err:=AI0_Com.xError;
	wAI0_Diag:=AI0_Com.wDiagCode;
	udtStatusAI0:=AI0_Com.udtStatus;
	udtParamAI0:=AI0_Com.udtPara;
	arrProcOutAI0:=AI0_Com.arrProcOut;

	(*AI0 module diagnostic*)
(*Boiler inlet water temperature*)
AI0_Ch1_Diag(udtStatus:=udtStatusAI0,iChannel:=int#1);					
	Boiler.AI[0].CW.ExtFault:=not AI0_Ch1_Diag.xDataValid;
	Boiler.AI[0].DiagCode:=AI0_Ch1_Diag.wDiagCode;
	Boiler.AI[0].PIW:=real_to_int(AI0_Ch1_Diag.rCurrentValue);

T_in_fb(Snsr_strct:=Boiler.AI[0]);
	Boiler.AI[0]:=T_in_fb.Snsr_strct;
	T_in_PLS:= T_in_fb.SnsrPLS;

(*Boiler outlet water temperature*)
AI0_Ch2_Diag(udtStatus:=udtStatusAI0,iChannel:=int#2);
	Boiler.AI[1].CW.ExtFault:=not AI0_Ch2_Diag.xDataValid;
	Boiler.AI[1].DiagCode:=AI0_Ch2_Diag.wDiagCode;
	Boiler.AI[1].PIW:=real_to_int(AI0_Ch2_Diag.rCurrentValue);

T_out_fb(Snsr_strct:=Boiler.AI[1]);
	Boiler.AI[1]:=T_out_fb.Snsr_strct;
	T_out_PLS:= T_out_fb.SnsrPLS;

(*Boiler smoke gas temperature*)
AI0_Ch3_Diag(udtStatus:=udtStatusAI0,iChannel:=int#3);
	Boiler.AI[3].CW.ExtFault:=not AI0_Ch3_Diag.xDataValid;
	Boiler.AI[3].DiagCode:=AI0_Ch3_Diag.wDiagCode;
	Boiler.AI[3].PIW:=real_to_int(AI0_Ch3_Diag.rCurrentValue);

T_smoke_fb(Snsr_strct:=Boiler.AI[3]);
	Boiler.AI[3]:=T_smoke_fb.Snsr_strct;
	T_smoke_PLS:= T_smoke_fb.SnsrPLS;

(*Boiler inlet water pressure*)
AI0_Ch4_Diag(udtStatus:=udtStatusAI0,iChannel:=int#4);
	Boiler.AI[10].CW.ExtFault:=not AI0_Ch4_Diag.xDataValid;
	Boiler.AI[10].DiagCode:=AI0_Ch4_Diag.wDiagCode;
	Boiler.AI[10].PIW:=real_to_int(AI0_Ch4_Diag.rCurrentValue);

	Boiler.AI[10].CW.bar_kgf:=true;
P_in_fb(Snsr_strct:=Boiler.AI[10]);
	Boiler.AI[10]:=P_in_fb.Snsr_strct;
	P_in_PLS:= P_in_fb.SnsrPLS;

	(*AI1 module parametrization*)
AI1_Ch1_Param(iChannel:=int#1,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[11].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI1);
	udtParamAI1:=AI1_Ch1_Param.udtPara;

AI1_Ch2_Param(iChannel:=int#2,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.Brn1.AI[0].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI1);
	udtParamAI1:=AI1_Ch2_Param.udtPara;

AI1_Ch3_Param(iChannel:=int#3,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[15].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI1);
	udtParamAI1:=AI1_Ch3_Param.udtPara;

AI1_Ch4_Param(iChannel:=int#4,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[16].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI1);
	udtParamAI1:=AI1_Ch4_Param.udtPara;

	(*AI1 module communication*)
AI1_Com(xActivate:=true,bSelect:=byte#16#0F,xVoltage:=false,
	udtPara:=udtParamAI1,arrProcIn:=arrProcInAI1);
	xAI1_Ready:=AI1_Com.xReady;
	xAI1_Err:=AI1_Com.xError;
	wAI1_Diag:=AI1_Com.wDiagCode;
	udtStatusAI1:=AI1_Com.udtStatus;
	udtParamAI1:=AI1_Com.udtPara;
	arrProcOutAI1:=AI1_Com.arrProcOut;

	(*AI1 module diagnostic*)
(*Boiler outlet water pressure*)
AI1_Ch1_Diag(udtStatus:=udtStatusAI1,iChannel:=int#1);
	Boiler.AI[11].CW.ExtFault:=not AI1_Ch1_Diag.xDataValid;
	Boiler.AI[11].DiagCode:=AI1_Ch1_Diag.wDiagCode;
	Boiler.AI[11].PIW:=real_to_int(AI1_Ch1_Diag.rCurrentValue);
	Boiler.AI[11].CW.bar_kgf:=true;

P_out_fb(Snsr_strct:=Boiler.AI[11]);
	Boiler.AI[11]:=P_out_fb.Snsr_strct;
	P_out_PLS:= P_out_fb.SnsrPLS;

(*Boiler inlet gas pressure*)
AI1_Ch2_Diag(udtStatus:=udtStatusAI1,iChannel:=int#2);
	Boiler.Brn1.AI[0].CW.ExtFault:=not AI1_Ch2_Diag.xDataValid;
	Boiler.Brn1.AI[0].DiagCode:=AI1_Ch2_Diag.wDiagCode;
	Boiler.Brn1.AI[0].PIW:=real_to_int(AI1_Ch2_Diag.rCurrentValue);
	Boiler.AI[0].CW.bar_kgf:=true;

P_gas_fb(Snsr_strct:=Boiler.Brn1.AI[0]);
	Boiler.Brn1.AI[0]:=P_gas_fb.Snsr_strct;
	P_gas_PLS:= P_gas_fb.SnsrPLS;

(*Boiler internal pressure*)
AI1_Ch3_Diag(udtStatus:=udtStatusAI1,iChannel:=int#3);
	Boiler.AI[15].CW.ExtFault:=not AI1_Ch3_Diag.xDataValid;
	Boiler.AI[15].DiagCode:=AI1_Ch3_Diag.wDiagCode;
	Boiler.AI[15].PIW:=real_to_int(AI1_Ch3_Diag.rCurrentValue);

P_internal_fb(Snsr_strct:=Boiler.AI[15]);
	Boiler.AI[15]:=P_internal_fb.Snsr_strct;
	P_internal_PLS:= P_internal_fb.SnsrPLS;

(*Exhauser inlet pressure*)
AI1_Ch4_Diag(udtStatus:=udtStatusAI1,iChannel:=int#4);
	Boiler.AI[16].CW.ExtFault:=not AI1_Ch4_Diag.xDataValid;
	Boiler.AI[16].DiagCode:=AI1_Ch4_Diag.wDiagCode;
	Boiler.AI[16].PIW:=real_to_int(AI1_Ch4_Diag.rCurrentValue);

P_exhsr_in_fb(Snsr_strct:=Boiler.AI[16]);
	Boiler.AI[16]:=P_exhsr_in_fb.Snsr_strct;
	P_exhsr_in_PLS:= P_exhsr_in_fb.SnsrPLS;


	(*AI2 module parametrization*)
AI2_Ch1_Param(iChannel:=int#1,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[24].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI2);
	udtParamAI2:=AI2_Ch1_Param.udtPara;

AI2_Ch2_Param(iChannel:=int#2,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[23].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI2);
	udtParamAI2:=AI2_Ch2_Param.udtPara;

AI2_Ch3_Param(iChannel:=int#3,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[12].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI2);
	udtParamAI2:=AI2_Ch3_Param.udtPara;

AI2_Ch4_Param(iChannel:=int#4,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=int_to_real(Boiler.AI[13].ADC_Range),
	rLowLimit:=0.0,udtPara:=udtParamAI2);
	udtParamAI2:=AI2_Ch4_Param.udtPara;

	(*AI2 module communication*)
AI2_Com(xActivate:=true,bSelect:=byte#16#0E,xVoltage:=false,
	udtPara:=udtParamAI2,arrProcIn:=arrProcInAI2);
	xAI2_Ready:=AI2_Com.xReady;
	xAI2_Err:=AI2_Com.xError;
	wAI2_Diag:=AI2_Com.wDiagCode;
	udtStatusAI2:=AI2_Com.udtStatus;
	udtParamAI2:=AI2_Com.udtPara;
	arrProcOutAI2:=AI2_Com.arrProcOut;

	(*AI2 module diagnostic*)
(*Reserve*)
AI2_Ch1_Diag(udtStatus:=udtStatusAI2,iChannel:=int#1);
	Boiler.AI[24].CW.ExtFault:=not AI2_Ch1_Diag.xDataValid;
	Boiler.AI[24].DiagCode:=AI2_Ch1_Diag.wDiagCode;
	Boiler.AI[24].PIW:=real_to_int(AI2_Ch1_Diag.rCurrentValue);

(*Boiler water flow*)
AI2_Ch2_Diag(udtStatus:=udtStatusAI2,iChannel:=int#2);
	Boiler.AI[23].CW.ExtFault:=not AI2_Ch2_Diag.xDataValid;
	Boiler.AI[23].DiagCode:=AI2_Ch2_Diag.wDiagCode;
	Boiler.AI[23].PIW:=real_to_int(AI2_Ch2_Diag.rCurrentValue);

F_hc_fb(Snsr_strct:=Boiler.AI[23]);
	Boiler.AI[23]:=F_hc_fb.Snsr_strct;
	F_hc_PLS:= F_hc_fb.SnsrPLS;

(*Recirculation pump inlet water pressure*)
AI2_Ch3_Diag(udtStatus:=udtStatusAI2,iChannel:=int#3);
	Boiler.AI[12].CW.ExtFault:=not AI2_Ch3_Diag.xDataValid;
	Boiler.AI[12].DiagCode:=AI2_Ch3_Diag.wDiagCode;
	Boiler.AI[12].PIW:=real_to_int(AI2_Ch3_Diag.rCurrentValue);
	Boiler.AI[12].CW.bar_kgf:=true;

P_pmp_in_fb(Snsr_strct:=Boiler.AI[12]);
	Boiler.AI[12]:=P_pmp_in_fb.Snsr_strct;
	P_pmp_in_PLS:= P_pmp_in_fb.SnsrPLS;

(*Recirculation pump outlet water pressure*)
AI2_Ch4_Diag(udtStatus:=udtStatusAI2,iChannel:=int#4);
	Boiler.AI[13].CW.ExtFault:=not AI2_Ch4_Diag.xDataValid;
	Boiler.AI[13].DiagCode:=AI2_Ch4_Diag.wDiagCode;
	Boiler.AI[13].PIW:=real_to_int(AI2_Ch4_Diag.rCurrentValue);
	Boiler.AI[13].CW.bar_kgf:=true;

P_pmp_out_fb(Snsr_strct:=Boiler.AI[13]);
	Boiler.AI[13]:=P_pmp_out_fb.Snsr_strct;
	P_pmp_out_PLS:= P_pmp_out_fb.SnsrPLS;


	(*AI3 module parametrization*)
AI3_Ch1_Param(iChannel:=int#1,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=10000.0,rLowLimit:=0.0,udtPara:=udtParamAI3);
	udtParamAI3:=AI3_Ch1_Param.udtPara;

AI3_Ch2_Param(iChannel:=int#2,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=10000.0,rLowLimit:=0.0,udtPara:=udtParamAI3);
	udtParamAI3:=AI3_Ch2_Param.udtPara;

AI3_Ch3_Param(iChannel:=int#3,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=10000.0,rLowLimit:=0.0,udtPara:=udtParamAI3);
	udtParamAI3:=AI3_Ch3_Param.udtPara;

AI3_Ch4_Param(iChannel:=int#4,iMode:=int#1,iFilter:=int#0,
	rHighLimit:=10000.0,rLowLimit:=0.0,udtPara:=udtParamAI3);
	udtParamAI3:=AI3_Ch4_Param.udtPara;

	(*AI3 module communication*)
AI3_Com(xActivate:=true,bSelect:=byte#16#0F,xVoltage:=false,
	udtPara:=udtParamAI3,arrProcIn:=arrProcInAI3);
	xAI3_Ready:=AI3_Com.xReady;
	xAI3_Err:=AI3_Com.xError;
	wAI3_Diag:=AI3_Com.wDiagCode;
	udtStatusAI3:=AI3_Com.udtStatus;
	udtParamAI3:=AI3_Com.udtPara;
	arrProcOutAI3:=AI3_Com.arrProcOut;

	(*AI3 module diagnostic*)
(*Burner AO feedback*)
AI3_Ch1_Diag(udtStatus:=udtStatusAI3,iChannel:=int#1);
	BrnrFeedback.CW.ExtFault:=not AI3_Ch1_Diag.xDataValid;
	BrnrFeedback.DiagCode:=AI3_Ch1_Diag.wDiagCode;
	BrnrFeedback.PIW:=real_to_int(AI3_Ch1_Diag.rCurrentValue);
	BrnrFeedback.k:= 100.0;
	BrnrFeedback.ADC_Range:=10000;

BrnrFeedback_fb(Snsr_strct:=BrnrFeedback);
	BrnrFeedback:=BrnrFeedback_fb.Snsr_strct;

(*Exhauser FC AO feedback*)
AI3_Ch2_Diag(udtStatus:=udtStatusAI3,iChannel:=int#2);
	ExhsrFeedback.CW.ExtFault:=not AI3_Ch2_Diag.xDataValid;
	ExhsrFeedback.DiagCode:=AI3_Ch2_Diag.wDiagCode;
	ExhsrFeedback.PIW:=real_to_int(AI3_Ch2_Diag.rCurrentValue);
	ExhsrFeedback.k:=50.0;
	ExhsrFeedback.ADC_Range:=10000;

ExhsrFeedback_fb(Snsr_strct:=ExhsrFeedback);
	ExhsrFeedback:=ExhsrFeedback_fb.Snsr_strct;

(*Exhauser Gate actual position feedback*)
AI3_Ch3_Diag(udtStatus:=udtStatusAI3,iChannel:=int#3);
	ExhsrGatePos.CW.ExtFault:=not AI3_Ch3_Diag.xDataValid;
	ExhsrGatePos.DiagCode:=AI3_Ch3_Diag.wDiagCode;
	ExhsrGatePos.PIW:=real_to_int(AI3_Ch3_Diag.rCurrentValue);
	ExhsrGatePos.k:= 100.0;
	ExhsrGatePos.ADC_Range:=10000;

ExhsrGatePos_fb(Snsr_strct:=ExhsrGatePos);
	ExhsrGatePos:=ExhsrGatePos_fb.Snsr_strct;

(*Pump FC AO feedback*)
AI3_Ch4_Diag(udtStatus:=udtStatusAI3,iChannel:=int#4);
	RecPmpFeedback.CW.ExtFault:=not AI3_Ch4_Diag.xDataValid;
	RecPmpFeedback.DiagCode:=AI3_Ch4_Diag.wDiagCode;
	RecPmpFeedback.PIW:=real_to_int(AI3_Ch4_Diag.rCurrentValue);
	RecPmpFeedback.k:=50.0;
	RecPmpFeedback.ADC_Range:=10000;

RecPmpFeedback_fb(Snsr_strct:=RecPmpFeedback);
	RecPmpFeedback:=RecPmpFeedback_fb.Snsr_strct;























(*@KEY@: END_WORKSHEET *)
END_PROGRAM
