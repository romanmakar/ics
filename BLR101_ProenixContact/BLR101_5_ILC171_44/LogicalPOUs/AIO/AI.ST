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
PROGRAM AI

(*Group:Default*)


VAR_EXTERNAL
	AI :	SENSOR;
END_VAR


VAR
	A07_Param :	IL_AI_4_UI_Para_V1_03;
	i :	INT;
	j :	INT;
	udtA07Param :	ANL_udt_Para_1_5;
	A07_Com :	IL_AI_4_UI_Com_V1_04;
	udtA07Status :	ANL_udt_Status_1_5;
	A07_Ready :	BOOL;
	A07_Err :	BOOL;
	A07_Frmwr :	STRING;
END_VAR


VAR_EXTERNAL
	A07_ProcIn :	ANL_ARR_W_1_4;
	A07_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A07_DiagCode :	WORD;
	A07_Diag :	IL_AI_4_UI_Diag_V1_03;
	A08_Param :	IL_AI_4_UI_Para_V1_03;
	udtA08Param :	ANL_udt_Para_1_5;
	A08_Com :	IL_AI_4_UI_Com_V1_04;
	A08_Ready :	BOOL;
	A08_Err :	BOOL;
	A08_DiagCode :	WORD;
	A08_Frmwr :	STRING;
	udtA08Status :	ANL_udt_Status_1_5;
END_VAR


VAR_EXTERNAL
	A08_ProcIn :	ANL_ARR_W_1_4;
	A08_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A08_Diag :	IL_AI_4_UI_Diag_V1_03;
	A09_Param :	IL_AI_4_UI_Para_V1_03;
	udtA09Param :	ANL_udt_Para_1_5;
	A09_Com :	IL_AI_4_UI_Com_V1_04;
	A09_Ready :	BOOL;
	A09_Err :	BOOL;
	A09_DiagCode :	WORD;
	A09_Frmwr :	STRING;
	udtA09Status :	ANL_udt_Status_1_5;
END_VAR


VAR_EXTERNAL
	A09_ProcIn :	ANL_ARR_W_1_4;
	A09_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A09_Diag :	IL_AI_4_UI_Diag_V1_03;
	A10_Param :	IL_AI_4_UI_Para_V1_03;
	udtA10Param :	ANL_udt_Para_1_5;
	A10_Com :	IL_AI_4_UI_Com_V1_04;
	A10_Ready :	BOOL;
	A10_Err :	BOOL;
	A10_Frmwr :	STRING;
	udtA10Status :	ANL_udt_Status_1_5;
END_VAR


VAR_EXTERNAL
	A10_ProcIn :	ANL_ARR_W_1_4;
	A10_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A10_Diag :	IL_AI_4_UI_Diag_V1_03;
	A11_Param :	IL_AI_4_UI_Para_V1_03;
	udtA11Param :	ANL_udt_Para_1_5;
	A11_Com :	IL_AI_4_UI_Com_V1_04;
	A11_Ready :	BOOL;
	A11_Err :	BOOL;
	A11_DiagCode :	WORD;
	A11_Frmwr :	STRING;
	udtA11Status :	ANL_udt_Status_1_5;
END_VAR


VAR_EXTERNAL
	A11_ProcIn :	ANL_ARR_W_1_4;
	A11_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A11_Diag :	IL_AI_4_UI_Diag_V1_03;
	A10_DiagCode :	WORD;
	A12_Param :	IL_AI_4_UI_Para_V1_03;
	udtA12Param :	ANL_udt_Para_1_5;
	A12_Com :	IL_AI_4_UI_Com_V1_04;
	A12_Ready :	BOOL;
	A12_Err :	BOOL;
	A12_DiagCode :	WORD;
	A12_Frmwr :	STRING;
	udtA12Status :	ANL_udt_Status_1_5;
END_VAR


