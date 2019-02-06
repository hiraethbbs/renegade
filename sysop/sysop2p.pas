{$A+,B-,D-,E-,F+,I-,L-,N-,O+,R-,S+,V-}

UNIT SysOp2P;

INTERFACE

USES
  Common,
  Crt,
  TimeFunc;

Procedure LastCallerEditor;

IMPLEMENTATION

Procedure LastCallerEditor;
Var
 LastCallerSize, B : Byte;
 W : Word;
 TempStr, N : String;
 Cmd : Char;
 Changed : Boolean;
 Last : ^LastCallerRec;

Procedure DeleteLastCallerRecord( W : Word );
Var
 LastCaller        : LastCallerRec;
 LastCallerFile    : File of LastCallerRec;
 LastCallerNew     : LastCallerRec;
 LastCallerNewFile : File of LastCallerRec;
 Counter           : Word;
Begin
Assign(LastCallerFile, General.DataPath+'LASTON.DAT');
Assign(LastCallerNewFile, General.DataPath+'LASTNEW.DAT');
{$I+} ReSet(LastCallerFile); {$I-}
{$I+} ReWrite(LastCallerNewFile); {$I-}
IF (IOResult <> 0) THEN
 BEGIN
  Print(' |04There was an error deleting record |12'+IntToStr(W)+'|04.');
  PauseScr(False);
  Exit;
 END;
NL;
Print(' |03Not implemented yet.');
NL;
PauseScr(False);
Close(LastCallerFile);
Close(LastCallerNewFile);
Exit;
End;

Procedure ChangeRecord(N : LongInt);
Var C : Char;
    TmpStr : String;
    TmpWord : Word;
    LastCallerFile : File of LastCallerRec;
    LastCallers    : LastCallerRec;


Begin
Assign(LastCallerFile, General.DataPath+'LASTON.DAT');
 {$I+} ReSet(LastCallerFile); {$I-}
Seek(LastCallerFile, N-1);
Read(LastCallerFile, LastCallers);

