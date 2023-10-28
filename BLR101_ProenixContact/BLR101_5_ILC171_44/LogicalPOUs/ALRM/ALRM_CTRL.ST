(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: ALRM
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM ALRM_CTRL

(*Group:Default*)


VAR_EXTERNAL
	CCL :	CYCLE;
	M :	MOTOR;
	ACK :	BOOL;
	MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


(*@KEY@: WORKSHEET
NAME: ALRM_CTRL
IEC_LANGUAGE: ST
*)
(*========================================================================================*)
(*General ALARM*)
(*========================================================================================*)
CCL[0].SW.ALARM := M[0].SW.AlarmAccum or
					M[1].SW.AlarmAccum or
					M[2].SW.AlarmAccum or
					M[3].SW.AlarmAccum or
					M[4].SW.AlarmAccum;

(*========================================================================================*)
(*General Acknowledge*)
(*========================================================================================*)

if CCL[0].CW.ACK or ACK then
	M[0].CW.ACK:= true;
	M[1].CW.ACK:= true;
	M[2].CW.ACK:= true;
	M[3].CW.ACK:= true;
	M[4].CW.ACK:= true;
	CCL[0].CW.ACK:= false;
	MBTCP_Data[1].X4:= false;
end_if;

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
