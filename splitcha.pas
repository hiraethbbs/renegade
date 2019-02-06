{$A+,B-,D-,E-,F+,I-,L-,N-,O+,R-,S+,V-}

UNIT SplitCha;

INTERFACE

Uses
  Common,
  MyIO;


PROCEDURE RequestSysOpChat(CONST MenuOption: Str50);
PROCEDURE ChatFileLog(b: Boolean);
PROCEDURE SysOpSplitChat;
{PROCEDURE GetChatPositions;}

IMPLEMENTATION

USES
  Crt,
  Dos,
  Email,
  Events,
  TimeFunc;

TYPE
  ChatStrArray = ARRAY [1..10] OF AStr;

VAR
  UserChat: ChatStrArray;
  SysOpChat: ChatStrArray;
  UserXPos,
  UserYPos,
  SysOpXPos,
  SysOpYPos: Byte;
  Cmd	: Char;
  ChatHelp : Boolean;
  ClrHlp:Shortint;
  ChatPositions : Array [1..8] of Byte;
  LastLine : AStr;

(*PROCEDURE GetChatPositions;
Var
 Junk,
 ChatFile : Astr;
 F        : Text;
 Counter  : Byte;


Begin
 Counter := 1;
 If(Exist(General.MiscPath+'SPLTCHAT.ANS')) OR (Exist(General.MiscPath+'SPLTCHAT.ASC')) Then
  Begin

   If ( Exist( General.MiscPath+'SPLTCHAT.ANS' ) )  Then
    Begin
     ChatFile := General.MiscPath+'SPLTCHAT.ANS';
    End
   Else
    Begin
     ChatFile := General.MiscPath+'SPLTCHAT.ASC';
    End;

  Assign(F, General.MiscPath+'SPLTCHAT.ANS');
  {$I+} Reset(F); {$I-}
  While Not (EOF(F)) Do
   Begin
    Read(F,Junk);

    If (Pos('|SS',Junk) > 0) Then { Start SysOp }
     Begin
      ChatPositions[1] := Pos('|SS', Junk); { Xpos }
      If (ChatPositions[1] > 80) Then Begin ChatPositions[1] := ChatPositions[1] - 80; End;
      ChatPositions[2] := Counter; { YPos Start }
     End { /|SS }
    Else if (Pos('|SE', Junk) > 0) Then
     Begin
      ChatPositions[3] := Counter; { YPos End }
     End { /|SE }
    Else If (Pos('|SL', Junk) > 0) Then
     Begin
      ChatPositions[7] := Pos('|SL', Junk);
     End { /|SL } { End SysOp }

    Else If (Pos('|US', Junk) > 0) Then { Start User }
     Begin
      ChatPositions[4] := Pos('|US', Junk);
      ChatPositions[5] := Counter;
     End { /|US }
    Else If (Pos('|UE', Junk) > 0) Then
     Begin
      ChatPositions[6] := Counter;
     End { /|UE }
    Else If (Pos('|UL', Junk) > 0) Then
     Begin
      ChatPositions[8] := Pos('|UL', Junk);
     End; { /|UL } { End User }
   Inc(Counter);
   End; { /While }
  End
 Else

  Begin

   ChatPositions[1] := 2;  { SysOp Start XPos                 }
   ChatPositions[2] := 2;  { SysOp Start YPos                 }
   ChatPositions[3] := 11; { SysOp End YPos                   }

   ChatPositions[4] := 2;  { User Start XPos                  }
   ChatPositions[5] := 13; { User Start YPos                  }
   ChatPositions[6] := 23; { User End YPos                    }

   ChatPositions[7] := 78; { SysOp XPos Line End Before Crlf; }
   ChatPositions[8] := 78; { User XPos Line End Before Crlf;  }
  End;
End; *)

PROCEDURE RequestSysOpChat(CONST MenuOption: Str50);
VAR
  User: UserRecordType;
  MHeader: MHeaderRec;
  Reason: AStr;
  Cmd: Char;
  Counter: Byte;
  UNum,
  Counter1: Integer;
  Chatted: Boolean;
