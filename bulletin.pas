
{$A+,B-,D-,E-,F+,I-,L-,N-,O+,R-,S+,V-}
UNIT Bulletin;

INTERFACE

USES
  Common;

FUNCTION FindOnlyOnce: Boolean;
FUNCTION NewBulletins: Boolean;
PROCEDURE Bulletins(MenuOption: Str50);
PROCEDURE UList(MenuOption: Str50);
PROCEDURE TodaysCallers(x: Byte; MenuOptions: Str50);
PROCEDURE AllCallers(x: Byte; MenuOptions: Str50);
PROCEDURE RGQuote(MenuOption: Str50);

IMPLEMENTATION

USES
  Dos,
  Common5,
  Mail1,
  ShortMsg,
  TimeFunc;

TYPE
  LastCallerPtrType = ^LastCallerRec;
  UserPtrType = ^UserRecordType;
  {AllCallersPtrType = ^LastCallerRec;}



PROCEDURE Bulletins(MenuOption: Str50);
VAR
  Main,
  Subs,
  InputStr: ASTR;


BEGIN
  NL;
  IF (MenuOption = '') THEN
    IF (General.BulletPrefix = '') THEN
      MenuOption := 'BULLETIN;BULLET'
    ELSE
      MenuOption := 'BULLETIN;'+General.BulletPrefix;
  IF (Pos(';',MenuOption) <> 0) THEN
  BEGIN
    Main := Copy(MenuOption,1,(Pos(';',MenuOption) - 1));
    Subs := Copy(MenuOption,(Pos(';',MenuOption) + 1),(Length(MenuOption) - Pos(';',MenuOption)));
  END
  ELSE
  BEGIN
    Main := MenuOption;
    Subs := MenuOption;
  END;
  PrintF(Main);
  IF (NOT NoFile) THEN
    REPEAT
      NL;
      { Prt(FString.BulletinLine); }
      lRGLngStr(16,FALSE);
      ScanInput(InputStr,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ?');
      IF (NOT HangUp) THEN
      BEGIN
        IF (InputStr[1] IN ['?']) THEN
          Prt(InputStr[1]);
          PrintF(Main);
        IF (InputStr <> '') AND NOT (InputStr[1] IN ['Q','?']) THEN
          BEGIN
           IF (Exist(General.MiscPath+Subs+'N'+InputStr+'.ASC')) OR
              (Exist(General.MiscPath+Subs+'N'+InputStr+'.ANS')) OR
              (Exist(General.MiscPath+Subs+'N'+InputStr+'.AVT')) OR
              (Exist(General.MiscPath+Subs+'N'+InputStr+'.TXT')) THEN
            BEGIN
             CLS;
             MCIAllowed := False;
             PrintF(Subs+'N'+InputStr);
             MCIAllowed := True;
            END
           ELSE
            BEGIN
             PrintF(Subs+InputStr);
            END;
          END;
      END;
    UNTIL (InputStr = 'Q') OR (HangUp);
END;

FUNCTION FindOnlyOnce: Boolean;
VAR
  (*
  DirInfo: SearchRec;
  *)
  DT: DateTime;
BEGIN
  FindOnlyOnce := FALSE;
  FindFirst(General.MiscPath+'ONLYONCE.*',AnyFile - Directory - VolumeID- DOS.Hidden,DirInfo);
  IF (DosError = 0) THEN
  BEGIN
    UnPackTime(DirInfo.Time,DT);
    IF (DateToPack(DT) > ThisUser.LastOn) THEN
      FindOnlyOnce := TRUE;
  END;
END;

FUNCTION NewBulletins: Boolean;
TYPE
  BulletinType = ARRAY [0..255] OF Byte;
VAR
  BulletinArray: ^BulletinType;
  DT: DateTime;
  (*
  DirInfo: SearchRec;
  *)
  BullCount,
  Biggest,
  LenOfBullPrefix,
  LenToCopy: Byte;
  Found: Boolean;

  PROCEDURE ShowBulls;
  VAR
    Counter,
    Counter1,
    Counter2: Byte;
  BEGIN
    FOR Counter := 0 TO BullCount DO
    BEGIN
      FOR Counter1 := 0 TO BullCount DO
        IF (BulletinArray^[Counter] < BulletinArray^[Counter1]) THEN
        BEGIN
          Counter2 := BulletinArray^[Counter];
          BulletinArray^[Counter] := BulletinArray^[Counter1];
          BulletinArray^[Counter1] := Counter2;
        END;
    END;
    Counter1 := 1;
    Prt(' |08[|07');
    FOR Counter2 := 0 TO (BullCount) DO
    BEGIN
      IF (Counter1 = 15) THEN
      BEGIN
        Prt('|07'+PadRightInt(BulletinArray^[Counter2],2));
        IF (Counter2 < BullCount) THEN
          Prt('|08]'+^M^J+' |08[|07')
        ELSE
          Prt('|08]|07');
        Counter1 := 0;
      END
      ELSE
      BEGIN
        Prt('|07'+PadRightInt(BulletinArray^[Counter2],2));
        IF (Counter2 < BullCount) THEN
          Prt('|08,|07')
        ELSE
          Prt('|08]|07');
      END;
      Inc(Counter1);
    END;
    NL;
 END;

BEGIN
  New(BulletinArray);
  FOR BullCount := 0 TO 255 DO
    BulletinArray^[BullCount] := 0;
  Found := FALSE;
  Biggest := 0;
  BullCount := 0;
  LenOfBullPrefix := (Length(General.BulletPrefix) + 1);
  FindFirst(General.MiscPath+General.BulletPrefix+'*.ASC',AnyFile - Directory - VolumeID - DOS.Hidden,DirInfo);
  WHILE (DosError = 0) DO
  BEGIN
    IF ((
      (Pos(General.BulletPrefix,General.MiscPath+General.BulletPrefix+'*.ASC') > 0 ) OR
       (Pos(General.BulletPrefix+'N',General.MiscPath+General.BulletPrefix+'N'+'*.ASC') > 0) AND
       (Pos('BULLETIN',AllCaps(DirInfo.Name)) = 0)) AND
       (Pos('~',DirInfo.Name) = 0)) THEN
    BEGIN
      UnPackTime(DirInfo.Time,DT);
      IF (DateToPack(DT) > ThisUser.LastOn) THEN
      BEGIN
        Found := TRUE;
        LenToCopy := (Pos('.',DirInfo.Name) - 1) - Length(General.BulletPrefix);
        BulletinArray^[BullCount] := StrToInt(Copy(DirInfo.Name,LenOfBullPrefix,LenToCopy));
        IF (BulletinArray^[BullCount] > Biggest) THEN
          Biggest := BulletinArray^[BullCount];
        Inc(BullCount);
      END;
    END;
    IF (BullCount > 254) THEN
      Exit;
    FindNext(DirInfo);
  END;
  IF (Found) THEN
  BEGIN
    Dec(BullCount);
    ShowBulls;
  END;
  Dispose(BulletinArray);
  NewBulletins := Found;
END;

FUNCTION UlistMCI(CONST S: ASTR; Data1,Data2: Pointer): STRING;
VAR
  UserPtr: UserPtrType;


BEGIN
  UlistMCI := S;
  UserPtr := Data1;

  CASE S[1] OF
    'A' : CASE S[2] OF
            'G' : UListMCI := IntToStr(AgeUser(UserPtr^.BirthDate));
          END;
    'D' : CASE S[2] OF
            'K' : UListMCI := IntToStr(UserPtr^.DK);
            'L' : UListMCI := IntToStr(UserPtr^.Downloads);
          END;
    'F' : CASE S[2] OF
            'O' : UListMCI := ToDate8(PD2Date(UserPtr^.FirstOn));
          END;
    'L' : CASE S[2] OF
            'C' : UListMCI := UserPtr^.CityState;
            'O' : UListMCI := ToDate8(PD2Date(UserPtr^.LastOn));
            '#' : UListMCI := IntToStr(UserPtr^.LoggedOn);
          END;
    'M' : CASE S[2] OF
            'P' : UListMCI := IntToStr(UserPtr^.MsgPost);
          END;
    'N' : CASE S[2] OF
            'O' : UListMCI := Userptr^.Note;
          END;
    'R' : CASE S[2] OF
            'N' : UListMCI := UserPtr^.RealName;
          END;
    'S' : CASE S[2] OF
            'X' : UListMCI := UserPtr^.Sex;
          END;
    'T' : CASE S[2] OF
            'T' : UListMCI := IntToStr(UserPtr^.TTimeOn);
          END;
    'U' : CASE S[2] OF
            'K' : UListMCI := IntToStr(UserPtr^.UK);
            'L' : UListMCI := IntToStr(UserPtr^.Uploads);
            'N' : UListMCI := Caps(UserPtr^.Name);
            '#' : UListMCI := IntToStr(UserPtr^.UserID);
            '1' : UListMCI := UserPtr^.UsrDefStr[1];
            '2' : UListMCI := UserPtr^.UsrDefStr[2];
            '3' : UListMCI := UserPtr^.UsrDefStr[3];
          END;

  END;
{Inc(UserPtr^.UserID); }
END;

PROCEDURE UList(MenuOption: Str50);
VAR
  Junk: Pointer;
  User: UserRecordType;
  Cmd: Char;
  TempStr: ASTR;
  Gender: Str1;
  State,
  UState: Str2;
  Age: Str3;
  DateLastOn: Str8;
  City,
  UCity: Str30;
  RName,
  UName: Str36;
  FN: Str50;
  RecNum,
  UserID:Integer;
  Counter:Byte;
  FilterUsers : Boolean;
  MenuOptionFilter : String;


  PROCEDURE Option(c1: Char; s1,s2: Str160);
  BEGIN
    Prompt('|11'+c1+''+s1+': ');
    IF (s2 <> '') THEN
      Print('|03"|11'+s2+'04"|11')
    ELSE
      Print('|03Not Set|11');
  END;

BEGIN
  IF (RUserList IN ThisUser.Flags) THEN
  BEGIN
    Print('You are restricted from listing users.');
    Exit;
  END;
  Age := '';
  City := '';
  DateLastOn := '';
  Gender := '';
  RName := '';
  State := '';
  UName := '';
  (* Taken out Feb 12 - 2013 because I hate this *)
{  IF (Pos(':',MenuOption) > 0) THEN
     BEGIN
      MenuOptionFilter := Copy( MenuOption,1, (Pos(':',MenuOption)+4) );
     END;
  IF (MenuOptionFilter = ':true') THEN
   BEGIN
    FilterUsers := TRUE;
   END
  ELSE
    BEGIN
     FilterUsers := FALSE;
    END;

  IF (FilterUsers) THEN
  BEGIN
  REPEAT
    NL;
    Print('     |15User lister search options:');
    NL;
    Option('A','  Age match string             ', Age);
    Option('C','  City match string            ', City);
    Option('D','  Date last online match string', DateLastOn);
    Option('G','  Gender match string          ', Gender);
    Option('R','  Real name match string       ', RName);
    Option('S','  State match string           ', State);
    Option('U','  User name match string       ', UName);
    NL;
    Prompt('  |03Enter choice (|11A|03,|11C|03,|11D|03,|11G|03,|11R|03,|11S|03,|11U|03) [|11L|03]ist [|11Q|03]uit |15: |11');
    OneK(Cmd,'QACDGLRSU'^M,TRUE,TRUE);
    NL;
    IF (Cmd IN ['A','C','D','G','R','S','U']) THEN
    BEGIN
      TempStr := 'Enter new match string for the ';
      CASE Cmd OF
        'A' : TempStr := TempStr + 'age';
        'C' : TempStr := TempStr + 'city';
        'D' : TempStr := TempStr + 'date last online';
        'G' : TempStr := TempStr + 'gender';
        'R' : TempStr := TempStr + 'real name';
        'S' : TempStr := TempStr + 'state';
        'U' : TempStr := TempStr + 'user name';
      END;
      TempStr := TempStr + ' |03[|11enter |03= |11Unset|03]';
      Print('^4'+TempStr);
      Prompt('|15 : |11');
    END;
    CASE Cmd OF
      'A' : BEGIN
              Mpl(3);
              Input(Age,3);
            END;
      'C' : BEGIN
              Mpl(30);
              Input(City,30);
            END;
      'D' : BEGIN
              Mpl(8);
              InputFormatted('',DateLastOn,'##/##/##',TRUE);
              IF (DayNum(DateLastOn) <> 0) AND (DayNum(DateLastOn) <= DayNum(DateStr)) THEN
              BEGIN
                Delete(DateLastOn,3,1);
                Insert('-',DateLastOn,3);
                Delete(DateLastOn,6,1);
                Insert('-',DateLastOn,6);
              END;
            END;
      'G' : BEGIN
              Mpl(1);
              Input(Gender,1);
            END;
      'R' : BEGIN
              Mpl(36);
              Input(RName,36);
            END;
      'S' : BEGIN
              Mpl(2);
              Input(State,2);
            END;
      'U' : BEGIN
              Mpl(36);
              Input(UName,36);
            END;
    END;
  UNTIL (Cmd IN ['L','Q',^M]) OR (HangUp);

  IF (Cmd IN ['L',^M]) THEN
        }
  BEGIN
    Abort := FALSE;
    Next := FALSE;
    AllowContinue := TRUE;

    IF (Pos(';',MenuOption) > 0) THEN
    BEGIN
      FN := Copy(MenuOption,(Pos(';',MenuOption) + 1),255);
      MenuOption := Copy(MenuOption,1,(Pos(';',MenuOption) - 1));
    END

    ELSE
      FN := 'USER';
    IF (NOT ReadBuffer(FN+'M')) THEN
      Exit;

    PrintF(FN+'H');

    Reset(UserFile);
    RecNum := 1;
    Counter := 1;

    WHILE (RecNum <= (FileSize(UserFile) - 1)) AND (NOT Abort) AND (NOT HangUp) DO
    BEGIN
      LoadURec(User,RecNum);
      UCity := (Copy(User.CityState,1,(Pos(',',User.CityState) - 1)));
      UState := SQOutSP((Copy(User.CityState,(Pos(',',User.CityState) + 2),(Length(User.CityState)))));
      User.UserID := RecNum;
      IF (AACS1(User,RecNum,MenuOption)) AND NOT (Deleted IN User.SFlags) THEN
        IF (Age = '') OR (Pos(Age,IntToStr(AgeUser(User.BirthDate))) > 0) THEN
          IF (City = '') OR (Pos(City,AllCaps(UCity)) > 0) THEN
            IF (DateLastOn = '') OR (Pos(DateLastOn,ToDate8(PD2Date(User.LastOn))) > 0) THEN
              IF (Gender = '') OR (Pos(Gender,User.Sex) > 0) THEN
                IF (RName = '') OR (Pos(RName,AllCaps(User.RealName)) > 0) THEN
                  IF (State = '') OR (Pos(State,AllCaps(UState)) > 0) THEN
                     IF (UName = '') OR (Pos(UName,User.Name) > 0) THEN
                        DisplayBuffer(UlistMCI,@User,Junk);
      Inc(RecNum);
      Inc(Counter);
      If (Counter = 16) Then
       Begin
        PauseScr(True);
        Counter := 1;
       End;
    END;
    Close(UserFile);
    IF (NOT Abort) AND (NOT HangUp) THEN
      PrintF(FN+'T');
    AllowContinue := FALSE;
  END;
  SysOpLog('Viewed User Listing.');
  LastError := IOResult;
END;

FUNCTION TodaysCallerMCI(CONST S: ASTR; Data1,Data2: Pointer): STRING;
VAR
  LastCallerPtr: LastCallerPtrType;
  s1: STRING[100];
BEGIN
  LastCallerPtr := Data1;
  TodaysCallerMCI := S;
  CASE S[1] OF
    'C' : CASE S[2] OF
            'A' : TodaysCallerMCI := FormatNumber(LastCallerPtr^.Caller);
          END;
    'D' : CASE S[2] OF
            'T' : TodaysCallerMCI := ToDate8(PD2Date(LastCallerPtr^.LogonTime));
            'K' : TodaysCallerMCI := IntToStr(LastCallerPtr^.DK);
            'L' : TodaysCallerMCI := IntToStr(LastCallerPtr^.Downloads);
          END;
    'E' : CASE S[2] OF
            'S' : TodaysCallerMCI := IntToStr(LastCallerPtr^.EmailSent);
          END;
    'F' : CASE S[2] OF
            'S' : TodaysCallerMCI := IntToStr(LastCallerPtr^.FeedbackSent);
          END;
    'L' : CASE S[2] OF
            'C' : TodaysCallerMCI := LastCallerPtr^.Location;
            'O' : BEGIN
                    s1 := PDT2Dat(LastCallerPtr^.LogonTime,0);
                    s1[0] := Char(Pos('m',s1) - 2);
                    s1[Length(s1)] := s1[Length(s1) + 1];
                    TodaysCallerMCI := s1;
                  END;
            'T' : BEGIN
                    IF (LastCallerPtr^.LogoffTime = 0) THEN
                      S1 := 'Online'
                    ELSE
                    BEGIN
                      s1 := PDT2Dat(LastCallerPtr^.LogoffTime,0);
                      s1[0] := Char(Pos('m',s1) - 2);
                      s1[Length(s1)] := s1[Length(s1) + 1];
                    END;
                    TodaysCallerMCI := s1;
                  END;
          END;
    'M' : CASE S[2] OF
            'P' : TodaysCallerMCI := IntToStr(LastCallerPtr^.MsgPost);
            'R' : TodaysCallerMCI := IntToStr(LastCallerPtr^.MsgRead);
          END;
    'N' : CASE S[2] OF
            'D' : TodaysCallerMCI := IntToStr(LastCallerPtr^.Node);
            'U' : IF (LastCallerPtr^.NewUser) THEN
                    TodaysCallerMCI := '*'
                  ELSE
                    TodaysCallerMCI := ' ';
          END;
    'O' : CASE S[2] OF
            'L' : BEGIN
                   IF (LastCallerPtr^.LogoffTime = 0) THEN
                    TodaysCallerMCI := 'o'
                   ELSE
                    TodaysCallerMCI := ' ';
                  END;
          END;
    'S' : CASE S[2] OF
            'P' : BEGIN
                  IF (LastCallerPtr^.Speed <> 0) AND
                     (LastCallerPtr^.Speed <> 1) AND
                     (NOT Telnet) AND
                     (LastCallerPtr^.Speed <> 2) THEN
                    TodaysCallerMCI := IntToStr(LastCallerPtr^.Speed);

                  IF (LastCallerPtr^.Speed = 0) THEN
                    TodaysCallerMCI := 'Local';
                  IF (Telnet) THEN
                    TodaysCallerMCI := 'Telnet';
                  IF (LastCallerPtr^.Speed = 1) THEN
                    TodaysCallerMCI := 'Web';
                  IF (LastCallerPtr^.Speed = 2) THEN
                    TodaysCallerMCI := 'FTP';

                  END;
          END;
    'T' : CASE S[2] OF
            'O' : WITH LastCallerPtr^ DO
                    TodaysCallerMCI := IntToStr((LogoffTime - LogonTime) DIV 60);
          END;
    'U' : CASE S[2] OF
            'K' : TodaysCallerMCI := IntToStr(LastCallerPtr^.UK);
            'L' : TodaysCallerMCI := IntToStr(LastCallerPtr^.Uploads);
            'N' : TodaysCallerMCI := LastCallerPtr^.UserName;
          END;
  END;
END;

FUNCTION AllCallersMCI(CONST S: ASTR; Data1,Data2: Pointer): STRING;
VAR
  AllCallersPtr : ^LastCallerRec;
  s1: STRING[100];
BEGIN
  AllCallersPtr := Data1;
  AllCallersMCI := S;
  CASE S[1] OF
    'C' : CASE S[2] OF
            'A' : AllCallersMCI := FormatNumber(AllCallersPtr^.Caller);
          END;
    'D' : CASE S[2] OF
            'T' : AllCallersMCI := ToDate8(PD2Date(AllCallersPtr^.LogonTime));
            'K' : AllCallersMCI := IntToStr(AllCallersPtr^.DK);
            'L' : AllCallersMCI := IntToStr(AllCallersPtr^.Downloads);
          END;
    'E' : CASE S[2] OF
            'S' : AllCallersMCI := IntToStr(AllCallersPtr^.EmailSent);
          END;
    'F' : CASE S[2] OF
            'S' : AllCallersMCI := IntToStr(AllCallersPtr^.FeedbackSent);
          END;
    'L' : CASE S[2] OF
            'C' : AllCallersMCI := AllCallersPtr^.Location;
            'O' : BEGIN
                    s1 := PDT2Dat(AllCallersPtr^.LogonTime,0);
                    s1[0] := Char(Pos('m',s1) - 2);
                    s1[Length(s1)] := s1[Length(s1) + 1];
                    AllCallersMCI := s1;
                  END;
            'T' : BEGIN
                    IF (AllCallersPtr^.LogoffTime = 0) THEN
                      S1 := 'Online'
                    ELSE
                    BEGIN
                      s1 := PDT2Dat(AllCallersPtr^.LogoffTime,0);
                      s1[0] := Char(Pos('m',s1) - 2);
                      s1[Length(s1)] := s1[Length(s1) + 1];
                    END;
                    AllCallersMCI := s1;
                  END;
          END;
    'M' : CASE S[2] OF
            'P' : AllCallersMCI := IntToStr(AllCallersPtr^.MsgPost);
            'R' : AllCallersMCI := IntToStr(AllCallersPtr^.MsgRead);
          END;
    'N' : CASE S[2] OF
            'D' : AllCallersMCI := IntToStr(AllCallersPtr^.Node);
            'U' : IF (AllCallersPtr^.NewUser) THEN
                    AllCallersMCI := '*'
                  ELSE
                    AllCallersMCI := ' ';
          END;
    'S' : CASE S[2] OF
            'P' : BEGIN
                  IF (AllCallersPtr^.Speed <> 0) AND
                     (AllCallersPtr^.Speed <> 1) AND
                     (NOT Telnet) AND
                     (AllCallersPtr^.Speed <> 2) THEN
                    AllCallersMCI := IntToStr(AllCallersPtr^.Speed);

                  IF (AllCallersPtr^.Speed = 0) THEN
                    AllCallersMCI := 'Local';
                  IF (Telnet) THEN
                    AllCallersMCI := 'Telnet';
                  IF (AllCallersPtr^.Speed = 1) THEN
                    AllCallersMCI := 'Web';
                  IF (AllCallersPtr^.Speed = 2) THEN
                    AllCallersMCI := 'FTP';

                  END;
          END;
    'T' : CASE S[2] OF
            'O' : WITH AllCallersPtr^ DO
                    AllCallersMCI := IntToStr((LogoffTime - LogonTime) DIV 60);
          END;
    'U' : CASE S[2] OF
            'K' : AllCallersMCI := IntToStr(AllCallersPtr^.UK);
            'L' : AllCallersMCI := IntToStr(AllCallersPtr^.Uploads);
            'N' : AllCallersMCI := AllCallersPtr^.UserName;
          END;
  END;
END;

PROCEDURE TodaysCallers(x: Byte; MenuOptions: Str50);
VAR
  Junk: Pointer;
  LastCallerFile: FILE OF LastCallerRec;
  LastCaller: LastCallerRec;
  RecNum: Integer;
BEGIN
  Abort := FALSE;
  Next := FALSE;
  AllowContinue := TRUE;
  IF (MenuOptions = '') THEN
    MenuOptions := 'LAST';
  IF (NOT ReadBuffer(MenuOptions+'M')) THEN
    Exit;
  Assign(LastCallerFile,General.DataPath+'LASTON.DAT');
  Reset(LastCallerFile);
  IF (IOResult <> 0) THEN
    Exit;
  RecNum := 0;
  IF (x > 0) AND (x <= FileSize(LastCallerFile)) THEN
    RecNum := (FileSize(LastCallerFile) - x);
  PrintF(MenuOptions+'H');
  Seek(LastCallerFile,RecNum);
  WHILE (NOT EOF(LastCallerFile)) AND (NOT Abort) AND (NOT HangUp) DO
  BEGIN
    Read(LastCallerFile,LastCaller);
    IF (((LastCaller.LogonTime DIV 86400) <> (GetPackDateTime DIV 86400)) AND (x > 0)) OR
       (((LastCaller.LogonTime DIV 86400) = (GetPackDateTime DIV 86400))) AND (NOT LastCaller.Invisible) THEN

          DisplayBuffer(TodaysCallerMCI,@LastCaller,Junk);
  END;
  Close(LastCallerFile);
  IF (NOT Abort) THEN
    PrintF(MenuOptions+'T');
  AllowContinue := FALSE;
  SysOpLog('Viewed Todays Callers.');
  LastError := IOResult;
END;

PROCEDURE AllCallers(x: Byte; MenuOptions: Str50);
VAR
  Junk: Pointer;
  AllCallersFile: FILE OF LastCallerRec;
  AllCallers: LastCallerRec;
  RecNum,
  i      : Integer;
  Count : Integer;

BEGIN
  Abort := FALSE;
  Next := FALSE;
  AllowContinue := TRUE;
  IF (MenuOptions = '') THEN
    MenuOptions := 'ALLCALL';
  IF (NOT ReadBuffer(MenuOptions+'M')) THEN
    Exit;
  Assign(AllCallersFile,General.DataPath+'ALLCALL.DAT');
  Reset(AllCallersFile);
  IF (IOResult <> 0) THEN
    Exit;
  RecNum := 0;
  IF (x > 0) AND (x <= FileSize(AllCallersFile)) THEN
   BEGIN
    RecNum := (FileSize(AllCallersFile) - x);
    Count := x;
   END
   ELSE
    BEGIN
     Count := 10; { Default Value }
    END;
  PrintF(MenuOptions+'H');

    FOR i := (FileSize(AllCallersFile) - Count) TO (FileSize(AllCallersFile) - 1) DO
     BEGIN
      Seek(AllCallersFile,i);
      Read(AllCallersFile,AllCallers);
       IF (NOT AllCallers.Invisible) AND (NOT Abort) AND (NOT Hangup) THEN
        BEGIN
         DisplayBuffer(TodaysCallerMCI,@AllCallers,Junk);
        END;
     END;

  Close(AllCallersFile);
  IF (NOT Abort) THEN
    PrintF(MenuOptions+'T');
  AllowContinue := FALSE;
  SysOpLog('Viewed All Callers.');
  LastError := IOResult;
END;


PROCEDURE RGQuote(MenuOption: Str50);
VAR
  StrPointerFile: FILE OF StrPointerRec;
  StrPointer: StrPointerRec;
  RGStrFile: FILE;
  F,
  F1: Text;
  MHeader: MHeaderRec;
  S: STRING;
  StrNum: Word;
  TotLoad: LongInt;
BEGIN
  IF (MenuOption = '') THEN
    Exit;
  Assign(StrPointerFile,General.LMultPath+MenuOption+'.PTR');
  Reset(StrPointerFile);
  TotLoad := FileSize(StrPointerFile);
  IF (TotLoad < 1) THEN
    Exit;
  IF (TotLoad > 65535) THEN
    Totload := 65535
  ELSE
    Dec(TotLoad);
  Randomize;
  StrNum := Random(Totload);
  Seek(StrPointerFile,StrNum);
  Read(StrPointerFile,StrPointer);
  Close(StrPointerFile);
  LastError := IOResult;
  IF (Exist(General.MiscPath+'QUOTEHDR.*')) THEN
    PrintF('QUOTEHDR')
  ELSE
  BEGIN
    NL;
    Print('|03[컴컴컴컴컴컴컴컴컴컴컴�[ |11And Now |03... |11A Quote For You! |03]컴컴컴컴컴컴컴컴컴컴컴]');
    NL;
  END;
  TotLoad := 0;
  Assign(RGStrFile,General.LMultPath+MenuOption+'.DAT');
  Reset(RGStrFile,1);
  Seek(RGStrFile,(StrPointer.Pointer - 1));
  REPEAT
    BlockRead(RGStrFile,S[0],1);
    BlockRead(RGStrFile,S[1],Ord(S[0]));
    Inc(TotLoad,(Length(S) + 1));
    IF (S[Length(S)] = '@') THEN
    BEGIN
      Dec(S[0]);
      Prt(Centre(S));
    END
    ELSE
      PrintACR(Centre(S));
  UNTIL (TotLoad >= StrPointer.TextSize) OR EOF(RGStrFile);
  Close(RGStrFile);
  LastError := IOResult;
  IF (Exist(General.MiscPath+'QUOTEFTR.*')) THEN
    PrintF('QUOTEFTR')
  ELSE
  BEGIN
    NL;
    Print('|03[컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�]');
    NL;
  END;
  IF (NOT General.UserAddQuote) THEN
    PauseScr(FALSE)
  ELSE IF (PYNQ('Would you like to add a quote? ',0,FALSE)) THEN
  BEGIN
    PrintF('QUOTE');
    InResponseTo := '';
    MHeader.Status := [];
    IF (InputMessage(TRUE,FALSE,'New Quote',MHeader,General.LMultPath+MenuOption+'.TMP',78,500)) then
      IF Exist(General.LMultPath+MenuOption+'.TMP') THEN
      BEGIN
        Assign(F,General.LMultPath+MenuOption+'.NEW');
        Reset(F);
        IF (IOResult <> 0) THEN
          ReWrite(F)
        ELSE
          Append(F);
        Assign(F1,General.LMultPath+MenuOption+'.TMP');
        Reset(F1);
        IF (IOResult <> 0) THEN
          Exit;
        WriteLn(F,'New quote from: '+Caps(ThisUser.Name)+' #'+IntToStr(UserNum)+'.');
        WriteLn(F,'');
        WriteLn(F,'$');
        WHILE (NOT EOF(F1)) DO
        BEGIN
          ReadLn(F1,S);
          WriteLn(F,S);
        END;
        WriteLn(F,'$');
        WriteLn(F,'');
        WriteLn(F);
        Close(F);
        Close(F1);
        Kill(General.LMultPath+MenuOption+'.TMP');
        NL;
        Print('^7Your new quote was saved.');
        PauseScr(FALSE);
        SendShortMessage(1,Caps(ThisUser.Name)+' added a new quote to "'+MenuOption+'.NEW".');
      END;
  END;
END;

END.
