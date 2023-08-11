(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: Cycle
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
PROGRAM MainCycle

(*Group:Default*)


VAR_EXTERNAL
    Cycle :	Cycle;
    Boiler :	Blr;
END_VAR


VAR
    xPrepStep :	BOOL;
    i :	BOOL;
END_VAR


VAR_EXTERNAL
    xBrnSafetyCircON :	BOOL;
END_VAR


VAR
    xPurgeStep :	BOOL;
    TON_1 :	TON;
    PLS_Start :	R_TRIG;
    xRestartStep :	BOOL;
    PidOnDelay :	TON;
    xOperationStep :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: MainCycle
IEC_LANGUAGE: ST
*)

PLS_Start(CLK:=Cycle.SW.Running);
(*PidOnDelay(IN:=xOperationStep,PT:=t#90s);*)

(*============================================================================*)
if Cycle.SW.Running then
(*============================================================================*)

    if	PLS_Start.Q or (Boiler.AI[1].SW.LH_alarm and xRestartStep) then
        xPrepStep:= true;
        xRestartStep:= false;
    end_if;
    
    if xPrepStep then
        Boiler.V[1].CW.AutoOpen:= not Boiler.V[1].SW.Opened;
        Boiler.V[2].CW.AutoOpen:= not Boiler.V[2].SW.Opened;
        Boiler.V[3].CW.AutoOpen:= not Boiler.V[3].SW.Opened;
    end_if;

    if	Boiler.V[1].SW.Opened and 
        Boiler.V[2].SW.Opened and
        Boiler.V[3].SW.Opened and 
        xPrepStep then
        Boiler.M[0].AutoFreq:= Boiler.M[0].MaxFreq;
        Boiler.Brn1.Sys.AutoSP:= Boiler.Brn1.Sys.MinSP ;
        xPrepStep:= false;
        xPurgeStep:= true;
    end_if;

    if xPurgeStep then
        Boiler.M[0].CW.AutoON:= Boiler.M[0].SW.AutoOK;
        Boiler.Brn1.CW.AutoON:= true;

        if Boiler.Brn1.SW.RUN and 
            (Boiler.Brn1.Sys.Phase >= word#34) then
            Boiler.M[0].AutoFreq:= Boiler.M[0].MinFreq;
            Boiler.M[0].CW.AutoON:= false;
            xPurgeStep:= false;
            xOperationStep:= true;
        end_if;
    end_if;

    if	xOperationStep and Boiler.Brn1.SW.FireOK then
        Boiler.Brn1.Reg[0].CW.En:= Boiler.Brn1.SW.Auto and Boiler.Brn1.SW.RUN;
        Boiler.Brn1.Sys.AutoSP:= Boiler.Brn1.Reg[0].Y / 10.0;

        Boiler.Reg[1].CW.En:=Boiler.M[0].SW.Auto and Boiler.M[0].SW.RUN;
        Boiler.M[0].CW.AutoON:= true;
        Boiler.M[0].AutoFreq:= Boiler.Reg[1].Y / 10.0;

        Boiler.M[1].CW.AutoON:= true;
        Boiler.Reg[2].CW.En:=Boiler.M[1].SW.Auto and Boiler.M[1].SW.RUN;
    else
        Boiler.Brn1.Reg[0].CW.En:= false;
        Boiler.Reg[1].CW.En:= false;
        Boiler.Reg[2].CW.En:= false;
    end_if;

    if Boiler.AI[1].SW.HL_alarm and xOperationStep then
        Boiler.Brn1.CW.AutoON:= false;
        Boiler.M[0].CW.AutoON:= false;
        Boiler.M[1].CW.AutoON:= false;
        xRestartStep:= true;
        xOperationStep:= false;
    end_if;

else
    xPrepStep:= false;
    xPurgeStep:= false;
    xOperationStep:= false;
    xRestartStep:= false;
    Boiler.Brn1.CW.AutoON:= false;
    Boiler.M[0].CW.AutoON:= false;
    Boiler.M[1].CW.AutoON:= false;
    Boiler.Brn1.Reg[0].CW.En:= false;
    Boiler.Reg[1].CW.En:= false;
    Boiler.Brn1.Sys.AutoSP:= 0.0;
    Boiler.M[0].AutoFreq:= 0.0;
(*============================================================================*)
end_if;
(*============================================================================*)
(*@KEY@: END_WORKSHEET *)
END_PROGRAM
