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
PROGRAM MB_RTU_2

(*Group:NewGroup*)


VAR
	TON_MB_RTU_Master_Startup :	TON;
	MB_AXL_RS_UNI_Act :	BOOL;
	MB_RTU_Master_Act :	BOOL;
	MB_RTU_FC_Act :	BOOL;
	MB_AXL_RS_UNI_REC_2_1 :	MB_AXL_RS_UNI_REC_2;
	udtSerialIF :	MB2_AXL_RSUNI2_UDT_IF;
END_VAR


VAR_EXTERNAL
	arrInData_AXL_RSUNI_2 :	MB2_AXL_RSUNI2_ARR_B_0_19;
	arrOutData_AXL_RSUNI_2 :	MB2_AXL_RSUNI2_ARR_B_0_19;
END_VAR


VAR
	udtDiag_AXL_RSUNI_REC :	MB_UDT_RTU_REC_DIAG;
	wDiagCode_AXL_RSUNI_REC :	WORD;
	wAddDiagCode_AXL_RSUNI_REC :	WORD;
	xError_AXL_RSUNI_REC :	BOOL;
	xBusy_AXL_RSUNI_REC :	BOOL;
	xActive_AXL_RSUNI_REC :	BOOL;
	MB_AXL_RS_UNI_SND_2_1 :	MB_AXL_RS_UNI_SND_2;
	udtDiag_AXL_RSUNI_SND :	MB_UDT_RTU_SND_DIAG;
	wAddDiagCode_AXL_RSUNI_SND :	WORD;
	wDiagCode_AXL_RSUNI_SND :	WORD;
	xError_AXL_RSUNI_SND :	BOOL;
	xBusy_AXL_RSUNI_SND :	BOOL;
	xActive_AXL_RSUNI_SND :	BOOL;
	MB_RTU_Master_4_1 :	MB_RTU_Master_4;
	udtMbData :	udtModbus2_Data;
	udtDiag_RTU_Master :	MB_UDT_RTU_MASTER_DIAG;
	wAddDiagCode_RTU_Master :	WORD;
	wDiagCode_RTU_Master :	WORD;
	xError_RTU_Master :	BOOL;
	xBusy_RTU_Master :	BOOL;
	xActive_RTU_Master :	BOOL;
	uiRespCount_RTU_Master :	UINT;
	uiReqCount_RTU_Master :	UINT;
	MB_RTU_FC3 :	MB_RTU_FC3_3;
	SlvAddr :	MBRTU_SlvAddr;
	RegAddr :	MBRTU_RegAddr;
	arrReadData_RTU_FC3 :	arrModbus2_W_1_125;
	udtDiag_RTU_FC3 :	MB_UDT_RTU_FC_DIAG;
	wAddDiagCode_RTU_FC3 :	WORD;
	wDiagCode_RTU_FC3 :	WORD;
	xError_RTU_FC3 :	BOOL;
	xDone_RTU_FC3 :	BOOL;
	xBusy_RTU_FC3 :	BOOL;
	xActive_RTU_FC3 :	BOOL;
	R_TRIG_1 :	R_TRIG;
	F_TRIG_3 :	F_TRIG;
	i :	INT;
	j :	INT;
	a :	INT;
	State :	INT;
	xSndReq_RTU_FC3 :	BOOL;
	b :	INT;
END_VAR


VAR_EXTERNAL
	SlvData_RSUNI_2 :	MBRTU_SlvData;
END_VAR


VAR
	i1 :	INT;
END_VAR


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;(*PLC status RUN*)
END_VAR


VAR
	FLG :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_RTU_2
