(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: eCLR
PROC_TYPE: ILC171_44
GROUP: Motor
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM Motor_section

(*Group:Default*)


VAR
	Exhauser :	MotorFB;
	RecPmp :	MotorFB;
END_VAR


VAR_EXTERNAL
	Boiler :	Blr;
	Cycle :	Cycle;
	xExhsr_FC_RUN :	BOOL;
	xExhsr_FC_OK :	BOOL;
	xExhsrDirectRUN :	BOOL;
	xExhsrTempFault :	BOOL;
	xExhsrRemote :	BOOL;
	xPmpRemote :	BOOL;
	xPmp_FC_RUN :	BOOL;
	xPmpDirectRUN :	BOOL;
END_VAR


VAR
	xPmp_FC_Fault :	BOOL;
END_VAR


VAR_EXTERNAL
	xPmpTempFault :	BOOL;
	xExhsrCOM :	BOOL;
	xExhsrDirectLock :	BOOL;
	xPmpCOM :	BOOL;
	xPmpDirectLock :	BOOL;
	arrMB_Srv1Data :	MB2_TCP_ARR_W_0_7167;
	ExhsrSP :	REAL;
	RecPmpSP :	REAL;
END_VAR


VAR
	Exhauser_PID :	BACL_PID_T1_V0_10;
	Pump_PID :	BACL_PID_T1_V0_10;
END_VAR


VAR_EXTERNAL
	arrSlvReadData :	SlvReadData;
END_VAR


VAR
	FC1_Current :	DWORD;
	FC2_Current :	DWORD;
END_VAR


VAR_EXTERNAL
	BrnrSP :	REAL;
	ExhsrFeedback :	Snsr;
END_VAR


VAR
	rExhsrPidDeviation :	REAL;
	rPumpPidDeviation :	REAL;
	ExhsrPID :	FPID;
	PmpPID :	FPID;
END_VAR


VAR_EXTERNAL
	RecPmpFeedback :	Snsr;
END_VAR


VAR
	RecPmpDryDelay :	TON;
END_VAR


VAR_EXTERNAL
	WarningWord :	Warn;
END_VAR


VAR
	RecPmpWetDelay :	TON;
	test :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: Motor_section
IEC_LANGUAGE: ST
*)

	(*Exhauser Motor DI*)
Boiler.M[0].CW.Enable:= xExhsrRemote;
Boiler.M[0].CW.AuxON:= Cycle.CW.AuxON;
Boiler.M[0].CW.ExtraEn:= true;
Boiler.M[0].CW.ExtraAlarm:= not xExhsr_FC_OK or not xExhsrTempFault;
Boiler.M[0].SW.Rem:= xExhsrRemote;
Boiler.M[0].SW.RUN:= xExhsr_FC_RUN or xExhsrDirectRUN;

	(*Exhauser Motor FB call*)