VAR_EXTERNAL
	A12_ProcIn :	ANL_ARR_W_1_4;
	A12_ProcOut :	ANL_ARR_W_1_4;
END_VAR


VAR
	A12_Diag :	IL_AI_4_UI_Diag_V1_03;
	SensorsFB :	SensorFB;
	AI_BUFF :	SENSOR_BUFF;
END_VAR


VAR_EXTERNAL
	AI_AUX :	SENSOR_MISC;
	AI_EVENT :	SENSOR_EVENT;
END_VAR


VAR
	A07_Param_2 :	IL_AI_4_UI_Para_V1_03;
	A07_Param_3 :	IL_AI_4_UI_Para_V1_03;
	A07_Param_4 :	IL_AI_4_UI_Para_V1_03;
	REAL_TO_MB :	REAL_TO_MB;
	j1 :	INT;
END_VAR


VAR_EXTERNAL
	MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


VAR
	j2 :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: AI
IEC_LANGUAGE: ST
*)

(*========================================================================================*)	
	(*A07 module parametrization*)
(*========================================================================================*)
for i:= 1 to 4 do
	j:= i - 1;
	A07_Param(iChannel:= i,iMode:= 1,iFilter:= 0,rHighLimit:= int_to_real(AI[j].ADC_Range),rLowLimit:= 0.0,udtPara:= udtA07Param);
	udtA07Param:= A07_Param.udtPara;
end_for;

(*========================================================================================*)
	(*A07 module communication*)