IEC_LANGUAGE: ST
*)
(*============================================================================*)
(*MB RTU startup timer*)
(*============================================================================*)
TON_MB_RTU_Master_Startup(IN:=PLCMODE_RUN,PT:=t#2s);
IF TON_MB_RTU_Master_Startup.Q and not (xError_AXL_RSUNI_REC or xError_RTU_Master
	or xError_AXL_RSUNI_SND) THEN
	MB_AXL_RS_UNI_Act		:= true;
	MB_RTU_Master_Act		:= true;
	MB_RTU_FC_Act			:= true;
ELSE
	MB_AXL_RS_UNI_Act		:= false;
	MB_RTU_Master_Act		:= false;
	MB_RTU_FC_Act			:= false;
END_IF;

(*============================================================================*)
(*MB_AXL_UNI_REC FB initialization*)
(*============================================================================*)
MB_AXL_RS_UNI_REC_2_1(xActivate:= MB_AXL_RS_UNI_Act,
	udtSerialIF:= udtSerialIF,
	arrInputData:= arrInData_AXL_RSUNI_2,
	arrOutputData:= arrOutData_AXL_RSUNI_2);

xActive_AXL_RSUNI_REC		:=MB_AXL_RS_UNI_REC_2_1.xActive;
xBusy_AXL_RSUNI_REC			:=MB_AXL_RS_UNI_REC_2_1.xBusy;
xError_AXL_RSUNI_REC		:=MB_AXL_RS_UNI_REC_2_1.xError;
wDiagCode_AXL_RSUNI_REC		:=MB_AXL_RS_UNI_REC_2_1.wDiagCode;
wAddDiagCode_AXL_RSUNI_REC	:=MB_AXL_RS_UNI_REC_2_1.wAddDiagCode;
udtDiag_AXL_RSUNI_REC		:=MB_AXL_RS_UNI_REC_2_1.udtDiag;
udtSerialIF					:=MB_AXL_RS_UNI_REC_2_1.udtSerialIF;
arrInData_AXL_RSUNI_2		:=MB_AXL_RS_UNI_REC_2_1.arrInputData;
arrOutData_AXL_RSUNI_2		:=MB_AXL_RS_UNI_REC_2_1.arrOutputData;

(*============================================================================*)
(*MB RTU Master FB initialization*)
(*============================================================================*)
MB_RTU_Master_4_1(xActivate:= xActive_AXL_RSUNI_REC and xActive_AXL_RSUNI_SND,
	xReset:= false,
	xAuto_CRC:= false,
	tTimeout:= t#200ms,
	udtSerialIF:= udtSerialIF,
	udtMbData:= udtMbData);

xActive_RTU_Master			:=MB_RTU_Master_4_1.xActive;
xBusy_RTU_Master			:=MB_RTU_Master_4_1.xBusy;
uiReqCount_RTU_Master		:=MB_RTU_Master_4_1.uiRequestsCounter;
uiRespCount_RTU_Master		:=MB_RTU_Master_4_1.uiResponsesCounter;
xError_RTU_Master			:=MB_RTU_Master_4_1.xError;
wDiagCode_RTU_Master		:=MB_RTU_Master_4_1.wDiagCode;
wAddDiagCode_RTU_Master		:=MB_RTU_Master_4_1.wAddDiagCode;
udtDiag_RTU_Master			:=MB_RTU_Master_4_1.udtDiag;
udtSerialIF					:=MB_RTU_Master_4_1.udtSerialIF;
udtMbData					:=MB_RTU_Master_4_1.udtMbData;

(*============================================================================*)
(*MB_AXL_UNI_SND FB initialization*)
(*============================================================================*)
MB_AXL_RS_UNI_SND_2_1(xActivate:= MB_AXL_RS_UNI_Act,
	udtSerialIF:= udtSerialIF,
	arrInputData:= arrInData_AXL_RSUNI_2,
	arrOutputData:= arrOutData_AXL_RSUNI_2);

xActive_AXL_RSUNI_SND		:=MB_AXL_RS_UNI_SND_2_1.xActive;
xBusy_AXL_RSUNI_SND			:=MB_AXL_RS_UNI_SND_2_1.xBusy;
xError_AXL_RSUNI_SND		:=MB_AXL_RS_UNI_SND_2_1.xError;
wDiagCode_AXL_RSUNI_SND		:=MB_AXL_RS_UNI_SND_2_1.wDiagCode;
wAddDiagCode_AXL_RSUNI_SND	:=MB_AXL_RS_UNI_SND_2_1.wAddDiagCode;
udtDiag_AXL_RSUNI_SND		:=MB_AXL_RS_UNI_SND_2_1.udtDiag;
udtSerialIF					:=MB_AXL_RS_UNI_SND_2_1.udtSerialIF;
arrInData_AXL_RSUNI_2		:=MB_AXL_RS_UNI_SND_2_1.arrInputData;
arrOutData_AXL_RSUNI_2		:=MB_AXL_RS_UNI_SND_2_1.arrOutputData;

(*============================================================================*)
(*Slaves registers addresses assigning*)
(*============================================================================*)
R_TRIG_1(CLK:= xActive_RTU_Master);

SlvAddr[0]					:= uint#10;											(*Pump 3.1 FC MB address*)
SlvAddr[1]					:= uint#11;											(*Pump 3.2 FC MB address*)
SlvAddr[2]					:= uint#12;											(*Pump 3.3 FC MB address*)
SlvAddr[3]					:= uint#13;											(*Pump 6.1 FC MB address*)
SlvAddr[4]					:= uint#14;											(*Pump 6.2 FC MB address*)

SlvAddr[5]					:= uint#21;											(*FT020 MB address*)
SlvAddr[6]					:= uint#22;											(*FT1107 MB address*)
SlvAddr[7]					:= uint#23;											(*FT1207 MB address*)
SlvAddr[8]					:= uint#24;											(*FT1307 MB address*)
SlvAddr[9]					:= uint#25;											(*FT2108 MB address*)
SlvAddr[10]					:= uint#20;											(*FT2208 MB address*)

IF R_TRIG_1.Q or FLG THEN
	i:= 0;
	j:= 0;
	FOR i1:= 0 to 4 DO
		RegAddr[i1][0]		:= uint#16129;										(*reg.16129 Frequency Hz*)
		RegAddr[i1][1]		:= uint#16099;										(*reg.16099 Power kWt*)
		RegAddr[i1][2]		:= uint#16139;										(*reg.16139 Motor Current A*)
		RegAddr[i1][3]		:= uint#16339;										(*reg.16339 HeatSink Temp.*)
		RegAddr[i1][4]		:= uint#16029;										(*reg.16029 Status Word*)
		RegAddr[i1][5]		:= uint#16899;										(*reg.16899 Alarm Word*)
		RegAddr[i1][6]		:= uint#16919;										(*reg.16919 Warning Word*)
		RegAddr[i1][7]		:= uint#15009;										(*reg.15009 Running hours h*)
		RegAddr[i1][8]		:= uint#15019;										(*reg.15019 kWh Counter*)
	END_FOR;

	FOR i1:= 5 to 9 DO
		RegAddr[i1][0]		:= uint#3874;										(*reg.3874 Volume flow*)
		RegAddr[i1][1]		:= uint#2610;										(*reg.2610 Totalizer val.*)
	END_FOR;

		RegAddr[10][0]		:= uint#0;											(*reg.0 Volume flow*)
		RegAddr[10][1]		:= uint#2;											(*reg.2 Totalizer val.*)

END_IF;


(*============================================================================*)
(*Pumps FCs parameters reading*)
(*============================================================================*)
MB_RTU_FC3(xActivate:= MB_RTU_Master_Act,
	xSendRequest:= xSndReq_RTU_FC3,
	xEnablePoll:=false,
	tPollInterval:= t#100ms,
	uiSlaveAddress:= SlvAddr[i],
	uiStartAddress:=RegAddr[i][j],
	iDataCount:= 2,
	arrReadData:= arrReadData_RTU_FC3,
	udtMbData:= udtMbData);

xActive_RTU_FC3				:=MB_RTU_FC3.xActive; 
xBusy_RTU_FC3				:=MB_RTU_FC3.xBusy;
xDone_RTU_FC3				:=MB_RTU_FC3.xDone;
xError_RTU_FC3				:=MB_RTU_FC3.xError;
wDiagCode_RTU_FC3			:=MB_RTU_FC3.wDiagCode;
wAddDiagCode_RTU_FC3		:=MB_RTU_FC3.wAddDiagCode;
udtDiag_RTU_FC3				:=MB_RTU_FC3.udtDiag;
arrReadData_RTU_FC3			:=MB_RTU_FC3.arrReadData;
udtMbData					:=MB_RTU_FC3.udtMbData;


CASE State OF
	0:	
		IF xActive_RTU_Master THEN
			xSndReq_RTU_FC3 := true;
			State:= 10; 
		END_IF;

	10:	
		IF MB_RTU_FC3.xDone or MB_RTU_FC3.xError THEN
			xSndReq_RTU_FC3 := false;
			State:= 100;
		END_IF;

	100:
		a:= j * 2;
		b:= a + 1;	

		SlvData_RSUNI_2[i][a]:= arrReadData_RTU_FC3[1];
		SlvData_RSUNI_2[i][b]:= arrReadData_RTU_FC3[2];
		State:= 1000;
	
	1000:
		j:= j + 1;	
		IF (j > 8) or ((i > 4) and (j > 1)) THEN
			j:= 0;
			i:= i + 1;
		END_IF;

		IF i > 10 THEN
			i:= 0;
		END_IF;

		State:= 0;
END_CASE;			

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
