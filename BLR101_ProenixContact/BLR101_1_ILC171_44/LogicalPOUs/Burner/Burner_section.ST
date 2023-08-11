(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Burner
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM Burner_section

(*Group:Default*)


VAR
    Burner :	BurnerFB;
END_VAR


VAR_EXTERNAL
    Boiler :	Blr;
    Cycle :	Cycle;
    xBrnRemote :	BOOL;
    xBrnQM_ON :	BOOL;
    xBrnSafetyCircON :	BOOL;
    xBrnRUN :	BOOL;
    xBrnFault :	BOOL;
    xBrnUnlock :	BOOL;
    xBrnCOM :	BOOL;
    arrMB_Srv1Data :	MB2_TCP_ARR_W_0_7167;
END_VAR


VAR
    BrnPID :	BACL_PID_T1_V0_10;
END_VAR


VAR_EXTERNAL
    BrnrSP :	REAL;
    BrnrFeedback :	Snsr;
    arrSlvReadData :	SlvReadData;
END_VAR


VAR
    rBrnPidDeviation :	REAL;
END_VAR


VAR_EXTERNAL
    TestFlag :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: Burner_section
IEC_LANGUAGE: ST
*)
    (*Burner DI*)
Boiler.Brn1.CW.Enable:= xBrnRemote;
Boiler.Brn1.CW.AuxON:= Cycle.CW.AuxON;
Boiler.Brn1.CW.ExtraEn:= xBrnSafetyCircON and xBrnQM_ON;
Boiler.Brn1.CW.ExtraAlarm:= xBrnFault; 
Boiler.Brn1.SW.Rem:= xBrnRemote;
Boiler.Brn1.SW.RUN:= xBrnRUN or (Boiler.Brn1.Sys.Phase > word#12);

    (*Burner FB call*)
Burner(Brn_strct:=Boiler.Brn1,Cycle:=Cycle,SetOvertime:=t#90s);
Boiler.Brn1:=Burner.Brn_strct;
    (*ModBusArray ControlWord Reset*)
arrMB_Srv1Data[100]:=word#0;

    (*Burner D0*)
xBrnUnlock:= Boiler.Brn1.CW.ACK;
xBrnCOM:= Boiler.Brn1.SW.COM;

    (*Burning controller parameters*)
Boiler.Brn1.Sys.Phase:= arrSlvReadData[0][1];
Boiler.Brn1.Sys.CurrOut:= real_to_word(BrnrFeedback.RealValue)(*arrSL1_ReadData[0][11]*);
Boiler.Brn1.Sys.CurrSP:= arrSlvReadData[0][12];
Boiler.Brn1.Sys.CurrPV:= arrSlvReadData[0][13];
Boiler.Brn1.Sys.FlameVal:= (arrSlvReadData[0][14] / word#10);
Boiler.Brn1.SW.FireOK:= (Boiler.Brn1.Sys.FlameVal > word#0);

Boiler.Brn1.Sys.StartUpCount.W0:= arrSlvReadData[4][22];
Boiler.Brn1.Sys.StartUpCount.W1:= arrSlvReadData[4][23];
Boiler.Brn1.Sys.HoursCount.W0:= arrSlvReadData[4][24];
Boiler.Brn1.Sys.HoursCount.W1:= arrSlvReadData[4][25];

Boiler.Brn1.Sys.ErrCode:= arrSlvReadData[4][26];
Boiler.Brn1.Sys.DiagCode:= arrSlvReadData[4][27];
Boiler.Brn1.Sys.ErrClass:= arrSlvReadData[4][28];


    (*Burner PID*)
BrnPID(IN_xEnable:=Boiler.Brn1.Reg[0].CW.En,
    IN_tCycleTime:=t#500ms,
    IN_rSetPoint:=Boiler.Brn1.Reg[0].SP,
    IN_rActValue:=Boiler.AI[1].RealValue,
    IN_rDeadBand:=Boiler.Brn1.Reg[0].DeadBand,
    IN_rYmax:=(Boiler.Brn1.Sys.MaxSP * 10.0),
    IN_rYmin:=(Boiler.Brn1.Sys.MinSP * 10.0),
    IN_rYoff:=Boiler.Brn1.Reg[0].ManVal,
    IN_rKR:=Boiler.Brn1.Reg[0].Kp,
    IN_rTN:=Boiler.Brn1.Reg[0].Tn,
    IN_rTV:=Boiler.Brn1.Reg[0].Tv);

Boiler.Brn1.Reg[0].Y:=BrnPID.OUT_rYout;
rBrnPidDeviation:=BrnPID.OUT_rControlDeviation;

if Boiler.Brn1.SW.Auto then
    BrnrSP:= Boiler.Brn1.Sys.AutoSP;
else
    BrnrSP:= Boiler.Brn1.Sys.ManSP;
end_if;


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
