{$A+,B-,D-,E-,F+,I-,L-,N-,O+,R-,S+,V-}

UNIT BBSList;

INTERFACE

PROCEDURE BBSList_Add;
PROCEDURE BBSList_Delete;
PROCEDURE BBSList_Edit;
PROCEDURE BBSList_View;
PROCEDURE BBSList_xView;

IMPLEMENTATION

USES
  Common,
  TimeFunc;

FUNCTION BBSListMCI(CONST S: ASTR; Data1,Data2: Pointer): STRING;
VAR
  BBSListPtr: ^BBSListRecordType;
  User: UserRecordType;
  TmpStr : String;
BEGIN
  BBSListPtr := Data1;
  BBSListMCI := S;
  CASE S[1] OF
    'X' : CASE S[2] OF
            'A' : BBSListMCI := BBSListPtr^.SDA;
            'B' : BBSListMCI := BBSListPtr^.SDB;
            'C' : BBSListMCI := BBSListPtr^.SDC;
            'D' : BBSListMCI := BBSListPtr^.SDD;
            'E' : BBSListMCI := BBSListPtr^.SDE;
            'F' : BBSListMCI := BBSListPtr^.SDF;
          END;
    'A' : CASE S[2] OF
            'C' :
             Begin
              If (Length(BBSListPtr^.PhoneNumber) > 0) Then
               Begin
                TmpStr := BBSListPtr^.PhoneNumber;
                Delete(TmpStr,4,Length(TmpStr));
                BBSListMCI := TmpStr;
               End
              Else
               Begin
                BBSListMCI := 'N/A';
               End;
             End;
          END;
    'B' : CASE S[2] OF
            'N' : BBSListMCI := BBSListPtr^.BBSName;
            'P' : BBSListMCI := IntToStr(BBSListPtr^.Port);
          END;
    'D' : CASE S[2] OF
            'A' : BBSListMCI := Pd2Date(BBSListPtr^.DateAdded);
            'E' : BBSListMCI := Pd2Date(BBSListPtr^.DateEdited);
            'S' : BBSListMCI := BBSListPtr^.Description;
            '2' : BBSListMCI := BBSListPtr^.Description2
          END;
    'L' : CASE S[2] OF
            'O' : BBSListMCI := BBSListPtr^.Location;
          END;
    'H' : CASE S[2] OF
            'R' : BBSListMCI := BBSListPtr^.Hours;
          END;
    'M' : CASE S[2] OF
            'N' : BBSListMCI := IntToStr(BBSListPtr^.MaxNodes);
          END;
    'O' : CASE S[2] OF
            'S' : Begin
                   If (Length(BBSListPtr^.OS) > 0) Then
                    BBSListMCI := BBSListPtr^.OS
                   Else
                    BBSListMCI := 'Unknown';
                  End;
          END;
    'P' : CASE S[2] OF
            'N' : Begin
                   If (Length(BBSListPtr^.PhoneNumber) > 0) Then
                    BBSListMCI := BBSListPtr^.PhoneNumber
                   Else
                    BBSListMCI := 'None';
                  End;
          END;
    'R' : CASE S[2] OF
            'N' : BBSListMCI := IntToStr(BBSListPtr^.RecordNum);
          END;
    'S' : CASE S[2] OF
            'A' : BBSListMCI := BBSListPtr^.SDA;
            'B' : BBSListMCI := BBSListPtr^.SDB;
            'C' : BBSListMCI := BBSListPtr^.SDC;
            'D' : BBSListMCI := BBSListPtr^.SDD;
            'E' : BBSListMCI := BBSListPtr^.SDE;
            'F' : BBSListMCI := BBSListPtr^.SDF;
            'G' : BBSListMCI := IntToStr(BBSListPtr^.SDG);
            'H' : BBSListMCI := ShowYesNo(BBSListPtr^.SDH);
            'I' : BBSListMCI := ShowYesNo(BBSListPtr^.SDI);
            'N' : BBSListMCI := BBSListPtr^.SysOpName;
            'P' : BBSListMCI := BBSListPtr^.Speed;
            'T' : Begin
                   IF (Length(BBSListPtr^.Birth) > 0) THEN
                     BBSListMCI := BBSListPtr^.Birth
                   ELSE
                     BBSListMCI := 'Unknown';
                  End;
            'V' : Begin
                   If (Length(BBSListPtr^.SoftwareVersion) > 0) Then
                    Begin
                     BBSListMCI := BBSListPtr^.SoftwareVersion;
                    End
                   Else
                    Begin
                     BBSListMCI := 'Unknown';
                    End;
                   End;
            'W' : BBSListMCI := BBSListPtr^.Software;
          END;
    'T' : CASE S[2] OF
            'N' : BBSListMCI := BBSListPtr^.TelnetUrl;
          END;
    'U' : CASE S[2] OF
            'N' : BEGIN
                    LoadURec(User,BBSListPtr^.UserID);
                    BBSListMCI := User.Name;
                  END;
          END;
    'W' : CASE S[2] OF
            'S' : BBSListMCI := BBSListPtr^.WebSiteUrl;
          END;
  END;
