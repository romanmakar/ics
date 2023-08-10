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
PROGRAM MB_TCP_sect

(*Group:Default*)


VAR
	MB_TCP_Server_V2_00_1 :	MB_TCP_Server_V2_00;
	TON_Startup :	TON;
END_VAR


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;(*PLC status RUN*)
	xMB_Srv1Err :	BOOL;
	xMB_Srv1ACK :	BOOL;
	xMB_Srv1AutoACK :	BOOL;
	arrMB_Srv1Data :	MB2_TCP_ARR_W_0_7167;
END_VAR


VAR
	xMB_Srv1Active :	BOOL;
	xMB_Srv1Connected :	BOOL;
	wMB_Srv1Diag :	WORD;
	wMB_Srv1AddDiag :	WORD;
	WORD_TO_BOOL_1 :	ReSyBasic_WordToBoolV01;
	BOOL_TO_WORD_1 :	ReSyBasic_BoolToWordV01;
	MB_TO_REAL_1 :	MB_TO_REAL;
	MB_TO_REAL_2 :	MB_TO_REAL;
	MB_TO_REAL_3 :	MB_TO_REAL;
	MB_TO_REAL_4 :	MB_TO_REAL;
	MB_TO_REAL_5 :	MB_TO_REAL;
	MB_TO_REAL_6 :	MB_TO_REAL;
	MB_TO_REAL_7 :	MB_TO_REAL;
	MB_TO_REAL_8 :	MB_TO_REAL;
	REAL_TO_MB_1 :	REAL_TO_MB;
	REAL_TO_MB_2 :	REAL_TO_MB;
	REAL_TO_MB_3 :	REAL_TO_MB;
	WORD_TO_BOOL_2 :	ReSyBasic_WordToBoolV01;
	BOOL_TO_WORD_2 :	ReSyBasic_BoolToWordV01;
	MB_TO_REAL_11 :	MB_TO_REAL;
	MB_TO_REAL_12 :	MB_TO_REAL;
	MB_TO_REAL_13 :	MB_TO_REAL;
	MB_TO_REAL_14 :	MB_TO_REAL;
	MB_TO_REAL_15 :	MB_TO_REAL;
	MB_TO_REAL_16 :	MB_TO_REAL;
	MB_TO_REAL_17 :	MB_TO_REAL;
	MB_TO_REAL_18 :	MB_TO_REAL;
	REAL_TO_MB_11 :	REAL_TO_MB;
	REAL_TO_MB_12 :	REAL_TO_MB;
	REAL_TO_MB_13 :	REAL_TO_MB;
	xMB_Srv1ON :	BOOL;
	i :	INT;
END_VAR


VAR_EXTERNAL
	Boiler :	Blr;
END_VAR


VAR
	WORD_TO_BOOL_3 :	ReSyBasic_WordToBoolV01;
	BOOL_TO_WORD_3 :	ReSyBasic_BoolToWordV01;
	MB_TO_REAL_21 :	MB_TO_REAL;
	MB_TO_REAL_22 :	MB_TO_REAL;
	MB_TO_REAL_23 :	MB_TO_REAL;
	REAL_TO_MB_21 :	REAL_TO_MB;
	REAL_TO_MB_22 :	REAL_TO_MB;
	REAL_TO_MB_23 :	REAL_TO_MB;
	WORD_TO_BOOL_4 :	ReSyBasic_WordToBoolV01;
	BOOL_TO_WORD_4 :	ReSyBasic_BoolToWordV01;
	MB_TO_REAL_31 :	MB_TO_REAL;
	REAL_TO_MB_31 :	REAL_TO_MB;
	z :	INT;
	z1 :	INT;
	z2 :	INT;
	z3 :	INT;
	z4 :	INT;
	z5 :	INT;
	z6 :	INT;
	z7 :	INT;
	z8 :	INT;
	z9 :	INT;
	z10 :	INT;
	z11 :	INT;
	z12 :	INT;
	z13 :	INT;
	z14 :	INT;
	z15 :	INT;
	z16 :	INT;
	z17 :	INT;
	z18 :	INT;
	z19 :	INT;
	z20 :	INT;
	z21 :	INT;
	z22 :	INT;
	z23 :	INT;
	z24 :	INT;
	z25 :	INT;
	z26 :	INT;
	z27 :	INT;
	z28 :	INT;
	z29 :	INT;
	z30 :	INT;
	z31 :	INT;
END_VAR


VAR_EXTERNAL
	Cycle :	Cycle;
END_VAR


