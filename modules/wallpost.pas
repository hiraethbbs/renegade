{$A+,B-,D+,E-,F+,I-,L+,N-,O+,R-,S+,V-}
Unit WallPost;


INTERFACE

Uses
    Dos,
    Common,
    TimeFunc,
    ShortMsg;

Type
    WallRecordType = {$IFDEF WIN32} Packed {$ENDIF} Record
                   UserName  : String[36];
                   AddDate,
                   EditDate  : UnixTime;
                   LineOne,
                   LineTwo     : String[78];
                   UserID    : LongInt;
                   Deleted,
                   Anonymous : Boolean;
    End;

Var
 HeadF,
 DataF : Boolean;

Procedure DoWallPost;

IMPLEMENTATION
Function ToLower( S : String ) : String;
Var
  i : Byte;
Begin
 For i := 1 to Length(S) Do
  Begin
   If S[i] in ['A'..'Z'] Then
   S[i] := Chr(Ord(S[i]) + 32);
  End;
  ToLower := S;
End;

Procedure StrRepeat( C : Char; B : Byte );
 Var R : Byte;
 Begin
  For R := 1 To B Do
   Begin
    Prt(C);
   End;
 End;

Function WallPostDataExist : Boolean;
 Begin
  WallPostDataExist := Exist(General.DataPath+'WALLPOST.DAT');
 End;

Procedure AddWallPost( WallRec : WallRecordType );
Var WallPostFile : File of WallRecordType;
 Begin

  Assign(WallPostFile, General.DataPath+'WALLPOST.DAT');

  IF (WallPostDataExist) THEN
   BEGIN
    {$I-} Reset(WallPostFile); {$I+}
   END
  ELSE
   BEGIN
    {$I-} ReWrite(WallPostFile); {$I+}
   END;
   Seek(WallPostFile, FileSize(WallPostFile));
   Write(WallPostFile, WallRec);
   Close(WallPostFile);
   Exit;
 End;

FUNCTION WallPostMCI(CONST S: ASTR; Data1,Data2: Pointer): STRING;
VAR
  WallPostPtr: ^WallRecordType;
  User: UserRecordType;
  TmpStr : String;
BEGIN
  WallPostPtr := Data1;
  WallPostMCI := S;
  CASE S[1] OF
    'A' : CASE S[2] OF
            'A' : WallPostMCI := AonOff(WallPostPtr^.Anonymous, 'True', 'False');
          END;
    'D' : CASE S[2] OF
            'A' : WallPostMCI := PD2Date(WallPostPtr^.AddDate);
            'E' : WallPostMCI := PD2Date(WallPostPtr^.EditDate);
            'L' : WallPostMCI := AonOff(WallPostPtr^.Deleted, 'Yes', 'No ');
          END;
    'L' : CASE S[2] OF
            '1' : WallPostMCI := WallPostPtr^.LineOne;
            '2' : WallPostMCI := WallPostPtr^.LineTwo;
          END;
    'U' : CASE S[2] OF
            '#' : BEGIN
                   IF (WallPostPtr^.Anonymous) THEN
                    WallPostMCI := '0';
                   IF (WallPostPtr^.Anonymous) AND (SysOp)
                      OR (NOT WallPostPtr^.Anonymous) THEN
                    WallPostMCI := IntToStr(WallPostPtr^.UserID);
                  END;
            'N' : BEGIN
                    LoadURec(User,WallPostPtr^.UserID);
                    IF (WallPostPtr^.Anonymous) THEN
                     WallPostMCI := 'anon';
                    IF (WallPostPtr^.Anonymous) AND (SysOp) THEN
                     WallPostMCI := ToLower(User.Name) + ' ^5(^4a^5)';
                    IF (NOT WallPostPtr^.Anonymous) THEN
                     WallPostMCI := ToLower(User.Name);
                  END;
          END;

  END;
END;

Procedure GetWallPostInput;
Var
   WallRecord : WallRecordType;
   LineOne,
   LineTwo : String[76];
   Changed : Boolean;

 Begin
  LineOne := '';
  LineTwo := '';
  CLS;
  PrintF('WALLH');
  If (NoFile) Then
   Begin
    Prt(' ');
    StrRepeat('Ä', 78);
    Print(Centre('^1... ^0%BN ^1WallPosts ...'));
    Prt(' ');
    StrRepeat('Ä', 78);
    NL;
   End;
 Print(' |03Enter up to two lines below - ');
 InputWN1(' |15: |17|01', LineOne, (SizeOf(WallRecord.LineOne)-1), [InterActiveEdit,ColorsAllowed], Changed);
 InputWN1(' |15: |17|01', LineTwo, (SizeOf(WallRecord.LineTwo)-1), [InterActiveEdit,ColorsAllowed], Changed);
 NL;
 IF (Length(LineOne) <= 0 ) AND (Length(LineTwo) <= 0) THEN
  Begin
  Print(' |04Aborted!');
  PauseScr(False);
  Exit;
  End
 ELSE
  BEGIN
 WallRecord.Anonymous := PYNQ(' |03Post Anonymous? |11', 0, False);
 WallRecord.UserName  := ThisUser.Name;
 WallRecord.LineOne   := LineOne;
 WallRecord.LineTwo   := LineTwo;
 WallRecord.UserID    := UserNum;
 WallRecord.Deleted   := False;
 WallRecord.AddDate   := GetPackDateTime;
 WallRecord.EditDate  := GetPackDateTime;

 IF PYNQ(' Add This Wallpost? ', 0, True) Then
  Begin
   AddWallPost(WallRecord);
  If (UserNum = 2) Then
   Begin
    SendShortMessage(1, '  .oO[ '+ThisUser.CallerID + ' added a new wallpost as guest.');
   End;
  End
 Else
  Begin
   Exit;
  End;

 END;
End; { End GetWallPostInput }

Procedure ShowWallPost;
 Var
  Data2 : Pointer;
  I, Counter : Integer;
  WallRec         : WallRecordType;
  WallPostRecFile : File Of WallRecordType;
 Begin
 CLS;
 PrintF('WALLH');
 If (NoFile) Then
  Begin
   Prt('|08 ');
   StrRepeat('Ä', 78);
   Print(Centre('^1... ^0%BN ^1WallPosts ...'));
   Prt('|08 ');
   StrRepeat('Ä', 78);
   NL;
  End;

 If (NOT WallPostDataExist) Then
  Begin
   Print('  |15No WallPosts Exist!');
   NL;
   Prt('|08 ');
   StrRepeat('Ä', 78);

   If PYNQ(' |03Would you like to add one? |11', 0, True) Then
    GetWallPostInput
   Else
    Exit;

  End
 Else
  Begin { Start Show Wall Posts; }

   Assign(WallPostRecFile, General.DataPath+'WALLPOST.DAT');
   {$I+} Reset(WallPostRecFile); {$I-}
   Counter := 1;
   ReadBuffer('WALLM');
   FOR I := FileSize(WallPostRecFile) DOWNTO 1 DO
    BEGIN
     Seek(WallPostRecFile, (I-1));
     Read(WallPostRecFile, WallRec);
       DisplayBuffer(WallPostMCI,@WallRec,Data2);
       Inc(Counter);
       IF (Counter-1 = 4) THEN
        Break
       ELSE
        Counter := Counter;
    END; { End For }
    If PYNQ(' |03Add a new wallpost? |11', 0, False) Then
     GetWallPostInput
    Else
     Exit;
  End;

 End; { End ShowWallPost }

Procedure DoWallPost;
 Begin
 ShowWallPost;
 End;

End.