BEGIN
  IF (ChatAttempts < General.MaxChat) OR (CoSysOp) THEN
  BEGIN
    NL;
    IF (Pos(';',MenuOption) <> 0) THEN
      Print(Copy(MenuOption,(Pos(';',MenuOption) + 1),Length(MenuOption)))
    ELSE
      lRGLngStr(37,FALSE); { FString.ChatReason; }
    Chatted := FALSE;
    Prt(': ');
    MPL(60);
    InputL(Reason,60);
    IF (Reason <> '') THEN
    BEGIN
      Inc(ChatAttempts);
      SysOpLog('^4Chat attempt:');
      SL1(Reason);
      IF (NOT SysOpAvailable) AND AACS(General.OverRideChat) THEN
        PrintF('CHATOVR');
      IF (SysOpAvailable) OR (AACS(General.OverRideChat) AND PYNQ(^M^J'SysOp is not available. Override? ',0,FALSE)) THEN
      BEGIN
        lStatus_Screen(100,'Press [SPACE] to chat or [ENTER] for silence.',FALSE,Reason);
        { Print(FString.ChatCall1); }
        lRGLngStr(14,FALSE);
        Counter := 0;
        Abort := FALSE;
        NL;
        REPEAT
          Inc(Counter);
          WKey;
          IF (OutCom) THEN
            Com_Send(^G);
          { Prompt(FString.ChatCall2); }
          lRGLngStr(15,FALSE);
          IF (OutCom) THEN
            Com_Send(^G);
          IF (ShutUpChatCall) THEN
            Delay(600)
          ELSE
          BEGIN
            FOR Counter1 := 300 DOWNTO 2 DO
            BEGIN
              Delay(1);
              Sound(Counter1 * 10);
            END;
            FOR Counter1 := 2 TO 300 DO
            BEGIN
              Delay(1);
              Sound(Counter1 * 10);
            END;
          END;
          NoSound;
          IF (KeyPressed) THEN
          BEGIN
            Cmd := ReadKey;
            CASE Cmd OF
               #0 : BEGIN
                      Cmd := ReadKey;
                      SKey1(Cmd);
                    END;
              #32 : BEGIN
                      Chatted := TRUE;
                      ChatAttempts := 0;
                      SysOpSplitChat;
                    END;
               ^M : ShutUpChatCall := TRUE;
            END;
          END;
        UNTIL (Counter = 9) OR (Chatted) OR (Abort) OR (HangUp);
        NL;
      END;
      lStatus_Screen(100,'Chat Request: '+Reason,FALSE,Reason);
      IF (Chatted) THEN
        ChatReason := ''
      ELSE
      BEGIN
        ChatReason := Reason;
        PrintF('NOSYSOP');
        UNum := StrToInt(MenuOption);
        IF (UNum > 0) THEN
        BEGIN
          InResponseTo := #1'Tried chatting';
          LoadURec(User,UNum);

          NL;

          Print('|03You can always send email to '+General.SysopName+'@'+LineR.NodeTelnetUrl+'.'+#13#10);
          IF PYNQ('  |03send mail to |11'+User.Name+'|03? |15',0,FALSE) THEN
          BEGIN
            MHeader.Status := [];
            SEmail(UNum,MHeader);
          END;
        END;
      END;
      TLeft;
    END;
  END
  ELSE
  BEGIN
    PrintF('GOAWAY');
    UNum := StrToInt(MenuOption);
    IF (UNum > 0) THEN
    BEGIN
      InResponseTo := 'Tried chatting (more than '+IntToStr(General.MaxChat)+' times!)';
      SysOpLog(InResponseTo);
      MHeader.Status := [];
      SEmail(UNum,MHeader);
    END;
  END;
END;

PROCEDURE ChatFileLog(b: Boolean);
VAR
  s: AStr;
BEGIN
  s := 'Chat';
  IF (ChatSeparate IN ThisUser.SFlags) THEN
    s := s + IntToStr(UserNum);
  s := General.LogsPath+s+'.LOG';
  IF (NOT b) THEN
  BEGIN
    IF (CFO) THEN
    BEGIN
      lStatus_Screen(100,'Chat recorded to '+s,FALSE,s);
      CFO := FALSE;
      IF (TextRec(ChatFile).Mode <> FMClosed) THEN
        Close(ChatFile);
    END;
  END
  ELSE
  BEGIN
    CFO := TRUE;
    IF (TextRec(ChatFile).Mode = FMOutPut) THEN
      Close(ChatFile);
    Assign(ChatFile,s);
    Append(ChatFile);
    IF (IOResult = 2) THEN
      ReWrite(ChatFile);
    IF (IOResult <> 0) THEN
      SysOpLog('Cannot open chat log file: '+s);
    lStatus_Screen(100,'Recording chat to '+s,FALSE,s);
    WriteLn(ChatFile);
    WriteLn(ChatFile);
    WriteLn(ChatFile,Dat);
    WriteLn(ChatFile);
    Writeln(ChatFile,'Recorded with user: '+Caps(ThisUser.Name));
    WriteLn(ChatFile);
    WriteLn(ChatFile,'Chat reason: '+AOnOff(ChatReason = '','None',ChatReason));
    WriteLn(ChatFile);
    WriteLn(ChatFile);
    WriteLn(ChatFile,'------------------------------------');
    WriteLn(ChatFile);
  END;
END;

PROCEDURE ANSIG(X,Y: Byte);
BEGIN
  IF (ComPortSpeed > 0) THEN
    IF (OkAvatar) THEN
      SerialOut(^V^H+Chr(Y)+Chr(X))
    ELSE
      SerialOut(#27+'['+IntToStr(Y)+';'+IntToStr(X)+'H');
  IF (WantOut) THEN
    GoToXY(X,Y);
END;

PROCEDURE Clear_Eol;
BEGIN
  IF (NOT OkAvatar) THEN
    SerialOut(#27'[K')
  ELSE
    SerialOut(^V^G);
  IF (WantOut) THEN
    ClrEOL;
END;

PROCEDURE SysOpChatWindow;

BEGIN
  CLS;
  Printf('SPLTCHAT');
  If not nofile then exit;

  ANSIG(1,1);
  Prompt('|03컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');

  ANSIG(( 80 - ( Length(General.SysopName)+6 ) ),1);
  Prompt('|03[ |15'+General.SysopName+' |03]');

  ANSIG(1,12);
  Prompt('|03컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴[ |11Ctrl+Z |03: |15Help |03]컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');

  ANSIG(1,23);
  Prompt('|03컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');

  ANSIG(4,23);
  Prompt('|03[ |15'+ThisUser.Name+' |03]');

END;

PROCEDURE SysOpSplitChat;
VAR
  S,
  SysOpStr,
  UserStr,
  SysOpLastLineStr,
  UserLastLineStr: AStr;

  SysOpLine,
  UserLine,
  SaveWhereX,
  SaveWhereY,
  SaveTextAttr : Byte;

  C: Char;
  SysOpCPos,
  UserCPos: Byte;

  ChatTime: LongInt;
  SaveEcho,
  SavePrintingFile,
  SaveMCIAllowed: Boolean;
  i             : Integer;

  PROCEDURE DoChar(C: Char; VAR CPos,XPos,YPos,Line: Byte; VAR ChatArray: ChatStrArray; VAR WrapLine: AStr);
  VAR
    i,
    Counter,
    Counter1: Byte;
  BEGIN

       if C = #27 then
       Begin
        InChat := False;
       End;
       if C = #63 then
       Begin
        InChat := False;
        Update_Screen;
       End;
    IF (CPos < 79) THEN
    BEGIN
      ANSIG(XPos,YPos);
      ChatArray[Line][CPos] := C;
      OutKey(C);
      Inc(CPos);
      Inc(XPos);

      ChatArray[Line][0] := Chr(CPos - 1);

      IF (Trapping) THEN
        Write(TrapFile,C);

    END
    ELSE
    BEGIN
      ChatArray[Line][CPos] := C;
      Inc(CPos);

      ChatArray[Line][0] := Chr(CPos - 1);
      Counter := (CPos - 1);
      WHILE (Counter > 0) AND (ChatArray[Line][Counter] <> ' ') AND (ChatArray[Line][Counter] <> ^H) DO
        Dec(Counter);
      IF (Counter > (CPos DIV 2)) AND (Counter <> (CPos - 1)) THEN
      BEGIN
        WrapLine := Copy(ChatArray[Line],(Counter + 1),(CPos - Counter));

        FOR Counter1 := (CPos - 2) DOWNTO Counter DO
        BEGIN
          ANSIG(XPos,YPos);
          Prompt(^H);
          Dec(XPos);
        END;
        FOR Counter1 := (CPos - 2) DOWNTO Counter DO
        BEGIN
          ANSIG(XPos,YPos);

          Prompt(' ');
          Inc(XPos);
        END;
        ChatArray[Line][0] := Chr(Counter - 1);
      END;

      NL;

      XPos := 2;

      IF (YPos > 2) AND (YPos < 12) OR (YPos > 13) AND (YPos < 23) THEN
      BEGIN

        Inc(YPos);
        Inc(Line);

      END

      ELSE
      BEGIN

        FOR Counter := 1 TO 9 DO
          ChatArray[Counter] := ChatArray[Counter + 1];
          LastLine := ChatArray[Counter];
          {ChatArray[10] := '';}


        FOR Counter := 10 DOWNTO 1 DO
        BEGIN
          ANSIG(2,Counter + 1);
          PrintMain(ChatArray[Counter]);
          LastLine := ChatArray[Counter];
          Clear_EOL;

        END;

      END;

      ANSIG(XPos,YPos);

      CPos := 1;

      ChatArray[Line] := '';

      IF (WrapLine <> '') THEN
      BEGIN
        Prompt(WrapLine);
        ChatArray[Line] := WrapLine;
        WrapLine := '';
        CPos := (Length(ChatArray[Line]) + 1);
        XPos := Length(ChatArray[Line]) + 2;
      END;

    END;

  END;

  PROCEDURE DOBackSpace(VAR Cpos,XPos: Byte; YPos: Byte; VAR S: AStr);
  BEGIN
    IF (CPos > 1) THEN
    BEGIN
      ANSIG(XPos,YPos);
      BackSpace;
      Dec(CPos);
      Dec(XPos);
      S[0] := Chr(CPos - 1);
    END;
  END;

  PROCEDURE DoTab(VAR CPos,XPos: Byte; YPos: Byte; VAR S: AStr);
  VAR
    Counter,
    Counter1: Byte;
  BEGIN
    Counter := (5 - (CPos MOD 5));
    IF ((CPos + Counter) < 79) THEN
    BEGIN
      FOR Counter1 := 1 TO Counter DO
      BEGIN
        ANSIG(XPos,YPos);
        Prompt(' ');
        S[CPos] := ' ';
        Inc(CPos);
        Inc(XPos);
      END;
      S[0] := Chr(CPos - 1);
    END;
  END;

  PROCEDURE DOCarriageReturn(VAR CPos,XPos,YPos: Byte; VAR S:AStr; LastStr : String);
  Var i : Shortint;


  BEGIN

    S[0] := Chr(CPos - 1);

    Inc(YPos);

        If (YPos = 6) Then
         Begin
          ANSIG(1,6);
          Clear_EOL;
         End;
        If (YPos = 22) Then
         Begin
          ANSIG(1,22);
          Clear_EOL;
         End;

        If (YPos = 7) Then
           Begin

            For i := 2 To 5 Do
             Begin
              ANSIG(1,i);
              Clear_EOL;
             End;

            YPos := 2;
           End

          Else If (YPos = 23) Then
           Begin

            For i := 18 To 21 Do
             Begin
              ANSIG(1,i);
              Clear_EOL;
             End;


            YPos := 18;
           End;


    XPos := 2;

    ANSIG(XPos,YPos);

    (* Do Cmds Here or add as Ctrl *)

    CPos := 1;
    S := '';
  END;

  PROCEDURE DOBackSpaceWord(VAR CPos,XPos: Byte; YPos: Byte; VAR S: AStr);
  BEGIN
    IF (CPos > 1) THEN
    BEGIN
      REPEAT
        ANSIG(XPos,YPos);
        BackSpace;
        Dec(CPos);
        Dec(XPos);
      UNTIL (CPos = 1) OR (S[CPos] = ' ');
      S[0] := Chr(CPos - 1);
    END;
  END;

  PROCEDURE DOBackSpaceLine(VAR CPos,Xpos: Byte; YPos: Byte; VAR S: AStr);
  VAR
    Counter: Byte;
  BEGIN
    IF (CPos > 1) THEN
    BEGIN
      FOR Counter := 1 TO (CPos - 1) DO
      BEGIN
        ANSIG(XPos,YPos);
        BackSpace;
        Dec(CPos);
        Dec(XPos);
      END;
      S[0] := Chr(CPos - 1);
    END;
  END;

BEGIN
  SaveWhereX := WhereX;
  SaveWhereY := WhereY;
  SaveTextAttr := TextAttr;
  SaveScreen(Wind);

  UserColor(1);
  SaveMCIAllowed := MCIAllowed;
  MCIAllowed := TRUE;
  ChatTime := GetPackDateTime;
  DOSANSIOn := FALSE;
  IF (General.MultiNode) THEN
  BEGIN
    LoadNode(ThisNode);
    SaveNAvail := (NAvail IN Noder.Status);
    Exclude(Noder.Status,NAvail);
    SaveNode(ThisNode);
  END;
  SavePrintingFile := PrintingFile;
  InChat := TRUE;
  ChatCall := FALSE;
  SaveEcho := Echo;
  Echo := TRUE;
  IF (General.AutoChatOpen) THEN
    ChatFileLog(TRUE)
  ELSE IF (ChatAuto IN ThisUser.SFlags) THEN
    ChatFileLog(TRUE);
  NL;
  Exclude(ThisUser.Flags,Alert);
  {
  PrintF('CHATINIT');
  IF (NoFile) THEN
    (*
    Prompt('^5'+FString.EnGage);
    *)
    lRGLNGStr(2,FALSE);
  }


  IF (ChatReason <> '') THEN
  BEGIN
    lStatus_Screen(100,ChatReason,FALSE,S);
    ChatReason := '';
  END;

  SysOpLastLineStr := '';
  UserLastLineStr := '';
  SysOpXPos := 2;
  SysOpYPos := 2;
  UserXPos := 2;
  UserYPos := 18;

  SysOpStr := '';
  UserStr := '';
  SysOpCPos := 1;
  UserCPos := 1;
  SysOpLine := 1;
  UserLine := 1;

  SysOpChatWindow;

  ANSIG(SysOpXPos,SysOpYPos);

  UserColor(General.SysOpColor);
  WColor := TRUE;

  REPEAT

    C := Char(GetKey);

    CheckHangUp;

    CASE Ord(C) OF
      32..255 :
          IF (WColor) THEN
            DoChar(C,SysOpCPos,SysOpXPos,SysOpYPos,SysOpLine,SysOpChat,SysOpLastLineStr)
          ELSE
            DoChar(C,UserCPos,UserXPos,UserYPos,UserLine,UserChat,UserLastLineStr);
      3 : Begin
           For ClrHlp:=18 To 21 Do
            Begin
             ANSIG(38,ClrHlp);
             Clear_EOL;
            End;
           ANSIG(SaveWhereX,SaveWhereY);
          End;

      7 : IF (OutCom) THEN { Ctrl+G }
            Com_Send(^G);
      8 : IF (WColor) THEN { Ctrl+H }
            DOBackSpace(SysOpCpos,SysOpXPos,SysOpYPos,SysOpStr)
          ELSE
            DOBackSpace(UserCpos,UserXPos,UserYPos,UserStr);
      9 : IF (WColor) THEN { Ctrl+I }
            DoTab(SysOpCPos,SysOpXPos,SysOpYPos,SysOpStr)
          ELSE
            DoTab(UserCPos,UserXPos,UserYPos,UserStr);
     13 : IF (WColor) THEN { Enter }
            DOCarriageReturn(SysOpCPos,SysOpXPos,SysOpYPos,SysOpStr,SysOpStr)
          ELSE
            DOCarriageReturn(UserCPos,UserXPos,UserYPos,UserStr,UserStr);

     17 : InChat := FALSE; { Ctrl+Q }
     27 : InChat := FALSE; { Escape }
     63 : InChat := FALSE; { F5 }

     23 : IF (WColor) THEN { Ctrl+W }
            DOBackSpaceWord(SysOpCPos,SysOpXPos,SysOpYPos,SysOpStr)
          ELSE
            DOBackSpaceWord(UserCPos,UserXPos,UserYPos,UserStr);
     24 : IF (WColor) THEN { Ctrl+X }
            DOBackSpaceLine(SysOpCPos,SysOpXpos,SysOpYPos,SysOpStr)
          ELSE
            DOBackSpaceLine(UserCPos,UserXpos,UserYPos,UserStr);

     26 : Begin { Ctrl+Z }

	   PrintF('CHATHELP');
            If Not nofile Then
             Begin
              OneK(Cmd,#27#26,FALSE,FALSE);
              Case Ord(Cmd) Of
	       26,27 : SysOpChatWindow; { Escape }
	      End; { /case }
             End { /If Not }
             Else
              Begin
                ChatHelp := TRUE;
                ANSIG(38,18);
                Print('^5Chat Help |15: ^4(^5Ctrl+C ^5:: ^4Clear Help^5)');
                ANSIG(38,19);
                Print('^5Ctrl+G |15: ^4Hangup     ^5Ctrl+W |15: ^4Delete Word');
                ANSIG(38,20);
                Print('^5Ctrl+H |15: ^4Backspace  ^5Ctrl+X |15: ^4Delete Line');
                ANSIG(38,21);
                Print('^5Ctrl+H |15: ^4Tab        ^5Ctrl+Q |15: ^4Quit|07');

                ANSIG(SaveWhereX,SaveWhereY);
              End; { /If Not else case }
          End; { /26 }
    END;

    (*

    IF (S[1] = '/') THEN
      S := AllCaps(S);

    IF (Copy(S,1,6) = '/TYPE ') AND (SysOp) THEN
    BEGIN
      S := Copy(S,7,(Length(S) - 6));
      IF (S <> '') THEN
      BEGIN
        PrintFile(S);
        IF (NoFile) THEN
          Print('*File not found*');
      END;
    END
    ELSE IF ((S = '/HELP') OR (S = '/?')) THEN
    BEGIN
      IF (SysOp) THEN
        Print('^5/TYPE d:\path\filename.ext^3: Type a file');
      {
      Print('^5/BYE^3:   Hang up');
      Print('^5/CLS^3:   Clear the screen');
      Print('^5/PAGE^3:  Page the SysOp and User');
      Print('^5/Q^3:     Exit chat mode'^M^J);
      }
      lRGLngStr(65,FALSE);
    END
    ELSE IF (S = '/CLS') THEN
      CLS
    ELSE IF (S = '/PAGE') THEN
    BEGIN
      FOR Counter := 650 TO 700 DO
      BEGIN
        Sound(Counter);
        Delay(4);
        NoSound;
      END;
      REPEAT
        Dec(Counter);
        Sound(Counter);
        Delay(2);
        NoSound;
      UNTIL (Counter = 200);
      Prompt(^G^G);
    END
    ELSE IF (S = '/BYE') THEN
    BEGIN
      Print('Hanging up ...');
      HangUp := TRUE;
    END
    ELSE IF (S = '/Q') THEN
    BEGIN
      InChat := FALSE;
      Print('Chat Aborted ...');
    END;
    IF (CFO) THEN
      WriteLn(ChatFile,S);
    *)
  UNTIL ((NOT InChat) OR (HangUp));

  RemoveWindow(Wind);
  ANSIG(SaveWhereX,SaveWhereY);
  TextAttr := SaveTextAttr;

  {
  PrintF('CHATEND');
  IF (NoFile) THEN
    (*
    Print('^5'+FString.lEndChat);
    *)
    lRGLngStr(3,FALSE);
  }
  IF (General.MultiNode) THEN
  BEGIN
    LoadNode(ThisNode);
    IF (SaveNAvail) THEN
      Include(Noder.Status,NAvail);
    SaveNode(ThisNode);
  END;
  ChatTime := (GetPackDateTime - ChatTime);
  IF (ChopTime = 0) THEN
    Inc(FreeTime,ChatTime);
  TLeft;
  S := 'Chatted for '+FormattedTime(ChatTime);
  IF (CFO) THEN
  BEGIN
    S := S+'  -{ Recorded in Chat';
    IF (ChatSeparate IN ThisUser.SFlags) THEN
      S := S + IntToStr(UserNum);
    S := S+'.LOG }-';
  END;
  SysOpLog(S);
  InChat := FALSE;
  Echo := SaveEcho;
  IF ((HangUp) AND (CFO)) THEN
  BEGIN
    WriteLn(ChatFile);
    WriteLn(ChatFile,'=> User disconnected');
    WriteLn(ChatFile);
  END;
  PrintingFile := SavePrintingFile;
  IF (CFO) THEN
    ChatFileLog(FALSE);
  IF (InVisEdit) THEN
    Buf := ^L;
  MCIAllowed := SaveMCIAllowed;
END;

END.
