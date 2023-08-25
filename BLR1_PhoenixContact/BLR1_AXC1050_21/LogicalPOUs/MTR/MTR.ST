(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MTRS
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM MTR

(*Group:Default*)


VAR_EXTERNAL
    Cycle :	CCL;
    M :	MOTOR;
    WarnWord :	WRN;
    AI :	SENSOR;
END_VAR


VAR
    Pmp31FB :	MotorFB;
END_VAR


VAR_EXTERNAL
    M_AUX :	MOTOR_MISC;
END_VAR


VAR
    i :	INT;
    PmpsFB :	MotorFB;
END_VAR


VAR_EXTERNAL
    Blr11_BrnRun :	BOOL;
    Blr11_BrnFault :	BOOL;
    Blr12_BrnRun :	BOOL;
    Blr12_BrnFault :	BOOL;
    Blr13_BrnRun :	BOOL;
    Blr13_BrnFault :	BOOL;
    Blr21_BrnRun :	BOOL;
    Blr21_BrnFault :	BOOL;
    Blr22_BrnRun :	BOOL;
    Blr22_BrnFault :	BOOL;
END_VAR


VAR
    PumpsFB :	MotorFB;
    MB_TO_REAL :	MB_TO_REAL;
END_VAR


VAR_EXTERNAL
    SlvData_RSUNI_2 :	MBRTU_SlvData;
    SlvData_RSUNI_1 :	MBRTU_SlvData;
    MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


VAR
    j :	INT;
    j2 :	INT;
    j3 :	INT;
    j4 :	INT;
    j5 :	INT;
    j6 :	INT;
    j7 :	INT;
    REAL_TO_MB :	REAL_TO_MB;
    BoilersFB :	MotorFB;
    BlrCycle :	CCL;
END_VAR


VAR_EXTERNAL
    CCL :	CYCLE;
    Blr11_EmergCirc :	BOOL;
    Blr12_EmergCirc :	BOOL;
    Blr13_EmergCirc :	BOOL;
    Blr21_EmergCirc :	BOOL;
    Blr22_EmergCirc :	BOOL;
END_VAR


VAR
    MotorFB_1 :	MotorFB;
END_VAR


VAR_EXTERNAL
    M_EVENT :	MOTOR_EVENT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MTR
IEC_LANGUAGE: ST
*)
Cycle.CW.AuxON:= true;
BlrCycle.SW.Running:= true;


FOR i:= 0 TO 4 DO
    j:= i * 32 + 3940;
    MBTCP_Data[j].X5:= true;
    M[i].CW.Enable:= true;
    M[i].CW.ExtraEn:= true;
    M[i].CW.AuxON:= true;
    M_AUX[i].SetOvertime:= 3;
END_FOR;

(*============================================================================*)
    (*Boiler 1.1 DI*)
(*============================================================================*)
M[0].CW.AutoON:=Blr11_BrnRun;
M[0].SW.RUN:=Blr11_BrnRun;
M[0].CW.ExtraEn:=Blr11_EmergCirc;
M[0].CW.ExtraAlarm:=Blr11_BrnFault;

(*============================================================================*)
    (*Boiler 1.2 DI*)
(*============================================================================*)
M[1].CW.AutoON:=Blr12_BrnRun;
M[1].SW.RUN:=Blr12_BrnRun;
M[1].CW.ExtraEn:=Blr12_EmergCirc;
M[1].CW.ExtraAlarm:=Blr12_BrnFault;

(*============================================================================*)
    (*Boiler 1.3 DI*)
(*============================================================================*)
M[2].CW.AutoON:=Blr13_BrnRun;
M[2].SW.RUN:=Blr13_BrnRun;
M[2].CW.ExtraEn:=Blr13_EmergCirc;
M[2].CW.ExtraAlarm:=Blr13_BrnFault;

(*============================================================================*)
    (*Boiler 2.1 DI*)
(*============================================================================*)
M[3].CW.AutoON:=Blr21_BrnRun;
M[3].SW.RUN:=Blr21_BrnRun;
M[3].CW.ExtraEn:=Blr21_EmergCirc;
M[3].CW.ExtraAlarm:=Blr21_BrnFault;

(*============================================================================*)
    (*Boiler 2.2 DI*)