END;

PROCEDURE BBSListScriptFile(VAR BBSList: BBSListRecordType);
VAR
  BBSScriptText: TEXT;
  Question: STRING;
  WhichOne: String;
  TmpBirth: String[10];
BEGIN
  Assign(BBSScriptText,General.MiscPath+'BBSLIST.SCR');
  Reset(BBSScriptText);
  WHILE NOT EOF(BBSScriptText) AND (NOT Abort) AND (NOT HangUp) DO
  BEGIN
    ReadLn(BBSScriptText,Question);
    IF (Question[1] = '[') THEN
    BEGIN
      WhichOne := AllCaps(Copy(Question, Pos('[',Question)+1, Pos(']',Question)-2));
      Question := Copy(Question,(Pos(':',Question) + 1),Length(Question));

      IF (WhichOne = 'BBSNAME') THEN
       BEGIN
        NL;
        PRT(Question+' ');
        MPL(SizeOf(BBSList.BBSName) - 1);
        InputMain(BBSList.BBSName,(SizeOf(BBSList.BBSName) - 1),[InterActiveEdit,ColorsAllowed]);
        Abort := (BBSList.BBSName = '');
       END
      ELSE IF WhichOne = 'SYSOPNAME' THEN
       BEGIN
        PRT(Question+' ');
        MPL(SizeOf(BBSList.SysOpName) - 1);
        InputMain(BBSList.SysOpName,(SizeOf(BBSList.SysOpName) - 1),[ColorsAllowed,InterActiveEdit]);
        Abort := (BBSList.SysOpName = '');
       END
      ELSE IF WhichOne = 'TELNETURL' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.TelnetUrl) - 1);
        InputMain(BBSList.TelnetUrl,(SizeOf(BBSList.TelnetUrl) - 1),[ColorsAllowed,InterActiveEdit]);
        Abort := (BBSList.TelnetUrl = '');
       END
      ELSE IF WhichOne = 'WEBSITEURL' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.WebSiteUrl) - 1);
        InputMain(BBSList.WebSiteUrl,(SizeOf(BBSList.WebSiteUrl) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.WebSiteUrl = '');}
       END
      ELSE IF WhichOne = 'PHONENUMBER' THEN
       BEGIN
        PRT(Question+' ');
        MPL(SizeOf(BBSList.PhoneNumber) - 1);
        InputMain(BBSList.PhoneNumber,(SizeOf(BBSList.PhoneNumber) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.PhoneNumber = '');}
       END
      ELSE IF WhichOne = 'SOFTWARE' THEN
       BEGIN
        PRT(Question+' ');
        MPL(SizeOf(BBSList.Software) - 1);
        InputMain(BBSList.Software,(SizeOf(BBSList.Software) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.Software = '');}
       END
      ELSE IF WhichOne = 'SOFTWAREVERSION' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.SoftwareVersion) - 1);
        InputMain(BBSList.SoftwareVersion,(SizeOf(BBSList.SoftwareVersion) - 1),[ColorsAllowed,InterActiveEdit]);
       END
      ELSE IF WhichOne = 'OS' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.OS) - 1);
        InputMain(BBSList.OS,(SizeOf(BBSList.OS) - 1),[ColorsAllowed,InterActiveEdit]);
       END
      ELSE IF WhichOne = 'SPEED' THEN
       BEGIN
        PRT(Question+' ');
        MPL(SizeOf(BBSList.Speed) - 1);
        InputMain(BBSList.Speed,(SizeOf(BBSList.Speed) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.Speed = '');}
       END
      ELSE IF WhichOne = 'HOURS' THEN
       BEGIN
        PRT(Question+' ');
        MPL(SizeOf(BBSList.Hours) - 1);
        InputMain(BBSList.Hours,(SizeOf(BBSList.Hours) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.Speed = '');}
       END
      ELSE IF WhichOne = 'DESCRIPTION' THEN
       BEGIN
        Prt(Question);
        MPL(SizeOf(BBSList.Description) - 1);
        InputMain(BBSList.Description,(SizeOf(BBSList.Description) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.Description = '');}
       END
      ELSE IF WhichOne = 'DESCRIPTION2' THEN
       BEGIN
        Prt(Question);
        MPL(SizeOf(BBSList.Description2) - 1);
        InputMain(BBSList.Description2,(SizeOf(BBSList.Description2) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.Description2 = '');}
       END
       ELSE IF WhichOne = 'MAXNODES' THEN
       BEGIN

        MPL(SizeOf(BBSList.MaxNodes) - 1);
        IF (BBSList.MaxNodes = 0) THEN
         BBSList.MaxNodes := 5;
        InputLongIntWoc(Question,BBSList.MaxNodes,[NumbersOnly,InteractiveEdit],1,1000);

       END
       ELSE IF WhichOne = 'PORT' THEN
       BEGIN
        IF (BBSList.Port = 0) THEN
         BBSList.Port := 23;
        MPL(SizeOf(BBSList.Port) - 1);

        InputWordWoc(Question,BBSList.Port,[NumbersOnly,InterActiveEdit],1,65535);
       END
       ELSE IF WhichOne = 'LOCATION' THEN
        BEGIN
         Prt(Question+' ');
         MPL(SizeOf(BBSList.Location) - 1);
         InputMain(BBSList.Location,(SizeOf(BBSList.Location) - 1),[ColorsAllowed,InterActiveEdit]);
        END
       ELSE IF WhichOne = 'BIRTH' THEN
        BEGIN
         TmpBirth := BBSList.Birth;
         IF (Length(TmpBirth) < 10) THEN
          TmpBirth := '12/31/1969';
         MPL(10);
         InputFormatted(Question+' |08(|07'+TmpBirth+'|08) |15: ',BBSList.Birth,'##/##/####',TRUE);
         IF (Length(BBSList.Birth) <= 0) THEN
          BBSList.Birth := TmpBirth;

        END
      ELSE IF WhichOne = 'SDA' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.SDA) - 1);
        InputMain(BBSList.SDA,(SizeOf(BBSList.SDA) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.xA = '');}
       END
      ELSE IF WhichOne = 'SDB' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.SDB) - 1);
        InputMain(BBSList.SDB,(SizeOf(BBSList.SDB) - 1),[ColorsAllowed,InterActiveEdit]);
        {Abort := (BBSList.xB = '');}
       END
      ELSE IF WhichOne = 'SDC' THEN
       BEGIN
        Prt(Question+' ');
        MPL(SizeOf(BBSList.SDC) - 1);
        InputMain(BBSList.SDC,(SizeOf(BBSList.SDC) - 1),[ColorsAllowed,InterActiveEdit]);
        { Abort := (BBSList.xC = '');  }
       END
      ELSE IF WhichOne = 'SDD' THEN BEGIN
       Prt(Question+' ');
       MPL(SizeOf(BBSList.SDD) - 1);
       InputMain(BBSList.SDD,(SizeOf(BBSList.SDD) - 1),[ColorsAllowed,InterActiveEdit]);
       { Abort := (BBSList.xD = '');}
      END
     ELSE IF WhichOne = 'SDE' THEN
      BEGIN
       Print(Question);
       MPL(SizeOf(BBSList.SDE) - 1);
       InputMain(BBSList.SDE,(SizeOf(BBSList.SDE) - 1),[ColorsAllowed,InterActiveEdit]);
       {Abort := (BBSList.xE = '');}
      END
     ELSE IF WhichOne = 'SDF' THEN
      BEGIN
       Print(Question);
       MPL(SizeOf(BBSList.SDF) - 1);
       InputMain(BBSList.SDF,(SizeOf(BBSList.SDF) - 1),[ColorsAllowed,InterActiveEdit]);
       {Abort := (BBSList.xF = '');}
      END
      ELSE IF WhichOne = 'SDG' THEN
      BEGIN

       MPL(SizeOf(BBSList.SDG) - 1);
       InputWordWoc(Question,BBSList.SDG,[NumbersOnly,InterActiveEdit],1,65535);
       {Abort := (BBSList.xE = '');}
      END
     ELSE IF WhichOne = 'SDH' THEN
      BEGIN
       BBSList.SDH := PYNQ(Question+' ',0,TRUE);
      END
     ELSE IF WhichOne = 'SDI' THEN
      BEGIN
       BBSList.SDI := PYNQ(Question+' ',6,FALSE);
      END;
     END;
    END;
  Close(BBSScriptText);
  LastError := IOResult;
