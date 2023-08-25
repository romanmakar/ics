(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM DI_DO

(*Group:Default*)


VAR_EXTERNAL
    WarnWord :WRN;
    M :MOTOR;
    V :VALVE;
    Cycle :CCL;
    ACK :BOOL;
    ALARM_HL :BOOL;
    ALARM_HA :BOOL;
    IDW0 :DWORD;
    QW0 :WORD;
    IDW1 :DWORD;
    IDW2 :DWORD;
    QW1 :WORD;
    QW2 :WORD;
    Blr11_BrnRun :BOOL;
    Blr11_BrnFault :BOOL;
    Blr12_BrnRun :BOOL;
    Blr12_BrnFault :BOOL;
    Blr13_BrnRun :BOOL;
    Blr13_BrnFault :BOOL;
    Blr11_GasFlowPls :BOOL;
    Blr12_GasFlowPls :BOOL;
    Blr13_GasFlowPls :BOOL;
    Blr21_BrnRun :BOOL;
    Blr21_BrnFault :BOOL;
    Blr22_BrnRun :BOOL;
    Blr22_BrnFault :BOOL;
    Blr1CapacityLim :BOOL;
END_VAR


VAR
    Blr21_Lock :BOOL;
END_VAR


VAR_EXTERNAL
    Blr2CapacityLim :BOOL;
    M_AUX :MOTOR_MISC;
    Blr11_EmergCirc :BOOL;
    Blr12_EmergCirc :BOOL;
    Blr13_EmergCirc :BOOL;
    Blr21_EmergCirc :BOOL;
    Blr22_EmergCirc :BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: DI_DO
IEC_LANGUAGE: ST
*)

(*============================================================================*)
                            (*AXC 3050 / Axioline 0*)
(*============================================================================*)
(*A02 Discret Input Signals*)
(*============================================================================*)
WarnWord.InputVoltage:=     IDW0.B3.X0;
WarnWord.UPS_Fault:=        IDW0.B3.X1;
WarnWord.UPS_Dischrg:=      IDW0.B3.X2;
WarnWord.UPS_Chrg:=         IDW0.B3.X3;
M_AUX[8].DirRun:=           IDW0.B3.X4;
M[8].SW.Rem:=               IDW0.B3.X5;
M_AUX[8].FCFault:=          IDW0.B3.X6;
M_AUX[8].FCRun:=            IDW0.B3.X7;

M_AUX[9].DirRun:=           IDW0.B2.X0;
M[9].SW.Rem:=               IDW0.B2.X1;
M_AUX[9].FCFault:=          IDW0.B2.X2;
M_AUX[9].FCRun:=            IDW0.B2.X3;
M_AUX[10].DirRun:=          IDW0.B2.X4;
M[10].SW.Rem:=              IDW0.B2.X5;
M_AUX[10].FCFault:=         IDW0.B2.X6;
M_AUX[10].FCRun:=           IDW0.B2.X7;

M_AUX[8].TempFault:=        not IDW0.B1.X0;
M_AUX[9].TempFault:=        not IDW0.B1.X1;
M_AUX[10].TempFault:=       not IDW0.B1.X2;
ACK:=                       IDW0.B1.X3;
WarnWord.Blr1_AlarmAccum:=  IDW0.B1.X4;
Blr11_BrnRun:=              IDW0.B1.X5;
Blr11_BrnFault:=            IDW0.B1.X6;
Blr11_EmergCirc:=           IDW0.B1.X7;

Blr12_BrnRun:=              IDW0.B0.X0;
Blr12_BrnFault:=            IDW0.B0.X1;
Blr12_EmergCirc:=           IDW0.B0.X2;
WarnWord.Fire:=             IDW0.B0.X3;
WarnWord.UnautAccess:=      IDW0.B0.X4;
WarnWord.CO_HL:=            IDW0.B0.X5;
WarnWord.CO_HH:=            IDW0.B0.X6;
WarnWord.CH_HH:=            IDW0.B0.X7;

(*============================================================================*)
(*A03 Discret Output Signals*)
(*============================================================================*)
QW0.X8:=                    M_AUX[8].DirLock;
QW0.X9:=                    M[8].SW.COM;
QW0.X10:=                   M_AUX[9].DirLock;
QW0.X11:=                   M[9].SW.COM;
QW0.X12:=                   M_AUX[10].DirLock;
QW0.X13:=                   M[10].SW.COM;
QW0.X14:=                   M_AUX[0].DirLock;
QW0.X15:=                   M_AUX[1].DirLock;
        
QW0.X0 :=                   Blr1CapacityLim;
QW0.X1 :=                   Cycle.SW.ALARM;
QW0.X2 :=                   Alarm_HA;
QW0.X3 :=                   M_AUX[2].DirLock;(*
QW0.X4 := 
QW0.X5 := 
QW0.X6 := 
QW0.X7 :=*)

(*============================================================================*)
                            (*AXL F BK PN / Axioline 1*)
(*============================================================================*)
(*A12 Discret Input Signals*)
(*============================================================================*)
Blr13_BrnRun:=              IDW1.B3.X0;
Blr13_BrnFault:=            IDW1.B3.X1;
Blr13_EmergCirc:=           IDW1.B3.X2;
Blr11_GasFlowPls:=          IDW1.B3.X3;
Blr12_GasFlowPls:=          IDW1.B3.X4;
Blr13_GasFlowPls:=          IDW1.B3.X5;
Blr21_BrnRun:=              IDW1.B3.X6;
Blr21_BrnFault:=            IDW1.B3.X7;

