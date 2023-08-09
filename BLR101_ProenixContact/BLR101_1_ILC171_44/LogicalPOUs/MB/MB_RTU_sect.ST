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
PROGRAM MB_RTU_sect

(*Group:Default*)


VAR
	TON_MB_RTU_Master_Startup :	TON;
END_VAR


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;(*PLC status RUN*)
END_VAR


VAR
	xMB_RTU_Master_Err :	BOOL;
	xMB_RTU_Master_ON :	BOOL;
END_VAR


VAR_EXTERNAL
	udtMB_Data :	udtModbus2_Data;
END_VAR


VAR
	xMB_RTU_Master_Act :	BOOL;
	xMB_RTU_Master_Busy :	BOOL;
	xMB_RTU_Master_Ready :	BOOL;
	uiMB_RTU_Master_ReqCount :	UINT;
	uiMB_RTU_Master_RespCount :	UINT;
	MB_RTU_Master_udtData :	MB2_RSUNI_UDT_DATA_V1;
	wMB_RTU_Master_Diag :	WORD;
	wMB_RTU_Master_AddDiag :	WORD;
	xMB_RTU_FC_ON :	BOOL;
END_VAR


VAR_EXTERNAL
	arrIN_Address :	MB2_RSUNI_ARR_B_1_62;
	arrOUT_Address :	MB2_RSUNI_ARR_B_1_62;
	Boiler :	Blr;
	wBrnSP :	WORD;
END_VAR


VAR
	R_TRIG_1 :	R_TRIG;
	F_TRIG_1 :	F_TRIG;
	MB_IL_UNI31_Master :	MB_IL_UNI31_Master_2;
	MB_RTU_FC6 :	MB_RTU_FC6_V2_01;
	MB_RTU_FC3 :	MB_RTU_FC3_V2_01;
END_VAR


VAR_EXTERNAL
	arrFC3_ReadData :	arrModbus2_W_1_125;
END_VAR


VAR
	xFC6_Act :	BOOL;
	xFC6_Busy :	BOOL;
	xFC6_Done :	BOOL;
	xFC6_Err :	BOOL;
	wFC6_Diag :	WORD;
	wFC6_AddDiag :	WORD;
	xFC3_Act :	BOOL;
	xFC3_Busy :	BOOL;
	xFC3_Done :	BOOL;
	xFC3_Err :	BOOL;
	wFC3_Diag :	WORD;
	wFC3_AddDiag :	WORD;
	i :	INT;
	uiSlvAddr :	UINT;
	uiSlvReg :	UINT;
	iSlvRegCount :	INT;
END_VAR


VAR_EXTERNAL
	arrSlvReadData :	SlvReadData;
END_VAR


VAR
	F_TRIG_2 :	F_TRIG;
	F_TRIG_3 :	F_TRIG;
	j :	INT;
	R_TRIG_2 :	R_TRIG;
END_VAR


VAR_EXTERNAL
	BrnrSP :	REAL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_RTU_sect
IEC_LANGUAGE: ST
*)

	(*MB RTU startup timer*)
