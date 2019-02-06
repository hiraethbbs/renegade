Program Scroll_Lock;

Uses
    Dos,
    Crt;

Begin
mem[Seg0040:$0017] := mem[Seg0040:$0017] xor 16;
End.