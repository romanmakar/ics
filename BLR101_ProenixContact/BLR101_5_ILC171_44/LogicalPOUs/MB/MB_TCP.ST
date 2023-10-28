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
PROGRAM MB_TCP

(*Group:Default*)


VAR
	TON_MBTCP_Master_Startup :	TON;
END_VAR


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;(*PLC status RUN*)
END_VAR


VAR
	MBTCP_SrvAct :	BOOL;
	MBTCP_Srv1Err :	BOOL;
	MB_TCP_Server_1 :	MB_TCP_Server_1;
	MBTCP_Srv1Ack :	BOOL;
END_VAR


VAR_EXTERNAL
	MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


VAR
	MBTCP_Srv1Active :	BOOL;
	MBTCP_Srv1Conn :	BOOL;
	MBTCP_Srv1DiagCode :	WORD;
	MBTCP_Srv1AddDiagCode :	WORD;
	MBTCP_Srv1Diag :	MB_TCP_UDT_SER_DIAG;
	MBTCP_Srv2Active :	BOOL;
	MBTCP_Srv2Conn :	BOOL;
	MBTCP_Srv2Err :	BOOL;
	MBTCP_Srv2DiagCode :	WORD;
	MBTCP_Srv2AddDiagCode :	WORD;
	MBTCP_Srv2Diag :	MB_TCP_UDT_SER_DIAG;
END_VAR


VAR_EXTERNAL
	AI :	SENSOR;
END_VAR


VAR
	i :	INT;
	j :	INT;
	j1 :	INT;
	j2 :	INT;
	j3 :	INT;
	j4 :	INT;
	j5 :	INT;
	j6 :	INT;
	j7 :	INT;
	j8 :	INT;
	j9 :	INT;
	j10 :	INT;
	j11 :	INT;
	j12 :	INT;
	j13 :	INT;
	j14 :	INT;
	j15 :	INT;
	j16 :	INT;
	j17 :	INT;
	j18 :	INT;
	j19 :	INT;
	j20 :	INT;
	j21 :	INT;
	j22 :	INT;
	j23 :	INT;
	j24 :	INT;
	j25 :	INT;
	j26 :	INT;
	j27 :	INT;
	j28 :	INT;
	j29 :	INT;
	j30 :	INT;
	j31 :	INT;
	MB_TO_REAL :	MB_TO_REAL;
	REAL_TO_MB :	REAL_TO_MB;
END_VAR


VAR_EXTERNAL
	M :	MOTOR;
END_VAR


VAR
	MB_TCP_Server_2 :	MB_TCP_Server_1;
END_VAR


VAR_EXTERNAL
	WarnWord :	WRN;
	CCL :	CYCLE;
	RGLTR :	REGULATOR;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_TCP