TON_MB_RTU_Master_Startup(IN:=PLCMODE_RUN,PT:=t#2s);
if TON_MB_RTU_Master_Startup.Q and not xMB_RTU_Master_Err then
	xMB_RTU_Master_ON:=true;
	xMB_RTU_FC_ON:=true;
else
	xMB_RTU_Master_ON:=false;
	xMB_RTU_FC_ON:=false;
end_if;


	(*MB RTU Master FB initialization*)
MB_IL_UNI31_Master(xActivate:=xMB_RTU_Master_ON,bSelectMode:=byte#16#1,diBaudrate:=dint#19200,wDataWidth:=word#16#4,xDTR_Control:=false,xDTR:=false,tTimeout:=t#1s,xReset:=false,udtMBData:=udtMB_Data,arrInputAddress:=arrIN_Address,arrOutputAddress:=arrOUT_Address);
xMB_RTU_Master_Act:=MB_IL_UNI31_Master.xActive;
xMB_RTU_Master_Busy:=MB_IL_UNI31_Master.xBusy;
xMB_RTU_Master_Ready:=MB_IL_UNI31_Master.xReady;
uiMB_RTU_Master_ReqCount:=MB_IL_UNI31_Master.uiRequestsCounter;
uiMB_RTU_Master_RespCount:=MB_IL_UNI31_Master.uiResponsesCounter;
MB_RTU_Master_udtData:=MB_IL_UNI31_Master.udtAddData;
xMB_RTU_Master_Err:=MB_IL_UNI31_Master.xError;
wMB_RTU_Master_Diag:=MB_IL_UNI31_Master.wDiagCode;
wMB_RTU_Master_AddDiag:=MB_IL_UNI31_Master.wAddDiagCode;
udtMB_Data:=MB_IL_UNI31_Master.udtMBData;
arrIN_Address:=MB_IL_UNI31_Master.arrInputAddress;
arrOUT_Address:=MB_IL_UNI31_Master.arrOutputAddress;




	(*Slaves registers addresses assigning*)
case i of
	0:	uiSlvAddr:= uint#1;
		uiSlvReg:= uint#0;
		iSlvRegCount:= 20;

	1:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#16029;	(*reg.16029 Status Word*)
		iSlvRegCount:= 2;

	2:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#16029;	(*reg.16029 Status Word*)
		iSlvRegCount:= 2;

	3:	uiSlvAddr:= uint#4;
		uiSlvReg:= uint#3873;
		iSlvRegCount:= 2;

	4:	uiSlvAddr:= uint#1;
		uiSlvReg:= uint#21;
		iSlvRegCount:= 19;

	5:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#16099;
		iSlvRegCount:= 2;

	6:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#16099;
		iSlvRegCount:= 2;

	7:	uiSlvAddr:= uint#4;
		uiSlvReg:= uint#2609;
		iSlvRegCount:= 2;

	8:	uiSlvAddr:= uint#1;
		uiSlvReg:= uint#60;
		iSlvRegCount:= 20;

	9:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#16129;	(*reg.16129 Frequency Hz*)
		iSlvRegCount:= 2;

	10:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#16129;	(*reg.16129 Frequency Hz*)
		iSlvRegCount:= 2;

	11:	uiSlvAddr:= uint#4;
		uiSlvReg:= uint#3009;
		iSlvRegCount:= 2;

	12:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#16139;	(*reg.16139 Motor Current A*)
		iSlvRegCount:= 2;

	13:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#16139;	(*reg.16139 Motor Current A*)
		iSlvRegCount:= 2;

	14:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#16899;	(*reg.16899 Alarm Word*)
		iSlvRegCount:= 2;

	15:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#16899;	(*reg.16899 Alarm Word*)
		iSlvRegCount:= 2;

	16:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#16919;	(*reg.16919 Warning Word*)
		iSlvRegCount:= 2;

	17:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#16919;	(*reg.16919 Warning Word*)
		iSlvRegCount:= 2;

	18:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#15009;	(*reg.15009 Running hours h*)
		iSlvRegCount:= 2;

	19:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#15009;	(*reg.15009 Running hours h*)
		iSlvRegCount:= 2;

	20:	uiSlvAddr:= uint#2;
		uiSlvReg:= uint#15019;	(*reg.15019 kWh Counter*)
		iSlvRegCount:= 2;

	21:	uiSlvAddr:= uint#3;
		uiSlvReg:= uint#15019;	(*reg.15019 kWh Counter*)
		iSlvRegCount:= 2;
end_case;



(*			arrRegAddr[0]:= uint#0;
			arrRegCount[0]:= 20;

			arrRegAddr[1]:= uint#21;
			arrRegCount[1]:= 19;

			arrRegAddr[2]:= uint#40;
			arrRegCount[2]:= 9;


	(*Pump inverter registers addresses assigning*)
					(*reg.16029 Status Word*)
					(*reg.16099 Power kW*)
					(*reg.16129 Frequency Hz*)
					(*reg.16139 Motor Current A*)
					(*reg.16899 Alarm Word*)
					(*reg.16919 Warning Word*)
					(*reg.15009 Running hours h*)
					(*reg.15019 kWh Counter*)

	(*Flow meter registers addresses assigning*)
					(*reg.3873 Volume Flow*)
					(*reg.2609 Totalizer Direct Flow*)
					(*reg.2809 Totalizer Reverse Flow*)

R_TRIG_1(CLK:=xMB_RTU_Master_ON);
R_TRIG_2(CLK:= (j = 4));

	(*Burning Controller Set Point writing*)
MB_RTU_FC6(xActivate:=xMB_RTU_Master_Act,xSendRequest:=R_TRIG_1.Q or R_TRIG_2.Q,xEnablePoll:=false,tPollInterval:=t#1s,uiSlaveAddress:=uint#1,uiStartAddress:=uint#45,wValue:=real_to_word(BrnrSP * 10.0),udtMbData:=udtMB_Data);
xFC6_Act:=MB_RTU_FC6.xActive;
xFC6_Busy:=MB_RTU_FC6.xBusy;
xFC6_Done:=MB_RTU_FC6.xDone;
xFC6_Err:=MB_RTU_FC6.xError;
wFC6_Diag:=MB_RTU_FC6.wDiagCode;
wFC6_AddDiag:=MB_RTU_FC6.wAddDiagCode;
udtMB_Data:=MB_RTU_FC6.udtMbData;

F_TRIG_2(CLK:=(MB_RTU_FC6.xDone or MB_RTU_FC6.xError));

	(*Burning Controller parameters reading*)
MB_RTU_FC3(xActivate:=xMB_RTU_Master_Act,xSendRequest:=(F_TRIG_2.Q or (F_TRIG_3.Q and (j <> 4))),xEnablePoll:=false,tPollInterval:=t#50ms,uiSlaveAddress:=uiSlvAddr,uiStartAddress:=uiSlvReg,iDataCount:=iSlvRegCount,arrReadData:=arrSlvReadData[i],udtMbData:=udtMB_Data);
xFC3_Act:=MB_RTU_FC3.xActive;
xFC3_Busy:=MB_RTU_FC3.xBusy;
xFC3_Done:=MB_RTU_FC3.xDone;
xFC3_Err:=MB_RTU_FC3.xError;
wFC3_Diag:=MB_RTU_FC3.wDiagCode;
wFC3_AddDiag:=MB_RTU_FC3.wAddDiagCode;
arrSlvReadData[i]:=MB_RTU_FC3.arrReadData;
udtMB_Data:=MB_RTU_FC3.udtMbData;

F_TRIG_3(CLK:=MB_RTU_FC3.xDone or MB_RTU_FC3.xError);

if F_TRIG_3.Q then
	i:= i + 1;
	j:= j + 1;
end_if;

if i > 21 then
	i:= 0;
end_if;

if j > 4 then
	j:= 0;
end_if;























(*@KEY@: END_WORKSHEET *)
END_PROGRAM