Exhauser(Mot_strct:=Boiler.M[0],Cycle:=Cycle,SetOvertime:=t#90s);
Boiler.M[0]:=Exhauser.Mot_strct;
ExhsrSP:=Exhauser.FreqValue;
	(*ModBusArray ControlWord Reset*)
arrMB_Srv1Data[1316]:=word#0;

	(*Exhauser Motor DO*)
xExhsrCOM:= Boiler.M[0].SW.COM;
xExhsrDirectLock:= Boiler.M[0].CW.Enable;

	(*Exhauser FC parameters*)
Boiler.M[0].ActFreq:= ExhsrFeedback.RealValue; 

FC1_Current:=DW_TO_DWORD(arrSlvReadData[12][2],arrSlvReadData[12][1]);
Boiler.M[0].Current:=dword_to_real(FC1_Current) / 100.0;

Boiler.M[0].RunHours:=(DW_TO_DWORD(arrSlvReadData[18][2],arrSlvReadData[18][1]));
Boiler.M[0].kWhCount:=(DW_TO_DWORD(arrSlvReadData[20][2],arrSlvReadData[20][1]));
Boiler.M[0].FC_StatusWord:=arrSlvReadData[1][1];
Boiler.M[0].FC_AlarmWord:=DW_TO_DWORD(arrSlvReadData[14][2],arrSlvReadData[14][1]);
Boiler.M[0].FC_WarnWord:=DW_TO_DWORD(arrSlvReadData[16][2],arrSlvReadData[16][1]);




ExhsrPID(REMOTE:=Boiler.Reg[1].CW.En,
	AUTO:= not Boiler.Reg[1].CW.ManMode,
	DIRECTN:=false,
	INTLCK:=false,
	Tscan:=500.0,
	Yman:=Boiler.Reg[1].ManVal,
	SPR:=abs(Boiler.Reg[1].SP),
	SPL:=0.0,
	X:=abs(Boiler.AI[16].RealValue),
	KP:=Boiler.Reg[1].Kp,
	TI:=Boiler.Reg[1].Tn,
	TD:=Boiler.Reg[1].Tv,
	HIGH:=(Boiler.M[0].MaxFreq * 10.0),
	LOW:=(Boiler.M[0].MinFreq * 10.0),
	INTLCKV:=0.0);

Boiler.Reg[1].Y:=ExhsrPID.Yout;


Exhauser_PID(IN_xEnable:=Boiler.Reg[1].CW.En,
	IN_tCycleTime:=t#500ms,
	IN_rSetPoint:= abs(Boiler.Reg[1].SP),
	IN_rActValue:= abs(Boiler.AI[16].RealValue),
	IN_rDeadBand:=Boiler.Reg[1].DeadBand,
	IN_rYmax:=(Boiler.M[0].MaxFreq * 10.0),
	IN_rYmin:=(Boiler.M[0].MinFreq * 10.0),
	IN_rYoff:=Boiler.Reg[1].ManVal,
	IN_rKR:=Boiler.Reg[1].Kp,
	IN_rTN:=Boiler.Reg[1].Tn,
	IN_rTV:=Boiler.Reg[1].Tv);

Boiler.Reg[1].Y:=Exhauser_PID.OUT_rYout;
rExhsrPidDeviation:=Exhauser_PID.OUT_rControlDeviation;


if Boiler.M[0].SW.Auto then
	ExhsrSP:= Boiler.M[0].AutoFreq;
else
	ExhsrSP:= Boiler.M[0].ManFreq;
end_if;


	(*Recirculation Pump Motor DI*)
Boiler.M[1].CW.Enable:= xPmpRemote;
Boiler.M[1].CW.AuxON:= Cycle.CW.AuxON;
Boiler.M[1].CW.ExtraEn:= true;
Boiler.M[1].CW.ExtraAlarm:= not xPmpTempFault or WarningWord.RecPmpDry;
Boiler.M[1].SW.Rem:= xPmpRemote;
Boiler.M[1].SW.RUN:= xPmp_FC_RUN or xPmpDirectRUN;

	(*Recirculation Pump Motor FB call*)
RecPmp(Mot_strct:=Boiler.M[1],Cycle:=Cycle,SetOvertime:=t#5s);
Boiler.M[1]:=RecPmp.Mot_strct;
RecPmpSP:=RecPmp.FreqValue;
	(*ModBusArray ControlWord Reset*)
arrMB_Srv1Data[1348]:=word#0;

	(*Recirculation Pump Motor DO*)
xPmpCOM:= Boiler.M[1].SW.COM;
xPmpDirectLock:= Boiler.M[1].CW.Enable;

	(*Recirculation Pump FC parameters*)

Boiler.M[1].ActFreq:= RecPmpFeedback.RealValue; 
(*(word_to_real(arrSlvReadData[10][1])) / 10.0;*)

FC2_Current:=DW_TO_DWORD(arrSlvReadData[13][2],arrSlvReadData[13][1]);
Boiler.M[1].Current:=dword_to_real(FC2_Current) / 100.0;

Boiler.M[1].RunHours:=(DW_TO_DWORD(arrSlvReadData[19][2],arrSlvReadData[19][1]));
Boiler.M[1].kWhCount:=(DW_TO_DWORD(arrSlvReadData[21][2],arrSlvReadData[21][1]));
Boiler.M[1].FC_StatusWord:=arrSlvReadData[2][1];
Boiler.M[1].FC_AlarmWord:=DW_TO_DWORD(arrSlvReadData[15][2],arrSlvReadData[15][1]);
Boiler.M[1].FC_WarnWord:=DW_TO_DWORD(arrSlvReadData[17][2],arrSlvReadData[17][1]);

Boiler.Reg[2].ActVal:= Boiler.AI[13].RealValue - Boiler.AI[12].RealValue;
	(*Pump PID*)

PmpPID(REMOTE:=Boiler.Reg[2].CW.En,
	AUTO:= true,
	DIRECTN:=false,
	INTLCK:=false,
	Tscan:=100.0,
	Yman:=Boiler.Reg[2].ManVal,
	SPR:=Boiler.Reg[2].SP,
	SPL:=0.0,
	X:=Boiler.Reg[2].ActVal,
	KP:=Boiler.Reg[2].Kp,
	TI:=Boiler.Reg[2].Tn,
	TD:=Boiler.Reg[2].Tv,
	HIGH:=(Boiler.M[1].MaxFreq * 10.0),
	LOW:=(Boiler.M[1].MinFreq * 10.0),
	INTLCKV:=0.0);

Boiler.Reg[2].Y:=PmpPID.Yout;


Pump_PID(IN_xEnable:=Boiler.Reg[2].CW.En, 
	IN_tCycleTime:=t#200ms, 
	IN_rSetPoint:=Boiler.Reg[2].SP,
	IN_rActValue:= Boiler.AI[16].RealValue,
	IN_rDeadBand:=Boiler.Reg[2].DeadBand,
	IN_rYmax:=(Boiler.M[0].MaxFreq * 10.0),
	IN_rYmin:=(Boiler.M[1].MinFreq * 10.0),
	IN_rYoff:=Boiler.Reg[2].ManVal,
	IN_rKR:=Boiler.Reg[2].Kp,
	IN_rTN:=Boiler.Reg[2].Tn,
	IN_rTV:=Boiler.Reg[2].Tv);

Boiler.Reg[2].Y:=Pump_PID.OUT_rYout;
rPumpPidDeviation:=Pump_PID.OUT_rControlDeviation;


if Boiler.M[1].SW.Auto then
	RecPmpSP:= (Boiler.Reg[2].Y / 10.0);
else
	RecPmpSP:= Boiler.M[1].ManFreq;
end_if;

RecPmpDryDelay(IN:=(Boiler.AI[12].RealValue < 0.5) and Boiler.M[1].SW.RUN,PT:=t#5s);
RecPmpWetDelay(IN:=(Boiler.AI[12].RealValue > 1.0) and WarningWord.RecPmpDry,PT:=t#60s);

if RecPmpDryDelay.Q then
	WarningWord.RecPmpDry:= true;
elsif RecPmpWetDelay.Q then
	WarningWord.RecPmpDry:= false;
end_if;	


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
