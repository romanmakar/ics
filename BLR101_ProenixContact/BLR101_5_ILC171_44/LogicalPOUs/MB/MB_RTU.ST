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
PROGRAM MB_RTU

(*Group:Default*)


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;(*PLC status RUN*)
END_VAR


VAR
	TON_MB_RTU_Master_Startup :	TON;
	MB_RTU_Master :	MB_IL_UNI31_Master_3;
	MBRTU_MasterAct :	BOOL;
	udtMbData :	udtModbus2_Data;
END_VAR


VAR_EXTERNAL
	MBRTU_InputAddress :	MB2_RSUNI_ARR_B_1_62;
	MBRTU_OutputAddress :	MB2_RSUNI_ARR_B_1_62;
END_VAR


VAR
	MBRTU_MasterActive :	BOOL;
	MBRTU_MasterBusy :	BOOL;
	MBRTU_MasterReady :	BOOL;
	MBRTU_MasterReqCount :	UINT;
	MBRTU_MasterRespCount :	UINT;
	MBRTU_MasterAddData :	MB2_RSUNI_UDT_DATA_V1;
	MBRTU_MasterErr :	BOOL;
	MBRTU_MasterDiagCode :	WORD;
	MBRTU_MasterAddDiagCode :	WORD;
	MBRTU_MasterDiag :	MB_UDT_IL_UNI_MASTER_DIAG;
	R_TRIG_1 :	R_TRIG;
	SlvAddr :	MBRTU_SlvAddr;
	RegAddr :	MBRTU_RegAddr;
	i :	INT;
	j :	INT;
	i1 :	INT;
	MB_RTU_FC3 :	MB_RTU_FC3_3;
	MBRTU_FC3_SndReq :	BOOL;
	MBRTU_FC3_ReadData :	arrModbus2_W_1_125;
	MBRTU_FC3_Active :	BOOL;
	MBRTU_FC3_Busy :	BOOL;
	MBRTU_FC3_Done :	BOOL;
	MBRTU_FC3_Err :	BOOL;
	MBRTU_FC3_DiagCode :	WORD;
	MBRTU_FC3_AddDiagCode :	WORD;
	MBRTU_FC3_Diag :	MB_UDT_RTU_FC_DIAG;
	a :	INT;
	b :	INT;
END_VAR


VAR_EXTERNAL
	MBRTU_Data :	MBRTU_SlvData;
END_VAR


VAR
	State :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_RTU
