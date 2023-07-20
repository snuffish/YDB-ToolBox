%DEBUG; Mumps Debug-interface CLI Tool
	;; This is a Mumps Debug-interface CLI Tool that`s able to use breakpoints (ZBreak, ZSTep) and it`s other features.
	D CLEAR^%GUI w "Welcome to the Mumps Debugger-interface CLI Tool by @Snuffish!",!

	VIEW "NOUNDEF"
	FOR  Q:(%ZR("OPTION")="q")  DO  Q:(%ZR("OPTION")="q")
	.S invokeRoutine=$$PROMPT^%DUTIL
	.D @invokeRoutine
	VIEW "UNDEF"
	Q

START
	READ:($d(%ROUTINE)=0) "Routine to run: ",%ROUTINE
	N (%ROUTINE) K ^%($J)
	S %CMD="LOCATION"

	S $ZSTEP="ZSHOW ""V"":^%DEBUG($J,""VARS"") S %CMD=$$INTERACT^%DEBUG($$FZPOS^%DUTIL($zpos)) ZST:%CMD=""NEXT"" OVER ZST:%CMD=""INTO"" INTO ZST:%CMD=""OUTOF"" OUTOF ZC:%CMD=""CONTINUE"""

	zb ^@%ROUTINE:$ZSTEP
	D ^@%ROUTINE

	Q

SHUTDOWN
	K ^%DEBUG($J)
	ZB -*
	Q

INTERACT(%ZPOS)
	N (%ZPOS)
	d CLEAR^%GUI,LOCATION(%ZPOS),VIEWVARS

	S %GPOS=",20" D POS^%GUI
	W !,"Enter command (n-next/step, v-view vars, l-location, i-step into, o-step outof, b-breakpoints, c-continue, z-ydb shell, q-quit):",!
	READ "> ",CMD#1

	S CMD=$S(CMD="l":"LOCATION",CMD="n":"NEXT",CMD="i":"INTO",CMD="o":"OUTOF",CMD="c":"CONTINUE",1:"")
	Q CMD


VIEWVARS
	N
	S i="" F  S i=$o(^%DEBUG($J,"VARS","V",i)) Q:(i="")  D
	.S value=^%DEBUG($J,"VARS","V",i)
	.Q:(value?1"%".E) ; Dont print vars with %-prefix
	.S ROWS($I(nr))=value

	S %GPOS=90 D FRAME^%GUI("VARS",30,.ROWS)
	Q


LOCATION(%ZPOS)
	N (%ZPOS)
	S ESC=$CHAR(27),RED=ESC_"[31m",RESET=ESC_"[0m",REDBG=$CHAR(27)_"[41;37m",RESETBG=$CHAR(27)_"[0m"
	S RANGE=3

	S *POS=$$DZPOS^%DUTIL(%ZPOS)
	S FROMLINE=POS("OFFSET")-RANGE
	S TOLINE=POS("OFFSET")+RANGE

	FOR i=FROMLINE:1:TOLINE  DO
	.S LINEPOS=POS("LABEL")_"+"_i_"^"_POS("ROUTINE")
	.S ROW="["_LINEPOS_"]"
	.S:(%ZPOS=LINEPOS) ROW=ROW_REDBG
	.S ROW=ROW_$T(@LINEPOS)
	.S:(%ZPOS=LINEPOS) ROW=ROW_RESETBG
	.S ROWS(i)=ROW

	DO FRAME^%GUI("LOCATION",80,.ROWS)

	Q
