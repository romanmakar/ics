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
PROGRAM MTR_CTRL

(*Group:Default*)


VAR
	RunPmpNum :	INT;
	TmpWTMax :	UDINT;
	TmpWTMin :	UDINT;
	TmpIndMax :	INT;
	TmpIndMin :	INT;
	i :	INT;
	StartPmpReq :	BOOL;
	StopPmpReq :	BOOL;
	Stage :	INT;
END_VAR


VAR_EXTERNAL
	CCL :	CYCLE;
END_VAR


VAR
	StartReqTmr :	TON;
	StopReqTmr :	TON;
	OverClckTmr :	TON;
	ReleaseTmr :	TON;
	TmpFreq :	REAL;
END_VAR


VAR_EXTERNAL
	M :	MOTOR;
	RGLTR :	REGULATOR;
	M_AUX :	MOTOR_MISC;
	MBTCP_Data :	MB_TCP_ARR_W_0_7167;
	AI :	SENSOR;
END_VAR


VAR
	MainPID :	FPID;
	TmpRotation :	BOOL;
	j :	INT;
END_VAR


VAR_EXTERNAL
	M_EVENT :	MOTOR_EVENT;
END_VAR


VAR
	TmpPmpAlarm :	BOOL;
	SysNum :	INT;
	LoInd :	INT;
	HiInd :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: MTR_CTRL
IEC_LANGUAGE: ST
*)
(*================================================================================================*)
(*Work time sorting*)(*Number of working pumps evaluation*)(*PID min and max limits determination*)
(*================================================================================================*)
SysNum:= 0;																		(*Sequence number of cycle in cycles array (regulator in reg. array)*)
LoInd:= 0;																		(*First number of pump in pumps array used here*)
HiInd:= 4;																		(*Last number of pump in pumps array used here*)
RunPmpNum:= 0;
RGLTR[SysNum].LL:= 50.0;
RGLTR[SysNum].LH:= 0.0;

(*================================================================================================*)
for i:= LoInd to HiInd do

	if M[i].SW.AutoOK and M[i].SW.RUN then										(*Working pump number determination*)
		RunPmpNum:= RunPmpNum + 1;					

		if M[i].MaxFreq > RGLTR[SysNum].LH  then								(*Assign pumps max. freq to RGLTR. hight limit*)
			RGLTR[SysNum].LH:= M[i].MaxFreq;
		end_if;

		if M[i].MinFreq < RGLTR[SysNum].LL then									(*Assign pumps min. freq to RGLTR. low limit*)
			RGLTR[SysNum].LL:= M[i].MinFreq;
		end_if;
	end_if;

	if not M[i].SW.AutoOK then
		M[i].CW.AutoON:= false;
	end_if;

	M[i].AutoFreq:= RGLTR[SysNum].Y / 10.0;										(*Assign pumps min. freq to RGLTR. low limit*)

(*================================================================================================*)
	(*Pumps Dry motion*)
(*================================================================================================*)
	j:= i * 2 + 2;

	M_AUX[i].CT1_ON:= (AI[j].RealValue <= 0.5) and M[i].SW.RUN and not M_AUX[i].DryMoveFault;

	if M_AUX[i].CT1 > 5 then
		M_AUX[i].DryMoveFault:= true;
	end_if;

	M_AUX[i].CT2_ON:= (AI[j].RealValue >= 1.0) and M_AUX[i].DryMoveFault;

	if M_AUX[i].CT2 > 30 then
		M_AUX[i].DryMoveFault:= false;
	end_if;

(*================================================================================================*)
	(*Alarm action*)
(*================================================================================================*)
	if M[i].SW.ManAuto and M_EVENT[i].AlarmAccum then
		TmpPmpAlarm:= true;
	end_if;
end_for;
(*================================================================================================*)



(*================================================================================================*)
	(*Set rotation command*)
(*================================================================================================*)
if CCL[SysNum].CW.Rotation then
	CCL[SysNum].SW.RotationON:= true;
	CCL[SysNum].CW.Rotation:= false;
end_if;

(*================================================================================================*)
	(*Start/Stop conditions*)