END;

FUNCTION BBSList_Exists: Boolean;
VAR
  BBSListFile: FILE OF BBSListRecordType;
  FSize: Longint;
  FExist: Boolean;
BEGIN
  FSize := 0;
  FExist := Exist(General.DataPath+'BBSLIST.DAT');
  IF (FExist) THEN
  BEGIN
    Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
    Reset(BBSListFile);
    FSize := FileSize(BBSListFile);
    Close(BBSListFile);
  END;
  IF (NOT FExist) OR (FSize = 0) THEN
  BEGIN
    NL;
    Print('There are currently no entries in the BBS List.');
    SysOpLog('The BBSLIST.DAT file is missing.');
  END;
  BBSList_Exists := (FExist) AND (FSize <> 0);
END;

PROCEDURE DisplayError(FName: ASTR; VAR FExists: Boolean);
BEGIN
  NL;
  PrintACR('|12ú |09The '+FName+'.*  File is missing.');
  PrintACR('|12ú |09Please, inform the Sysop!');
  SysOpLog('The '+FName+'.* file is missing.');
  FExists := FALSE;
END;

FUNCTION BBSListScript_Exists: Boolean;
VAR
  FExists: Boolean;
BEGIN
  FExists := Exist(General.MiscPath+'BBSLIST.SCR');
  IF (NOT FExists) THEN
    DisplayError('BBSLIST.SCR',FExists);
  BBSListScript_Exists := FExists;