Blr21_EmergCirc:=           IDW1.B2.X0;
Blr22_BrnRun:=              IDW1.B2.X1;
Blr22_BrnFault:=            IDW1.B2.X2;
Blr22_EmergCirc:=           IDW1.B2.X3;
M_AUX[5].DirRun:=           IDW1.B2.X4;
M[5].SW.Rem:=               IDW1.B2.X5;
M_AUX[5].FCRun:=            IDW1.B2.X6;
M_AUX[5].TempFault:=        not IDW1.B2.X7;

M_AUX[6].DirRun:=           IDW1.B1.X0;
M[6].SW.Rem:=               IDW1.B1.X1;
M_AUX[6].FCRun:=            IDW1.B1.X2;
M_AUX[6].TempFault:=        not IDW1.B1.X3;
M_AUX[7].DirRun:=           IDW1.B1.X4;
M[7].SW.Rem:=               IDW1.B1.X5;
M_AUX[7].FCRun:=            IDW1.B1.X6;
M_AUX[7].TempFault:=        not IDW1.B1.X7;

M_AUX[11].DirRun:=          IDW1.B0.X0;
M[11].SW.Rem:=              IDW1.B0.X1;
M_AUX[11].FCRun:=           IDW1.B0.X2;
M_AUX[12].DirRun:=          IDW1.B0.X3;
M[12].SW.Rem:=              IDW1.B0.X4;
M_AUX[12].FCRun:=           IDW1.B0.X5;
WarnWord.Drain_LH:=         IDW1.B0.X6;
WarnWord.Drain_HL:=         IDW1.B0.X7;

(*============================================================================*)
(*A13 Discret Input Signals*)
(*============================================================================*)
WarnWord.Drain_HH:=         IDW2.B3.X0;
V[0].SW.Closed:=            IDW2.B3.X1;
V[0].SW.Opened:=            IDW2.B3.X2;
V[0].SW.Rem:=               IDW2.B3.X3;
V[1].SW.Closed:=            IDW2.B3.X4;
V[1].SW.Opened:=            IDW2.B3.X5;
V[1].SW.Rem:=               IDW2.B3.X6;
V[2].SW.Closed:=            IDW2.B3.X7;

V[2].SW.Opened:=            IDW2.B2.X0;
V[2].SW.Rem:=               IDW2.B2.X1;
WarnWord.Blr2_AlarmAccum:=  IDW2.B2.X2;
M_AUX[5].LocStop:=          IDW2.B2.X3;
M_AUX[6].LocStop:=          IDW2.B2.X4;
M_AUX[7].LocStop:=          IDW2.B2.X5;
M_AUX[11].LocStop:=         IDW2.B2.X6;
M_AUX[12].LocStop:=         IDW2.B2.X7;

M[13].SW.RUN:=              IDW2.B1.X0;
M[13].SW.AlarmAccum:=       IDW2.B1.X1;
M[14].SW.RUN:=              IDW2.B1.X2;
M[14].SW.AlarmAccum:=       IDW2.B1.X3;
M[15].SW.RUN:=              IDW2.B1.X4;
M[15].SW.AlarmAccum:=       IDW2.B1.X5;
M[16].SW.RUN:=              IDW2.B1.X6;
M[16].SW.AlarmAccum:=       IDW2.B1.X7;

M_AUX[8].LocStop:=          IDW2.B0.X0;
M_AUX[9].LocStop:=          IDW2.B0.X1;
M_AUX[10].LocStop:=         IDW2.B0.X2;
(*:= IDW2.B0.X3;
                        :=  IDW2.B0.X4;
                        :=  IDW2.B0.X5;
                        :=  IDW2.B0.X6;
                        :=  IDW2.B0.X7;*)

(*============================================================================*)
(*A14 Discret Output Signals*)
(*============================================================================*)
QW1.X8:=                    M_AUX[3].DirLock;
QW1.X9:=                    Blr2CapacityLim;
QW1.X10:=                   M_AUX[5].DirLock;
QW1.X11:=                   M[5].SW.COM;
QW1.X12:=                   M_AUX[6].DirLock;
QW1.X13:=                   M[6].SW.COM;
QW1.X14:=                   M_AUX[7].DirLock;
QW1.X15:=                   M[7].SW.COM;

QW1.X0:=                    M_AUX[11].DirLock;
QW1.X1:=                    M[11].SW.COM;
QW1.X2:=                    M_AUX[12].DirLock; 
QW1.X3:=                    M[12].SW.COM; 
QW1.X4:=                    M_AUX[13].DirLock; 
QW1.X5:=                    M_AUX[14].DirLock; 
QW1.X6:=                    M_AUX[15].DirLock; 
QW1.X7:=                    M_AUX[16].DirLock; 
(*============================================================================*)
(*A15 Discret Output Signals*)
(*============================================================================*)
QW2.X8:=                    V[0].SW.COM_Close;
QW2.X9:=                    V[0].SW.COM_Open;
QW2.X10:=                   V[1].SW.COM_Close; 
QW2.X11:=                   V[1].SW.COM_Open;
QW2.X12:=                   V[2].SW.COM_Close;
QW2.X13:=                   V[2].SW.COM_Open;
QW2.X14:=                   V[3].SW.COM_Open;
QW2.X15:=                   V[4].SW.COM_Open; 
QW2.X0:=                    V[5].SW.COM_Open;
QW2.X1:=                    V[6].SW.COM_Open;
QW2.X2:=                    V[7].SW.COM_Open;
QW2.X3:=                    V[8].SW.COM_Open;
QW2.X4:=                    M_AUX[4].DirLock;(*
QW2.X5:= 
QW2.X6:= 
QW2.X7:=*)

(*============================================================================*)




(*@KEY@: END_WORKSHEET *)
END_PROGRAM
