%DUTIL; Utilites the main %DEBUG routine
	Q


FZPOS(%ZPOS,%FORMAT)
	n (%ZPOS,%FORMAT)
	s %FORMAT=$$FUNC^%UCASE($g(%FORMAT,"LOR"))
	;
	; Format a zpos string to the desired format: "<Label>+<Offset>^<Routine>"
	; You can also decide which FORMAT you want the ZPOS String to be returned as.
	;
	; @param %ZPOS		The zpos string
	; @param %FORMAT	Specify which zpos format should be returned [L = "Label", O = "Offset", R = "Routine"] (Default: "LOR")
	;
	; Usage:
	; 	> w $$FZPOS("Label+0^Test")
	; 	> w $$FZPOS("Label^Test")
	;	> w $$FZPOS("+0^Test")
	;	> w $$FZPOS("^Test")
	; 		@returns "Label+0^Test"
	;
	; 	> w $$FZPOS("Label+0^Test","OR")
	;		@returns "+0^Test"
	;	> w $$FZPOS("Label+0^Test","LR")
	;		@returns "Label^Test"
	;
	s *POS=$$DZPOS(%ZPOS)

	s LABEL=POS("LABEL")
	s OFFSET="+"_POS("OFFSET")
	s ROUTINE="^"_POS("ROUTINE")

	view "NOUNDEF"
	k:'($f(%FORMAT,"L")) LABEL
	k:'($f(%FORMAT,"O")) OFFSET
	k:'($f(%FORMAT,"R")) ROUTINE
	s retZPos=LABEL_OFFSET_ROUTINE
	view "UNDEF"

	q retZPos


DZPOS(%ZPOS)
	n (%ZPOS) s *retStruct=struct
	;
	; Destruct a zpos string to an Mumps-Struct Object
	;
	; @param 	%ZPOS		The zpos position
	; @returns {Struct}		Destructed zpos Mumps-Struct
	;
	; Usage:
	; 	> s *POS=$$DZPOS("Label+0^Test")
	; 	> s *POS=$$DZPOS("Label^Test")
	;	> s *POS=$$DZPOS("+0^Test")
	;	> s *POS=$$DZPOS("^Test")
	; 		@returns
	; 			STRUCT("LABEL")="Label"
	; 			STRUCT("OFFSET")=0
	; 			STRUCT("ROUTINE")="Test"
	;

	s %=$p(%ZPOS,"^",1)
	s struct("LABEL")=$p(%,"+",1)
	s struct("OFFSET")=+$p(%,"+",2)
	s struct("ROUTINE")=$p(%ZPOS,"^",2)

	q *retStruct


GALABELS(%ROUTINE)
	n (%ROUTINE) s:$q *retLabels=LABELS
	;
	; Get all labels from a specified routine.
	; Includes the label and it`s associated metadata.
	;
	; @param 	%ROUTINE		The routine name
	; @returns	{Struct|NORET}	The labels as a Mumps-Struct
	;
	; Usage:
	; 	> d GALABELS("test")
	;  	> s *LABELS=$$GALABELS("test")
    ; 	@returns
    ; 		LABELS(1)="Test"
    ; 		LABELS(1,"ZPOS")="Test+1^test"
    ; 		LABELS(1,"ZPOS","LABEL")="Test"
    ; 		LABELS(1,"ZPOS","OFFSET")=1
    ; 		LABELS(1,"ZPOS","ROUTINE")="test"
    ; 		LABELS(2)="powerOf"
    ; 		LABELS(2,"ARGS",1)="value"
    ; 		LABELS(2,"ARGS",2)="pw"
    ; 		LABELS(2,"ZPOS")="powerOf+9^test"
    ; 		LABELS(2,"ZPOS","LABEL")="powerOf"
    ; 		LABELS(2,"ZPOS","OFFSET")=9
    ; 		LABELS(2,"ZPOS","ROUTINE")="test"
    ;

	for i=1:1 s line=$t(+i^@%ROUTINE) q:(line="")  d
	.q:($e(line,1)=" ")
	.s name=$p(line,"(",1)
	.s zpos=$$FZPOS^%DUTIL(name_"+"_i_"^"_%ROUTINE)
	.s LABELS($i(nr))=name
	.s LABELS(nr,"ZPOS")=zpos
	.s *%=$$DZPOS^%DUTIL(zpos) m LABELS(nr,"ZPOS")=%
	.if line["("  d
	..s %=$p(line,"(",2),%=$tr(%,"()"),*args=$$SPLIT^%MPIECE(%,",")
	..m LABELS(nr,"ARGS")=args

	q:$q *retLabels
	zwr LABELS q


PROMPT()
	n (%ZR)
	w !,"Please choose an option (s-start, h-help, q-quit)",!
	read "> ",option#1 w !
	s retValue=$s(option="s":"START",option="h":"HELP^%DUTIL",option="q":"",1:"")

	s %ZR("OPTION")=option

	Q retValue


HELP n
	D CLEAR^%GUI

	S TEXT="Lordem Ipsum is simply dummy text of the printing and typesetting industry.\nLorem Ipsum has been the industry's standard dummy text ever since the 1500s,\nwhen an unknown printer took a galley of type and scrambled it to make a type specimen book.\nIt has survived not only five centuries, but also the leap into electronic typesetting,\nremaining essentially unchanged."
	D FRAME^%GUI("HELP",100,TEXT)

	Q