END;

FUNCTION BBSListAddScreens_Exists: Boolean;
VAR
  FExistsH,
  FExistsN,
  FExistsT: Boolean;
BEGIN
  FExistsH := TRUE;
  FExistsN := TRUE;
  FExistsT := TRUE;
  IF (NOT ReadBuffer('BBSNH')) THEN
    DisplayError('BBSNH',FExistsH);
  IF (NOT ReadBuffer('BBSMN')) THEN
    DisplayError('BBSMN',FExistsN);
  IF (NOT ReadBuffer('BBSNT')) THEN
    DisplayError('BBSNT',FExistsT);
  BBSListAddScreens_Exists := (FExistsH) AND (FExistsN) AND (FExistsT);
END;

FUNCTION BBSListEditScreens_Exists: Boolean;
VAR
  FExistsT,
  FExistsM: Boolean;
BEGIN
  FExistsT := TRUE;
  FExistsM := TRUE;
  IF (NOT ReadBuffer('BBSLET')) THEN
    DisplayError('BBSLET',FExistsT);
  IF (NOT ReadBuffer('BBSLEM')) THEN
    DisplayError('BBSLEM',FExistsM);
  BBSListEditScreens_Exists := (FExistsT) AND (FExistsM);
END;

PROCEDURE BBSList_Renumber;
VAR
  BBSListFile: FILE OF BBSListRecordType;
  BBSList: BBSListRecordType;
  OnRec: Longint;