IEC_LANGUAGE: ST
*)
(*========================================================================================*)
(*MB RTU startup timer*)
(*========================================================================================*)
TON_MB_RTU_Master_Startup(IN:=PLCMODE_RUN,PT:=t#2s);
MBRTU_MasterAct:= TON_MB_RTU_Master_Startup.Q and not MBRTU_MasterErr;

(*========================================================================================*)
(*MB RTU Master FB initialization*)
(*========================================================================================*)
MB_RTU_Master(xActivate:= MBRTU_MasterAct,bSelectMode:= byte#16#1,diBaudrate:= dint#38400,wDataWidth:= word#16#4,xDTR_Control:= false,xDTR:= false,tTimeout:= t#1s,xReset:= false,udtMBData:= udtMbData,arrInputAddress:= MBRTU_InputAddress,arrOutputAddress:= MBRTU_OutputAddress);
	MBRTU_MasterActive		:=	MB_RTU_Master.xActive;
	MBRTU_MasterBusy		:=	MB_RTU_Master.xBusy;
	MBRTU_MasterReady		:=	MB_RTU_Master.xReady;
	MBRTU_MasterReqCount	:=	MB_RTU_Master.uiRequestsCounter;
	MBRTU_MasterRespCount	:=	MB_RTU_Master.uiResponsesCounter;
	MBRTU_MasterAddData		:=	MB_RTU_Master.udtAddData;
	MBRTU_MasterErr			:=	MB_RTU_Master.xError;
	MBRTU_MasterDiagCode	:=	MB_RTU_Master.wDiagCode;
	MBRTU_MasterAddDiagCode	:=	MB_RTU_Master.wAddDiagCode;
	MBRTU_MasterDiag		:=	MB_RTU_Master.udtDiag;
	udtMbData				:=	MB_RTU_Master.udtMBData;
	MBRTU_InputAddress		:=	MB_RTU_Master.arrInputAddress;
	MBRTU_OutputAddress		:=	MB_RTU_Master.arrOutputAddress;

(*========================================================================================*)
(*Slaves registers addresses assigning*)
(*========================================================================================*)
R_TRIG_1(CLK:= MBRTU_MasterActive);

SlvAddr[0]					:= uint#10;		(*Pump 2.1 FC MB address*)
SlvAddr[1]					:= uint#11;		(*Pump 2.2 FC MB address*)
SlvAddr[2]					:= uint#12;		(*Pump 2.3 FC MB address*)
SlvAddr[3]					:= uint#13;		(*Pump 2.4 FC MB address*)
SlvAddr[4]					:= uint#14;		(*Pump 2.5 FC MB address*)

if R_TRIG_1.Q then
	i:= 0;
	j:= 0;
	for i1:= 0 to 4 do
		(*RegAddr[i1][0]	:= uint#16129;	(*reg.16129 Frequency Hz*)
		RegAddr[i1][0]		:= uint#16099;	(*reg.16099 Power kWt*)
		RegAddr[i1][1]		:= uint#16139;	(*reg.16139 Motor Current A*)
		RegAddr[i1][2]		:= uint#16339;	(*reg.16339 HeatSink Temp.*)
		RegAddr[i1][3]		:= uint#16029;	(*reg.16029 Status Word*)
		RegAddr[i1][4]		:= uint#16899;	(*reg.16899 Alarm Word*)
		RegAddr[i1][5]		:= uint#16919;	(*reg.16919 Warning Word*)
		RegAddr[i1][6]		:= uint#15009;	(*reg.15009 Running hours h*)
		RegAddr[i1][7]		:= uint#15019;	(*reg.15019 kWh Counter*)
	end_for;
end_if;

(*========================================================================================*)
(*Pumps FCs parameters reading*)
(*========================================================================================*)

MB_RTU_FC3(xActivate:= MBRTU_MasterActive,xSendRequest:= MBRTU_FC3_SndReq,xEnablePoll:=false,tPollInterval:= t#100ms,uiSlaveAddress:= SlvAddr[i],uiStartAddress:= RegAddr[i][j],iDataCount:= 2,arrReadData:= MBRTU_FC3_ReadData,udtMbData:= udtMbData);
	MBRTU_FC3_Active		:=	MB_RTU_FC3.xActive;
	MBRTU_FC3_Busy			:=	MB_RTU_FC3.xBusy;
	MBRTU_FC3_Done			:=	MB_RTU_FC3.xDone;
	MBRTU_FC3_Err			:=	MB_RTU_FC3.xError;
	MBRTU_FC3_DiagCode		:=	MB_RTU_FC3.wDiagCode;
	MBRTU_FC3_AddDiagCode	:=	MB_RTU_FC3.wAddDiagCode;
	MBRTU_FC3_Diag			:=	MB_RTU_FC3.udtDiag;
	MBRTU_FC3_ReadData		:=	MB_RTU_FC3.arrReadData;
	udtMbData				:=	MB_RTU_FC3.udtMbData;

case State of
	0:	
		if MBRTU_MasterActive then
			MBRTU_FC3_SndReq := true;
			State:= 10; 
		end_if;

	10:	
		if MB_RTU_FC3.xDone or MB_RTU_FC3.xError then
			MBRTU_FC3_SndReq := false;
			State:= 100;
		end_if;

	100:
		a:= j * 2;
		b:= a + 1;

		MBRTU_Data[i][a]:= MBRTU_FC3_ReadData[1];
		MBRTU_Data[i][b]:= MBRTU_FC3_ReadData[2];
		State:= 1000;
	
	1000:
		j:= j + 1;	
		if j > 7 then
			j:= 0;
			i:= i + 1;
		end_if;

		if i > 4 then
			i:= 0;
		end_if;

		State:= 0;
end_case;			


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
