
{  MD5 implementation for Turbo Pascal 6.0  }
{	    (c) 1993 Don Crusher	    }


{$A-,B-,D-,E-,F-,G-,I-,L-,N-,O-,R-,S-,V-,X-}

{.$define bp7bug}

  unit md5;

interface

  type digest = array[0..15] of byte;

  procedure md5digest(var message; len: word; var d: digest);
    {- digest a message with length len bytes, put the result in d }

implementation

  type context = array[0..3] of longint;

  var x: array[0..15] of longint;
      ctxt: context;

  function f(x,y,z: longint): longint; far;
  begin
    f := (x and y) or ((not x) and z)
  end;

  function g(x,y,z: longint): longint; far;
  begin
    g := (x and z) or (y and (not z))
  end;

  function h(x,y,z: longint): longint; far;
  begin
    h := x xor y xor z
  end;

  function i(x,y,z: longint): longint; far;
  begin
    i := y xor (x or (not z))
  end;

  function rol(x: longint; s: byte): longint;
  begin
    {$ifdef bp7bug}
    for s := 1 to s do
      if x >= 0
	then x := x+x
	else x := x+x+1;
    rol := x
    {$else}
    rol := (x shl s) or (x shr (32-s))
    {$endif}
  end;

  procedure transform;
    type fn = function(x,y,z: longint): longint;
    const fntbl: array[0..3] of fn = (f,g,h,i);
	  order: array[0..3] of byte = (0,3,2,1);
	  schedule1: array[0..63] of byte =
     (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,1,6,11,0,5,10,15,4,9,14,3,8,13,2,7,12,
      5,8,11,14,1,4,7,10,13,0,3,6,9,12,15,2,0,7,14,5,12,3,10,1,8,15,6,13,4,11,2,9);
	  schedule2: array[0..63] of byte =
     (7,12,17,22,7,12,17,22,7,12,17,22,7,12,17,22,5,9,14,20,5,9,14,20,5,9,14,20,5,9,14,20,
      4,11,16,23,4,11,16,23,4,11,16,23,4,11,16,23,6,10,15,21,6,10,15,21,6,10,15,21,6,10,15,21);
	  t: array[0..63] of longint =
     ($d76aa478,$e8c7b756,$242070db,$c1bdceee,$f57c0faf,$4787c62a,$a8304613,
      $fd469501,$698098d8,$8b44f7af,$ffff5bb1,$895cd7be,$6b901122,$fd987193,
      $a679438e,$49b40821,$f61e2562,$c040b340,$265e5a51,$e9b6c7aa,$d62f105d,
      $02441453,$d8a1e681,$e7d3fbc8,$21e1cde6,$c33707d6,$f4d50d87,$455a14ed,
      $a9e3e905,$fcefa3f8,$676f02d9,$8d2a4c8a,$fffa3942,$8771f681,$6d9d6122,
      $fde5380c,$a4beea44,$4bdecfa9,$f6bb4b60,$bebfbc70,$289b7ec6,$eaa127fa,
      $d4ef3085,$04881d05,$d9d4d039,$e6db99e5,$1fa27cf8,$c4ac5665,$f4292244,
      $432aff97,$ab9423a7,$fc93a039,$655b59c3,$8f0ccc92,$ffeff47d,$85845dd1,
      $6fa87e4f,$fe2ce6e0,$a3014314,$4e0811a1,$f7537e82,$bd3af235,$2ad7d2bb,
      $eb86d391);
    var ctct: context;
	i,n: word;
  begin
    ctct := ctxt;
    for i := 0 to 63 do
      begin
	n := order[i and 3];
	ctxt[n] := ctxt[succ(n) and 3]+rol(ctxt[n]+fntbl[i shr 4](ctxt[succ(n) and 3],
	 ctxt[succ(succ(n)) and 3],ctxt[pred(n) and 3])+x[schedule1[i]]+t[i],schedule2[i])
      end;
    for i := 0 to 3 do inc(ctxt[i],ctct[i])
  end;

  procedure md5digest(var message; len: word; var d: digest);
    const ctxtini: digest =
     ($01,$23,$45,$67,$89,$ab,$cd,$ef,$fe,$dc,$ba,$98,$76,$54,$32,$10);
    var xx: array[0..63] of byte absolute x;
	p: pointer;
	i: word;
  begin
    move(ctxtini,ctxt,16);
    p := @message;
    i := len;
    while i >= 64 do
      begin
	move(p^,x,64);
	transform;
	inc(word(p),64);
	dec(i,64)
      end;
    move(p^,x,i);
    xx[i] := $80;
    if i < 56
      then fillchar(xx[i+1],55-i,#0)
      else
	begin
	  fillchar(xx[i+1],63-i,#0);
	  transform;
	  fillchar(x,56,#0)
	end;
    x[14] := longint(len) shl 3;
    x[15] := 0;
    transform;
    move(ctxt,d,16)
  end;

end.