(*============================================================================*)
M[4].CW.AutoON:=Blr22_BrnRun;
M[4].SW.RUN:=Blr22_BrnRun;
M[4].CW.ExtraEn:=Blr22_EmergCirc;
M[4].CW.ExtraAlarm:=Blr22_BrnFault;

(*============================================================================*)
M[1].AutoFreq:=M[0].AutoFreq;
M[2].AutoFreq:=M[0].AutoFreq;
M[4].AutoFreq:=M[3].AutoFreq;
(*============================================================================*)
    (*Boilers FB processing*)
(*============================================================================*)
FOR i:= 0 TO 4 DO
    BoilersFB(Mot_strct:=M[i],Aux_strct:=M_AUX[i],Cycle:=BlrCycle);
    M[i]:=BoilersFB.Mot_strct;
    M_AUX[i]:=BoilersFB.Aux_strct;
END_FOR;

(*============================================================================*)
FOR i:= 5 TO 7 DO
    j:= i - 5;
(*============================================================================*)
    (*Pump 3.x structure parameters*)
(*============================================================================*)
    M[i].CW.Enable:=M[i].SW.Rem;
    M[i].CW.AuxON:=CCL[2].CW.AuxON ;
    M[i].CW.ExtraAlarm:=M_AUX[i].DryMoveFault or M_AUX[i].TempFault;
    M[i].CW.ExtraEn:=true;
    M[i].SW.RUN:=M_AUX[i].DirRun or M_AUX[i].FCRun;
    M_AUX[i].SetOvertime:=90;
(*============================================================================*)
    (*Pump 3.x FC parameters*)
(*============================================================================*)
    M[i].ActFreq:=word_to_real(SlvData_RSUNI_2[j][0]) / 10.0;
    M[i].Power:=word_to_real(SlvData_RSUNI_2[j][2]) / 1000.0;a
    M[i].Current:=word_to_real(SlvData_RSUNI_2[j][4]) / 100.0; 
    M[i].HeatSinkTemp:=word_to_real(SlvData_RSUNI_2[j][6]);
    M[i].FC_StatusWord:=SlvData_RSUNI_2[j][8];
    M[i].FC_AlarmWord:=DW_TO_DWORD(SlvData_RSUNI_2[j][10],SlvData_RSUNI_2[j][11]);
    M[i].FC_WarnWord:=DW_TO_DWORD(SlvData_RSUNI_2[j][12],SlvData_RSUNI_2[j][13]);

    M[i].RunHours:=dword_to_real(DW_TO_DWORD(SlvData_RSUNI_2[j][14],SlvData_RSUNI_2[j][15]));
    M[i].kWhCount:=dword_to_real(DW_TO_DWORD(SlvData_RSUNI_2[j][16],SlvData_RSUNI_2[j][17]));

(*============================================================================*)
    (*Pumps 3.x FB processing*)
(*============================================================================*)
    PumpsFB(Mot_strct:=M[i],Aux_strct:=M_AUX[i],Cycle:=CCL[2]);
    M[i]:=PumpsFB.Mot_strct;
    M_AUX[i]:=PumpsFB.Aux_strct;
    M_EVENT[i]:=PumpsFB.Event;	
END_FOR;

(*============================================================================*)
FOR i:= 8 TO 10 DO
    j:= i - 8;
(*============================================================================*)
    (*Pump 5.x structure parameters*)
(*============================================================================*)
    M[i].CW.Enable:= M[i].SW.Rem;
    M[i].CW.AuxON:= Cycle.CW.AuxON;
    M[i].CW.ExtraAlarm:= M_AUX[i].DryMoveFault or M_AUX[i].TempFault;
    M[i].CW.ExtraEn:= true;
    M[i].SW.RUN:= M_AUX[i].DirRun or M_AUX[i].FCRun;
    M_AUX[i].SetOvertime:= 90;
(*============================================================================*)
    (*Pump 5.x FC parameters*)
(*============================================================================*)
    M[i].ActFreq:=word_to_real(SlvData_RSUNI_1[j][0]) / 10.0;
    M[i].Power:=word_to_real(SlvData_RSUNI_1[j][3]) / 100.0;
    M[i].Current:=word_to_real(SlvData_RSUNI_1[j][5]) / 100.0; 
    M[i].HeatSinkTemp:=word_to_real(SlvData_RSUNI_1[j][6]);
    M[i].FC_StatusWord:=SlvData_RSUNI_1[j][8];
    M[i].FC_AlarmWord:=DW_TO_DWORD(SlvData_RSUNI_1[j][10],SlvData_RSUNI_1[j][11]);
    M[i].FC_WarnWord:=DW_TO_DWORD(SlvData_RSUNI_1[j][12],SlvData_RSUNI_1[j][13]);

    M[i].RunHours:=dword_to_real(DW_TO_DWORD(SlvData_RSUNI_1[j][14],SlvData_RSUNI_1[j][15]));
    M[i].kWhCount:=dword_to_real(DW_TO_DWORD(SlvData_RSUNI_1[j][16],SlvData_RSUNI_1[j][17]));