VAR
	BOOL_TO_WORD_5 :	ReSyBasic_BoolToWordV01;
	MB_TO_REAL_9 :	MB_TO_REAL;
	MB_TO_REAL_10 :	MB_TO_REAL;
	REAL_TO_MB_4 :	REAL_TO_MB;
	REAL_TO_MB_5 :	REAL_TO_MB;
	REAL_TO_MB_6 :	REAL_TO_MB;
	MB_TO_REAL_19 :	MB_TO_REAL;
	MB_TO_REAL_20 :	MB_TO_REAL;
	MB_TO_REAL_24 :	MB_TO_REAL;
	MB_TO_REAL_25 :	MB_TO_REAL;
	MB_TO_REAL_26 :	MB_TO_REAL;
	MB_TO_REAL_27 :	MB_TO_REAL;
	MB_TO_REAL_28 :	MB_TO_REAL;
	MB_TO_REAL_29 :	MB_TO_REAL;
	MB_TO_REAL_30 :	MB_TO_REAL;
	MB_TO_REAL_32 :	MB_TO_REAL;
	REAL_TO_MB_33 :	REAL_TO_MB;
	REAL_TO_MB_34 :	REAL_TO_MB;
	MB_TO_REAL_33 :	MB_TO_REAL;
	WORD_TO_BOOL_5 :	ReSyBasic_WordToBoolV01;
	WORD_TO_BOOL_7 :	ReSyBasic_WordToBoolV01;
	WORD_TO_BOOL_6 :	ReSyBasic_WordToBoolV01;
	BOOL_TO_WORD_6 :	ReSyBasic_BoolToWordV01;
	BOOL_TO_WORD_7 :	ReSyBasic_BoolToWordV01;
	BOOL_TO_WORD_8 :	ReSyBasic_BoolToWordV01;
	REAL_TO_MB_7 :	REAL_TO_MB;
	REAL_TO_MB_8 :	REAL_TO_MB;
	REAL_TO_MB_9 :	REAL_TO_MB;
	REAL_TO_MB_10 :	REAL_TO_MB;
	WORD_TO_BOOL_8 :	ReSyBasic_WordToBoolV01;
	BOOL_TO_WORD_9 :	ReSyBasic_BoolToWordV01;
	MB_TO_REAL_34 :	MB_TO_REAL;
	MB_TO_REAL_35 :	MB_TO_REAL;
	MB_TO_REAL_36 :	MB_TO_REAL;
	MB_TO_REAL_37 :	MB_TO_REAL;
	MB_TO_REAL_38 :	MB_TO_REAL;
	MB_TO_REAL_39 :	MB_TO_REAL;
	MB_TO_REAL_40 :	MB_TO_REAL;
	MB_TO_REAL_41 :	MB_TO_REAL;
	MB_TO_REAL_42 :	MB_TO_REAL;
	MB_TO_REAL_43 :	MB_TO_REAL;
	REAL_TO_MB_14 :	REAL_TO_MB;
	REAL_TO_MB_15 :	REAL_TO_MB;
	REAL_TO_MB_16 :	REAL_TO_MB;
	REAL_TO_MB_17 :	REAL_TO_MB;
END_VAR


VAR_EXTERNAL
	WarningWord :	Warn;
END_VAR


VAR
	MB_TCP_Server_V2_00_2 :	MB_TCP_Server_V2_00;
	xMB_Srv2Active :	BOOL;
	xMB_Srv2Connected :	BOOL;
	xMB_Srv2Err :	BOOL;
	wMB_Srv2Diag :	WORD;
	wMB_Srv2AddDiag :	WORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: MB_TCP_sect
IEC_LANGUAGE: ST
*)

	(*MB startup timer*)