(*================================================================================================*)
StartReqTmr(IN:=(((RGLTR[SysNum].Y / 10.0) >= (RGLTR[SysNum].LH - 2.0)) and
				(RGLTR[SysNum].ActVal < RGLTR[SysNum].SP) and
				not StartPmpReq and CCL[SysNum].SW.Running),PT:=t#60s); 		(*Start auxiliary pump condition*)

StopReqTmr(IN:=(((RGLTR[SysNum].Y / 10.0) <= (RGLTR[SysNum].LL + 1.0)) and 
				(RGLTR[SysNum].ActVal >= RGLTR[SysNum].SP) and
				not StopPmpReq and CCL[SysNum].SW.Running),PT:=t#60s);			(*Stop pump condition*)

(*================================================================================================*)
	(*Cycle handling*)
(*================================================================================================*)
IF CCL[SysNum].SW.Running then
	if (StartReqTmr.Q or (RunPmpNum < 1) or TmpPmpAlarm) and (Stage = 0) then	(*Stage route: 1 >> 2 >> 0*)
		Stage:= 1;
		if TmpPmpAlarm then
			TmpPmpAlarm:= false;
		end_if;
	elsif CCL[SysNum].SW.RotationON and (RunPmpNum > 0) and (Stage = 0) then	(*Stage route: 3 >> 1 >> 2 >> 4 >> 0*)
		TmpRotation:= true;
		Stage:= 3;
	elsif StopReqTmr.Q and (Stage = 0) then										(*Stage route: 3 >> 4 >> 0*)
		Stage:= 3;
	end_if;
else
	StartPmpReq:= false;
	StopPmpReq:= false;
	TmpFreq:= 0.0;
	CCL[SysNum].SW.RotationON:= false;
	TmpRotation:= false;
	Stage:= 0;
	TmpPmpAlarm:= false;
	
	for i:= LoInd to HiInd do
		M[i].CW.AutoON:= false;
	end_for;
end_if;

OverClckTmr(IN:=StartPmpReq and not OverClckTmr.Q,PT:=t#3s);					(*Overclocking pulse timer*)
ReleaseTmr(IN:=StopPmpReq and not ReleaseTmr.Q,PT:=t#3s);						(*Releasing pulse timer*)

case Stage of
	
	0:	StartPmpReq:= false;
		StopPmpReq:= false;
		TmpPmpAlarm:= false;
		CCL[SysNum].SW.RotationON:= false;
		TmpRotation:= false;
		TmpFreq:= 0.0;

	1:	StartPmpReq:= true;														(*Determ. higher work time*)
		TmpWTMin:= udint#0;
		TmpIndMin:= 0;
		for i:= LoInd to HiInd do
			if M_AUX[i].Seconds >= TmpWTMin then	
				TmpWTMin:= M_AUX[i].Seconds;									(*Assign. higher work time to temporary var.*)	
			end_if;
		end_for;

		for i:= LoInd to HiInd do
			if M[i].SW.AutoOK and not M[i].SW.RUN then							(*Determ. lowest work time pump*)
				if M_AUX[i].Seconds <= TmpWTMin then
					TmpWTMin:= M_AUX[i].Seconds;
					TmpIndMin:= i;												(*Determ. lowest work time pump index*)
				end_if;
			end_if;
		end_for;
		if (TmpIndMin < LoInd) and (TmpIndMin > HiInd) then
			Stage:= 5;
		else
			M[TmpIndMin].CW.AutoON:= true;										(*Start lowest work time pump*)
			TmpFreq:= M[TmpIndMin].MinFreq;										(*with min. frequency*)
			Stage:= 2;
		end_if;

	2:	M[TmpIndMin].AutoFreq:= TmpFreq;										(*Overclocking new pump*)
		if OverClckTmr.Q then
			TmpFreq:= TmpFreq + 1.0;
		elsif M[TmpIndMin].AutoFreq >= (RGLTR[SysNum].Y / 10.0)  then
			StartPmpReq:= false;
			if TmpRotation then
				Stage:= 4;
			else
				Stage:= 5;
			end_if;
		end_if;
		
	3:	TmpWTMax:= udint#0;														(*Determ. highest work time pump*)
		TmpIndMax:= 0;
		for i:= LoInd to HiInd do 
			if M[i].SW.AutoOK and M[i].SW.RUN then
				if M_AUX[i].Seconds >= TmpWTMax then
					TmpWTMax:= M_AUX[i].Seconds;
					TmpIndMax:= i;
				end_if;
			end_if;
		end_for;
		if TmpRotation then
			Stage:= 1;
		else
			TmpFreq:= RGLTR[SysNum].Y / 10.0;
			Stage:= 4;
		end_if;

	4:	StopPmpReq:= true;														(*Releasing highest work time pump*)
		M[TmpIndMax].AutoFreq:= TmpFreq;
		if ReleaseTmr.Q then
			TmpFreq:= TmpFreq - 1.0;
		elsif M[TmpIndMax].AutoFreq <= M[TmpIndMax].MinFreq then
			M[TmpIndMax].CW.AutoON:= false;
			StopPmpReq:= false;
			Stage:= 5;
			TmpFreq:= 0.0;
		end_if;

	5:	StartPmpReq:= false;
		StopPmpReq:= false;
		TmpPmpAlarm:= false;
		CCL[SysNum].SW.RotationON:= false;
		TmpRotation:= false;
		TmpFreq:= 0.0;
		Stage:= 0;
end_case;


(*================================================================================================*)
	(*Main PID*)
(*================================================================================================*)
RGLTR[SysNum].ActVal:= AI[12].RealValue(* - AI[0].RealValue*);
MainPID(REMOTE:=CCL[SysNum].SW.Running,
		AUTO:=true,
		DIRECTN:=false,
		INTLCK:=(RunPmpNum <= 0),
		Tscan:=1.0,
		Yman:=RGLTR[SysNum].ManVal,
		SPR:=(RGLTR[SysNum].SP * 100.0),
		SPL:=0.0,
		X:=(RGLTR[SysNum].ActVal * 100.0),
		KP:=RGLTR[SysNum].Kp,
		TI:=RGLTR[SysNum].Tn,
		TD:=RGLTR[SysNum].Tv,
		HIGH:=(RGLTR[SysNum].LH * 10.0),
		LOW:=(RGLTR[SysNum].LL * 10.0),
		INTLCKV:=0.0);
RGLTR[SysNum].Y:=MainPID.Yout;

(*================================================================================================*)



(*@KEY@: END_WORKSHEET *)
END_PROGRAM
