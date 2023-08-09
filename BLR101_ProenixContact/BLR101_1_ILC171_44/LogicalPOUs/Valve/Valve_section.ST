(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Valve
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM Valve_section

(*Group:Default*)


VAR
	Vlv_Blr_in :	ValveFB;
	Vlv_Blr_out :	ValveFB;
	Exhsr_Gate :	ValveFB;
END_VAR


VAR_EXTERNAL
	Boiler :	Blr;
	Cycle :	Cycle;
	xVlv_in_QM_ON :	BOOL;
	xVlv_in_Remote :	BOOL;
	xVlv_in_RUN :	BOOL;
	xVlv_in_TorqueSwAlrm :	BOOL;
	xVlv_in_Closed :	BOOL;
	xVlv_in_Opened :	BOOL;
	xVlv_out_QM_ON :	BOOL;
	xVlv_out_Remote :	BOOL;
	xVlv_out_RUN :	BOOL;
	xVlv_out_TorqueSwAlrm :	BOOL;
	xVlv_out_Closed :	BOOL;
	xVlv_out_Opened :	BOOL;
	xExhsrGt_QM_ON :	BOOL;
	xExhsrGt_Remote :	BOOL;
	xExhsrGt_RUN :	BOOL;
	xExhsrGt_Closed :	BOOL;
	xExhsrGt_Opened :	BOOL;
	xVlv_in_COM_OP :	BOOL;
	xVlv_in_COM_CL :	BOOL;
	xVlv_out_COM_OP :	BOOL;
	xVlv_out_COM_CL :	BOOL;
	xExhsrGt_COM_OP :	BOOL;
	xExhsrGt_COM_CL :	BOOL;
	arrMB_Srv1Data :	MB2_TCP_ARR_W_0_7167;
	ExhsrGatePos :	Snsr;
END_VAR


VAR
	ExhsrGatePID :	BACL_PID3P_T1_V0_10;
END_VAR


(*@KEY@: WORKSHEET
NAME: Valve_section
IEC_LANGUAGE: ST
*)

	(*Boiler Input Valve DI*)
Boiler.V[1].CW.Enable:= xVlv_in_Remote;
Boiler.V[1].CW.AuxON:= Cycle.CW.AuxON;
Boiler.V[1].CW.ExtraEn:= xVlv_in_QM_ON;
Boiler.V[1].CW.ExtraAlarm:= not xVlv_in_TorqueSwAlrm;
Boiler.V[1].SW.Rem:= xVlv_in_Remote;
Boiler.V[1].SW.RUN:= xVlv_in_RUN; 
Boiler.V[1].SW.Closed:= xVlv_in_Closed;
Boiler.V[1].SW.Opened:= xVlv_in_Opened; 

	(*Boiler Input Valve FB call*)
Vlv_Blr_in(Vlv_strct:=Boiler.V[1],SetOvertime:=t#80s,Cycle:=Cycle);
Boiler.V[1]:=Vlv_Blr_in.Vlv_strct;
	(*ModBusArray ControlWord Reset*)
arrMB_Srv1Data[1492]:=word#0;

	(*Boiler Input Valve D0*)
xVlv_in_COM_OP:= Boiler.V[1].SW.COM_Open;
xVlv_in_COM_CL:= Boiler.V[1].SW.COM_Close;




	(*Boiler Output Valve DI*)
Boiler.V[2].CW.Enable:= xVlv_out_Remote;
Boiler.V[2].CW.AuxON:= Cycle.CW.AuxON;
Boiler.V[2].CW.ExtraEn:= xVlv_out_QM_ON;
Boiler.V[2].CW.ExtraAlarm:= not xVlv_out_TorqueSwAlrm;
Boiler.V[2].SW.Rem:= xVlv_out_Remote;
Boiler.V[2].SW.RUN:= xVlv_out_RUN; 
Boiler.V[2].SW.Closed:= xVlv_out_Closed;
Boiler.V[2].SW.Opened:= xVlv_out_Opened; 

	(*Boiler Output Valve FB call*)
Vlv_Blr_out(Vlv_strct:=Boiler.V[2],SetOvertime:=t#80s,Cycle:=Cycle);
Boiler.V[2]:=Vlv_Blr_out.Vlv_strct;
	(*ModBusArray ControlWord Reset*)
arrMB_Srv1Data[1508]:=word#0;

	(*Boiler Output Valve D0*)
xVlv_out_COM_OP:= Boiler.V[2].SW.COM_Open;
xVlv_out_COM_CL:= Boiler.V[2].SW.COM_Close;




	(*Exhauser Gate DI*)
Boiler.V[3].CW.Enable:= xExhsrGt_Remote;
Boiler.V[3].CW.AuxON:= Cycle.CW.AuxON;
Boiler.V[3].CW.ExtraEn:= xExhsrGt_QM_ON;
Boiler.V[3].SW.Rem:= xExhsrGt_Remote;
Boiler.V[3].SW.RUN:= xExhsrGt_RUN; 
Boiler.V[3].SW.Closed:= xExhsrGt_Closed;
Boiler.V[3].SW.Opened:= xExhsrGt_Opened; 

	(*Exhauser Gate FB call*)
Exhsr_Gate(Vlv_strct:=Boiler.V[3],SetOvertime:=t#60s,Cycle:=Cycle);
Boiler.V[3]:=Exhsr_Gate.Vlv_strct;
	(*ModBusArray ControlWord Reset*)
arrMB_Srv1Data[1524]:=word#0;

	(*Exhsr Gate Valve D0*)
xExhsrGt_COM_OP:= Boiler.V[3].SW.COM_Open;
xExhsrGt_COM_CL:= Boiler.V[3].SW.COM_Close;

Boiler.V[3].ActPos:=ExhsrGatePos.RealValue;


	(*Exhsr Gate Valve PID
ExhsrGatePID(IN_xActivate:=Boiler.Reg[0].CW.En,IN_tCycleTime:=t#3s,IN_rSetPoint:=Boiler.Reg[0].SP,IN_rActValue:=Boiler.AI[15].RealValue,IN_rDeadBand:=Boiler.Reg[2].DeadBand,IN_rKR:=Boiler.Reg[0].Kp,IN_rTN:=Boiler.Reg[0].Tn,IN_rTV:=Boiler.Reg[0].Tv,IN_tRunningTime:=t#5s);
Boiler.V[3].CW.AutoOpen:=ExhsrGatePID.OUT_xUp;
Boiler.V[3].CW.AutoClose:=ExhsrGatePID.OUT_xDown;*)


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