BEGIN
  Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
  Reset(BBSListFile);
  Abort := FALSE;
  OnRec := 1;
  WHILE (OnRec <= FileSize(BBSListFile)) DO
  BEGIN
    Seek(BBSListFile,(OnRec - 1));
    Read(BBSListFile,BBSList);
    BBSList.RecordNum := OnRec;
    Seek(BBSListFile,(OnRec - 1));
    Write(BBSListFile,BBSList);
    Inc(OnRec);
  END;
  Close(BBSListFile);
  LastError := IOResult;
END;

PROCEDURE BBSList_Sort;
VAR
  BBSListFile: FILE OF BBSListRecordType;
  BBSList1,
  BBSList2: BBSListRecordType;
  S,
  I,
  J,
  pl,
  Gap: INTEGER;
BEGIN
  IF (BBSList_Exists) THEN
  BEGIN
    Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
    Reset(BBSListFile);
    pl := FileSize(BBSListFile);
    Gap := pl;
    REPEAT;
      Gap := (Gap DIV 2);
      IF (Gap = 0) THEN
        Gap := 1;
      s := 0;
      FOR I := 1 TO (pl - Gap) DO
      BEGIN
        J := (I + Gap);
        Seek(BBSListFile,(i - 1));
        Read(BBSListFile,BBSList1);
        Seek(BBSListFile,(j - 1));
        Read(BBSListFile,BBSList2);
        IF (BBSList1.BBSName > BBSList2.BBSName) THEN
        BEGIN
          Seek(BBSListFile,(i - 1));
          Write(BBSListFile,BBSList2);
          Seek(BBSListFile,(j - 1));
          Write(BBSListFile,BBSList1);
          Inc(s);
        END;
      END;
    UNTIL (s = 0) AND (Gap = 1);
    Close(BBSListFile);
    LastError := IOResult;
    IF (PL > 0) THEN
    BEGIN
      NL;
      Print('Sorted '+IntToStr(pl)+' BBS List entries.');
      SysOpLog('Sorted the BBS Listing');
    END;
  END;
END;

PROCEDURE BBSList_Add;
VAR
  Data2: Pointer;
  BBSList: BBSListRecordType;
BEGIN
  IF (BBSListScript_Exists) AND (BBSListAddScreens_Exists) THEN
  BEGIN
    NL;
    IF PYNQ(' Add an entry to the BBS list? ',0,FALSE) THEN
    BEGIN
      FillChar(BBSList,SizeOf(BBSList),0);
      BBSListScriptFile(BBSList);
      IF (NOT Abort) THEN
      BEGIN
        PrintF('BBSNH');
        ReadBuffer('BBSMN');
        DisplayBuffer(BBSListMCI,@BBSList,Data2);
        PrintF('BBSNT');
        NL;
        IF (PYNQ(' Save '+BBSList.BBSName+'? ',0,TRUE)) THEN
        BEGIN
          Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
          IF (Exist(General.DataPath+'BBSLIST.DAT')) THEN
            Reset(BBSListFile)
          ELSE
          Rewrite(BBSListFile);
          Seek(BBSListFile,FileSize(BBSListFile));
          BBSList.UserID := UserNum;
          BBSList.DateAdded := GetPackDateTime;
          BBSList.DateEdited := BBSList.DateAdded;
          BBSList.RecordNum := (FileSize(BBSListFile) + 1);
          Write(BBSListFile,BBSList);
          Close(BBSListFile);
          LastError := IOResult;
          BBSList_Sort;
          BBSList_Renumber;
          SysOpLog('Added BBS Listing: '+BBSList.BBSName+'.');
        END;
      END;
    END;
  END;
END;

PROCEDURE BBSList_Delete;
VAR
  Data2: Pointer;
  BBSList: BBSListRecordType;
  OnRec,
  RecNum: Longint;
  Found: Boolean;
