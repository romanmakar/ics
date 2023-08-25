(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: VLVS
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM VLV

(*Group:Default*)


VAR_EXTERNAL
    Cycle :CCL;
    V :VALVE;
END_VAR


VAR
    i :INT;
    ValvesFB :ValveFB;
END_VAR


VAR_EXTERNAL
    V_AUX :VALVE_MISC;
END_VAR


VAR
    j :INT;
END_VAR


VAR_EXTERNAL
    MBTCP_Data :MB_TCP_ARR_W_0_7167;
END_VAR


VAR
    VLV_Cycle :CCL;
END_VAR


VAR_EXTERNAL
    AI :SENSOR;
END_VAR


(*@KEY@: WORKSHEET
NAME: VLV
IEC_LANGUAGE: ST
*)
(*============================================================================*)
    (*Valve TV7001 structure parameters*)
(*============================================================================*)
V[0].CW.Enable:= V[0].SW.Rem;
V[0].CW.AuxON:= Cycle.CW.AuxON;
V[0].CW.ExtraEn:= true;
V[0].SW.RUN:= V[0].SW.COM_Open or V[0].SW.COM_Close; 
V[0].ActPos:= AI[91].RealValue;
V_AUX[0].SetOvertime:= 180;

(*============================================================================*)
    (*Valve TV8019 structure parameters*)
(*============================================================================*)
V[1].CW.Enable:= V[1].SW.Rem;
V[1].CW.AuxON:= Cycle.CW.AuxON;
V[1].CW.ExtraEn:= true;
V[1].SW.RUN:= V[1].SW.COM_Open or V[1].SW.COM_Close;
V[1].ActPos:= AI[92].RealValue; 
V_AUX[1].SetOvertime:= 70;

(*============================================================================*)
    (*Valve TV9008 structure parameters*)
(*============================================================================*)
V[2].CW.Enable:= V[2].SW.Rem;
V[2].CW.AuxON:= Cycle.CW.AuxON;
V[2].CW.ExtraEn:= true;
V[2].SW.RUN:= V[2].SW.COM_Open or V[2].SW.COM_Close; 
V[2].ActPos:= AI[93].RealValue;
V_AUX[2].SetOvertime:= 70;

(*============================================================================*)
    (*Valve HV5004 structure parameters*)
(*============================================================================*)
V[3].CW.Enable:= true;
V[3].CW.AuxON:= Cycle.CW.AuxON;
V[3].CW.ExtraEn:= true;
V[3].SW.RUN:= V[3].SW.COM_Open; 
V[3].SW.Opened:= V[3].SW.COM_Open;
V_AUX[3].SetOvertime:= 3; 

(*============================================================================*)
    (*Valve HV8009 structure parameters*)
(*============================================================================*)
V[4].CW.Enable:= true;
V[4].CW.AuxON:= Cycle.CW.AuxON;
V[4].CW.ExtraEn:= true;
V[4].SW.RUN:= V[4].SW.COM_Open; 
V[4].SW.Opened:= V[4].SW.COM_Open;
V_AUX[4].SetOvertime:= 3; 

(*============================================================================*)
    (*Valve HV016 structure parameters*)
(*============================================================================*)
V[5].CW.Enable:= true;
V[5].CW.AuxON:= Cycle.CW.AuxON;
V[5].CW.ExtraEn:= true;
V[5].SW.RUN:= V[5].SW.COM_Open; 
V[5].SW.Opened:= V[5].SW.COM_Open;
V_AUX[5].SetOvertime:= 3; 

(*============================================================================*)
    (*Valve HV017 structure parameters*)
(*============================================================================*)
V[6].CW.Enable:= true;
V[6].CW.AuxON:= Cycle.CW.AuxON;
V[6].CW.ExtraEn:= true;
V[6].SW.RUN:= V[6].SW.COM_Open; 
V[6].SW.Opened:= V[6].SW.COM_Open;
V_AUX[6].SetOvertime:= 3; 

(*============================================================================*)
    (*Valve HV018 structure parameters*)
(*============================================================================*)
V[7].CW.Enable:= true;
V[7].CW.AuxON:= Cycle.CW.AuxON;
V[7].CW.ExtraEn:= true;
V[7].SW.RUN:= V[7].SW.COM_Open; 
V[7].SW.Opened:= V[7].SW.COM_Open;
V_AUX[7].SetOvertime:= 3; 

(*============================================================================*)
    (*Valve HV024 structure parameters*)
(*============================================================================*)
V[8].CW.Enable:= true;
V[8].CW.AuxON:= Cycle.CW.AuxON;
V[8].CW.ExtraEn:= true;
V[8].SW.RUN:= V[8].SW.COM_Open; 
V[8].SW.Opened:= V[8].SW.COM_Open; 
V_AUX[8].SetOvertime:= 3;

(*============================================================================*)
    (*Valves FB processing*)
(*============================================================================*)
for i:= 0 to 8 do
    j:= i * 16 + 4580;
    VLV_Cycle.SW.Running:= V[i].SW.ManAuto;
    ValvesFB(Vlv_strct:=V[i],Aux_strct:=V_AUX[i],Cycle:=VLV_Cycle);
    V[i]:=ValvesFB.Vlv_strct;
    V_AUX[i]:=ValvesFB.Aux_strct;
end_for;

(*============================================================================*)

(*@KEY@: END_WORKSHEET *)
END_PROGRAM
