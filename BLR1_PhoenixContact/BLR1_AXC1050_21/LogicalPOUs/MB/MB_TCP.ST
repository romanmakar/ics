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
	V :	VALVE;
	RGLTR :	REGULATOR;
	CCL :	CYCLE;
	M_AUX :	MOTOR_MISC;
END_VAR


VAR
	MB_TCP_Server :	MB_TCP_Server_1;
	MBTCP_SrvActive :	BOOL;
	MBTCP_SrvConn :	BOOL;
	MBTCP_SrvErr :	BOOL;
	MBTCP_SrvDiagCode :	WORD;
	MBTCP_SrvAddDiagCode :	WORD;
	MBTCP_SrvDiag :	MB_TCP_UDT_SER_DIAG;
	MBTCP_DataScd :	MB_TCP_ARR_W_0_7167;
	MBTCP_SrvAck :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_TCP
IEC_LANGUAGE: ST
*)
(*============================================================================*)
(*MB TCP startup timer*)
(*============================================================================*)
TON_MBTCP_Master_Startup(IN:=PLCMODE_RUN,PT:=t#2s);
MBTCP_SrvAct:= TON_MBTCP_Master_Startup.Q;

(*============================================================================*)
(*MB TCP server FB initialization port 502*)
(*============================================================================*)
MB_TCP_Server(xActivate:=MBTCP_SrvAct,
	xAcknowledge:=MBTCP_SrvAck,
	xAutoAck:=true,
	xUDP_Mode:=false,
	iTCP_Port:=502,
	(*strPartner_IP:= STRING *)
	tReconnectDelay:=t#100ms,
	tTimeout:=t#0s,
	uiOffsetInputRegister:=uint#0,
	uiOffsetHoldingRegister:=uint#0,
	uiOffsetInputs:=uint#0,
	uiOffsetCoils:=uint#0,
	arrModbusData:=MBTCP_DataScd);

	MBTCP_SrvActive:=MB_TCP_Server.xActive;
	MBTCP_SrvConn:=MB_TCP_Server.xConnected;
	MBTCP_SrvErr:=MB_TCP_Server.xError;
	MBTCP_SrvDiagCode:=MB_TCP_Server.wDiagCode;
	MBTCP_SrvAddDiagCode:=MB_TCP_Server.wAddDiagCode;
	MBTCP_SrvDiag:=MB_TCP_Server.udtDiag;
	MBTCP_DataScd:=MB_TCP_Server.arrModbusData;

(*============================================================================*)
(*MB TCP server #1 FB initialization port 503*)
(*============================================================================*)
MB_TCP_Server_1(xActivate:=MBTCP_SrvAct,
	xAcknowledge:=MBTCP_Srv1Ack,
	xAutoAck:=true,
	xUDP_Mode:=false,
	iTCP_Port:=503,
	(*strPartner_IP:= STRING *)
	tReconnectDelay:=t#100ms,
	tTimeout:=t#0s,
	uiOffsetInputRegister:=uint#0,
	uiOffsetHoldingRegister:=uint#0,
	uiOffsetInputs:=uint#0,
	uiOffsetCoils:=uint#0,
	arrModbusData:=MBTCP_Data);

	MBTCP_Srv1Active:=MB_TCP_Server_1.xActive;
	MBTCP_Srv1Conn:=MB_TCP_Server_1.xConnected;
	MBTCP_Srv1Err:=MB_TCP_Server_1.xError;
	MBTCP_Srv1DiagCode:=MB_TCP_Server_1.wDiagCode;
	MBTCP_Srv1AddDiagCode:=MB_TCP_Server_1.wAddDiagCode;
	MBTCP_Srv1Diag:=MB_TCP_Server_1.udtDiag;
	MBTCP_Data:=MB_TCP_Server_1.arrModbusData;

(*============================================================================*)
(*MB TCP server #2 FB initialization port 503*)
(*============================================================================*)
MB_TCP_Server_2(xActivate:=MBTCP_SrvAct,
	xAcknowledge:=MBTCP_Srv1Ack,
	xAutoAck:=true,
	xUDP_Mode:=false,
	iTCP_Port:=503,
	(*strPartner_IP:= STRING *)
	tReconnectDelay:=t#100ms,
	tTimeout:=t#0s,
	uiOffsetInputRegister:=uint#0,
	uiOffsetHoldingRegister:=uint#0,
	uiOffsetInputs:=uint#0,
	uiOffsetCoils:=uint#0,
	arrModbusData:=MBTCP_Data);

	MBTCP_Srv2Active:=MB_TCP_Server_2.xActive;
	MBTCP_Srv2Conn:=MB_TCP_Server_2.xConnected;
	MBTCP_Srv2Err:=MB_TCP_Server_2.xError;
	MBTCP_Srv2DiagCode:=MB_TCP_Server_2.wDiagCode;
	MBTCP_Srv2AddDiagCode:=MB_TCP_Server_2.wAddDiagCode;
	MBTCP_Srv2Diag:=MB_TCP_Server_2.udtDiag;
	MBTCP_Data:=MB_TCP_Server_2.arrModbusData;

(*============================================================================*)
(*Read/Write cycles data from/to Modbus array  / addr.0 - addr.9*)
(*============================================================================*)
FOR i:= 0 to 4 DO
	j:= i * 2;
	j1:= j + 1;

	CCL[i].CW.Start	:=MBTCP_Data[j].X1;
	CCL[i].CW.Stop:=MBTCP_Data[j].X2;
	CCL[i].CW.ACK:=MBTCP_Data[j].X4;
	CCL[i].CW.Rotation:=MBTCP_Data[j].X8;
	MBTCP_Data[j]:=word#0;

	MBTCP_Data[j1].X0:=CCL[i].SW.ALARM;
	MBTCP_Data[j1].X1:=CCL[i].SW.ON;
	MBTCP_Data[j1].X2:=CCL[i].SW.Running;
	MBTCP_Data[j1].X8:=CCL[i].SW.RotationON;
END_FOR;

(*============================================================================*)
(*Read/Write sensors parameters from/to Modbus array  / addr.100 - addr.3938*)
(*============================================================================*)
FOR i:= 0 to 119 DO
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

	AI[i].CW.FltrEn:=MBTCP_Data[j].X0;
	AI[i].CW.LimEn:=MBTCP_Data[j].X1;
	AI[i].CW.SimEn:=MBTCP_Data[j].X2;

	MBTCP_Data[j1].X0:=AI[i].SW.Fault;	
	MBTCP_Data[j1].X1:=AI[i].SW.HH_alarm;	
	MBTCP_Data[j1].X2:=AI[i].SW.HL_alarm;
	MBTCP_Data[j1].X3:=AI[i].SW.LH_alarm;
	MBTCP_Data[j1].X4:=AI[i].SW.LL_alarm;

	MB_TO_REAL(LoWord:=MBTCP_Data[j2],HiWord:=MBTCP_Data[j3]);
	AI[i].Ymin:=MB_TO_REAL.OUT;

	MB_TO_REAL(LoWord:=MBTCP_Data[j4],HiWord:=MBTCP_Data[j5]);
	AI[i].Ymax:=MB_TO_REAL.OUT;

	(*AI[i].ADC_Range:=word_to_int(MBTCP_Data[j6]);*)			
	AI[i].SamplingTime:=word_to_int(MBTCP_Data[j7]);			

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

	AI[i].LimDelay:=word_to_int(MBTCP_Data[j18]);

	MBTCP_Data[j19]:=AI[i].DiagCode;

(*	MB_TO_REAL(LoWord:=MBTCP_Data[j20],HiWord:=MBTCP_Data[j21]);
	AI[i].res1:=MB_TO_REAL.OUT;	*)

	MBTCP_Data[j22]:=int_to_word(AI[i].PIW);
	MBTCP_Data[j23]:=int_to_word(AI[i].IntValue);

	REAL_TO_MB(IN:=AI[i].RealValue);
	MBTCP_Data[j24]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j25]:=REAL_TO_MB.HiWord;

	MB_TO_REAL(LoWord:=MBTCP_Data[j26],HiWord:=MBTCP_Data[j27]);
	AI[i].SimValue:=MB_TO_REAL.OUT;
END_FOR;


(*============================================================================*)
(*Read/Write motors parameters from/to Modbus array  / addr.3940 - addr.4578*)
(*============================================================================*)
FOR i:= 0 to 19 DO
	j:= i * 32 + 3940;
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

	M[i].CW.ACK:=MBTCP_Data[j].X3;
	M[i].CW.ManMode:=MBTCP_Data[j].X4;
	M[i].CW.AutoMode:=MBTCP_Data[j].X5;
	M[i].CW.ManStart:=MBTCP_Data[j].X6;
	M[i].CW.ManStop:=MBTCP_Data[j].X7;
	M[i].CW.SimEn:=MBTCP_Data[j].X15;
	MBTCP_Data[j]:=word#0;

	MBTCP_Data[j1].X0:=M[i].SW.Rem;
	MBTCP_Data[j1].X1:=M[i].SW.ManAuto;
	MBTCP_Data[j1].X2:=M[i].SW.RUN;
	MBTCP_Data[j1].X3:=M[i].SW.COM;
	MBTCP_Data[j1].X4:=M[i].SW.AlarmAccum;
	MBTCP_Data[j1].X5:=M[i].SW.Ready;

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

	MBTCP_Data[j22]:=M[i].Status;
	MBTCP_Data[j23]:=M[i].FC_StatusWord;

	MBTCP_Data[j24]:=M[i].FC_AlarmWord.W0;
	MBTCP_Data[j25]:=M[i].FC_AlarmWord.W1;

	MBTCP_Data[j26]:=M[i].FC_WarnWord.W0;
	MBTCP_Data[j27]:=M[i].FC_WarnWord.W1;

	MBTCP_Data[j28]:=M[i].FC_ErrCode;
	MBTCP_Data[j29]:=M[i].Index;
END_FOR;

(*============================================================================*)
(*Read/Write valves parameters from/to Modbus array  / addr.4580 - addr.4898*)
(*============================================================================*)
FOR i:= 0 to 19 DO
	j:= i * 16 + 4580;
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

	V[i].CW.ACK	:=MBTCP_Data[j].X3;
	V[i].CW.ManMode:=MBTCP_Data[j].X4;
	V[i].CW.AutoMode:=MBTCP_Data[j].X5;
	V[i].CW.ManOpen:=MBTCP_Data[j].X6;
	V[i].CW.Stop:=MBTCP_Data[j].X7;
	V[i].CW.ManClose:=MBTCP_Data[j].X8;
	V[i].CW.SimEn:=MBTCP_Data[j].X15;
	MBTCP_Data[j]:=word#0;

	MBTCP_Data[j1].X0:=V[i].SW.Rem;
	MBTCP_Data[j1].X1:=V[i].SW.ManAuto;
	MBTCP_Data[j1].X2:=V[i].SW.RUN;
	MBTCP_Data[j1].X3:=V[i].SW.COM_Open;
	MBTCP_Data[j1].X4:=V[i].SW.COM_Close;
	MBTCP_Data[j1].X5:=V[i].SW.Opened;
	MBTCP_Data[j1].X6:=V[i].SW.Closed;
	MBTCP_Data[j1].X7:=V[i].SW.AlarmAccum;

	MB_TO_REAL(LoWord:=MBTCP_Data[j2],HiWord:=MBTCP_Data[j3]);
	V[i].SetPos:=MB_TO_REAL.OUT;

	REAL_TO_MB(IN:=V[i].ActPos);
	MBTCP_Data[j4]:=REAL_TO_MB.LoWord;
	MBTCP_Data[j5]:=REAL_TO_MB.HiWord;

	MBTCP_Data[j6]:=V[i].Status;
END_FOR;

(*============================================================================*)
(*Read/Write regulators parameters from/to Modbus array  / addr.4900 - addr.5538*)
(*============================================================================*)
FOR i:= 0 to 19 DO
	j:= i * 32 + 4900;
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

(*	RGLTR[i].CW.En:=MBTCP_Data[j].X0;
	RGLTR[i].CW.ManMode:=MBTCP_Data[j].X1;
	RGLTR[i].CW.Reset:=MBTCP_Data[j].X2;
	RGLTR[i].CW.Hold:=MBTCP_Data[j].X3;
	RGLTR[i].CW.SimEn:=MBTCP_Data[j].X15;
	MBTCP_Data[j]:=word#0;*)

	MBTCP_Data[j1].X0:=RGLTR[i].SW.Error;
	MBTCP_Data[j1].X1:=RGLTR[i].SW.LH;
	MBTCP_Data[j1].X2:=RGLTR[i].SW.LL;

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
END_FOR;

(*============================================================================*)

(*============================================================================*)
(*DATA FOR SCADA*)
(*============================================================================*)
(*============================================================================*)
(*Read/Write 5.x pumps cycle from/to Modbus array  / addr.20 - addr.21*)
(*============================================================================*)
(*	CCL[3].CW.Start:=MBTCP_DataScd[20].X1;
	CCL[3].CW.Stop:=MBTCP_DataScd[20].X2;
	CCL[3].CW.ACK:=MBTCP_DataScd[20].X4;
	CCL[3].CW.Rotation:=MBTCP_DataScd[20].X8;*)

	MBTCP_DataScd[30].X0:=CCL[3].SW.ALARM;
	MBTCP_DataScd[30].X2:=CCL[3].SW.Running;
	MBTCP_DataScd[30].X8:=CCL[3].SW.RotationON;

(*============================================================================*)
(*Read/Write 5.x pumps parameters from/to Modbus array  / addr.100 - addr.189*)
(*============================================================================*)
FOR i:= 8 to 10 DO
	j:= i * 30 - 140;
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

(*	M[i].CW.AutoMode:=MBTCP_DataScd[j].X5;
	M[i].CW.ManMode:=MBTCP_DataScd[j].X4;
	M[i].CW.ManStart:=MBTCP_DataScd[j].X6;
	M[i].CW.ManStop:=MBTCP_DataScd[j].X7;
	M[i].CW.ACK:=MBTCP_DataScd[j].X15;*)

	MBTCP_DataScd[j1].X0:=M[i].SW.Rem;
	MBTCP_DataScd[j1].X1:=M[i].SW.ManAuto;
	MBTCP_DataScd[j1].X2:=M[i].SW.RUN;
	MBTCP_DataScd[j1].X3:=M[i].SW.COM;
	MBTCP_DataScd[j1].X4:=M[i].SW.AlarmAccum;

	MB_TO_REAL(LoWord:=MBTCP_DataScd[j2],HiWord:=MBTCP_DataScd[j3]);
	M[i].ManFreq:=MB_TO_REAL.OUT;

	REAL_TO_MB(IN:=M[i].ActFreq);
	MBTCP_DataScd[j4]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j5]:=REAL_TO_MB.HiWord;

	MBTCP_DataScd[j6]:=M[i].Status;
	MBTCP_DataScd[j7]:=M[i].Status;

	REAL_TO_MB(IN:=M[i].Current);
	MBTCP_DataScd[j8]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j9]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].Power);
	MBTCP_DataScd[j10]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j11]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].HeatSinkTemp);
	MBTCP_DataScd[j12]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j13]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].RunHours);
	MBTCP_DataScd[j14]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j15]:=REAL_TO_MB.HiWord;

	REAL_TO_MB(IN:=M[i].kWhCount);
	MBTCP_DataScd[j16]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j17]:=REAL_TO_MB.HiWord;

	MBTCP_DataScd[j18]:=M[i].FC_ErrCode;
END_FOR;

(*============================================================================*)
(*Read/Write 5.x pumps parameters from/to Modbus array  / addr.3002 - addr.xxx*)
(*============================================================================*)
FOR i:= 0 to 5 DO
	j:= i * 2 + 3002;
	j1:= j + 1;

	REAL_TO_MB(IN:=AI[i].RealValue);
	MBTCP_DataScd[j]:=REAL_TO_MB.LoWord;
	MBTCP_DataScd[j1]:=REAL_TO_MB.HiWord;
END_FOR;

MBTCP_DataScd[65].X1:=AI[0].SW.Fault;
MBTCP_DataScd[65].X2:=AI[1].SW.Fault;
MBTCP_DataScd[65].X3:=AI[2].SW.Fault;
MBTCP_DataScd[65].X4:=AI[3].SW.Fault;
MBTCP_DataScd[65].X5:=AI[4].SW.Fault;
MBTCP_DataScd[65].X6:=AI[5].SW.Fault;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