BEGIN
  IF (BBSList_Exists) AND (BBSListEditScreens_Exists) THEN
  BEGIN
    AllowContinue := FALSE;
    Found := FALSE;
    Abort := FALSE;
    Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
    Reset(BBSListFile);
    OnRec := 1;
    WHILE (OnRec <= FileSize(BBSListFile)) AND (NOT Abort) AND (NOT HangUp) DO
    BEGIN
      Seek(BBSListFile,(OnRec - 1));
      Read(BBSListFile,BBSList);
      IF (BBSList.UserID = UserNum) OR (CoSysOp) THEN
      BEGIN
        PrintF('BBSLDT');
        ReadBuffer('BBSLEM');
        DisplayBuffer(BBSListMCI,@BBSList,Data2);
        NL;
        IF (PYNQ(' Delete '+BBSLIST.BBSName+'? ',0,FALSE)) THEN
        BEGIN
          SysOpLog('Deleted BBS Listing: '+BBSList.BBSName+'.');
          IF ((OnRec - 1) <= (FileSize(BBSListFile) - 2)) THEN
            FOR RecNum := (OnRec - 1) TO (FileSize(BBSListFile) - 2) DO
            BEGIN
              Seek(BBSListFile,(RecNum + 1));
              Read(BBSListFile,BBSList);
              Seek(BBSListFile,RecNum);
              Write(BBSListFile,BBSList);
            END;
          Seek(BBSListFile,(FileSize(BBSListFile) - 1));
          Truncate(BBSListFile);
          Dec(OnRec);
        END;
        Found := TRUE;
      END;
      Inc(OnRec);
    END;
    Close(BBSListFile);
    LastError := IOResult;
    BBSList_ReNumber;
    IF (NOT Found) THEN
    BEGIN
      NL;
      Print(' You may only delete BBS Listing''s that you have entered.');
      SysOpLog('Tried to delete a BBS Listing.');
    END;
  END;
END;

PROCEDURE BBSList_Edit;
VAR
  Data2: Pointer;
  BBSList: BBSListRecordType;
  OnRec: Longint;
  Found: Boolean;
  Edit : LongInt;
BEGIN
  IF (BBSList_Exists) AND (BBSListEditScreens_Exists) AND (BBSListAddScreens_Exists) THEN
  BEGIN
    Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
    Reset(BBSListFile);
    AllowContinue := FALSE;
    Found := FALSE;
    Abort := FALSE;
    OnRec := 1;
    WHILE (NOT Abort) AND (NOT HangUp) DO
    BEGIN

     PrintF('BBSLEDT');
      ReadBuffer('BBSLEM');
      While OnRec <= FileSize(BBSListFile) Do
       Begin
        Seek(BBSListFile, OnRec -1);
        Read(BBSListFile,BBSList);
        DisplayBuffer(BBSListMCI,@BBSList,Data2);
        Inc(OnRec);
       End;

      NL;
      MPL(FileSize(BBSListFile));
      InputLongIntWOC(' Edit which BBS? :',Edit,[],1,FileSize(BBSListFile));

      Abort := (Edit <> 0 );

      IF (Edit <= FileSize(BBSListFile)) AND (Edit > 0) THEN
       BEGIN
       Seek(BBSListFile,(Edit -1))
       END
      ELSE
       BEGIN
        Close(BBSListFile);
        Exit;
       END;
      Read(BBSListFile,BBSList);
      IF (BBSList.UserID = UserNum) OR (CoSysOp) OR (BBSList.SysopName = ThisUser.Name) THEN
      BEGIN
        PrintF('BBSLEH');
        ReadBuffer('BBSLEM');
        DisplayBuffer(BBSListMCI,@BBSList,Data2);
        NL;
        IF (PYNQ(' |03Would you like to edit this BBS Listing? |11',0,TRUE)) THEN

        BEGIN
          BBSListScriptFile(BBSList);
          IF (NOT Abort) THEN
          BEGIN
            PrintF('BBSNH');
            ReadBuffer('BBSMN');
            DisplayBuffer(BBSListMCI,@BBSList,Data2);
            PrintF('BBSNT');
            NL;
            IF (PYNQ(' |03Would you like to save this BBS Listing? |11',0,TRUE)) THEN
            BEGIN
              Seek(BBSListFile,(Edit -1));
              BBSList.DateEdited := GetPackDateTime;
              Write(BBSListFile,BBSList);
              SysOpLog('Edited BBS Listing: '+BBSList.BBSName+'.');
            END;
          END;
        END;
        Found := TRUE;
      END;
      {Inc(OnRec);}
      Exit;
    END;
    Close(BBSListFile);
    LastError := IOResult;
    IF (NOT Found) THEN
    BEGIN
      NL;
      Print(' You may only edit BBS Listing''s that you have entered.');
      SysOpLog('Tried to edit a BBS Listing.');
    END;
  END;