(*========================================================================================*)
A07_Com(xActivate:= true,bSelect:= byte#16#0F,xVoltage:= false,udtPara:=udtA07Param,arrProcIn:= A07_ProcIn);
	A07_Ready			:=	A07_Com.xReady;
	A07_Err				:=	A07_Com.xError;
	A07_DiagCode		:=	A07_Com.wDiagCode;
	A07_Frmwr			:=	A07_Com.strFirmware;
	udtA07Status		:=	A07_Com.udtStatus;
	udtA07Param 		:=	A07_Com.udtPara;
	A07_ProcOut			:=	A07_Com.arrProcOut;
(*========================================================================================*)
	(*A07 module diagnostic*)
(*========================================================================================*)
for i:= 1 to 4 do
	j:= i - 1;
	A07_Diag(udtStatus:= udtA07Status,iChannel:= i);
	AI[j].CW.ExtFault:= not A07_Diag.xDataValid;
	AI[j].DiagCode:= A07_Diag.wDiagCode;
	AI[j].PIW:= real_to_int(A07_Diag.rCurrentValue);
end_for;


(*========================================================================================*)	
	(*A08 module parametrization*)
(*========================================================================================*)
for i:= 1 to 4 do
	j:= i + 3;
	A08_Param(iChannel:= i,iMode:= 1,iFilter:= 0,rHighLimit:= int_to_real(AI[j].ADC_Range),rLowLimit:= 0.0,udtPara:= udtA08Param);
	udtA08Param:= A08_Param.udtPara;
end_for;

(*========================================================================================*)
	(*A08 module communication*)
(*========================================================================================*)
A08_Com(xActivate:= true,bSelect:= byte#16#0F,xVoltage:= false,udtPara:=udtA08Param,arrProcIn:= A08_ProcIn);
	A08_Ready			:=	A08_Com.xReady;
	A08_Err				:=	A08_Com.xError;
	A08_DiagCode		:=	A08_Com.wDiagCode;
	A08_Frmwr			:=	A08_Com.strFirmware;
	udtA08Status		:=	A08_Com.udtStatus;
	udtA08Param 		:=	A08_Com.udtPara;
	A08_ProcOut			:=	A08_Com.arrProcOut;
(*========================================================================================*)
	(*A08 module diagnostic*)
(*========================================================================================*)
for i:= 1 to 4 do
	j:= i + 3;
	A08_Diag(udtStatus:= udtA08Status,iChannel:= i);
	AI[j].CW.ExtFault:= not A08_Diag.xDataValid;
	AI[j].DiagCode:= A08_Diag.wDiagCode;
	AI[j].PIW:= real_to_int(A08_Diag.rCurrentValue);
end_for;



(*========================================================================================*)	
	(*A09 module parametrization*)
(*========================================================================================*)
for i:= 1 to 4 do
	j:= i + 7;
	A09_Param(iChannel:= i,iMode:= 1,iFilter:= 0,rHighLimit:= int_to_real(AI[j].ADC_Range),rLowLimit:= 0.0,udtPara:= udtA09Param);
	udtA09Param:= A09_Param.udtPara;
end_for;

(*========================================================================================*)
	(*A09 module communication*)
(*========================================================================================*)
A09_Com(xActivate:= true,bSelect:= byte#16#0F,xVoltage:= false,udtPara:=udtA09Param,arrProcIn:= A09_ProcIn);
	A09_Ready			:=	A09_Com.xReady;
	A09_Err				:=	A09_Com.xError;
	A09_DiagCode		:=	A09_Com.wDiagCode;
	A09_Frmwr			:=	A09_Com.strFirmware;
	udtA09Status		:=	A09_Com.udtStatus;
	udtA09Param 		:=	A09_Com.udtPara;
	A09_ProcOut			:=	A09_Com.arrProcOut;
(*========================================================================================*)
	(*A09 module diagnostic*)
(*========================================================================================*)
for i:= 1 to 4 do
	j:= i + 7;
	A09_Diag(udtStatus:= udtA09Status,iChannel:= i);
	AI[j].CW.ExtFault:= not A09_Diag.xDataValid;
	AI[j].DiagCode:= A09_Diag.wDiagCode;
	AI[j].PIW:= real_to_int(A09_Diag.rCurrentValue);
end_for;



(*========================================================================================*)	
	(*A10 module parametrization*)
(*========================================================================================*)
	A10_Param(iChannel:= 1,iMode:= 1,iFilter:= 0,rHighLimit:= int_to_real(AI[12].ADC_Range),rLowLimit:= 0.0,udtPara:= udtA10Param);
	udtA10Param:= A10_Param.udtPara;

(*========================================================================================*)
	(*A10 module communication*)
(*========================================================================================*)
A10_Com(xActivate:= true,bSelect:= byte#16#01,xVoltage:= false,udtPara:=udtA10Param,arrProcIn:= A10_ProcIn);
	A10_Ready			:=	A10_Com.xReady;
	A10_Err				:=	A10_Com.xError;
	A10_DiagCode		:=	A10_Com.wDiagCode;
	A10_Frmwr			:=	A10_Com.strFirmware;
	udtA10Status		:=	A10_Com.udtStatus;
	udtA10Param 		:=	A10_Com.udtPara;
	A10_ProcOut			:=	A10_Com.arrProcOut;
(*========================================================================================*)
	(*A10 module diagnostic*)
(*========================================================================================*)
	A10_Diag(udtStatus:= udtA10Status,iChannel:= 1);
	AI[12].CW.ExtFault:= not A10_Diag.xDataValid;
	AI[12].DiagCode:= A10_Diag.wDiagCode;
	AI[12].PIW:= real_to_int(A10_Diag.rCurrentValue);



(*========================================================================================*)	
	(*A11 module parametrization*)
(*========================================================================================*)
for i:= 1 to 3 do
	j:= i + 15;
	A11_Param(iChannel:= i,iMode:= 0,iFilter:= 0,rHighLimit:= 10000.0,rLowLimit:= 0.0,udtPara:= udtA11Param);
	udtA11Param:= A11_Param.udtPara;
end_for;

(*========================================================================================*)
	(*A11 module communication*)
(*========================================================================================*)
A11_Com(xActivate:= true,bSelect:= byte#16#07,xVoltage:= false,udtPara:=udtA11Param,arrProcIn:= A11_ProcIn);
	A11_Ready			:=	A11_Com.xReady;
	A11_Err				:=	A11_Com.xError;
	A11_DiagCode		:=	A11_Com.wDiagCode;
	A11_Frmwr			:=	A11_Com.strFirmware;
	udtA11Status		:=	A11_Com.udtStatus;
	udtA11Param 		:=	A11_Com.udtPara;
	A11_ProcOut			:=	A11_Com.arrProcOut;
(*========================================================================================*)
	(*A11 module diagnostic*)
(*========================================================================================*)
for i:= 1 to 3 do
	j:= i + 15;
	A11_Diag(udtStatus:= udtA11Status,iChannel:= i);
	AI[j].CW.ExtFault:= not A11_Diag.xDataValid;
	AI[j].DiagCode:= A11_Diag.wDiagCode;
	AI[j].PIW:= real_to_int(A11_Diag.rCurrentValue);
end_for;




(*========================================================================================*)	
	(*A12 module parametrization*)
(*========================================================================================*)
for i:= 1 to 2 do
	j:= i + 19;
	A12_Param(iChannel:= i,iMode:= 0,iFilter:= 0,rHighLimit:= 10000.0,rLowLimit:= 0.0,udtPara:= udtA12Param);
	udtA12Param:= A12_Param.udtPara;
end_for;

(*========================================================================================*)
	(*A12 module communication*)
(*========================================================================================*)
A12_Com(xActivate:= true,bSelect:= byte#16#03,xVoltage:= false,udtPara:=udtA12Param,arrProcIn:= A12_ProcIn);
	A12_Ready			:=	A12_Com.xReady;
	A12_Err				:=	A12_Com.xError;
	A12_DiagCode		:=	A12_Com.wDiagCode;
	A12_Frmwr			:=	A12_Com.strFirmware;
	udtA12Status		:=	A12_Com.udtStatus;
	udtA12Param 		:=	A12_Com.udtPara;
	A12_ProcOut			:=	A12_Com.arrProcOut;
(*========================================================================================*)
	(*A12 module diagnostic*)
(*========================================================================================*)
for i:= 1 to 2 do
	j:= i + 19;
	A12_Diag(udtStatus:= udtA12Status,iChannel:= i);
	AI[j].CW.ExtFault:= not A12_Diag.xDataValid;
	AI[j].DiagCode:= A12_Diag.wDiagCode;
	AI[j].PIW:= real_to_int(A12_Diag.rCurrentValue);
end_for;

(*================================================================================================*)	
	(*FC AO param*)
(*================================================================================================*)
for i:= 16 to 18 do
	j:= i * 32 + 104;
	j1:= j + 1;
	j2:= j + 2;
	
	REAL_TO_MB(IN:=100.0);
	MBTCP_Data[j]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j1]:=REAL_TO_MB.HiWord;

	MBTCP_Data[j2]:= word#10000;
end_for;

for i:= 20 to 21 do
	j:= i * 32 + 104;
	j1:= j + 1;
	j2:= j + 2;
	
	REAL_TO_MB(IN:=100.0);
	MBTCP_Data[j]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j1]:=REAL_TO_MB.HiWord;

	MBTCP_Data[j2]:= word#10000;
end_for;

(*================================================================================================*)	
	(*Analog sensors processing*)
(*================================================================================================*)

AI[0].CW.bar_kgf:= true;
for i:= 2 to 12 do
	AI[i].CW.bar_kgf:= true;
end_for;

for i:= 0 to 23 do
	SensorsFB(Snsr_strct:= AI[i],Buff:= AI_Buff[i],Aux_strct:= AI_AUX[i]);
	AI[i]:=SensorsFB.Snsr_strct;
	AI_BUFF[i]:=SensorsFB.Buff;
	AI_EVENT[i]:=SensorsFB.Event;
	AI_AUX[i]:=SensorsFB.Aux_strct;
end_for;


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
