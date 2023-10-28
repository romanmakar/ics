(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: DIO
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM DI_DO

(*Group:Default*)


VAR_EXTERNAL
	CCL :	CYCLE;
	WarnWord :	WRN;
	A03 :	DWORD;
	A04 :	BYTE;
	A05 :	BYTE;
	A06 :	BYTE;
	ACK :	BOOL;
	M :	MOTOR;
	M_AUX :	MOTOR_MISC;
	ONBOARD_INPUT_BIT0 :	BOOL;(*Local input IN1*)
	ONBOARD_INPUT_BIT1 :	BOOL;(*Local input IN2*)
	ONBOARD_INPUT_BIT2 :	BOOL;(*Local input IN3*)
	ONBOARD_INPUT_BIT4 :	BOOL;(*Local input IN5*)
	ONBOARD_INPUT_BIT5 :	BOOL;(*Local input IN6*)
	ONBOARD_INPUT_BIT6 :	BOOL;(*Local input IN7*)
	ONBOARD_OUTPUT_BIT0 :	BOOL;(*Local output OUT1*)
END_VAR


(*@KEY@: WORKSHEET
NAME: DI_DO
IEC_LANGUAGE: ST
*)

(*========================================================================================*)
							(*ILC 171 ETH / Inline A01 DI signals*)
(*========================================================================================*)
WarnWord.InputVoltage_1		:=	ONBOARD_INPUT_BIT0;
WarnWord.InputVoltage_2		:=	ONBOARD_INPUT_BIT1;
ACK							:=	ONBOARD_INPUT_BIT2;
WarnWord.UPS_Fault			:=	ONBOARD_INPUT_BIT4;
WarnWord.UPS_Dischrg		:=	ONBOARD_INPUT_BIT5;
WarnWord.UPS_Chrg			:=	ONBOARD_INPUT_BIT6;

ONBOARD_OUTPUT_BIT0			:=	CCL[0].SW.ALARM;

(*========================================================================================*)
(*A03 DI Signals*)
(*========================================================================================*)
M[0].SW.Rem					:= 	A03.X0;
M_AUX[0].FCRun				:= 	A03.X1;
M_AUX[0].DirRun				:= 	A03.X2;
M_AUX[0].TempFault			:=	not A03.X3;
WarnWord.Pmp21_Leak			:= 	A03.X4;
M[1].SW.Rem					:= 	A03.X5;
M_AUX[1].FCRun				:= 	A03.X6;
M_AUX[1].DirRun				:= 	A03.X7;

M_AUX[1].TempFault			:= 	not A03.X8;
WarnWord.Pmp22_Leak			:= 	A03.X9;
M[2].SW.Rem					:= 	A03.X10;
M_AUX[2].FCRun				:= 	A03.X11;
M_AUX[2].DirRun				:= 	A03.X12;
M_AUX[2].TempFault			:= 	not A03.X13;
WarnWord.Pmp23_Leak			:= 	A03.X14;
M[3].SW.Rem					:= 	A03.X15;

M_AUX[3].FCRun				:= 	A03.X16;
M_AUX[3].DirRun				:= 	A03.X17;
M_AUX[3].TempFault			:= 	not A03.X18;
WarnWord.Pmp24_Leak			:= 	A03.X19;
M[4].SW.Rem					:= 	A03.X20;
M_AUX[4].FCRun				:=	A03.X21;
M_AUX[4].DirRun				:=	A03.X22;
M_AUX[4].TempFault			:=	not A03.X23;

WarnWord.Pmp25_Leak			:=	A03.X24;
M_AUX[0].LocStop			:=	A03.X25;
M_AUX[1].LocStop			:=	A03.X26;
M_AUX[2].LocStop			:=	A03.X27;
M_AUX[3].LocStop			:=	A03.X28;
M_AUX[4].LocStop			:=	A03.X29;(*
							:=	A03.X30;
							:=	A03.X31;*)

(*========================================================================================*)
(*A04 DI Signals*)
(*========================================================================================*)
(*							:= 	A04.X0;
							:= 	A04.X1;
							:= 	A04.X2;
							:= 	A04.X3;
							:= 	A04.X4;
							:= 	A04.X5;
							:= 	A04.X6;
							:= 	A04.X7;*)

(*========================================================================================*)
(*A05 Discret Output Signals*)
(*========================================================================================*)
A05.X0 						:=	M[0].SW.COM;
A05.X1 						:=	M_AUX[0].DirLock;
A05.X2 						:=	M[1].SW.COM;
A05.X3 						:=	M_AUX[1].DirLock;
A05.X4 						:=	M[2].SW.COM;
A05.X5 						:=	M_AUX[2].DirLock;(* 
A05.X6 						:= 
A05.X7	 					:=*)	

(*========================================================================================*)
(*A06 Discret Output Signals*)
(*========================================================================================*)
A06.X0 						:=	M[3].SW.COM;
A06.X1 						:=	M_AUX[3].DirLock;
A06.X2 						:=	M[4].SW.COM;
A06.X3 						:=	M_AUX[4].DirLock;(*
A06.X4 						:= 
A06.X5 						:= 
A06.X6 						:= 
A06.X7	 					:=*)

(*========================================================================================*)
							
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
