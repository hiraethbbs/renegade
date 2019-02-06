Renegade BBS
======

Just my personal upgrade project of Renegade 1.19

USERM.ASC/.ANS

 ~L# = Number of time on<br />
 ~FO = First Time On<br />
 ~TT = Total Time On<br />
 ~U# = User ID { Needs help (doesn't work yet) }<br />

General MCI

%PE = Pause without a prompt, Useful if you want to have a different prompt somewhere. (..Press any Key..%PE)<br />
%NL = Empty mci, can use to pad or justify strings. (Outputs nothing.)<br />

Keyboard keys added

F1 = System Keys Help { Same as Ctrl+Home, also updated the menu so it is correct }<br />
F2 = Edit user with warning { Same as Alt+E (I really just like F keys better) }<br />
F5 = Split screen chat { Same as Alt+S ( Alt+S, F5 or Esc quits now }<br />

Ansi added
SPLTCHAT - For Split screen chat. (SysOp input starts at line 4,2, user input starts at line 14,2)

Fixes

Fixed Split Screen chat scroll.  Now it clears the texts and repositions the cursor at the top instead of going on
until both the sysop and user are typing on line 25 over and over.


Original source at https://github.com/Renegade-Exodus/RG119SRC

Rick Parish's WIN32 Port at https://github.com/rickparrish/RG119SRC