IEC_LANGUAGE: ST
*)
(*========================================================================================*)
(*MB TCP startup timer*)
(*========================================================================================*)
TON_MBTCP_Master_Startup(IN:=PLCMODE_RUN,PT:=t#2s);
MBTCP_SrvAct:= TON_MBTCP_Master_Startup.Q;

(*========================================================================================*)
(*MB TCP server #1 FB initialization port 503*)
(*========================================================================================*)
MB_TCP_Server_1(xActivate:=MBTCP_SrvAct,xAcknowledge:=MBTCP_Srv1Ack,xAutoAck:=true,xUDP_Mode:=false,iTCP_Port:=503,(*strPartner_IP:= STRING *)tReconnectDelay:=t#100ms,tTimeout:=t#0s,uiOffsetInputRegister:=uint#0,uiOffsetHoldingRegister:=uint#0,uiOffsetInputs:=uint#0,uiOffsetCoils:=uint#0,arrModbusData:=MBTCP_Data);
	MBTCP_Srv1Active		:=	MB_TCP_Server_1.xActive;
	MBTCP_Srv1Conn			:=	MB_TCP_Server_1.xConnected;
	MBTCP_Srv1Err			:=	MB_TCP_Server_1.xError;
	MBTCP_Srv1DiagCode		:=	MB_TCP_Server_1.wDiagCode;
	MBTCP_Srv1AddDiagCode	:=	MB_TCP_Server_1.wAddDiagCode;
	MBTCP_Srv1Diag			:=	MB_TCP_Server_1.udtDiag;
	MBTCP_Data				:=	MB_TCP_Server_1.arrModbusData;

(*========================================================================================*)
(*MB TCP server #2 FB initialization port 503*)
(*========================================================================================*)
MB_TCP_Server_2(xActivate:=MBTCP_SrvAct,xAcknowledge:=MBTCP_Srv1Ack,xAutoAck:=true,xUDP_Mode:=false,iTCP_Port:=503,(*strPartner_IP:= STRING *)tReconnectDelay:=t#100ms,tTimeout:=t#0s,uiOffsetInputRegister:=uint#0,uiOffsetHoldingRegister:=uint#0,uiOffsetInputs:=uint#0,uiOffsetCoils:=uint#0,arrModbusData:=MBTCP_Data);
	MBTCP_Srv2Active		:=	MB_TCP_Server_2.xActive;
	MBTCP_Srv2Conn			:=	MB_TCP_Server_2.xConnected;
	MBTCP_Srv2Err			:=	MB_TCP_Server_2.xError;
	MBTCP_Srv2DiagCode		:=	MB_TCP_Server_2.wDiagCode;
	MBTCP_Srv2AddDiagCode	:=	MB_TCP_Server_2.wAddDiagCode;
	MBTCP_Srv2Diag			:=	MB_TCP_Server_2.udtDiag;
	MBTCP_Data				:=	MB_TCP_Server_2.arrModbusData;


(*========================================================================================*)
(*Read/Write Cycle CW from/to Modbus array / addr.1*)
(*========================================================================================*)
(*	CCL[0].CW.AuxON			:=	MBTCP_Data[0].X0;*)
	CCL[0].CW.Start			:=	MBTCP_Data[0].X1;
	CCL[0].CW.Stop			:=	MBTCP_Data[0].X2;
(*	CCL[0].CW.PulseStart	:=	MBTCP_Data[0].X3;*)
	CCL[0].CW.ACK 			:=	MBTCP_Data[0].X4;
	CCL[0].CW.Rotation		:=	MBTCP_Data[0].X8;
	MBTCP_Data[0]			:=	word#0;
(*========================================================================================*)
	(*Write Cycle SW to Modbus array / addr.2*)
(*========================================================================================*)
	MBTCP_Data[1].X0		:=	CCL[0].SW.ALARM;
	MBTCP_Data[1].X1		:=	CCL[0].SW.ON;
	MBTCP_Data[1].X2		:=	CCL[0].SW.Running;
	MBTCP_Data[1].X8		:=	CCL[0].SW.RotationON;

(*========================================================================================*)
	(*Write Cycle SW to Modbus array / addr.10*)
(*========================================================================================*)
	MBTCP_Data[10].X0		:=	WarnWord.InputVoltage_1;
	MBTCP_Data[10].X1		:=	WarnWord.InputVoltage_2;
	MBTCP_Data[10].X2		:=	WarnWord.UPS_Fault;
	MBTCP_Data[10].X3		:=	WarnWord.UPS_Chrg;
	MBTCP_Data[10].X4		:=	WarnWord.UPS_Dischrg;
	MBTCP_Data[10].X5		:=	WarnWord.EmergStop;
	MBTCP_Data[10].X6		:=	WarnWord.UnautAccess;
	MBTCP_Data[10].X7		:=	WarnWord.Fire;
	MBTCP_Data[10].X8		:=	WarnWord.CO_HL;
	MBTCP_Data[10].X9		:=	WarnWord.CO_HH;
	MBTCP_Data[10].X10		:=	WarnWord.CH_HH;

(*========================================================================================*)
(*Read/Write sensors parameters from/to Modbus array  / addr.100 - addr.1698*)
(*========================================================================================*)
for i:= 0 to 49 do
	j:= i * 32 + 100;
	j1:= j + 1;
	j2:= j + 2;
	j3:= j + 3;
	j4:= j + 4;
	j5:= j + 5;
	j6:= j + 6;
	j7:= j + 7;
	j8:= j + 8;
	j9:= j + 9;
	j10:= j + 10;
	j11:= j + 11;
	j12:= j + 12;
	j13:= j + 13;
	j14:= j + 14;
	j15:= j + 15;
	j16:= j + 16;
	j17:= j + 17;
	j18:= j + 18;
	j19:= j + 19;
	j20:= j + 20;
	j21:= j + 21;
	j22:= j + 22;
	j23:= j + 23;
	j24:= j + 24;
	j25:= j + 25;
	j26:= j + 26;
	j27:= j + 27;
	j28:= j + 28;
	j29:= j + 29;
	j30:= j + 30;
	j31:= j + 31;

	AI[i].CW.FltrEn			:=	MBTCP_Data[j].X0;
	AI[i].CW.LimEn			:=	MBTCP_Data[j].X1;
	AI[i].CW.SimEn			:=	MBTCP_Data[j].X2;

	MBTCP_Data[j1].X0		:=	AI[i].SW.Fault;	
	MBTCP_Data[j1].X1		:=	AI[i].SW.HH_alarm;	
	MBTCP_Data[j1].X2		:=	AI[i].SW.HL_alarm;
	MBTCP_Data[j1].X3		:=	AI[i].SW.LH_alarm;
	MBTCP_Data[j1].X4		:=	AI[i].SW.LL_alarm;

	MB_TO_REAL(LoWord:=MBTCP_Data[j2],HiWord:=MBTCP_Data[j3]);
	AI[i].Ymin:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j4],HiWord:=MBTCP_Data[j5]);
	AI[i].Ymax:=MB_TO_REAL.OUT;

	AI[i].ADC_Range			:=	word_to_int(MBTCP_Data[j6]);			
	AI[i].SamplingTime		:=	word_to_int(MBTCP_Data[j7]);			

	MB_TO_REAL(LoWord:=MBTCP_Data[j8],HiWord:=MBTCP_Data[j9]);
	AI[i].HH:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j10],HiWord:=MBTCP_Data[j11]);
	AI[i].HL:=MB_TO_REAL.OUT;
			
	MB_TO_REAL(LoWord:=MBTCP_Data[j12],HiWord:=MBTCP_Data[j13]);
	AI[i].LH:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j14],HiWord:=MBTCP_Data[j15]);
	AI[i].LL:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j16],HiWord:=MBTCP_Data[j17]);
	AI[i].DeadBand:=MB_TO_REAL.OUT;

	AI[i].LimDelay			:=	word_to_int(MBTCP_Data[j18]);

	MBTCP_Data[j19]			:=	AI[i].DiagCode;

