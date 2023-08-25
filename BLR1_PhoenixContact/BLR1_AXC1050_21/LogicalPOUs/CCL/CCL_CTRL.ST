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


VAR
	i :	INT;
END_VAR


VAR_EXTERNAL
	PLCMODE_RUN :	BOOL;														(*PLC status RUN*)
	M :	MOTOR;
	CCL :	CYCLE;
END_VAR


VAR
	j :	INT;
END_VAR


VAR_EXTERNAL
	MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


(*@KEY@: WORKSHEET
NAME: CCL_CTRL
IEC_LANGUAGE: ST
*)
(*============================================================================*)
(*Automation cycles handling*)
(*============================================================================*)
for i:= 0 to 4 do
	j:= i * 2;
	CCL[i].CW.AuxON:= PLCMODE_RUN;
	CCL[i].SW.ON:= (CCL[i].SW.ON or CCL[i].CW.Start) and not CCL[i].CW.Stop and
		not CCL[i].SW.ALARM and CCL[i].CW.AuxON;
	CCL[i].SW.Running:= CCL[i].SW.ON;
	CCL[i].CW.Start:= false;
	CCL[i].CW.Stop:= false;
end_for;
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