TON_Startup(IN:=PLCMODE_RUN,PT:=t#2s);
if TON_Startup.Q and not xMB_Srv1Err then
	xMB_Srv1ON:=true;
else
	xMB_Srv1ON:=false;
end_if; 

	(*MB Server #1 FB init, port 503*)
MB_TCP_Server_V2_00_1(xActivate:=xMB_Srv1ON,
	xAcknowledge:=xMB_Srv1ACK,
	xAutoAck:=true,
	xUDP_Mode:=false,
	iTCP_Port:=int#503,
	tTimeout:=t#0s,
	uiOffsetInputRegister:=uint#0,
	uiOffsetHoldingRegister:=uint#0,
	uiOffsetInputs:=uint#0,
	uiOffsetCoils:=uint#0,
	arrModbusData:=arrMB_Srv1Data);

xMB_Srv1Active:=MB_TCP_Server_V2_00_1.xActive;
xMB_Srv1Connected:=MB_TCP_Server_V2_00_1.xConnected;
xMB_Srv1Err:=MB_TCP_Server_V2_00_1.xError;
wMB_Srv1Diag:=MB_TCP_Server_V2_00_1.wDiagCode;
wMB_Srv1AddDiag:=MB_TCP_Server_V2_00_1.wAddDiagCode;
arrMB_Srv1Data:=MB_TCP_Server_V2_00_1.arrModbusData;

	(*MB Server #2 FB init, port 503*)
MB_TCP_Server_V2_00_2(xActivate:=xMB_Srv1ON,
	xAcknowledge:=xMB_Srv1ACK,
	xAutoAck:=true,
	xUDP_Mode:=false,
	iTCP_Port:=int#503,
	tTimeout:=t#0s,
	uiOffsetInputRegister:=uint#0,
	uiOffsetHoldingRegister:=uint#0,
	uiOffsetInputs:=uint#0,
	uiOffsetCoils:=uint#0,
	arrModbusData:=arrMB_Srv1Data);
	
xMB_Srv2Active:=MB_TCP_Server_V2_00_2.xActive;
xMB_Srv2Connected:=MB_TCP_Server_V2_00_2.xConnected;
xMB_Srv2Err:=MB_TCP_Server_V2_00_2.xError;
wMB_Srv2Diag:=MB_TCP_Server_V2_00_2.wDiagCode;
wMB_Srv2AddDiag:=MB_TCP_Server_V2_00_2.wAddDiagCode;
arrMB_Srv1Data:=MB_TCP_Server_V2_00_2.arrModbusData;


	(*Read/Write Cycle CW from/to Modbus array / addr.1*)
(*	Cycle.CW.AuxON:=arrMB_Srv1Data[1].X0;*)
	Cycle.CW.Start:=arrMB_Srv1Data[1].X1;
	Cycle.CW.Stop:=arrMB_Srv1Data[1].X2;
(*	Cycle.CW.PulseStart:=arrMB_Srv1Data[1].X3;*)
	Cycle.CW.ACK :=arrMB_Srv1Data[1].X4;

	(*Write Cycle SW to Modbus array / addr.2*)
	arrMB_Srv1Data[2].X0:=Cycle.SW.ALARM;
	arrMB_Srv1Data[2].X1:=Cycle.SW.ON;
	arrMB_Srv1Data[2].X2:=Cycle.SW.Running;

	(*Write Warning Words TO Modbus array / addr.3 - addr.4*)
	arrMB_Srv1Data[3].X0:=WarningWord.InputVoltage;
	arrMB_Srv1Data[3].X1:=WarningWord.UPS;
	arrMB_Srv1Data[3].X2:=WarningWord.UPS_Charging;
	arrMB_Srv1Data[3].X3:=WarningWord.UPS_Discharging;
	arrMB_Srv1Data[3].X4:=WarningWord.EmergStop;
	arrMB_Srv1Data[3].X5:=WarningWord.CO2_CH4;
	arrMB_Srv1Data[3].X6:=WarningWord.Fire;
	arrMB_Srv1Data[3].X7:=WarningWord.Tout_hi;
	arrMB_Srv1Data[3].X8:=WarningWord.Pout_lo;
	arrMB_Srv1Data[3].X9:=WarningWord.Pout_hi;
	arrMB_Srv1Data[3].X10:=WarningWord.Pbrng_hi;
	arrMB_Srv1Data[3].X11:=WarningWord.Pfuel;
	arrMB_Srv1Data[3].X12:=WarningWord.Fout_lo;

	(*Put sensors real values into another place for trends addr.10*)
	(*Boiler inlet pressure
	arrMB_Srv1Data[10]:= arrMB_Srv1Data[702];
	arrMB_Srv1Data[11]:= arrMB_Srv1Data[703];*)
	(*Boiler outlet pressure
	arrMB_Srv1Data[12]:= arrMB_Srv1Data[734];
	arrMB_Srv1Data[13]:= arrMB_Srv1Data[735];*)
	(*Boiler inlet temperature
	arrMB_Srv1Data[14]:= arrMB_Srv1Data[382];
	arrMB_Srv1Data[15]:= arrMB_Srv1Data[383];*)
	(*Boiler outlet temperature
	arrMB_Srv1Data[16]:= arrMB_Srv1Data[382];
	arrMB_Srv1Data[17]:= arrMB_Srv1Data[383];*)



	(*Read/Write Burner CW from/to Modbus array / addr.100*)
(*	Boiler.Brn1.CW.Enable:=arrMB_Srv1Data[100].X0;
	Boiler.Brn1.CW.AuxON:=arrMB_Srv1Data[100].X1;*)		
	Boiler.Brn1.CW.EnableAuto:=arrMB_Srv1Data[100].X2;
	Boiler.Brn1.CW.DisableAuto:=arrMB_Srv1Data[100].X3;
	Boiler.Brn1.CW.ManStart:=arrMB_Srv1Data[100].X4;
	Boiler.Brn1.CW.ManStop:=arrMB_Srv1Data[100].X5;
(*	Boiler.Brn1.CW.AutoON:=arrMB_Srv1Data[100].X6;*)
	Boiler.Brn1.CW.ACK:=arrMB_Srv1Data[100].X7;
(*	Boiler.Brn1.CW.ExtraEn:=arrMB_Srv1Data[100].X8;
	Boiler.Brn1.CW.ExtraAlarm:=arrMB_Srv1Data[100].X9;*)
	Boiler.Brn1.CW.SimEn:=arrMB_Srv1Data[100].X10;
(*	Boiler.Brn1.CW.Ignition:=arrMB_Srv1Data[100].X11;*)

	(*Read Burner SW from/to Modbus array / addr.101*)
	arrMB_Srv1Data[101].X0:=Boiler.Brn1.SW.Rem;
	arrMB_Srv1Data[101].X1:=Boiler.Brn1.SW.Auto;
	arrMB_Srv1Data[101].X2:=Boiler.Brn1.SW.RUN;
	arrMB_Srv1Data[101].X3:=Boiler.Brn1.SW.COM;
	arrMB_Srv1Data[101].X4:=Boiler.Brn1.SW.AlarmAccum;
	arrMB_Srv1Data[101].X5:=Boiler.Brn1.SW.COM;
	arrMB_Srv1Data[101].X6:=false;
	arrMB_Srv1Data[101].X7:=false; 
	arrMB_Srv1Data[101].X8:=Boiler.Brn1.SW.FireOK;
	arrMB_Srv1Data[101].X9:=Boiler.Brn1.SW.IgnFireOK;



	(*Read/Write Burner sensors parameters from/to Modbus array / addr.102 - addr.261 *)
for i:=0 to 4 do
	z:= i * 32 + 102;
	z1:= z + 1;
	z2:= z + 2;
	z3:= z + 3;
	z4:= z + 4;
	z5:= z + 5;
	z6:= z + 6;
	z7:= z + 7;
	z8:= z + 8;
	z9:= z + 9;
	z10:= z + 10;
	z11:= z + 11;
	z12:= z + 12;
	z13:= z + 13;
	z14:= z + 14;
	z15:= z + 15;
	z16:= z + 16;
	z17:= z + 17;
	z18:= z + 18;
	z19:= z + 19;
	z20:= z + 20;
	z21:= z + 21;
	z22:= z + 22;
	z23:= z + 23;
	z24:= z + 24;
	z25:= z + 25;
	z26:= z + 26;
	z27:= z + 27;
	z28:= z + 28;
	z29:= z + 29;
	z30:= z + 30;
	z31:= z + 31;

	Boiler.Brn1.AI[i].CW.FltrEn:=arrMB_Srv1Data[z].X0;
	Boiler.Brn1.AI[i].CW.LimEn:=arrMB_Srv1Data[z].X1;
	Boiler.Brn1.AI[i].CW.SimEn:=arrMB_Srv1Data[z].X2;
(*	Boiler.Brn1.AI[i].CW.bar_kgf:=arrMB_Srv1Data[z].X8;*)

	arrMB_Srv1Data[z1].X0:=Boiler.Brn1.AI[i].SW.Fault;
	arrMB_Srv1Data[z1].X2:=Boiler.Brn1.AI[i].SW.HH_alarm;
	arrMB_Srv1Data[z1].X3:=Boiler.Brn1.AI[i].SW.HL_alarm;
	arrMB_Srv1Data[z1].X4:=Boiler.Brn1.AI[i].SW.LH_alarm;
	arrMB_Srv1Data[z1].X5:=Boiler.Brn1.AI[i].SW.LL_alarm;

	MB_TO_REAL_1(IN_LoWord:=arrMB_Srv1Data[z2],IN_HiWord:=arrMB_Srv1Data[z3]);
	Boiler.Brn1.AI[i].k:=MB_TO_REAL_1.Float;

	MB_TO_REAL_2(IN_LoWord:=arrMB_Srv1Data[z4],IN_HiWord:=arrMB_Srv1Data[z5]);
	Boiler.Brn1.AI[i].b:=MB_TO_REAL_2.Float;

	Boiler.Brn1.AI[i].ADC_Range:=WORD_TO_INT(arrMB_Srv1Data[z6]);
	Boiler.Brn1.AI[i].SamplingTime:=WORD_TO_INT(arrMB_Srv1Data[z7]);

	MB_TO_REAL_3(IN_LoWord:=arrMB_Srv1Data[z8],IN_HiWord:=arrMB_Srv1Data[z9]);
	Boiler.Brn1.AI[i].HH:=MB_TO_REAL_3.Float;

	MB_TO_REAL_4(IN_LoWord:=arrMB_Srv1Data[z10],IN_HiWord:=arrMB_Srv1Data[z11]);
	Boiler.Brn1.AI[i].HL:=MB_TO_REAL_4.Float;

	MB_TO_REAL_5(IN_LoWord:=arrMB_Srv1Data[z12],IN_HiWord:=arrMB_Srv1Data[z13]);
	Boiler.Brn1.AI[i].LH:=MB_TO_REAL_5.Float;

	MB_TO_REAL_6(IN_LoWord:=arrMB_Srv1Data[z14],IN_HiWord:=arrMB_Srv1Data[z15]);
	Boiler.Brn1.AI[i].LL:=MB_TO_REAL_6.Float;

	MB_TO_REAL_7(IN_LoWord:=arrMB_Srv1Data[z16],IN_HiWord:=arrMB_Srv1Data[z17]);
	Boiler.Brn1.AI[i].DeadBand:=MB_TO_REAL_7.Float;

	Boiler.Brn1.AI[i].LimDelay:=WORD_TO_INT(arrMB_Srv1Data[z18]);
	arrMB_Srv1Data[z19]:=Boiler.Brn1.AI[i].DiagCode;

	MB_TO_REAL_8(IN_LoWord:=arrMB_Srv1Data[z22],IN_HiWord:=arrMB_Srv1Data[z23]);
	Boiler.Brn1.AI[i].SimValue:=MB_TO_REAL_8.Float;

	arrMB_Srv1Data[z24]:=INT_TO_WORD(Boiler.Brn1.AI[i].PIW);
	arrMB_Srv1Data[z25]:=INT_TO_WORD(Boiler.Brn1.AI[i].IntValue);

	REAL_TO_MB_1(IN_Val:=Boiler.Brn1.AI[i].RealValue);
	arrMB_Srv1Data[z26]:=REAL_TO_MB_1.LoWord;
	arrMB_Srv1Data[Z27]:=REAL_TO_MB_1.HiWord;

	REAL_TO_MB_2(IN_Val:=Boiler.Brn1.AI[i].AccumDir);
	arrMB_Srv1Data[z28]:=REAL_TO_MB_2.LoWord;
	arrMB_Srv1Data[z29]:=REAL_TO_MB_2.HiWord;

	REAL_TO_MB_3(IN_Val:=Boiler.Brn1.AI[i].AccumRev);
	arrMB_Srv1Data[z30]:=REAL_TO_MB_3.LoWord;
	arrMB_Srv1Data[z31]:=REAL_TO_MB_3.HiWord;
end_for;


	(*Read/Write Burner PID parameters from/to Modbus array / addr.262 - addr.293 *)
(*	Boiler.Brn1.Reg[0].CW.En:=arrMB_Srv1Data[262].X0;*)
	Boiler.Brn1.Reg[0].CW.ManMode:=arrMB_Srv1Data[262].X1;
	Boiler.Brn1.Reg[0].CW.SimEn:=arrMB_Srv1Data[262].X2;
(*	Boiler.Brn1.Reg[0].CW.Reset:=arrMB_Srv1Data[262].X3;
	Boiler.Brn1.Reg[0].CW.Hold:=arrMB_Srv1Data[262].X4;*)

	arrMB_Srv1Data[263].X0:=Boiler.Brn1.Reg[0].SW.Error;
	arrMB_Srv1Data[263].X1:=Boiler.Brn1.Reg[0].SW.LH;
	arrMB_Srv1Data[263].X2:=Boiler.Brn1.Reg[0].SW.LL;

	MB_TO_REAL_9(IN_LoWord:=arrMB_Srv1Data[264],IN_HiWord:=arrMB_Srv1Data[265]);
	Boiler.Brn1.Reg[0].SP:=MB_TO_REAL_9.Float;

	MB_TO_REAL_10(IN_LoWord:=arrMB_Srv1Data[266],IN_HiWord:=arrMB_Srv1Data[267]);
	Boiler.Brn1.Reg[0].Kp:=MB_TO_REAL_10.Float;
	
	MB_TO_REAL_11(IN_LoWord:=arrMB_Srv1Data[268],IN_HiWord:=arrMB_Srv1Data[269]);
	Boiler.Brn1.Reg[0].Tn :=MB_TO_REAL_11.Float;

	MB_TO_REAL_12(IN_LoWord:=arrMB_Srv1Data[270],IN_HiWord:=arrMB_Srv1Data[271]);
	Boiler.Brn1.Reg[0].Tv:=MB_TO_REAL_12.Float;

	MB_TO_REAL_13(IN_LoWord:=arrMB_Srv1Data[272],IN_HiWord:=arrMB_Srv1Data[273]);
	Boiler.Brn1.Reg[0].Td:=MB_TO_REAL_13.Float;

	MB_TO_REAL_14(IN_LoWord:=arrMB_Srv1Data[274],IN_HiWord:=arrMB_Srv1Data[275]);
	Boiler.Brn1.Reg[0].Offset:=MB_TO_REAL_14.Float;

	MB_TO_REAL_15(IN_LoWord:=arrMB_Srv1Data[276],IN_HiWord:=arrMB_Srv1Data[277]);
	Boiler.Brn1.Reg[0].ManVal:=MB_TO_REAL_15.Float;

	MB_TO_REAL_16(IN_LoWord:=arrMB_Srv1Data[278],IN_HiWord:=arrMB_Srv1Data[279]);
	Boiler.Brn1.Reg[0].DeadBand:=MB_TO_REAL_16.Float;

	MB_TO_REAL_17(IN_LoWord:=arrMB_Srv1Data[280],IN_HiWord:=arrMB_Srv1Data[281]);
	Boiler.Brn1.Reg[0].LH:=MB_TO_REAL_17.Float;

	MB_TO_REAL_18(IN_LoWord:=arrMB_Srv1Data[282],IN_HiWord:=arrMB_Srv1Data[283]);
	Boiler.Brn1.Reg[0].LL:=MB_TO_REAL_18.Float;

	REAL_TO_MB_4(IN_Val:=Boiler.Brn1.Reg[0].Y);
	arrMB_Srv1Data[284]:=REAL_TO_MB_4.LoWord;
	arrMB_Srv1Data[285]:=REAL_TO_MB_4.HiWord;

	REAL_TO_MB_5(IN_Val:=Boiler.Brn1.Reg[0].DIFF);
	arrMB_Srv1Data[286]:=REAL_TO_MB_5.LoWord;
	arrMB_Srv1Data[287]:=REAL_TO_MB_5.HiWord;

	REAL_TO_MB_6(IN_Val:=Boiler.Brn1.Reg[0].ActVal);
	arrMB_Srv1Data[288]:=REAL_TO_MB_6.LoWord;
	arrMB_Srv1Data[289]:=REAL_TO_MB_6.HiWord;

	(*Read/Write Burner System parameters from/to Modbus array / addr.294 - addr.355*)

	MB_TO_REAL_19(IN_LoWord:=arrMB_Srv1Data[294],IN_HiWord:=arrMB_Srv1Data[295]);
	Boiler.Brn1.Sys.MinSP:=MB_TO_REAL_19.Float;

	MB_TO_REAL_20(IN_LoWord:=arrMB_Srv1Data[296],IN_HiWord:=arrMB_Srv1Data[297]);
	Boiler.Brn1.Sys.MaxSP:=MB_TO_REAL_20.Float;

	MB_TO_REAL_21(IN_LoWord:=arrMB_Srv1Data[298],IN_HiWord:=arrMB_Srv1Data[299]);
	Boiler.Brn1.Sys.ManSP:=MB_TO_REAL_21.Float;

	arrMB_Srv1Data[302]:=Boiler.Brn1.Sys.Phase;
	arrMB_Srv1Data[303]:=Boiler.Brn1.Sys.CurrOut;
	arrMB_Srv1Data[305]:=Boiler.Brn1.Sys.CurrSP;
	arrMB_Srv1Data[306]:=Boiler.Brn1.Sys.FlameVal;
	
	arrMB_Srv1Data[308]:=Boiler.Brn1.Sys.StartUpCount.W0;
	arrMB_Srv1Data[309]:=Boiler.Brn1.Sys.StartUpCount.W1;

	arrMB_Srv1Data[310]:=Boiler.Brn1.Sys.HoursCount.W0;
	arrMB_Srv1Data[311]:=Boiler.Brn1.Sys.HoursCount.W1;

	arrMB_Srv1Data[312]:=Boiler.Brn1.Sys.ErrCode;
	arrMB_Srv1Data[313]:=Boiler.Brn1.Sys.DiagCode;
	arrMB_Srv1Data[314]:=Boiler.Brn1.Sys.ErrClass;

	arrMB_Srv1Data[355]:=Boiler.Brn1.Sys.Status;

	(*Read/Write Boiler sensors parameters from/to Modbus array  / addr.356 - addr.1315*)
for i:=0 to 29 do
	z:= i * 32 + 356;
	z1:= z + 1;
	z2:= z + 2;
	z3:= z + 3;
	z4:= z + 4;
	z5:= z + 5;
	z6:= z + 6;
	z7:= z + 7;
	z8:= z + 8;
	z9:= z + 9;
	z10:= z + 10;
	z11:= z + 11;
	z12:= z + 12;
	z13:= z + 13;
	z14:= z + 14;
	z15:= z + 15;
	z16:= z + 16;
	z17:= z + 17;
	z18:= z + 18;
	z19:= z + 19;
	z20:= z + 20;
	z21:= z + 21;
	z22:= z + 22;
	z23:= z + 23;
	z24:= z + 24;
	z25:= z + 25;
	z26:= z + 26;
	z27:= z + 27;
	z28:= z + 28;
	z29:= z + 29;
	z30:= z + 30;
	z31:= z + 31;

	Boiler.AI[i].CW.FltrEn:=arrMB_Srv1Data[z].X0;
	Boiler.AI[i].CW.LimEn:=arrMB_Srv1Data[z].X1;
	Boiler.AI[i].CW.SimEn:=arrMB_Srv1Data[z].X2;
(*	Boiler.AI[i].CW.bar_kgf:=arrMB_Srv1Data[z].X8;*)

	arrMB_Srv1Data[z1].X0:=Boiler.AI[i].SW.Fault;
	arrMB_Srv1Data[z1].X1:=Boiler.AI[i].SW.HH_alarm;
	arrMB_Srv1Data[z1].X2:=Boiler.AI[i].SW.HL_alarm;
	arrMB_Srv1Data[z1].X3:=Boiler.AI[i].SW.LH_alarm;
	arrMB_Srv1Data[z1].X5:=Boiler.AI[i].SW.LL_alarm;

	MB_TO_REAL_22(IN_LoWord:=arrMB_Srv1Data[z2],IN_HiWord:=arrMB_Srv1Data[z3]);
	Boiler.AI[i].k:=MB_TO_REAL_22.Float;

	MB_TO_REAL_23(IN_LoWord:=arrMB_Srv1Data[z4],IN_HiWord:=arrMB_Srv1Data[z5]);
	Boiler.AI[i].b:=MB_TO_REAL_23.Float;

	Boiler.AI[i].ADC_Range:=WORD_TO_INT(arrMB_Srv1Data[z6]);
	Boiler.AI[i].SamplingTime:=WORD_TO_INT(arrMB_Srv1Data[z7]);

	MB_TO_REAL_24(IN_LoWord:=arrMB_Srv1Data[z8],IN_HiWord:=arrMB_Srv1Data[z9]);
	Boiler.AI[i].HH:=MB_TO_REAL_24.Float;

	MB_TO_REAL_25(IN_LoWord:=arrMB_Srv1Data[z10],IN_HiWord:=arrMB_Srv1Data[z11]);
	Boiler.AI[i].HL:=MB_TO_REAL_25.Float;

	MB_TO_REAL_26(IN_LoWord:=arrMB_Srv1Data[z12],IN_HiWord:=arrMB_Srv1Data[z13]);
	Boiler.AI[i].LH:=MB_TO_REAL_26.Float;

	MB_TO_REAL_27(IN_LoWord:=arrMB_Srv1Data[z14],IN_HiWord:=arrMB_Srv1Data[z15]);
	Boiler.AI[i].LL:=MB_TO_REAL_27.Float;

	MB_TO_REAL_28(IN_LoWord:=arrMB_Srv1Data[z16],IN_HiWord:=arrMB_Srv1Data[z17]);
	Boiler.AI[i].DeadBand:=MB_TO_REAL_28.Float;

	Boiler.AI[i].LimDelay:=WORD_TO_INT(arrMB_Srv1Data[z18]);
	arrMB_Srv1Data[z19]:=Boiler.AI[i].DiagCode;

	MB_TO_REAL_29(IN_LoWord:=arrMB_Srv1Data[z22],IN_HiWord:=arrMB_Srv1Data[z23]);
	Boiler.AI[i].SimValue:=MB_TO_REAL_29.Float;

	arrMB_Srv1Data[z24]:=INT_TO_WORD(Boiler.AI[i].PIW);
	arrMB_Srv1Data[z25]:=INT_TO_WORD(Boiler.AI[i].IntValue);

	REAL_TO_MB_7(IN_Val:=Boiler.AI[i].RealValue);
	arrMB_Srv1Data[z26]:=REAL_TO_MB_7.LoWord;
	arrMB_Srv1Data[z27]:=REAL_TO_MB_7.HiWord;

	REAL_TO_MB_8(IN_Val:=Boiler.AI[i].AccumDir);
	arrMB_Srv1Data[z28]:=REAL_TO_MB_8.LoWord;
	arrMB_Srv1Data[z29]:=REAL_TO_MB_8.HiWord;

	REAL_TO_MB_9(IN_Val:=Boiler.AI[i].AccumRev);
	arrMB_Srv1Data[z30]:=REAL_TO_MB_9.LoWord;
	arrMB_Srv1Data[z31]:=REAL_TO_MB_9.HiWord;
end_for;

	(*Read/Write Motors parameters from/to Modbus array  / addr.1316 - addr.1475 *)
for i:=0 to 4 do 
	z:= i * 32 + 1316;
	z1:= z + 1;
	z2:= z + 2;
	z3:= z + 3;
	z4:= z + 4;
	z5:= z + 5;
	z6:= z + 6;
	z7:= z + 7;
	z8:= z + 8;
	z9:= z + 9;
	z10:= z + 10;
	z11:= z + 11;
	z12:= z + 12;
	z13:= z + 13;
	z14:= z + 14;
	z15:= z + 15;
	z16:= z + 16;
	z17:= z + 17;
	z18:= z + 18;
	z19:= z + 19;
	z20:= z + 20;
	z21:= z + 21;
	z22:= z + 22;
	z23:= z + 23;
	z24:= z + 24;
	z25:= z + 25;
	z26:= z + 26;
	z27:= z + 27;
	z28:= z + 28;
	z29:= z + 29;
	z30:= z + 30;
	z31:= z + 31;

(*	Boiler.M[i].CW.Enable:=arrMB_Srv1Data[z].X0;
	Boiler.M[i].CW.AuxON:=arrMB_Srv1Data[z].X1;*)
	Boiler.M[i].CW.EnableAuto:=arrMB_Srv1Data[z].X2;
	Boiler.M[i].CW.DisableAuto:=arrMB_Srv1Data[z].X3;
	Boiler.M[i].CW.ManStart:=arrMB_Srv1Data[z].X4;
	Boiler.M[i].CW.ManStop:=arrMB_Srv1Data[z].X5;
(*	Boiler.M[i].CW.AutoON:=arrMB_Srv1Data[z].X6;*)
	Boiler.M[i].CW.ACK:=arrMB_Srv1Data[z].X7;
(*	Boiler.M[i].CW.ExtraEn:=arrMB_Srv1Data[z].X8;
	Boiler.M[i].CW.ExtraAlarm:=arrMB_Srv1Data[z].X9;*)
	Boiler.M[i].CW.SimEn:=arrMB_Srv1Data[z].X10;

	arrMB_Srv1Data[z1].X0:=Boiler.M[i].SW.Rem;
	arrMB_Srv1Data[z1].X1:=Boiler.M[i].SW.Auto;
	arrMB_Srv1Data[z1].X2:=Boiler.M[i].SW.RUN;
	arrMB_Srv1Data[z1].X3:=Boiler.M[i].SW.COM;
	arrMB_Srv1Data[z1].X4:=Boiler.M[i].SW.AlarmAccum;

	MB_TO_REAL_30(IN_LoWord:=arrMB_Srv1Data[z2],IN_HiWord:=arrMB_Srv1Data[z3]);
	Boiler.M[i].MinFreq:=MB_TO_REAL_30.Float;

	MB_TO_REAL_31(IN_LoWord:=arrMB_Srv1Data[z4],IN_HiWord:=arrMB_Srv1Data[z5]);
	Boiler.M[i].MaxFreq:=MB_TO_REAL_31.Float;

	MB_TO_REAL_32(IN_LoWord:=arrMB_Srv1Data[z6],IN_HiWord:=arrMB_Srv1Data[z7]);
	Boiler.M[i].ManFreq:=MB_TO_REAL_32.Float;

	REAL_TO_MB_21(IN_Val:=Boiler.M[i].AutoFreq);
	arrMB_Srv1Data[z8]:=REAL_TO_MB_21.LoWord;
	arrMB_Srv1Data[z9]:=REAL_TO_MB_21.HiWord;

	REAL_TO_MB_10(IN_Val:=Boiler.M[i].ActFreq);
	arrMB_Srv1Data[z10]:=REAL_TO_MB_10.LoWord;
	arrMB_Srv1Data[z11]:=REAL_TO_MB_10.HiWord;

	REAL_TO_MB_11(IN_Val:=Boiler.M[i].Current);
	arrMB_Srv1Data[z12]:=REAL_TO_MB_11.LoWord;
	arrMB_Srv1Data[z13]:=REAL_TO_MB_11.HiWord;

	arrMB_Srv1Data[z14]:=Boiler.M[i].RunHours.W0;
	arrMB_Srv1Data[z15]:=Boiler.M[i].RunHours.W1;

	arrMB_Srv1Data[z16]:=Boiler.M[i].kWhCount.W0;
	arrMB_Srv1Data[z17]:=Boiler.M[i].kWhCount.W1;

	arrMB_Srv1Data[z18]:=Boiler.M[i].Status;
	arrMB_Srv1Data[z19]:=Boiler.M[i].FC_StatusWord;

	arrMB_Srv1Data[z20]:=Boiler.M[i].FC_AlarmWord.W0;
	arrMB_Srv1Data[z21]:=Boiler.M[i].FC_AlarmWord.W1;

	arrMB_Srv1Data[z22]:=Boiler.M[i].FC_WarnWord.W0;
	arrMB_Srv1Data[z23]:=Boiler.M[i].FC_WarnWord.W1;

	arrMB_Srv1Data[z24]:=Boiler.M[i].FC_ErrCode;
	arrMB_Srv1Data[z25]:=Boiler.M[i].Index;
end_for;



	(*Read/Write Valves parameters from/to Modbus array  / addr.1476 - addr.1587*)
for i:=0 to 6 do
	z:= i * 16 + 1476;
	z1:= z + 1;
	z2:= z + 2;
	z3:= z + 3;
	z4:= z + 4;
	z5:= z + 5;
	z6:= z + 6;
	z7:= z + 7;
	z8:= z + 8;
	z9:= z + 9;
	z10:= z + 10;
	z11:= z + 11;
	z12:= z + 12;
	z13:= z + 13;
	z14:= z + 14;
	z15:= z + 15;
	

(*	Boiler.V[i].CW.Enable:=arrMB_Srv1Data[z].X0;
	Boiler.V[i].CW.AuxON:=arrMB_Srv1Data[z].X1;*)
	Boiler.V[i].CW.EnableAuto:=arrMB_Srv1Data[z].X2;
	Boiler.V[i].CW.DisableAuto:=arrMB_Srv1Data[z].X3;
	Boiler.V[i].CW.ManOpen:=arrMB_Srv1Data[z].X4;
	Boiler.V[i].CW.Stop:=arrMB_Srv1Data[z].X5;
	Boiler.V[i].CW.ManClose:=arrMB_Srv1Data[z].X6;
(*	Boiler.V[i].CW.AutoOpen:=arrMB_Srv1Data[z].X7;
	Boiler.V[i].CW.AutoClose:=arrMB_Srv1Data[z].X8;*)
	Boiler.V[i].CW.ACK:=arrMB_Srv1Data[z].X9;
(*	Boiler.V[i].CW.ExtraEn:=arrMB_Srv1Data[z].X10;
	Boiler.V[i].CW.ExtraAlarm:=arrMB_Srv1Data[z].X11;
	Boiler.V[i].CW.SimEn:=arrMB_Srv1Data[z].X12;*)

	arrMB_Srv1Data[z1].X0:=Boiler.V[i].SW.Rem;
	arrMB_Srv1Data[z1].X1:=Boiler.V[i].SW.Auto;
	arrMB_Srv1Data[z1].X2:=Boiler.V[i].SW.COM_Open;
	arrMB_Srv1Data[z1].X3:=Boiler.V[i].SW.COM_Close;
	arrMB_Srv1Data[z1].X4:=Boiler.V[i].SW.RUN;
	arrMB_Srv1Data[z1].X5:=Boiler.V[i].SW.Opened;
	arrMB_Srv1Data[z1].X6:=Boiler.V[i].SW.Closed;
	arrMB_Srv1Data[z1].X7:=Boiler.V[i].SW.AlarmAccum;

	MB_TO_REAL_33(IN_LoWord:=arrMB_Srv1Data[z2],IN_HiWord:=arrMB_Srv1Data[z3]);
	Boiler.V[i].SetPos:=MB_TO_REAL_33.Float;

	REAL_TO_MB_12(IN_Val:=Boiler.V[i].ActPos);
	arrMB_Srv1Data[z4]:=REAL_TO_MB_12.LoWord;
	arrMB_Srv1Data[z5]:=REAL_TO_MB_12.HiWord;

	arrMB_Srv1Data[z6]:=Boiler.V[i].Status;
end_for;



	(*Read/Write Regulator parameters from/to Modbus array  / addr.1588 - addr.1747*)
for i:=0 to 4 do 
	z:= i * 32 + 1588;
	z1:= z + 1;
	z2:= z + 2;
	z3:= z + 3;
	z4:= z + 4;
	z5:= z + 5;
	z6:= z + 6;
	z7:= z + 7;
	z8:= z + 8;
	z9:= z + 9;
	z10:= z + 10;
	z11:= z + 11;
	z12:= z + 12;
	z13:= z + 13;
	z14:= z + 14;
	z15:= z + 15;
	z16:= z + 16;
	z17:= z + 17;
	z18:= z + 18;
	z19:= z + 19;
	z20:= z + 20;
	z21:= z + 21;
	z22:= z + 22;
	z23:= z + 23;
	z24:= z + 24;
	z25:= z + 25;
	z26:= z + 26;
	z27:= z + 27;
	z28:= z + 28;
	z29:= z + 29;
	z30:= z + 30;
	z31:= z + 31;

(*	Boiler.Reg[i].CW.En:=arrMB_Srv1Data[z].X0;*)
	Boiler.Reg[i].CW.ManMode:=arrMB_Srv1Data[z].X1;
	Boiler.Reg[i].CW.SimEn:=arrMB_Srv1Data[z].X2;
(*	Boiler.Reg[i].CW.Reset:=arrMB_Srv1Data[z].X3;
	Boiler.Reg[i].CW.Hold:=arrMB_Srv1Data[z].X4;*)

	arrMB_Srv1Data[z1].X0:=Boiler.Reg[i].SW.Error;
	arrMB_Srv1Data[z1].X1:=Boiler.Reg[i].SW.LH;
	arrMB_Srv1Data[z1].X2:=Boiler.Reg[i].SW.LL;

	MB_TO_REAL_34(IN_LoWord:=arrMB_Srv1Data[z2],IN_HiWord:=arrMB_Srv1Data[z3]);
	Boiler.Reg[i].SP:=MB_TO_REAL_34.Float;

	MB_TO_REAL_35(IN_LoWord:=arrMB_Srv1Data[z4],IN_HiWord:=arrMB_Srv1Data[z5]);
	Boiler.Reg[i].Kp:=MB_TO_REAL_35.Float;

	MB_TO_REAL_36(IN_LoWord:=arrMB_Srv1Data[z6],IN_HiWord:=arrMB_Srv1Data[z7]);
	Boiler.Reg[i].Tn:=MB_TO_REAL_36.Float;

	MB_TO_REAL_37(IN_LoWord:=arrMB_Srv1Data[z8],IN_HiWord:=arrMB_Srv1Data[z9]);
	Boiler.Reg[i].Tv:=MB_TO_REAL_37.Float;

	MB_TO_REAL_38(IN_LoWord:=arrMB_Srv1Data[z10],IN_HiWord:=arrMB_Srv1Data[z11]);
	Boiler.Reg[i].Td:=MB_TO_REAL_38.Float;

	MB_TO_REAL_39(IN_LoWord:=arrMB_Srv1Data[z12],IN_HiWord:=arrMB_Srv1Data[z13]);
	Boiler.Reg[i].Offset:=MB_TO_REAL_39.Float;

	MB_TO_REAL_40(IN_LoWord:=arrMB_Srv1Data[z14],IN_HiWord:=arrMB_Srv1Data[z15]);
	Boiler.Reg[i].ManVal:=MB_TO_REAL_40.Float;

	MB_TO_REAL_41(IN_LoWord:=arrMB_Srv1Data[z16],IN_HiWord:=arrMB_Srv1Data[z17]);
	Boiler.Reg[i].DeadBand:=MB_TO_REAL_41.Float;

	MB_TO_REAL_42(IN_LoWord:=arrMB_Srv1Data[z18],IN_HiWord:=arrMB_Srv1Data[z19]);
	Boiler.Reg[i].LH:=MB_TO_REAL_42.Float;

	MB_TO_REAL_43(IN_LoWord:=arrMB_Srv1Data[z20],IN_HiWord:=arrMB_Srv1Data[z21]);
	Boiler.Reg[i].LL:=MB_TO_REAL_43.Float;

	REAL_TO_MB_13(IN_Val:=Boiler.Reg[i].Y);
	arrMB_Srv1Data[z22]:=REAL_TO_MB_13.LoWord;
	arrMB_Srv1Data[z23]:=REAL_TO_MB_13.HiWord;

	REAL_TO_MB_14(IN_Val:=Boiler.Reg[i].DIFF);
	arrMB_Srv1Data[z24]:=REAL_TO_MB_14.LoWord;
	arrMB_Srv1Data[z25]:=REAL_TO_MB_14.HiWord;

	REAL_TO_MB_15(IN_Val:=Boiler.Reg[i].ActVal);
	arrMB_Srv1Data[z26]:=REAL_TO_MB_15.LoWord;
	arrMB_Srv1Data[z27]:=REAL_TO_MB_15.HiWord;

	REAL_TO_MB_16(IN_Val:=Boiler.Reg[i].res0);
	arrMB_Srv1Data[z28]:=REAL_TO_MB_16.LoWord;
	arrMB_Srv1Data[z29]:=REAL_TO_MB_16.HiWord;

	REAL_TO_MB_17(IN_Val:=Boiler.Reg[i].res1);
	arrMB_Srv1Data[z30]:=REAL_TO_MB_17.LoWord;
	arrMB_Srv1Data[z31]:=REAL_TO_MB_17.HiWord;
end_for;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