END;

PROCEDURE BBSList_View;
VAR
  Data2: Pointer;
  BBSList: BBSListRecordType;
  OnRec: Longint;
  Cnt : Byte;
BEGIN

  IF (BBSList_Exists) AND (BBSListAddScreens_Exists) THEN
  BEGIN
    Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
    Reset(BBSListFile);
    ReadBuffer('BBSMN');
    AllowContinue := TRUE;
    Abort := FALSE;
    PrintF('BBSNH');
    OnRec := 1;
    Cnt := 1;
    WHILE (OnRec <= FileSize(BBSListFile)) AND (NOT Abort) AND (NOT HangUp) DO
    BEGIN
      Seek(BBSListFile,(OnRec - 1));
      Read(BBSListFile,BBSList);
      DisplayBuffer(BBSListMCI,@BBSList,Data2);
      Inc(OnRec);
      Inc(Cnt);
      If Cnt = (23 - 4) Then
       Begin
        PauseScr(True);
        Cnt := 1;
       End
      Else
       Begin
        Cnt := Cnt;
       End;
    END;
    Close(BBSListFile);
    LastError := IOResult;
    IF (NOT Abort) THEN
      PrintF('BBSNT');
    AllowContinue := FALSE;
    SysOpLog('Viewed the BBS Listing.');
  END;
END;

PROCEDURE BBSList_xView;   (* Do we need xview *)
VAR
  Data2: Pointer;
  BBSList: BBSListRecordType;
  OnRec: Longint;
  Edit : Longint;
BEGIN
  IF (BBSList_Exists) THEN   (* Add BBSME & BBSEH exist checking here *)
  BEGIN
    Assign(BBSListFile,General.DataPath+'BBSLIST.DAT');
    Reset(BBSListFile);

      PrintF('BBSLEH');
      ReadBuffer('BBSLEM');
      OnRec := 1;
      While OnRec <= FileSize(BBSListFile) Do
       Begin
        Seek(BBSListFile, OnRec -1);
        Read(BBSListFile,BBSList);
        DisplayBuffer(BBSListMCI,@BBSList,Data2);
        Inc(OnRec);
       End;
      PrintF('BBSLET');
      NL;
      MPL(FileSize(BBSListFile));
      InputLongIntWOC(' View which BBS? :',Edit,[],1,FileSize(BBSListFile));

      Abort := (Edit <> 0 );

      IF (Edit <= FileSize(BBSListFile)) AND (Edit > 0) THEN
       BEGIN
       Seek(BBSListFile,(Edit -1));
       Read(BBSListFile,BBSList);
       Close(BBSListFile);
       END
      ELSE
       BEGIN
        Close(BBSListFile);
        Exit;
       END;

    IF (ReadBuffer('BBSME')) THEN
    BEGIN
      AllowContinue := TRUE;
      Abort := FALSE;
      PrintF('BBSEH');
      WHILE (NOT Abort) AND (NOT HangUp) DO
      BEGIN
      DisplayBuffer(BBSListMCI,@BBSList,Data2);
      PrintF('BBSET');
      AllowContinue := FALSE;
      {PauseScr(FALSE);}
      SysOpLog('Viewed Extended BBS Listing of '+BBSList.BBSName+'.');
      Exit;
      END;


    END;
    {Close(BBSListFile);}
    LastError := IOResult;
  END;
END;

END.
