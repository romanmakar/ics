(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: CCL
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM CCL_CTRL

(*Group:Default*)


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;(*PLC status RUN*)
	CCL :	CYCLE;
	MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


(*@KEY@: WORKSHEET
NAME: CCL_CTRL
IEC_LANGUAGE: ST
*)
(*================================================================================================*)
(*Automation cycles handling*)
(*================================================================================================*)
CCL[0].CW.AuxON:= PLCMODE_RUN;
CCL[0].SW.ON:= (CCL[0].SW.ON or CCL[0].CW.Start) and not CCL[0].CW.Stop and CCL[0].CW.AuxON;
CCL[0].SW.Running:= CCL[0].SW.ON;
CCL[0].CW.Start:= false;
CCL[0].CW.Stop:= false;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
