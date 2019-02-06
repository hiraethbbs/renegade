Program Update;

Uses
  Dos,
  Crt,
  Common,
  BBSList;

Type

  UnixTime = Longint;

  OldBBSListRecordType =          { *.BBS file records }
{$IFDEF WIN32} PACKED {$ENDIF} RECORD
    RecordNum: LongInt;        { Number OF the Record For Edit }
    UserID: LongInt;           { User ID OF person adding this }
    BBSName: STRING[30];       { Name OF BBS                   }
    SysOpName: STRING[30];     { SysOp OF BBS                  }
    TelnetUrl: STRING[60];     { Telnet Urls                   }
    WebSiteUrl: STRING[60];    { Web Site Url                  }
    PhoneNumber: STRING[20];   { Phone number OF BBS           }
    Software: STRING[8];       { Software used by BBS          }
    Speed: STRING[8];          { Highest connect speed OF BBS  }
    Description: STRING[60];   { Description OF BBS            }
    Description2: STRING[60];  { Second line OF descrition     }
    DateAdded: UnixTime;       { Date entry was added          }
    DateEdited: UnixTime;      { Date entry was last edited    }
    XA: STRING[8];             { sysop definable A             }
    XB: STRING[30];            { sysop definable B             }
    XC: STRING[30];            { sysop definable C             }
    XD: STRING[40];            { sysop definable D             }
    XE: STRING[60];            { sysop definable E             }
    XF: STRING[60];            { sysop definable F             }
  END;

NewBBSListRecordType =          { *.BBS file records }
{$IFDEF WIN32} PACKED {$ENDIF} RECORD
 RecordNum: LongInt;        { Number OF the Record For Edit }
    UserID: LongInt;           { User ID OF person adding this }
    BBSName: STRING[30];       { Name OF BBS                   }
    SysOpName: STRING[30];     { SysOp OF BBS                  }
    TelnetUrl: STRING[60];     { Telnet Urls                   }
    WebSiteUrl: STRING[60];    { Web Site Url                  }
    PhoneNumber: STRING[20];   { Phone number OF BBS           }
    Software: STRING[12];       { Software used by BBS          }
    Speed: STRING[8];          { Highest connect speed OF BBS  }
    Description: STRING[60];   { Description OF BBS            }
    Description2: STRING[60];  { Second line OF descrition     }
    DateAdded: UnixTime;       { Date entry was added          }
    DateEdited: UnixTime;      { Date entry was last edited    }
    XA: STRING[8];             { sysop definable A             }
    XB: STRING[30];            { sysop definable B             }
    XC: STRING[30];            { sysop definable C             }
    XD: STRING[40];            { sysop definable D             }
    XE: STRING[60];            { sysop definable E             }
    XF: STRING[60];            { sysop definable F             }
    END;


Var
  BBSListDat    : String;

  OldBBSFile    : File Of OldBBSListRecordType;
  OldBBSDat     : OldBBSListRecordType;

  BBSFile       : File Of NewBBSListRecordType;
  BBSDat        : NewBBSListRecordType;

  i             : Integer;
  TempFile,Dir      : String;


Function GetDataFile : String;
Begin
 GetDir(0,BBSListDat);
 BBSListDat := BBSListDat+'\DATA\BBSLIST.DAT';
 If Exist(BBSListDat) Then
  Begin
   GetDataFile := BBSListDat;
   Exit;
  End
 Else
  Begin
   WriteLn(BBSListDat, ' doesn''t exist');
   WriteLn('Run this from inside your RENEGADE/X Home Dir.');
   WriteLn;
   Halt;
  End;
End;

Begin { Main Program }

BBSListDat := GetDataFile; { Get BBSLIST.DAT or Quit }
TempFile := 'D:\REN\DATA\BBSTEMP.DAT';

           Assign(OldBBSFile, BBSListDat);
           Assign(BBSFile, TempFile);
           Reset(OldBBSFile);
           Rewrite(BBSFile);
           Seek(OldBBSFile, 0);
           Seek(BBSFile, 0);

For i := 1 to FileSize(OldBBSFile) Do
 Begin

   Read(OldBBSFile, OldBBSDat);

   BBSDat.RecordNum     := OldBBSDat.RecordNum;
   BBSDat.UserID        := OldBBSDat.UserID;
   BBSDat.BBSName       := OldBBSDat.BBSName;
   BBSDat.SysOpName     := OldBBSDat.SysOpName;
   BBSDat.TelnetUrl     := OldBBSDat.TelnetUrl;
   BBSDat.WebSiteUrl    := OldBBSDat.WebSiteUrl;
   BBSDat.PhoneNumber   := OldBBSDat.PhoneNumber;
   BBSDat.Software      := OldBBSDat.Software;
   BBSDat.Speed         := OldBBSDat.Speed;
   BBSDat.Description   := OldBBSDat.Description;
   BBSDat.Description2  := OldBBSDat.Description2;
   BBSDat.DateAdded     := OldBBSDat.DateAdded;
   BBSDat.DateEdited    := OldBBSDat.DateEdited;
   BBSDat.XA            := OldBBSDat.XA;
   BBSDat.XB            := OldBBSDat.XB;
   BBSDat.XC            := OldBBSDat.XC;
   BBSDat.XD            := OldBBSDat.XD;
   BBSDat.XE            := OldBBSDat.XE;
   BBSDat.XF            := OldBBSDat.XF;

  Write(BBSFile, BBSDat);

  Seek(OldBBSFile, i);
  Seek(BBSFile, i);

 End;

GetDir(0,Dir);
Rename(OldBBSFile,Dir+'\DATA\BBSLIST.OLD');
Rename(BBSFile,Dir+'\DATA\BBSLIST.DAT');

Close(OldBBSFile);
Close(BBSFile);
End.