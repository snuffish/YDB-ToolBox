%GUI; Routine Utility to handle CLI GUI Operations
	Q

CLEAR U $P:(X=0:Y=0:CLEAR) Q

; Move the cursor to the specified coordinates.
; $INCREMENT the Y-Position after every call.
POS N (%GPOS)
	VIEW "NOUNDEF" S X=$P(%GPOS,",",1),Y=$P(%GPOS,",",2) S:(X="") X=1 S:(Y="") Y=1 VIEW "UNDEF"
	WRITE $CHAR(27)_"["_Y_";"_X_"H"
	S $P(%GPOS,",",1)=X
	S $P(%GPOS,",",2)=$I(Y)
	Q


FRAME(TITLE,WIDTH,CONTENT,DELIMETER)
	N (TITLE,WIDTH,CONTENT,DELIMETER,%GPOS)
	;
	; Render a Window Frame
	;
	; @param	TITLE		{String}		The title of the Frame					(default: "")
	; @param	WIDTH		{Integer}		The width of the frame					(default: 50)
	; @param	CONTENT		{Array|String}	The content of the frame
	; @param	DELIMETER	{String}		The delimeter if CONTENT is a {String}	(default: "\n")
	; @returns	{Void}
	;
	S TITLE=$G(TITLE,""),WIDTH=$G(WIDTH,50),DELIMETER=$G(DELIMETER,"\n")

	I $D(CONTENT)#10 S *CONTENT=$$SPLIT^%MPIECE(CONTENT,DELIMETER) ; If a string, split the new-lines into an Array

	D POS WRITE "╔",$$PAD(TITLE,WIDTH,"═","C"),"╗",! ; Top window frame
	S INDEX="" FOR  S INDEX=$O(CONTENT(INDEX)) Q:(INDEX="")  D
	.S ROW=$TR(CONTENT(INDEX),$C(9),$C(32)) ; Convert tabs to spaces
	.D POS WRITE "║",$$PAD(ROW,WIDTH),"║",!
	D POS WRITE "╚",$$PAD(,WIDTH,"═"),"╝",! ; Bottom window frame

	Q


SELECT(LIST,DELIMETER)
	N (LIST,DELIMETER)
	S DELIMETER=$G(DELIMETER,"|")

	I $D(LIST)#10 S *LIST=$$SPLIT^%MPIECE(LIST,DELIMETER)
	S SELECTED=-1,SELECTION=$O(LIST(""))

	S CMD="" for  Q:(CMD="q")  DO
	.D CLEAR
	.S INDEX="" for  S INDEX=$O(LIST(INDEX)) Q:(INDEX="")  DO
	..w:(SELECTION=INDEX) $C(10132)_$C(32)
	..w LIST(INDEX),!
	.READ "[w-up, s-down, space-select, q-quit]",!,CMD#1
	.I CMD="w" S SELECTION=$O(LIST(SELECTION),-1)
	.I CMD="s" S SELECTION=$O(LIST(SELECTION))
	.I CMD=" " S SELECTED=SELECTION,CMD="q"

	I SELECTED=-1 S *RET=SELECTED Q *RET

	S RET("KEY")=SELECTED
	S RET("VALUE")=LIST(SELECTED)

	S *RET=RET Q *RET


PAD:(TEXT,LENGTH,PADCHAR,JUSTIFY)
	N (TEXT,LENGTH,PADCHAR,JUSTIFY)
	;
	; Padding the specified data input
	;
	; @param TEXT		Input text to be padded (default: "")
	; @param LENGTH		Pad length (Default: 6)
	; @param PADCHAR	Pad char (Default: " ")
	; @param JUSTIFY	Padding justifying ["L", "R", "C"] (Default: "L")
	; @return			Padded input
	;
	S TEXT=$G(TEXT,""),LENGTH=$G(LENGTH,6),PADCHAR=$G(PADCHAR," "),JUSTIFY=$G(JUSTIFY,"L")
	S space=LENGTH-$LENGTH(TEXT)

	IF JUSTIFY="L"  DO
	.S leftPad=""
	.S rightPad=$JUSTIFY("",space)
	ELSE  IF JUSTIFY="R"  DO
	.S leftPad=$JUSTIFY("",space)
	.S rightPad=""
	ELSE  IF JUSTIFY="C"  DO
	.S leftPad=$JUSTIFY("",space\2)
	.S rightPad=$JUSTIFY("",space/2+(space#2))
	QUIT $TR(leftPad_TEXT_rightPad," ",PADCHAR)
