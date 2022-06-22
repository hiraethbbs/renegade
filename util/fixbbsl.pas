Program FixBBSL;

Uses
  Dos,
  Crt,
  Common,
  BBSList;

Type

  UnixTime = Longint;

  OldBBSListRecordType =          { *.BBS file records }
    {$IFDEF WIN32} PACKED {$ENDIF} RECORD
    RecordNum    : LongInt;    { Number OF the Record For Edit }
    UserID       : LongInt;    { User ID OF person adding this }
    BBSName      : STRING[30]; { Name OF BBS                   }
    SysOpName    : STRING[30]; { SysOp OF BBS                  }
    TelnetUrl    : STRING[60]; { Telnet Urls                   }
    WebSiteUrl   : STRING[60]; { Web Site Url                  }
    PhoneNumber  : STRING[20]; { Phone number OF BBS           }
    Software
    {$IFDEF FIRSTUPDATE}
                 : STRING[8];
    {$ELSE}                    { Software used by BBS          }
                 : String[12];
    {$ENDIF}
    Speed        : STRING[8];  { Highest connect speed OF BBS  }
    Description  : STRING[60]; { Description OF BBS            }
    Description2 : STRING[60]; { Second line OF descrition     }
    DateAdded    : UnixTime;   { Date entry was added          }
    DateEdited   : UnixTime;   { Date entry was last edited    }
    XA           : STRING[8];  { sysop definable A             }
    XB           : STRING[30]; { sysop definable B             }
    XC           : STRING[30]; { sysop definable C             }
    XD           : STRING[40]; { sysop definable D             }
    XE           : STRING[60]; { sysop definable E             }
    XF           : STRING[60]; { sysop definable F             }
  END;

  NewBBSListRecordType =          { New *.BBS file records     }
    {$IFDEF WIN32} PACKED {$ENDIF} RECORD
    RecordNum,                    { Number OF the Record For Edit }
    UserID,                       { User ID OF person adding this }
    MaxNodes        : LongInt;    { Maximum Number Of Nodes       }
    Port            : Word;       { Telnet Port                   }
    BBSName         : STRING[30]; { Name OF BBS                   }
    SysOpName       : STRING[30]; { SysOp OF BBS                  }
    TelnetUrl       : STRING[60]; { Telnet Urls                   }
    WebSiteUrl      : STRING[60]; { Web Site Url                  }
    PhoneNumber     : STRING[20]; { Phone number OF BBS           }
    Location        : STRING[30]; { Location of BBS               }
    Software,                     { Software used by BBS          }
    SoftwareVersion : String[12]; { Software Version of BBS       }
    OS              : STRING[20]; { Operating System of BBS       }
    Speed           : STRING[8];  { Highest connect speed OF BBS  }
    Hours           : STRING[20]; { Hours of Operation            }
    Birth           : STRING[10]; { When The BBS Began            }
    Description     : STRING[60]; { Description OF BBS            }
    Description2    : STRING[60]; { Second line OF descrition     }
    DateAdded       : UnixTime;   { Date entry was added          }
    DateEdited      : UnixTime;   { Date entry was last edited    }
    SDA             : STRING[8];  { sysop definable A             }
    SDB             : STRING[30]; { sysop definable B             }
    SDC             : STRING[30]; { sysop definable C             }
    SDD             : STRING[40]; { sysop definable D             }
    SDE             : STRING[60]; { sysop definable E             }
    SDF             : STRING[60]; { sysop definable F             }
    SDG             : Word;       { sysop definable G             }
    SDH,                          { sysop definable H             }
    SDI             : Boolean;    { sysop definable I             }
  END;


Var

  OldBBSFile    : File Of OldBBSListRecordType;
  OldBBSDat     : OldBBSListRecordType;

  BBSFile       : File Of NewBBSListRecordType;
  BBSDat        : NewBBSListRecordType;

  i             : Integer;

  TempFile,
  Dir,
  BBSListDat    : String;


Function GetDataFile : String;
Var
  Old : String;
Begin
 GetDir(0,BBSListDat);
 BBSListDat := BBSListDat+'\DATA\BBSLIST.DAT';
 GetDir(0,Old);
 Old := Old+'\DATA\BBSLIST.OLD';
 If Exist(Old) Then
  Begin
   WriteLn;
   TextColor(12);
   Write(' ', Old);
   TextColor(4);
   WriteLn(' exists. ');
   TextColor(7);
   WriteLn(' It seems you have already run this program.  ');
   TextColor(7);
   WriteLn(' There is no need to run it again.');
   WriteLn;
   Halt;
  End
 Else If Exist(BBSListDat) Then
  Begin
   GetDataFile := BBSListDat;
   Exit;
  End
 Else
  Begin
   WriteLn;
   TextColor(12);
   Write(' ',BBSListDat);
   TextColor(4);
   WriteLn(' doesn''t exist');
   TextColor(7);
   WriteLn(' Run this from inside your RENEGADE Home Dir.');
   WriteLn;
   Halt;
  End;
End;

Begin { Main Program }

BBSListDat := GetDataFile; { Get BBSLIST.DAT or Quit }

TempFile := 'DATA\BBSTEMP.DAT';

           Assign(OldBBSFile, BBSListDat);
           Assign(BBSFile, TempFile);
           Reset(OldBBSFile);
           Rewrite(BBSFile);
           Seek(OldBBSFile, 0);
           Seek(BBSFile, 0);
           WriteLn;
           TextColor(3);
           Write(' Converting Old BBS Records ');

For i := 1 to FileSize(OldBBSFile) Do
 Begin
   Delay(200);
   TextColor(11);
   Write('.');
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
   BBSDat.SDA           := OldBBSDat.XA;
   BBSDat.SDB           := OldBBSDat.XB;
   BBSDat.SDC           := OldBBSDat.XC;
   BBSDat.SDD           := OldBBSDat.XD;
   BBSDat.SDE           := OldBBSDat.XE;
   BBSDat.SDF           := OldBBSDat.XF;

  Write(BBSFile, BBSDat);

  Seek(OldBBSFile, i);
  Seek(BBSFile, i);

 End;
TextColor(3);
WriteLn(' Done!');

GetDir(0,Dir);

WriteLn;
TextColor(3);
Write(' Copying ');
TextColor(11);
Write(Dir,'\DATA\BBSLIST.DAT ');
TextColor(3);
Write('to ');
TextColor(11);
Write(Dir,'\DATA\BBSLIST.OLD ');
TextColor(3);
Write('...');

Rename(OldBBSFile,Dir+'\DATA\BBSLIST.OLD');

TextColor(3);
WriteLn(' Done!');

TextColor(3);
Write(' Moving  ');
TextColor(11);
Write(Dir,'\DATA\BBSTEMP.DAT ');
TextColor(3);
Write('to ');
TextColor(11);
Write(Dir,'\DATA\BBSLIST.DAT ');
TextColor(3);
Write('...');

Rename(BBSFile,Dir+'\DATA\BBSLIST.DAT');

TextColor(3);
WriteLn(' Done!');
WriteLn;

Close(OldBBSFile);
Close(BBSFile);

End.