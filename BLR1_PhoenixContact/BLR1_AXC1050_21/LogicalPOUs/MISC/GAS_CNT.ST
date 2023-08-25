(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MISC
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM GAS_CNT

(*Group:Default*)


VAR_EXTERNAL
	AI :	SENSOR;
END_VAR


VAR
	Blr1GasCntFB :	PlsFlwCnt;
	Blr2GasCntFB :	PlsFlwCnt;
	Blr3GasCntFB :	PlsFlwCnt;
END_VAR


VAR_EXTERNAL
	Blr11_GasFlowPls :	BOOL;
	Blr12_GasFlowPls :	BOOL;
	Blr13_GasFlowPls :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: GAS_CNT
IEC_LANGUAGE: ST
*)
Blr1GasCntFB(Pls:=Blr11_GasFlowPls,PulseWeight:=1.0);
AI[116].Ymax:= Blr1GasCntFB.Flow * 1.4;

Blr2GasCntFB(Pls:=Blr12_GasFlowPls,PulseWeight:=1.0);
AI[117].Ymax:= Blr2GasCntFB.Flow * 1.4;

Blr3GasCntFB(Pls:=Blr13_GasFlowPls,PulseWeight:=1.0);
AI[118].Ymax:= Blr3GasCntFB.Flow * 1.4;


(*@KEY@: END_WORKSHEET *)
END_PROGRAM