(*============================================================================*)
    (*Pumps 5.x FB processing*)
(*============================================================================*)
    PumpsFB(Mot_strct:=M[i],Aux_strct:=M_AUX[i],Cycle:=CCL[3]);
    M[i]:=PumpsFB.Mot_strct;
    M_AUX[i]:=PumpsFB.Aux_strct;
    M_EVENT[i]:=PumpsFB.Event;
END_FOR;


(*============================================================================*)
FOR i:= 11 TO 12 DO
    j:= i - 8;
(*============================================================================*)
    (*Pump 6.x structure parameters*)
(*============================================================================*)
    M[i].CW.Enable:=M[i].SW.Rem;
    M[i].CW.AuxON:=Cycle.CW.AuxON;
    M[i].CW.ExtraAlarm:=M_AUX[i].DryMoveFault or M_AUX[i].TempFault;
    M[i].CW.ExtraEn:=true;
    M[i].SW.RUN:=M_AUX[i].DirRun or M_AUX[i].FCRun;
    M_AUX[i].SetOvertime:=90;
(*============================================================================*)
    (*Pump 6.x FC parameters*)
(*============================================================================*)
    M[i].ActFreq:=word_to_real(SlvData_RSUNI_2[j][0]) / 10.0;
    M[i].Power:=word_to_real(SlvData_RSUNI_2[j][2]) / 1000.0;
    M[i].Current:=word_to_real(SlvData_RSUNI_2[j][4]) / 100.0; 
    M[i].HeatSinkTemp:=word_to_real(SlvData_RSUNI_2[j][6]);
    M[i].FC_StatusWord:=SlvData_RSUNI_2[j][8];
    M[i].FC_AlarmWord:=DW_TO_DWORD(SlvData_RSUNI_2[j][10],SlvData_RSUNI_2[j][11]);
    M[i].FC_WarnWord:=DW_TO_DWORD(SlvData_RSUNI_2[j][12],SlvData_RSUNI_2[j][13]);

    M[i].RunHours:=dword_to_real(DW_TO_DWORD(SlvData_RSUNI_2[j][14],SlvData_RSUNI_2[j][15]));
    M[i].kWhCount:=dword_to_real(DW_TO_DWORD(SlvData_RSUNI_2[j][16],SlvData_RSUNI_2[j][17]));

(*============================================================================*)
    (*Pumps 6.x FB processing*)
(*============================================================================*)
    PumpsFB(Mot_strct:=M[i],Aux_strct:=M_AUX[i],Cycle:=CCL[4]);
    M[i]:=PumpsFB.Mot_strct;
    M_AUX[i]:=PumpsFB.Aux_strct;
    M_EVENT[i]:=PumpsFB.Event;
END_FOR;

(*============================================================================*)
    (*Reset CWs and rewrite parameters TO MB TCP*)
(*============================================================================*)
FOR i:= 5 TO 12 DO
    j:= i * 32 + 3940;
    j2:= j + 2;
    j3:= j + 3;
    j4:= j + 4;
    j5:= j + 5;
    j6:= j + 6;
    j7:= j + 7;

    REAL_TO_MB(IN:=M[i].MinFreq);
    MBTCP_Data[j2]:=REAL_TO_MB.LoWord;
    MBTCP_Data[j3]:=REAL_TO_MB.HiWord;

    REAL_TO_MB(IN:=M[i].MaxFreq);
    MBTCP_Data[j4]:=REAL_TO_MB.LoWord;
    MBTCP_Data[j5]:=REAL_TO_MB.HiWord;

    REAL_TO_MB(IN:=M[i].ManFreq);
    MBTCP_Data[j6]:=REAL_TO_MB.LoWord;
    MBTCP_Data[j7]:=REAL_TO_MB.HiWord;
END_FOR;

(*============================================================================*)
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