REPEAT
CLS;
NL;
 Print(' |08컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
    With LastCallers Do
     Begin
      Print(' |08(|07A|08) |03Node            |15: |11' + IntToStr(Node));
      Print(' |08(|07B|08) |03User            |15: |11' + UserName);
      Print(' |08(|07C|08) |03Location        |15: |11' + Location);
      Print(' |08(|07D|08) |03Caller #        |15: |11' + IntToStr(Caller));
      Print(' |08(|07E|08) |03User ID         |15: |11' + IntToStr(UserID));
      Print(' |08(|07F|08) |03Speed           |15: |11' + IntToStr(Speed));
      Print(' |08(|07G|08) |03Logon           |15: |11' + PD2Time12(LogonTime));
      Print(' |08(|07H|08) |03Logoff          |15: |11' + AOnOff( LogoffTime = 0, 'Online', PD2Time12(LogoffTime) ) );
      Print(' |08(|07I|08) |03New             |15: |11' + ShowYesNo(NewUser));
      Print(' |08(|07J|08) |03Invisible       |15: |11' + ShowYesNo(Invisible));
      Print(' |08(|07K|08) |03Uploads         |15: |11' + IntToStr(Uploads));
      Print(' |08(|07L|08) |03UK              |15: |11' + IntToStr(UK));
      Print(' |08(|07M|08) |03Downloads       |15: |11' + IntToStr(Downloads));
      Print(' |08(|07N|08) |03DK              |15: |11' + IntToStr(DK));
      Print(' |08(|07O|08) |03Messages Read   |15: |11' + IntToStr(MsgRead));
      Print(' |08(|07P|08) |03Messages Posted |15: |11' + IntToStr(MsgPost));
      Print(' |08(|07R|08) |03Email Sent      |15: |11' + IntToStr(EmailSent));
      Print(' |08(|07S|08) |03Feedback Sent   |15: |11' + IntToStr(FeedbackSent));
      {Reserved: ARRAY [1..17] OF Byte; }
      Print(' |08컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
      Prt(' |03Choose Option |08[|07A|08-|07S|08,|07Q|08] |15: |11');
      OneK(C, 'ABCDEFGHIJKLMNOPQRS'^M, True, False);
      END;


      Case Upcase(C) OF

       'A' : BEGIN
              NL;
              InputByteWOC(' |03Enter New Node |15:|08', LastCallers.Node, [NumbersOnly,DisplayValue], 1, MaxNodes);
             END;
       'B','C' : BEGIN
        NL;
                  CASE Upcase(C) OF
                  'B' : BEGIN
                         MPL(36);
                         Prt(' |03Enter New User Name |15: |11');
                         InputMain(LastCallers.UserName, 36,[InterActiveEdit,DisplayValue,ReDisplay,CapWords]);
                        END;
                  'C' : BEGIN
                         MPL(30);
                         Prt(' |03Enter New Location |15: |11');
                         InputMain(LastCallers.Location, 30,[InterActiveEdit,DisplayValue,ReDisplay]);
                        END;
                  END;
                 END;
       'D'..'F','L','N' : BEGIN
        NL;
        CASE Upcase(C) OF
         'D' : BEGIN
                InputLongIntWOC(' |03Enter New Value |15:|08',LastCallers.Caller, [DisplayValue,NumbersOnly],
                General.CallerNum-10, 2147483647);
                IF (LastCallers.Caller > General.CallerNum) THEN
                 BEGIN
                  General.CallerNum := LastCallers.Caller;
                  General.TotalCalls := (General.TotalCalls + (LastCallers.Caller - General.CallerNum) );
                  SaveGeneral(False);
                 END;
               END;
         'E' : InputLongIntWOC(' |03Enter New Value |15:|08',LastCallers.UserID, [DisplayValue,NumbersOnly], 1,
         General.NumUsers);
         'F' : InputLongIntWOC(' |03Enter New Value |15:|08',LastCallers.Speed, [DisplayValue,NumbersOnly], 0, 115200);
         'L' : InputLongIntWOC(' |03Enter New Value |15:|08',LastCallers.UK, [DisplayValue,NumbersOnly], 0, 2147483647);
         'N' : InputLongIntWOC(' |03Enter New Value |15:|08',LastCallers.DK, [DisplayValue,NumbersOnly], 0, 2147483647);
        END;
       END;
       'G','H' : BEGIN
                  CASE Upcase(C) OF
                   'G' : BEGIN
                          NL;

                          MPL(5);
                          InputFormatted(' |03Enter New Logon Time |08[|0724 Hour|08] |15: |11', TempStr, '##:##', True);
                          If (TempStr <> '') AND ( StrToInt(Copy(TempStr,1,2)) <= 23 )
                          AND ( StrToInt(Copy(TempStr,4,2)) <= 59 ) AND (Length(TempStr) = 5) Then
                           Begin
                            LastCallers.LogonTime := Norm2Unix(
                            StrToInt(Copy(DateStr,7,4)),
                            StrToInt(Copy(DateStr,1,2)),
                            StrToInt(Copy(DateStr,4,2)),
                            StrToInt(Copy(TempStr,1,2)),
                            StrToInt(Copy(TempStr,4,2)),0);
                           End
                          Else
                           Begin
                            If (Length(TempStr) < 1) Then
                             Begin
                              LastCallers.LogoffTime := LastCallers.LogoffTime;
                             End
                            Else
                             Begin
                              NL;
                              Print(' |03Time must be in 24 hour format.');
                              PauseScr(False);
                              LastCallers.LogonTime := LastCallers.LogonTime;
                             End;
                           End;
                         END;
                   'H' : BEGIN
                          NL;
                          MPL(5);
                          InputFormatted(' |03Enter New Logoff Time |08[|0724 Hour|08] |15: |11', TempStr, '##:##', True);
                          If (TempStr <> '') AND ( StrToInt(Copy(TempStr,1,2)) <= 23 )
                          AND ( StrToInt(Copy(TempStr,4,2)) <= 59 ) AND (Length(TempStr) = 5) Then
                           Begin
                            LastCallers.LogoffTime := Norm2Unix(
                            StrToInt(Copy(DateStr,7,4)),
                            StrToInt(Copy(DateStr,1,2)),
                            StrToInt(Copy(DateStr,4,2)),
                            StrToInt(Copy(TempStr,1,2)),
                            StrToInt(Copy(TempStr,4,2)),0);
                           End
                          Else
                           Begin
                            If (Length(TempStr) < 1) Then
                             Begin
                              LastCallers.LogoffTime := LastCallers.LogoffTime;
                             End
                            Else
                             Begin
                              NL;
                              Print(' |03Time must be in 24 hour format.');
                              PauseScr(False);
                              LastCallers.LogoffTime := LastCallers.LogoffTime;
                             End;
                           End;

                         END;
                   END;
                 END;
       'I','J' : BEGIN
                  CASE Upcase(C) Of
                  'I' :  BEGIN
                          IF (LastCallers.NewUser) THEN
                           LastCallers.NewUser := False
                          ELSE
                           LastCallers.NewUser := True;
                         END;
                  'J' : BEGIN
                         IF (LastCallers.Invisible) THEN
                          LastCallers.Invisible := False
                         ELSE
                          LastCallers.Invisible := True;
                        END;
                 END;
                END;
       'K','M','O','P','R','S' : BEGIN
                           NL;
                           TmpWord := 0;
                           InputWordWOC(' |03Enter New Value |15:|08',TmpWord, [NumbersOnly], 0, 65535);
                           CASE Upcase(C) Of
                            'K' : LastCallers.Uploads := TmpWord;
                            'M' : LastCallers.Downloads := TmpWord;
                            'O' : LastCallers.MsgRead := TmpWord;
                            'P' : LastCallers.MsgPost := TmpWord;
                            'R' : LastCallers.EmailSent := TmpWord;
                            'S' : LastCallers.FeedbackSent := TmpWord;
                          END;
                         END;

      END;
UNTIL Upcase(C) IN ['Q',^M];

Seek(LastCallerFile, (N-1));
Write(LastCallerFile, LastCallers);
Close(LastCallerFile);
Exit;

End; { END ChangeRecord }

Begin
If (NOT Exist(General.DataPath+'LASTON.DAT') ) Then
 Begin
  Print('%LF '+General.DataPath+'|03LASTON.DAT Is Missing.');
  Exit;
 End;
REPEAT
 Assign(LastCallerFile, General.DataPath+'LASTON.DAT');
 {$I+} ReSet(LastCallerFile); {$I-}

 Seek(LastCallerFile, 0);
 CLS;
 NL;
 Print('  |03# |11:|08: |03Node |11:|08: |03UserName                           |11:|08: |03Logon      |11:|08: |03Logoff');
 Print(' |08컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
 IF ( FileSize(LastCallerFile) > 0) Then
  BEGIN
 For B := 1 To FileSize(LastCallerFile) Do
  Begin
   Read(LastCallerFile, Last^);

   Print('  |07' +
   PadLeftInt(B,3) +
   '  |03'+ PadLeftInt(Last^.Node, 6) +
   '  |11'+ PadLeftStr(Last^.UserName, 36) +
   '  |03'+ PadLeftStr(PD2Time12(Last^.LogonTime),12) +
   '  |07'+ PadLeftStr(AOnOff(Last^.LogoffTime=0, '|15Online',PD2Time12(Last^.LogoffTime)),12));
   Seek(LastCallerFile, B);
  End;
END
ELSE
BEGIN
Print('  |03There have been no callers today.');
 END;

  Print(' |08컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
  Prt(' |03Choose Option |08[|07D|08,|07M|08,|07Q|08] |15: |11');
  OneK(Cmd, 'DMQ'^M, True, False);
  LastCallerSize := FileSize(LastCallerFile);
  Close(LastCallerFile);
  Case Upcase(Cmd) Of
   'D' : Begin
         NL;
         MPL( LastCallerSize );
         InputWordWOC(' |03Delete which record?|08', W, [NumbersOnly], 1, LastCallerSize );
          If (W > 0) AND (W <= LastCallerSize ) Then
           Begin
            DeleteLastCallerRecord(W);
           End;
         End;
   'M' : Begin
          NL;
          TextAttr := $1F;
          MPL( LastCallerSize );

          InputWordWOC(' |03Modify which record?|08', W, [NumbersOnly], 1, LastCallerSize );
          If (W > 0) AND (W <= LastCallerSize ) Then
           Begin
            {Seek(LastCallerFile, (W-1));
            Read(LastCallerFile, Last^);}
            ChangeRecord(W);

           End;
          End;
   'Q',#13 : Exit;
  END;

 UNTIL Upcase(Cmd) IN ['Q',#13];

End; { End LastCallerEditor }

End. { End Unit }