(*	MB_TO_REAL(LoWord:=MBTCP_Data[j20],HiWord:=MBTCP_Data[j21]);
	AI[i].res1:=MB_TO_REAL.OUT;	*)

	MBTCP_Data[j22]			:= 	int_to_word(AI[i].PIW);
	MBTCP_Data[j23]			:=	int_to_word(AI[i].IntValue);

	REAL_TO_MB(IN:=AI[i].RealValue);
	MBTCP_Data[j24]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j25]:=REAL_TO_MB.HiWord;

	MB_TO_REAL(LoWord:=MBTCP_Data[j26],HiWord:=MBTCP_Data[j27]);
	AI[i].SimValue:=MB_TO_REAL.OUT;
end_for;


(*========================================================================================*)
(*Read/Write motors parameters from/to Modbus array  / addr.1700 - addr.2018*)
(*========================================================================================*)
for i:= 0 to 9 do
	j:= i * 32 + 1700;
	j1:= j + 1;
	j2:= j + 2;
	j3:= j + 3;
	j4:= j + 4;
	j5:= j + 5;
	j6:= j + 6;
	j7:= j + 7;
	j8:= j + 8;
	j9:= j + 9;
	j10:= j + 10;
	j11:= j + 11;
	j12:= j + 12;
	j13:= j + 13;
	j14:= j + 14;
	j15:= j + 15;
	j16:= j + 16;
	j17:= j + 17;
	j18:= j + 18;
	j19:= j + 19;
	j20:= j + 20;
	j21:= j + 21;
	j22:= j + 22;
	j23:= j + 23;
	j24:= j + 24;
	j25:= j + 25;
	j26:= j + 26;
	j27:= j + 27;
	j28:= j + 28;
	j29:= j + 29;
	j30:= j + 30;
	j31:= j + 31;

	M[i].CW.ACK				:=	MBTCP_Data[j].X3;
	M[i].CW.ManMode			:=	MBTCP_Data[j].X4;
	M[i].CW.AutoMode		:=	MBTCP_Data[j].X5;
	M[i].CW.ManStart		:=	MBTCP_Data[j].X6;
	M[i].CW.ManStop			:=	MBTCP_Data[j].X7;
	M[i].CW.SimEn			:=	MBTCP_Data[j].X15;
	MBTCP_Data[j]			:=	word#0;

	MBTCP_Data[j1].X0		:=	M[i].SW.Rem;
	MBTCP_Data[j1].X1		:=	M[i].SW.ManAuto;
	MBTCP_Data[j1].X2		:=	M[i].SW.RUN;
	MBTCP_Data[j1].X3		:=	M[i].SW.COM;
	MBTCP_Data[j1].X4		:=	M[i].SW.AlarmAccum;
	MBTCP_Data[j1].X5		:=	M[i].SW.Ready;

	MB_TO_REAL(LoWord:=MBTCP_Data[j2],HiWord:=MBTCP_Data[j3]);
	M[i].MinFreq:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j4],HiWord:=MBTCP_Data[j5]);
	M[i].MaxFreq:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j6],HiWord:=MBTCP_Data[j7]);
	M[i].ManFreq:=MB_TO_REAL.OUT;

	REAL_TO_MB(IN:=M[i].ActFreq);
	MBTCP_Data[j10]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j11]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].Current);
	MBTCP_Data[j12]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j13]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].Power);
	MBTCP_Data[j14]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j15]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].HeatSinkTemp);
	MBTCP_Data[j16]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j17]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].RunHours);
	MBTCP_Data[j18]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j19]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].kWhCount);
	MBTCP_Data[j20]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j21]:=REAL_TO_MB.HiWord;

	MBTCP_Data[j22]			:= 	M[i].Status;
	MBTCP_Data[j23]			:=	M[i].FC_StatusWord;

	MBTCP_Data[j24]			:= 	M[i].FC_AlarmWord.W0;
	MBTCP_Data[j25]			:=	M[i].FC_AlarmWord.W1;

	MBTCP_Data[j26]			:= 	M[i].FC_WarnWord.W0;
	MBTCP_Data[j27]			:=	M[i].FC_WarnWord.W1;

	MBTCP_Data[j28]			:= 	M[i].FC_ErrCode;
	MBTCP_Data[j29]			:=	M[i].Index;
