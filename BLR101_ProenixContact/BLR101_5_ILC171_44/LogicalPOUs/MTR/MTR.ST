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
    M :	MOTOR;
    CCL :	CYCLE;
    WarnWord :	WRN;
    M_AUX :	MOTOR_MISC;
    AI :	SENSOR;
END_VAR


VAR
    i :	INT;
    j :	INT;
    PumpsFB :	MotorFB;
END_VAR


VAR_EXTERNAL
    MBRTU_Data :	MBRTU_SlvData;
END_VAR


VAR
    REAL_TO_MB :	REAL_TO_MB;
    y :	INT;
END_VAR


VAR_EXTERNAL
    MBTCP_Data :	MB_TCP_ARR_W_0_7167;
END_VAR


VAR
    y2 :	INT;
    y3 :	INT;
    y4 :	INT;
    y5 :	INT;
    y6 :	INT;
    y7 :	INT;
END_VAR


VAR_EXTERNAL
    M_EVENT :	MOTOR_EVENT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MTR
IEC_LANGUAGE: ST
*)

    M[0].CW.AuxON			:= CCL[0].CW.AuxON and WarnWord.InputVoltage_1;
    M[1].CW.AuxON			:= CCL[0].CW.AuxON and WarnWord.InputVoltage_1;
    M[2].CW.AuxON			:= CCL[0].CW.AuxON and WarnWord.InputVoltage_1;
    M[3].CW.AuxON			:= CCL[0].CW.AuxON and WarnWord.InputVoltage_2;
    M[4].CW.AuxON			:= CCL[0].CW.AuxON and WarnWord.InputVoltage_2;

    M[0].ActFreq			:= AI[16].RealValue;
    M[1].ActFreq			:= AI[17].RealValue;
    M[2].ActFreq			:= AI[18].RealValue;
    M[3].ActFreq			:= AI[20].RealValue;
    M[4].ActFreq			:= AI[21].RealValue;

for i:= 0 to 4 do
(*================================================================================================*)
    (*Pumps 2.x structure parameters*)
(*================================================================================================*)
    M[i].CW.Enable			:= M[i].SW.Rem;
    M[i].CW.ExtraAlarm		:= M_AUX[i].DryMoveFault or M_AUX[i].DiffPressFault or M_AUX[i].TempFault;
    M[i].CW.ExtraEn			:= true;
    M[i].SW.RUN				:= M_AUX[i].DirRun or M_AUX[i].FCRun;
    M_AUX[i].SetOvertime	:= 30;

(*================================================================================================*)
    (*Pumps FB processing*)
(*================================================================================================*)
    PumpsFB(Mot_strct:=M[i],Aux_strct:=M_AUX[i],Cycle:=CCL[0]);
    M[i]:=PumpsFB.Mot_strct;
    M_AUX[i]:=PumpsFB.Aux_strct;
    M_EVENT[i]:=PumpsFB.Event;

(*================================================================================================*)
    (*Pumps 2.x FC parameters*)
(*================================================================================================*)
    j:= i + 13;
    M[i].Power				:= word_to_real(MBRTU_Data[i][0]) / 1000.0;
    M[i].Current			:= word_to_real(MBRTU_Data[i][2])/ 100.0; 
    M[i].HeatSinkTemp		:= word_to_real(MBRTU_Data[i][4]);
    M[i].FC_StatusWord		:= MBRTU_Data[i][6];
    M[i].FC_AlarmWord		:= DW_TO_DWORD(MBRTU_Data[i][8],MBRTU_Data[i][9]);
    M[i].FC_WarnWord		:= DW_TO_DWORD(MBRTU_Data[i][10],MBRTU_Data[i][11]);

    M[i].RunHours           := dword_to_real(DW_TO_DWORD(MBRTU_Data[i][12],MBRTU_Data[i][13]));
    M[i].kWhCount			:= dword_to_real(DW_TO_DWORD(MBRTU_Data[i][14],MBRTU_Data[i][15]));

(*================================================================================================*)
    (*Reset and rewrite parameters to MB TCP*)
(*================================================================================================*)
    y:= i * 32 + 1700;
    y2:= y + 2;
    y3:= y + 3;
    y4:= y + 4;
    y5:= y + 5;
    y6:= y + 6;
    y7:= y + 7;

    REAL_TO_MB(IN:=M[i].MinFreq);
    MBTCP_Data[y2]:=REAL_TO_MB.LoWord;
    MBTCP_Data[y3]:=REAL_TO_MB.HiWord;

    REAL_TO_MB(IN:=M[i].MaxFreq);
    MBTCP_Data[y4]:=REAL_TO_MB.LoWord;
    MBTCP_Data[y5]:=REAL_TO_MB.HiWord;

    REAL_TO_MB(IN:=M[i].ManFreq);
    MBTCP_Data[y6]:=REAL_TO_MB.LoWord;
    MBTCP_Data[y7]:=REAL_TO_MB.HiWord;
end_for;



(*@KEY@: END_WORKSHEET *)
END_PROGRAM
