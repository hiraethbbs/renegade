Program SPLTTEST;

Uses
    Dos,
    Crt;


Var
   ChatPositions : Array [1..8] of Byte;
   Junk,Junk2     : String;
   F        : Text;
   Counter  : Byte;

Begin
 Counter := 1;

 Assign(F, 'SPLTCHAT.TPL');
  {$I+} Reset(F); {$I-}

  While Not (EOF(F)) Do
   Begin
    Readln(F,Junk);

    If (Pos('|SS',Junk) > 0) Then { Start SysOp }
     Begin
      ChatPositions[1] := Pos('|SS', Junk); { Xpos }
      ChatPositions[2] := Counter; { YPos Start }
     End { /|SS }

    Else if (Pos('|SE', Junk) > 0) Then
     Begin
      ChatPositions[3] := Counter; { YPos End }
     End; { /|SE }

    If (Pos('|SL', Junk) > 0) Then
     Begin
      ChatPositions[7] := (Pos('|SL', Junk)+2);
     End; { /|SL } { End SysOp }

    If (Pos('|US', Junk) > 0) Then { Start User }
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
WriteLn('|SS (XPos) : ', ChatPositions[1]);
WriteLn('|SS (YPos) : ', ChatPositions[2]);
WriteLn('|SE (YPos) : ', ChatPositions[3]);
WriteLn('|US (XPos) : ', ChatPositions[4]);
WriteLn('|US (YPos) : ', ChatPositions[5]);
WriteLn('|UE (YPos) : ', ChatPositions[6]);
WriteLn('|SL (XPos) : ', ChatPositions[7]);
WriteLn('|UL (XPos) : ', ChatPositions[8]);

End.