end_for;

(*========================================================================================*)
(*Read/Write regulators parameters from/to Modbus array  / addr.2180 - addr.2498*)
(*========================================================================================*)
for i:= 0 to 9 do
	j:= i * 32 + 2180;
	j1:= j + 1;
	j2:= j + 2;
	j3:= j + 3;
	j4:= j + 4;
	j5:= j + 5;
	j6:= j + 6;
	j7:= j + 7;
	j8:= j + 8;
	j9:= j + 9;
	j10:= j + 10;
	j11:= j + 11;
	j12:= j + 12;
	j13:= j + 13;
	j14:= j + 14;
	j15:= j + 15;
	j16:= j + 16;
	j17:= j + 17;
	j18:= j + 18;
	j19:= j + 19;
	j20:= j + 20;
	j21:= j + 21;
	j22:= j + 22;
	j23:= j + 23;
	j24:= j + 24;
	j25:= j + 25;
	j26:= j + 26;
	j27:= j + 27;
	j28:= j + 28;
	j29:= j + 29;
	j30:= j + 30;
	j31:= j + 31;

(*	RGLTR[i].CW.En			:=	MBTCP_Data[j].X0;
	RGLTR[i].CW.ManMode		:=	MBTCP_Data[j].X1;
	RGLTR[i].CW.Reset		:=	MBTCP_Data[j].X2;
	RGLTR[i].CW.Hold		:=	MBTCP_Data[j].X3;
	RGLTR[i].CW.SimEn		:=	MBTCP_Data[j].X15;
	MBTCP_Data[j]			:=	word#0;*)

	MBTCP_Data[j1].X0		:=	RGLTR[i].SW.Error;
	MBTCP_Data[j1].X1		:=	RGLTR[i].SW.LH;
	MBTCP_Data[j1].X2		:=	RGLTR[i].SW.LL;

	MB_TO_REAL(LoWord:=MBTCP_Data[j2],HiWord:=MBTCP_Data[j3]);
	RGLTR[i].SP:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j4],HiWord:=MBTCP_Data[j5]);
	RGLTR[i].Kp:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j6],HiWord:=MBTCP_Data[j7]);
	RGLTR[i].Tn:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j8],HiWord:=MBTCP_Data[j9]);
	RGLTR[i].Tv:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j10],HiWord:=MBTCP_Data[j11]);
	RGLTR[i].Td:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j12],HiWord:=MBTCP_Data[j13]);
	RGLTR[i].Offset:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j14],HiWord:=MBTCP_Data[j15]);
	RGLTR[i].ManVal:=MB_TO_REAL.OUT;

(*	MB_TO_REAL(LoWord:=MBTCP_Data[j16],HiWord:=MBTCP_Data[j17]);
	RGLTR[i].LH:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j18],HiWord:=MBTCP_Data[j19]);
	RGLTR[i].LL:=MB_TO_REAL.OUT;*)

	REAL_TO_MB(IN:=RGLTR[i].Y);
	MBTCP_Data[j20]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j21]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=RGLTR[i].DIFF);
	MBTCP_Data[j22]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j23]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=RGLTR[i].ActVal);
	MBTCP_Data[j24]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j25]:=REAL_TO_MB.HiWord;

	MB_TO_REAL(LoWord:=MBTCP_Data[j26],HiWord:=MBTCP_Data[j27]);
	RGLTR[i].DeadBand:=MB_TO_REAL.OUT;
end_for;


























(*@KEY@: END_WORKSHEET *)
END_PROGRAM
