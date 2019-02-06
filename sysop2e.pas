{$A+,B-,D-,E-,F+,I-,L-,N-,O+,R-,S+,V-}

{ System Configuration - System Flagged Functions }

(*  1.  Add checking for deleted users or forwarded mail to option 1 *)

UNIT SysOp2E;

INTERFACE

PROCEDURE SystemFlaggedFunctions;

IMPLEMENTATION

USES
  Crt,
  Common;

PROCEDURE SystemFlaggedFunctions;
VAR
  Cmd,
  Cmd1: Char;
  LowNum,
  HiNum,
  TempInt: Integer;
BEGIN
  REPEAT
    WITH General DO
    BEGIN
      Abort := FALSE;
      Next := FALSE;
      Print('%CL');
      NL;
      Print('  |03System Toggles');
      NL;
      PrintACR('|11  A. |03Handles allowed on system : |07'+ShowOnOff(AllowAlias)+
             '|11  B. |03Phone number in logon     : |07'+ShowOnOff(PhonePW));
      PrintACR('|11  C. |03Local security protection : |07'+ShowOnOff(LocalSec)+
             '|11  D. |03Use EMS for overlay file  : |07'+ShowOnOff(UseEMS));
      PrintACR('|11  E. |03Global activity trapping  : |07'+ShowOnOff(GlobalTrap)+
             '|11  F. |03Auto chat buffer open     : |07'+ShowOnOff(AutoChatOpen));
      PrintACR('|11  G. |03AutoMessage in logon      : |07'+ShowOnOff(AutoMInLogon)+
             '|11  H. |03Bulletins in logon        : |07'+ShowOnOff(BullInLogon));
      PrintACR('|11  I. |03User info in logon        : |07'+ShowOnOff(YourInfoInLogon)+
             '|11  J. |03Strip color off SysOp Log : |07'+ShowOnOff(StripCLog));
      PrintACR('|11  K. |03Offhook in local logon    : |07'+ShowOnOff(OffHookLocalLogon)+
             '|11  L. |03Trap Teleconferencing     : |07'+ShowOnOff(TrapTeleConf));
      PrintACR('|11  M. |03Compress file/msg numbers : |07'+ShowOnOff(CompressBases)+
             ' |11 N. |03Use BIOS for video output : |07'+ShowOnOff(UseBIOS));
      PrintACR('|11  O. |03Use IEMSI handshakes      : |07'+ShowOnOff(UseIEMSI)+
             '|11  P. |03Refuse new users          : |07'+ShowOnOff(ClosedSystem));
      PrintACR('|11  R. |03Swap shell function       : |07'+ShowOnOff(SwapShell)+
             '|11  S. |03Use shuttle logon         : |07'+ShowOnOff(ShuttleLog));
      PrintACR('|11  T. |03Chat call paging          : |07'+ShowOnOff(ChatCall)+
             '|11  U. |03Time limits are per call  : |07'+ShowOnOff(PerCall));
      PrintACR('|11  V. |03SysOp Password checking   : |07'+ShowOnOff(SysOpPWord)+
             '|11  W. |03Random quote in logon     : |07'+ShowOnOff(LogonQuote));
      PrintACR('|11  X. |03User add quote in logon   : |07'+ShowOnOff(UserAddQuote)+
             '|11  Y. |03Use message area lightbar : |07'+ShowOnOff(UseMsgAreaLightBar));
      PrintACR('|11  Z. |03Use file area lightbar    : |07'+ShowOnOff(UseFileAreaLightBar)+
             '|11  !. |03OneLiners in login        : |07'+ShowOnOff(Oneliners));
      PrintACR('                                    '+
             '|11  @. |03Wallposts in login        : |07'+ShowOnOff(Wallposts));

      PrintACR('');
      PrintACR('  |111|03. New user message sent to : |07'+AOnOff((NewApp = -1),'Off',PadLeftInt(NewApp,5))+
      PadRightStr('|03Node |15: |11%ND',34));
      PrintACR('  |112|03. Mins before TimeOut bell : |07'+AOnOff((TimeOutBell = -1),'Off',PadLeftInt(TimeOutBell,3))+
      PadRightStr('|03Time |15: |11%TI',41));
      PrintACR('  |113|03. Mins before TimeOut      : |07'+AOnOff((TimeOut = -1),'Off',PadLeftInt(TimeOut,3))+
      PadRightStr('|03Date |15: |11%DA',44));
      Prt('%LF|03  Option? [|11A|03-|11Z|03, |111|03-|113|03, |15Q|03] |15: |11');
      OneK(Cmd,'QABCDEFGHIJKLMNOPRSTUVWXYZ123!@'^M,TRUE,TRUE);
      CASE Cmd OF
        'A' : AllowAlias := NOT AllowAlias;
        'B' : BEGIN
                PhonePW := NOT PhonePW;
                IF (PhonePW) THEN
                  NewUserToggles[7] := 8
                ELSE
                  NewUserToggles[7] := 0;
              END;
        'C' : LocalSec := NOT LocalSec;
        'D' : BEGIN
                UseEMS := NOT UseEMS;
                IF (UseEMS) THEN
                  OvrUseEMS := TRUE
                ELSE
                  OvrUseEMS := FALSE;
              END;
        'E' : GlobalTrap := NOT GlobalTrap;
        'F' : AutoChatOpen := NOT AutoChatOpen;
        'G' : AutoMInLogon := NOT AutoMInLogon;
        'H' : BullInLogon := NOT BullInLogon;
        'I' : YourInfoInLogon := NOT YourInfoInLogon;
        'J' : StripCLog := NOT StripCLog;
        'K' : OffHookLocalLogon := NOT OffHookLocalLogon;
        'L' : TrapTeleConf := NOT TrapTeleConf;
        'M' : BEGIN
                CompressBases := NOT CompressBases;
                IF (CompressBases) THEN
                  Print('%LFCompressing file/message areas ...')
                ELSE
                  Print('%LFDe-compressing file/message areas ...');
                NewCompTables;
              END;
        'N' : BEGIN
                UseBIOS := NOT UseBIOS;
                DirectVideo := NOT UseBIOS;
              END;
        'O' : UseIEMSI := NOT UseIEMSI;
        'P' : ClosedSystem := NOT ClosedSystem;
        'R' : SwapShell := NOT SwapShell;
        'S' : ShuttleLog := NOT ShuttleLog;
        'T' : ChatCall := NOT ChatCall;
        'U' : PerCall := NOT PerCall;
        'V' : SysOpPWord := NOT SysOpPWord;
        'W' : LogonQuote := NOT LogonQuote;
        'X' : UserAddQuote := NOT UserAddQuote;
        'Y' : UseMsgAreaLightBar := NOT UseMsgAreaLightBar;
        'Z' : UseFileAreaLightBar := NOT UseFileAreaLightBar;
        '!' : Oneliners := NOT Oneliners;
        '@' : Wallposts := NOT Wallposts;
        '1'..'3' :
              BEGIN
                Prt('%LFSelect option [^5E^4=^5Enable^4,^5D^4=^5Disable^4,^5<CR>^4=^5Quit^4]: ');
                OneK(Cmd1,^M'ED',TRUE,TRUE);
                IF (Cmd1 IN ['E','D']) THEN
                BEGIN
                  CASE Cmd1 OF
                    'E' : BEGIN
                            CASE Cmd OF
                              '1' : BEGIN
                                      LowNum := 1;
                                      HiNum := (MaxUsers - 1);
                                      TempInt := NewApp;
                                    END;
                              '2' : BEGIN
                                      LowNum := 1;
                                      HiNum := 20;
                                      TempInt := TimeOutBell;
                                    END;
                              '3' : BEGIN
                                      LowNum := 1;
                                      HiNum := 20;
                                      TempInt := TimeOut;
                                    END;
                            END;
                            InputIntegerWOC('%LFEnter value for this function',TempInt,[NumbersOnly],LowNum,HiNum);
                          END;
                    'D' : TempInt := -1;
                  END;
                  CASE Cmd OF
                    '1' : NewApp := TempInt;
                    '2' : TimeOutBell := TempInt;
                    '3' : TimeOut := TempInt;
                  END;
                  Cmd := #0;
                END;
          END;
      END;
    END;
  UNTIL (Cmd = 'Q') OR (HangUp);
END;

END.
