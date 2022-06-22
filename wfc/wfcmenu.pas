{$A+,B-,D+,E-,F+,I-,L+,N-,O+,R-,S+,V-}

UNIT WFCMenu;

INTERFACE

PROCEDURE WFCMDefine;
PROCEDURE WFCMenus;

IMPLEMENTATION

USES
  Crt,
  Dos,
  Boot,
  Bulletin,
  Common,
  CUser,
  Doors,
  EMail,
  Events,
  File7,
  File10,
  File13,
  Mail1,
  Mail2,
  Mail3,
  Maint,
  Menus2,
  MsgPack,
  MultNode,
  MyIO,
  SysOp1,
  SysOp2,
  SysOp3,
  SysOp4,
  SysOp5,
  SysOp6,
  SysOp7,
  SysOp8,
  SysOp9,
  SysOp10,
  SysOp11,
  SysOp12,
  SysOp2p,
  TimeFunc,
  MiscUser;

VAR
  LastKeyPress: LongInt;

CONST
  ANSWER_LENGTH=278;
  ANSWER : array [1..278] of Char = (
     #0,#16,' ',#26,#26,'Ä',#15,'.', #7,'.', #8,'.',' ',#15,'a','n','s',
    'w','e','r','i','n','g',' ','c','a','l','l',' ', #8,'.', #7,'.',#15,
    '.', #0,#26,#28,'Ä',#24,' ',#26,'L','Ä',#24,' ','Ä', #3,'[',#11,'a',
     #3,']', #0,'Ä','Ä', #3,'3','0','0', #0,#26, #3,'Ä', #3,'[',#11,'c',
     #3,']', #0,'Ä', #3,'2','4','0','0', #0,#26, #3,'Ä', #3,'[',#11,'e',
     #3,']', #0,'Ä', #3,'7','2','0','0', #0,#26, #3,'Ä', #3,'[',#11,'g',
     #3,']',' ','1','2','0','0','0', #0,#26, #3,'Ä', #3,'[',#11,'i', #3,
    ']',' ','1','6','8','0','0', #0,#26, #3,'Ä', #3,'[',#11,'k', #3,']',
    ' ','3','8','4','0','0', #0,#26, #5,'Ä',#24,' ','Ä', #3,'[',#11,'b',
     #3,']', #0,'Ä', #3,'1','2','0','0', #0,#26, #3,'Ä', #3,'[',#11,'d',
     #3,']', #0,'Ä', #3,'4','8','0','0', #0,#26, #3,'Ä', #3,'[',#11,'f',
     #3,']', #0,'Ä', #3,'9','6','0','0', #0,#26, #3,'Ä', #3,'[',#11,'h',
     #3,']',' ','1','4','4','0','0', #0,#26, #3,'Ä', #3,'[',#11,'j', #3,
    ']',' ','1','9','2','0','0', #0,#26, #3,'Ä', #3,'[',#11,'l', #3,']',
    ' ','5','7','6','0','0', #0,#26, #5,'Ä',#24,' ',#26,'M','Ä',#24,#24,
    #24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,
    #24,#25,'N',#11,'d',#24);


{  ANSWER_LENGTH = 203;
  ANSWER: ARRAY [1..203] OF Char = (
    #11,#16,#25,#23,#15,'R','e','n','e','g','a','d','e',' ','i','s',' ',
    'a','n','s','w','e','r','i','n','g',' ','t','h','e',' ','p','h','o',
    'n','e','.',#25,#19,#24,#25,'K',#24,' ',' ',#15,'[',#14,'A',#15,']',
    ' ',' ','3','0','0',#25,#3 ,'[',#14,'C',#15,']',' ','2','4','0','0',
    #25,#3 ,'[',#14,'E',#15,']',' ','7','2','0','0',#25,#3 ,'[',#14,'G',
    #15,']',' ','1','2','0','0','0',#25,#3 ,'[',#14,'I',#15,']',' ','1',
    '6','8','0','0',#25,#3 ,'[',#14,'K',#15,']',' ','3','8','4','0','0',
    #25,#2 ,#24,' ',' ','[',#14,'B',#15,']',' ','1','2','0','0',#25,#3 ,
    '[',#14,'D',#15,']',' ','4','8','0','0',#25,#3 ,'[',#14,'F',#15,']',
    ' ','9','6','0','0',#25,#3 ,'[',#14,'H',#15,']',' ','1','4','4','0',
    '0',#25,#3 ,'[',#14,'J',#15,']',' ','1','9','2','0','0',#25,#3 ,'[',
    #14,'L',#15,']',' ','5','7','6','0','0',#25,#2 ,#24,#25,'K',#24);
 }
  WFCNET_LENGTH = 98;
  WFCNET: ARRAY [1..98] OF Char = (
    #0 ,#17,#25,'K',#24,#25,#26,#15,'R','e','n','e','g','a','d','e',' ',
    'N','e','t','w','o','r','k',' ','N','o','d','e',#25,#27,#24,#25,'K',
    #24,#25,#9 ,'P','r','e','s','s',' ','[','S','P','A','C','E','B','A',
    'R',']',' ','t','o',' ','l','o','g','i','n','.',' ',' ','P','r','e',
    's','s',' ','[','Q',']',' ','t','o',' ','q','u','i','t',' ','R','e',
    'n','e','g','a','d','e','.',#25,#10,#24,#25,'K',#24);

    {$I WFCINC.PAS}
{  WFC_LENGTH=1153;
  WFC : array [1..1153] of Char = (
     #7,#16,' ','ú',' ',' ','7',':','3','4',' ','p','m',' ',#15,'Ä', #7,
    #26, #9,'Ä',#15,'ú', #8,#26, #4,'Ä','ú',' ',#15,'w','a','i','t','i',
    'n','g',' ','f','o','r',' ','c','a','l','l',' ', #8,'ú',#26, #3,'Ä',
    #15,'ú', #7,#26, #9,'Ä',#15,'Ä','Ä',' ', #7,'0','2','-','1','0','-',
    '2','0','1','3',' ','ú',#24,' ',#15,'Ú',#26,#16,'Ä','¿',' ','Ú',#26,
    #16,'Ä','¿',' ','Ú',#26,#16,'Ä','¿',' ','Ú',#26,#15,'Ä','¿',#24,' ',
    '³',' ',' ', #8,'t','o','d','a','y',#39,'s',' ','s','t','a','t','s',
    ' ',' ',#15,'³',' ','³',' ', #8,'s','y','s','t','e','m',' ','a','v',
    'e','r','a','g','e','s',' ',#15,'³',' ','³',' ',' ', #8,'s','y','s',
    't','e','m',' ','t','o','t','a','l','s',' ',' ',#15,'³',' ','³',#25,
     #2, #8,'o','t','h','e','r',' ','i','n','f','o',#25, #2,#15,'³',#24,
    ' ','³',' ', #3,'C','a','l','l','s',#25,#10,#15,'³',' ', #7,'³',' ',
     #3,'C','a','l','l','s',#25,#10, #7,'³',' ','³',' ', #3,'C','a','l',
    'l','s',#25,#10, #7,'³',' ','ú',' ', #3,'n','o','d','e',#25,#10,#15,
    '³',#24,' ','³',' ', #3,'P','o','s','t','s',#25,#10,#15,'³',' ', #7,
    '³',' ', #3,'P','o','s','t','s',#25,#10, #7,'³',' ','³',' ', #3,'P',
    'o','s','t','s',#25,#10, #7,'³',' ','³',' ', #3,'U','n','d','e','r',
    #25, #9, #7,'³',#24,' ',#15,'³',' ', #3,'E','m','a','i','l',#25,#10,
    #15,'³',' ', #8,'³',' ', #3,'#',' ','U','L',#25,#11, #7,'³',' ', #8,
    '³',' ', #3,'#',' ','U','L',#25,#11, #8,'³',' ', #7,'³',' ', #3,'E',
    'r','r','o','r','s',#25, #8, #7,'³',#24,' ','ú',' ', #3,'N','e','w',
    'u','s','e','r','s',#25, #7, #7,'ú',' ', #8,'³',' ', #3,'#',' ','D',
    'L',#25,#11, #8,'³',' ','³',' ', #3,'#',' ','D','L',#25,#11, #7,'ú',
    ' ', #8,'³',' ', #3,'M','a','i','l',#25,#10, #8,'³',#24,' ',#15,'³',
    ' ', #3,'F','e','e','d','b','a','c','k',#25, #7, #7,'³',#25, #2, #3,
    'A','c','t','i','v','i','t','y',#25, #7, #8,'³',#25, #2, #3,'D','a',
    'y','s',#25,#11, #7,'ú',' ', #8,'³',' ', #3,'U','s','e','r','s',#24,
    ' ', #7,'³',' ', #3,'#',' ','U','L',#25,#11, #8,'³',#24,' ', #7,'³',
    ' ', #3,'B','y','t','e','s',' ','U','L',#25, #7, #8,'³',#25,#24, #7,
    'Ä',' ', #8,'m','o','d','e','m',' ', #7,'Ä',#24,' ','ú',' ', #3,'#',
    ' ','D','L',#25,#11, #7,'ú',#25,'9', #8,'ú',#24,' ','³',' ', #3,'B',
    'y','t','e','s',' ','D','L',#25,'B', #8,'³',#24,' ','³',' ', #3,'M',
    'i','n','u','t','e','s',#25, #8, #8,'ú',#24,#25, #2, #3,'O','v','e',
    'r','l','a','y','s',#25, #7, #8,'³',#25,'9', #7,'³',#24,#25, #2, #3,
    'F','r','e','e',#25,#11, #7,'³',#25,'9','³',#24,#25,#18,'À',#26, #8,
    'Ä',#15,'Ä','Ä',' ', #7,'Ä',' ',#26, #6,'Ä', #8,'ú',#26, #4,'Ä',#15,
    #26, #3,'Ä', #8,'Ä','Ä',' ','Ä','ú',#26, #4,'Ä', #7,#26, #4,'Ä',' ',
    'Ä','Ä','Ä',#15,#26, #3,'Ä', #7,#26, #3,'Ä','Ù',#24,#24,' ',#15,'Ú',
    #26, #3,'Ä', #7,'ú',#15,#26, #8,'Ä', #7,#26, #3,'Ä',#15,'Ä','Ä','Ä',
     #7,'ú',#15,'Ä','Ä', #7,'Ä','Ä','Ä', #8,#26, #3,'Ä',' ','ú',' ','c',
    'o','m','m','a','n','d','s',' ','ú',' ',#26, #3,'Ä', #7,'Ä','Ä','Ä',
    #15,#26, #9,'Ä', #7,'Ä','Ä','ú',#26, #3,'Ä',#15,#26, #6,'Ä','¿',#24,
    ' ', #7,'³',' ', #3,'[',#11,'s', #3,']','y','s','t','e','m',' ','c',
    'o','n','f','i','g',' ','[',#11,'f', #3,']','i','l','e',' ','b','a',
    's','e',#25, #3,'[',#11,'c', #3,']','a','l','l','e','r','s',#25, #3,
    '[',#11,'i', #3,']','n','i','t',' ','m','o','d','e','m',#25, #3,'[',
    #11,'!', #3,']',' ','v','a','l','i','d','a','t','e',#25, #2, #7,'³',
    #24,' ','³',' ', #3,'[',#11,'u', #3,']','s','e','r',' ','e','d','i',
    't','o','r',#25, #2,'[',#11,'b', #3,']','M','s','g',' ','b','a','s',
    'e',#25, #3,'[',#11,'p', #3,']','a','c','k',' ','m','s','g','s',' ',
    ' ','[',#11,'o', #3,']','f','f','h','o','o','k',' ','m','o','d','e',
    'm',' ','[',#11,'l', #3,']','o','g','s',#25, #8, #7,'³',#24,' ', #8,
    '³',' ', #3,'[',#11,'#', #3,']','M','e','n','u',' ','e','d','i','t',
    'o','r',' ',' ','[',#11,'x', #3,']','f','e','r',' ','p','r','o','t',
    's',#25, #2,'[',#11,'m', #3,']','a','i','l',' ','r','e','a','d',' ',
    ' ','[',#11,'a', #3,']','n','s','w','e','r',' ','m','o','d','e','m',
    ' ',' ','[',#11,'z', #3,']',' ','h','i','s','t','o','r','y',#25, #3,
     #8,'³',#24,' ','ú',' ', #3,'[',#11,'e', #3,']','v','e','n','t',' ',
    'e','d','i','t','o','r',' ',' ','[',#11,'w', #3,']','r','i','t','e',
    ' ','m','a','i','l',#25, #2,'[',#11,'r', #3,']','e','a','d',' ','m',
    'a','i','l',' ',' ','[',#11,'h', #3,']','a','n','g','u','p',' ','m',
    'o','d','e','m',' ',' ','[',#11,'d', #3,']','r','o','p',' ','t','o',
    ' ','d','o','s',' ',' ', #8,'ú',#24,' ','ú',' ', #3,'[',#11,'v', #3,
    ']','o','t','i','n','g',' ','e','d','i','t','o','r',' ','[',#11,'$',
     #3,']','c','o','n','f',' ','e','d','i','t',#25, #2,'[',' ',']',' ',
    'l','o','g',' ','o','n',#25, #2,'[',#11,'n', #3,']','o','d','e',' ',
    'l','i','s','t','i','n','g',' ',' ','[',#11,'q', #3,']','u','i','t',
    ' ','t','o',' ','d','o','s',' ',' ', #8,'³',#24,#24,#24); }

{  WFC_LENGTH = 1153;
  WFC : ARRAY [1..1153] OF Char = (
    #11,#19,#25,#22,' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
    'g','o','d','t','a',' ','b','b','s',' ',' ',' ',' ',' ',' ',' ',' ',
    ' ',' ',' ',' ',#25,#22,#24,' ', #11,'Ú',#26,#16,'Ä', #11,'¿',' ', #0,
    'Ú',#26,#16,'Ä', #9,'¿',' ', #0,'Ú',#26,#16,'Ä', #9,'¿',' ', #0,'Ú',
    #26,#15,'Ä', #9,'¿',' ',#24,' ', #0,'³',' ',' ',#11,'T','o','d','a',
    'y',#39,'s',' ','S','t','a','t','s',' ',' ', #11,'³',' ', #0,'³',' ',
    #10,'S','y','s','t','e','m',' ','A','v','e','r','a','g','e','s',' ',
     #9,'³',' ', #0,'³',' ',' ',#10,'S','y','s','t','e','m',' ','T','o',
    't','a','l','s',' ',' ', #9,'³',' ', #0,'³',#25, #11,#19,'O','t','h',
    'e','r',' ','I','n','f','o',#25, #2, #9,'³',' ',#24,' ', #0,'³',' ',
    #15,'C','a','l','l','s',#25,#10, #9,'³',' ', #0,'³',' ',#15,'C','a',
    'l','l','s',#25,#10, #9,'³',' ', #0,'³',' ',#15,'C','a','l','l','s',
    #25,#10, #9,'³',' ', #0,'³',' ',#15,'n','o','d','e',#25,#10, #9,'³',
    ' ',#24,' ', #0,'³',' ',#15,'P','o','s','t','s',#25,#10, #9,'³',' ',
     #0,'³',' ',#15,'P','o','s','t','s',#25,#10, #9,'³',' ', #0,'³',' ',
    #15,'P','o','s','t','s',#25,#10, #9,'³',' ', #0,'³',' ',#15,'U','n',
    'd','e','r',#25, #9, #9,'³',' ',#24,' ', #0,'³',' ',#15,'E','m','a',
    'i','l',#25,#10, #9,'³',' ', #0,'³',' ',#15,'#',' ','U','L',#25,#11,
     #9,'³',' ', #0,'³',' ',#15,'#',' ','U','L',#25,#11, #9,'³',' ', #0,
    '³',' ',#15,'E','r','r','o','r','s',#25, #8, #9,'³',' ',#24,' ', #0,
    '³',' ',#15,'N','e','w','u','s','e','r','s',#25, #7, #9,'³',' ', #0,
    '³',' ',#15,'#',' ','D','L',#25,#11, #9,'³',' ', #0,'³',' ',#15,'#',
    ' ','D','L',#25,#11, #9,'³',' ', #0,'³',' ',#15,'M','a','i','l',#25,
    #10, #9,'³',' ',#24,' ', #0,'³',' ',#15,'F','e','e','d','b','a','c',
    'k',#25, #7, #9,'³',' ', #0,'³',' ',#15,'A','c','t','i','v','i','t',
    'y',#25, #7, #9,'³',' ', #0,'³',' ',#15,'D','a','y','s',#25,#11, #9,
    '³',' ', #0,'³',' ',#15,'U','s','e','r','s',#25, #9, #9,'³',' ',#24,
    ' ', #0,'³',' ',#15,'#',' ','U','L',#25,#11, #9,'³',' ', #0,'À', #9,
    #26,#16,'Ä','Ù',' ', #0,'À', #9,#26,#16,'Ä','Ù',' ', #0,'À', #9,#26,
    #15,'Ä','Ù',' ',#24,' ', #0,'³',' ',#15,'K','b',' ','U','L',#25,#10,
     #9,'³',' ', #0,'Ú',#26,#23,'Ä',' ',#15,'M','o','d','e','m',' ', #0,
    #26,#24,'Ä', #9,'¿',' ',#24,' ', #0,'³',' ',#15,'#',' ','D','L',#25,
    #11, #9,'³',' ', #0,'³',#16,#25,'7', #9,#17,'³',' ',#24,' ', #0,'³',
    ' ',#15,'K','b',' ','D','L',#25,#10, #9,'³',' ', #0,'³',#16,#25,'7',
     #9,#17,'³',' ',#24,' ', #0,'³',' ',#15,'M','i','n','u','t','e','s',
    #25, #8, #9,'³',' ', #0,'³',#16,#25,'7', #9,#17,'³',' ',#24,' ', #0,
    '³',' ',#15,'O','v','e','r','l','a','y','s',#25, #7, #9,'³',' ', #0,
    '³',#16,#25,'7', #9,#17,'³',' ',#24,' ', #0,'³',' ',#15,'F','r','e',
    'e',' ',' ',' ',' ',' ',#25, #6, #9,'³',' ', #0,'³',#16,#25,'7', #9,
    #17,'³',' ',#24,' ', #0,'À', #9,#26,#16,'Ä','Ù',' ', #0,'À', #9,#26,
    '7','Ä','Ù',' ',#24,#25,'O',#24,' ', #0,'Ú',#26,'K','Ä', #9,'¿',' ',
    #24,' ', #0,'³',' ',#15,'[',#14,'S',#15,']','y','s','t','e','m',' ',
    'C','o','n','f','i','g',' ','[',#14,'F',#15,']','i','l','e',' ','B',
    'a','s','e',#25, #3,'[',#14,'C',#15,']','a','l','l','e','r','s',#25,
     #3,'[',#14,'I',#15,']','n','i','t',' ','M','o','d','e','m',#25, #3,
    '[',#14,'!',#15,']','V','a','l','i','d','a','t','e',#25, #3, #9,'³',
    ' ',#24,' ', #0,'³',' ',#15,'[',#14,'U',#15,']','s','e','r',' ','E',
    'd','i','t','o','r',#25, #2,'[',#14,'B',#15,']','M','s','g',' ','B',
    'a','s','e',#25, #3,'[',#14,'P',#15,']','a','c','k',' ','M','s','g',
    's',' ',' ','[',#14,'O',#15,']','f','f','h','o','o','k',' ','M','o',
    'd','e','m',' ','[',#14,'L',#15,']','o','g','s',#25, #8, #9,'³',' ',
    #24,' ', #0,'³',' ',#15,'[',#14,'#',#15,']','M','e','n','u',' ','E',
    'd','i','t','o','r',' ',' ','[',#14,'X',#15,']','f','e','r',' ','P',
    'r','o','t','s',#25, #2,'[',#14,'M',#15,']','a','i','l',' ','R','e',
    'a','d',' ',' ','[',#14,'A',#15,']','n','s','w','e','r',' ','M','o',
    'd','e','m',' ',' ','[',#14,'Z',#15,']','H','i','s','t','o','r','y',
    #25, #4, #9,'³',' ',#24,' ', #0,'³',' ',#15,'[',#14,'E',#15,']','v',
    'e','n','t',' ','E','d','i','t','o','r',' ',' ','[',#14,'W',#15,']',
    'r','i','t','e',' ','M','a','i','l',#25, #2,'[',#14,'R',#15,']','e',
    'a','d',' ','M','a','i','l',' ',' ','[',#14,'H',#15,']','a','n','g',
    'u','p',' ','M','o','d','e','m',' ',' ','[',#14,'D',#15,']','r','o',
    'p',' ','t','o',' ','D','O','S',' ',' ', #9,'³',' ',#24,' ', #0,'³',
    ' ',#15,'[',#14,'V',#15,']','o','t','i','n','g',' ','E','d','i','t',
    'o','r',' ','[',#14,'$',#15,']','C','o','n','f','e','r','e','n','c',
    'e','s',' ','[',' ',']',' ','L','o','g',' ','O','n',#25, #2,'[',#14,
    'N',#15,']','o','d','e',' ','l','i','s','t','i','n','g',' ',' ','[',
    #14,'Q',#15,']','u','i','t',' ','t','o',' ','D','O','S',' ',' ', #9,
    '³',' ',#24,' ', #0,'À', #9,#26,'K','Ä','Ù',' ',#24,#24);

 }
  WFC0_LENGTH = 488;
  WFC0: ARRAY [1..488] OF Char = (
    #11,#19,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,
    #24,#24,#17,' ', #0,'Ú',#26,'K','Ä', #9,'¿',' ',#24,' ', #0,'³',' ',
    #15,'[',#14,'S',#15,']','y','s','t','e','m',' ','C','o','n','f','i',
    'g',' ','[',#14,'F',#15,']','i','l','e',' ','B','a','s','e',#25, #3,
    '[',#14,'C',#15,']','a','l','l','e','r','s',#25, #3,'[',#14,'I',#15,
    ']','n','i','t',' ','M','o','d','e','m',#25, #3,'[',#14,'!',#15,']',
    'V','a','l','i','d','a','t','e',#25, #3, #9,'³',' ',#24,' ', #0,'³',
    ' ',#15,'[',#14,'J',#15,']','u','m','p',' ','t','o',' ','D','O','S',
    #25, #2,'[',#14,'B',#15,']','M','s','g',' ','B','a','s','e',#25, #3,
    '[',#14,'P',#15,']','a','c','k',' ','M','s','g','s',' ',' ','[',#14,
    'O',#15,']','f','f','h','o','o','k',' ','M','o','d','e','m',' ','[',
    #14,'L',#15,']','o','g','s',#25, #8, #9,'³',' ',#24,' ', #0,'³',' ',
    #15,'[',#14,'#',#15,']','M','e','n','u',' ','E','d','i','t','o','r',
    ' ',' ','[',#14,'X',#15,']','f','e','r',' ','P','r','o','t','s',#25,
     #2,'[',#14,'M',#15,']','a','i','l',' ','R','e','a','d',' ',' ','[',
    #14,'A',#15,']','n','s','w','e','r',' ','M','o','d','e','m',' ',' ',
    '[',#14,'Z',#15,']','H','i','s','t','o','r','y',#25, #4, #9,'³',' ',
    #24,' ', #0,'³',' ',#15,'[',#14,'E',#15,']','v','e','n','t',' ','E',
    'd','i','t','o','r',' ',' ','[',#14,'W',#15,']','r','i','t','e',' ',
    'M','a','i','l',#25, #2,'[',#14,'R',#15,']','e','a','d',' ','M','a',
    'i','l',' ',' ','[',#14,'H',#15,']','a','n','g','u','p',' ','M','o',
    'd','e','m',' ',' ','[',#14,'U',#15,']','s','e','r',' ','E','d','i',
    't','o','r',' ',' ', #9,'³',' ',#24,' ', #0,'³',' ',#15,'[',#14,'V',
    #15,']','o','t','i','n','g',' ','E','d','i','t','o','r',' ','[',#14,
    '$',#15,']','C','o','n','f','e','r','e','n','c','e','s',' ','[',#14,
    'D',#15,']','i','s','p','l','a','y',' ','N','S',' ','[',#14,'N',#15,
    ']','o','d','e',' ','l','i','s','t','i','n','g',' ',' ','[',#14,'Q',
    #15,']','u','i','t',' ','t','o',' ','D','O','S',' ',' ', #9,'³',' ',
    #24,' ', #0,'À', #9,#26,'K','Ä','Ù',' ',#24,#24);

PROCEDURE WFCMDefine;
BEGIN
  UploadsToday := 0;
  DownloadsToday := 0;
  UploadKBytesToday := 0;
  DownloadKBytesToday := 0;
  PrivatePostsToday := 0;
  PublicPostsToday := 0;
  FeedbackPostsToday := 0;
  ChatAttempts := 0;
  ShutUpChatCall := FALSE;
  ContList := FALSE;
  BadDLPath := FALSE;
  TellUserEvent := 0;
  TimeWarn := FALSE;
  FastLogon := FALSE;
  FileArea := 1;
  MsgArea := 1;
  ReadFileArea := -1;
  ReadMsgArea := -1;
  InWFCMenu := TRUE;
  Reading_A_Msg := FALSE;
  OutCom := FALSE;
  UserOn := FALSE;
  LastLineStr := '';
  ChatReason := '';
  Buf := '';
  HangUp := FALSE;
  ChatCall := FALSE;
  HungUp := FALSE;
  TimedOut := FALSE;
  Rate := 3840;
  ANSIDetected := FALSE;
  TextAttr := (General.WFCFg + (16 * General.WFCBg));;
  ClrScr;
  UserNum := 0;
  IF ((MaxUsers - 1) >= 1) THEN
  BEGIN
    LoadURec(ThisUser,1);
    TempPause := (Pause IN ThisUser.Flags);
    Reset(SchemeFile);
    IF (ThisUser.ColorScheme > 0) AND (ThisUser.ColorScheme <= FileSize(SchemeFile)) THEN
      Seek(SchemeFile,(ThisUser.ColorScheme - 1));
    Read(SchemeFile,Scheme);
    Close(SchemeFile);
    NewCompTables;
    UserNum := 1;
  END
  ELSE
    WITH ThisUser DO
    BEGIN
      LineLen := 80;
      PageLen := 24;
      Flags := [HotKey,Pause,Novice,ANSI,Color];
      Exclude(Flags,Avatar);
      Reset(SchemeFile);
      Read(SchemeFile,Scheme);
      Close(SchemeFile);
    END;
END;

PROCEDURE GetConnection;
VAR
  s: AStr;
  C: Char;
  Done: Boolean;
  rl,
  SaveTimer: LongInt;

  PROCEDURE GetResultCode(CONST ResultCode: AStr);
  VAR
    MaxCodes: Byte;
  BEGIN
    MaxCodes := MaxResultCodes;    { NOTE!  Done backwards to avoid CONNECT 1200 / CONNECT 12000 confusion!! }
    Reliable := (Pos(Liner.Reliable,ResultCode) > 0);
    WITH Liner DO
    REPEAT
      IF (Connect[MaxCodes] <> '') AND (Pos(Connect[MaxCodes],ResultCode) > 0) THEN
      BEGIN
        CASE MaxCodes OF
           1 : ActualSpeed := 300;
           2 : ActualSpeed := 600;
           3 : ActualSpeed := 1200;
           4 : ActualSpeed := 2400;
           5 : ActualSpeed := 4800;
           6 : ActualSpeed := 7200;
           7 : ActualSpeed := 9600;
           8 : ActualSpeed := 12000;
           9 : ActualSpeed := 14400;
          10 : ActualSpeed := 16800;
          11 : ActualSpeed := 19200;
          12 : ActualSpeed := 21600;
          13 : ActualSpeed := 24000;
          14 : ActualSpeed := 26400;
          15 : ActualSpeed := 28800;
          16 : ActualSpeed := 31200;
          17 : ActualSpeed := 33600;
          18 : ActualSpeed := 38400;
          19 : ActualSpeed := 57600;
          20 : ActualSpeed := 115200;
        END;
        Done := TRUE;
      END
      ELSE
        Dec(MaxCodes);
    UNTIL (Done) OR (MaxCodes = 1);
  END;

BEGIN
  IF (AnswerBaud > 0) THEN
  BEGIN
    ActualSpeed := AnswerBaud;
    IF (LockedPort IN Liner.MFlags) THEN
      ComPortSpeed := Liner.InitBaud
    ELSE
      ComPortSpeed := ActualSpeed;
    AnswerBaud := 0;
    InCom := TRUE;
    Exit;
  END;

  Reliable := FALSE;    { Could've been set in boot - don't move }

  Com_Flush_Recv;
  IF (Liner.Answer <> '') THEN
    Com_Send_Str(Liner.Answer);

  IF (SysOpOn) THEN
    Update_Logo(ANSWER,ScreenAddr[(3*2)+(19*160)-162],ANSWER_LENGTH);

  rl := 0;
  SaveTimer := Timer;

  s := '';

  REPEAT
    Done := FALSE;

    IF (KeyPressed) THEN
    BEGIN

       C := UpCase(ReadKey);

       IF (C = ^[) THEN
       BEGIN
         DTR(FALSE);
         Done := TRUE;
         Com_Send_Str(Liner.HangUp);
         Delay(100);
         DTR(TRUE);
         Com_Flush_Recv;
       END;

       CASE C OF
         'A' : ActualSpeed := 300;
         'B' : ActualSpeed := 1200;
         'C' : ActualSpeed := 2400;
         'D' : ActualSpeed := 4800;
         'E' : ActualSpeed := 7200;
         'F' : ActualSpeed := 9600;
         'G' : ActualSpeed := 12000;
         'H' : ActualSpeed := 14400;
         'I' : ActualSpeed := 16800;
         'J' : ActualSpeed := 19200;
         'K' : ActualSpeed := 38400;
         'L':  ActualSpeed := 57600;
       END;
       Done := TRUE;
    END;

    C := CInKey;
    IF (rl <> 0) AND (ABS(rl - Timer) > 2) AND (C = #0) THEN
      C := ^M;
    IF (C > #0) THEN
    BEGIN
      WriteWFC(C);
      IF (C <> ^M) THEN
      BEGIN
        IF (Length(s) >= 160) THEN
          Delete(s,1,120);
        s := s + C;
        rl := Timer;
      END
      ELSE
      BEGIN
        IF (Pos(Liner.NoCarrier,s) > 0) THEN
          Done := TRUE;
        IF (Pos(Liner.CallerID,s) > 0) THEN
          CallerIDNumber := Copy(s,Pos(Liner.CallerID,s) + Length(Liner.CallerID),40);
        GetResultCode(s);
        rl := 0;
      END;
    END;
    IF (C = ^M) THEN
      s := '';
    IF (ABS(Timer - SaveTimer) > 45) THEN
      Done := TRUE;
  UNTIL (Done);


  Com_Flush_Recv;

  IF (ABS(Timer - SaveTimer) > 45) THEN
    C := 'X';

  InCom := (ActualSpeed <> 0);

  IF (InCom) AND (LockedPort IN Liner.MFlags) THEN
    ComPortSpeed := Liner.InitBaud
  ELSE
    ComPortSpeed := ActualSpeed;

END;

PROCEDURE WFCDraw;
VAR
  HistoryFile: FILE OF HistoryRecordType;
  History: HistoryRecordType;
  s: STRING[10];
  L: LongInt;
BEGIN
  Window(1,1,MaxDisplayCols,MaxDisplayRows);
  LastWFCX := 1;
  LastWFCY := 1;
  CursorOn(FALSE);
  ClrScr;
  IF (AnswerBaud > 0) THEN
    Exit;

  IF (NOT BlankMenuNow) AND (SysOpOn) THEN
  BEGIN

    IF (SysOpOn) THEN
    BEGIN

      PrintF('WFC.ANS');
      IF (NoFile) THEN
      Begin
       Update_Logo(WFC,ScreenAddr[0],WFC_LENGTH);
      End;

      IF (General.NetworkMode) THEN
        Update_Logo(WFCNET,ScreenAddr[(3*2)+(19*160)-162],WFCNET_LENGTH);

      LoadURec(ThisUser,1);


      TextAttr := (General.WFCFg + (16 * General.WFCBg));
      GoToXY(4,1);
      Write(PadRightStr(TimeStr,8));
      GoToXY(68,1);
      Write(DateStr);

      Assign(HistoryFile,General.DataPath+'HISTORY.DAT');
      IF (NOT Exist(General.DataPath+'HISTORY.DAT')) THEN
      BEGIN
        ReWrite(HistoryFile);
        WITH History DO
        BEGIN
          Date := Date2PD(DateStr);
          Active := 0;
          Callers := 0;
          NewUsers := 0;
          Posts := 0;
          EMail := 0;
          FeedBack := 0;
          Errors := 0;
          Uploads := 0;
          Downloads := 0;
          UK := 0;
          Dk := 0;
          FOR L := 0 TO 20 DO
            UserBaud[L] := 0;
        END;
        Write(HistoryFile,History);
      END
      ELSE
      BEGIN
        Reset(HistoryFile);
        Seek(HistoryFile,(FileSize(HistoryFile) - 1));
        Read(HistoryFile,History);
      END;
      Close(HistoryFile);

      WITH History DO
      BEGIN
        { WFCFg, WFCBg }


        TextAttr := (General.WFCFg + (16 * General.WFCBg));

        GoToXY(14,04);
        Write(PadRightInt(Callers,5));

        GoToXY(14,05);
        Write(PadRightInt(Posts,5));

        GoToXY(14,06);
        Write(PadRightInt(EMail,5));

        GoToXY(14,07);
        Write(PadRightInt(NewUsers,5));

        GoToXY(14,08);
        Write(PadRightInt(FeedBack,5));

        GoToXY(14,09);
        Write(PadRightInt(Uploads,5));

        {TextAttr := 3; }
        S := ConvertBytes(UK * 1024,FALSE);
{        GoToXY(04,10);
        Write(Copy(S,(Pos(' ',S) + 1),Length(S))+' UL'); }

{        TextAttr := 11; }
        GoToXY(14,10);
        Write(PadRightStr(Copy(S,1,(Pos(' ',S) - 1)),5));

        GoToXY(14,11);
        Write(PadRightInt(Downloads,5));

{        TextAttr := 3; }
        S := ConvertBytes(DK * 1024,FALSE);
{        GoToXY(04,12);
        Write(Copy(S,(Pos(' ',S) + 1),Length(S))+' DL'); }

{        TextAttr := 11;}
        GoToXY(14,12);
        Write(PadRightStr(Copy(S,1,(Pos(' ',S) - 1)),5));

        GoToXY(14,13);
        Write(PadRightInt(Active,5));
        GoToXY(14,14);

        CASE OverlayLocation OF
          0 : Write(' Disk');
          1 : Write('  EMS');
          2 : Write('  XMS');
        END;

        GoToXY(11,15);
        L := DiskKBFree(StartDir);
        IF (L < General.MinSpaceForUpload) OR (L < General.MinSpaceForPost) THEN
        TextAttr := (General.WFCFg + (16 * General.WFCBg));

        Write(PadRightStr(ConvertKB(L,FALSE),8));
        TextAttr := (General.WFCFg + (16 * General.WFCBg));;

        IF (General.DaysOnline = 0) THEN
          Inc(General.DaysOnline);
        GoToXY(34,04);
        Str(((General.TotalCalls + Callers) / General.DaysOnline):2:2,s);
        Write(PadRightStr(s,5));

        GoToXY(34,05);
        Str(((General.TotalPosts + Posts) / General.DaysOnline):2:2,s);
        Write(PadRightStr(s,5));

        GoToXY(34,06);
        Str(((General.TotalUloads + Uploads) / General.DaysOnline):2:2,s);
        Write(PadRightStr(s,5));

        GoToXY(34,07);
        Str(((General.TotalDloads + Downloads) / General.DaysOnline):2:2,s);
        Write(PadRightStr(s,5));

        GoToXY(34,08);
        Str(((General.TotalUsage + Active) / General.DaysOnline) / 14.0:2:2,s);
        Write(PadRightStr(s,4),'%');

        GoToXY(53,04);
        Write(PadRightInt(General.CallerNum,6));

        GoToXY(53,05);
        Write(PadRightInt((General.TotalPosts + Posts),6));

        GoToXY(53,06);
        Write(PadRightInt((General.TotalUloads + Uploads),6));

        GoToXY(53,07);
        Write(PadRightInt((General.TotalDloads + Downloads),6));

        GoToXY(53,08);
        Write(PadRightInt(General.DaysOnline,6));

        GoToXY(73,04);
        Write(PadRightInt(ThisNode,5));

        GoToXY(73,5);
        CASE Tasker OF
          None     : Write('  DOS');
          DV       : Write('   DV');
          Win      : Write('  Win');
          OS2      : Write(' OS/2');
          Win32    : Write('Win32');
          Dos5N    : Write('DOS/N');
          FreeDOS  : BEGIN GoToXY(71,5); Write('FreeDOS'); END;
        END;

        GoToXY(73,06);
        Write(PadRightInt(Errors,5));

        IF (ThisUser.Waiting > 0) THEN
          TextAttr := (15 + (16 * General.WFCBg));;
        GoToXY(73,07);
        Write(PadRightInt(ThisUser.Waiting,5));

        TextAttr := (General.WFCFg + (16 * General.WFCBg));;
        GoToXY(73,08);
        Write(PadRightInt(General.NumUsers,5));

        IF (General.TotalUsage < 1) OR (General.DaysOnline < 1) THEN
          UpdateGeneral;
        TextAttr := 7;
      END;
    END
    ELSE
      Update_Logo(WFC0,ScreenAddr[0],WFC0_LENGTH);
  END;
END;

PROCEDURE WFCMenus;
CONST
  RingNumber: Byte = 0;
  MultiRinging: Boolean = FALSE;
VAR
  WFCMessage,
  s: AStr;
  C,
  c2: Char;
  UNum: Integer;
  LastRing,
  LastMinute,
  rl2,
  LastInit: LongInt;
  InBox,
  RedrawWFC,
  PhoneOffHook,
  CheckForConnection: Boolean;

  PROCEDURE InitModem;
  VAR
    s: AStr;
    C: Char;
    try: Integer;
    rl,
    rl1: LongInt;
    done: Boolean;
  BEGIN
    C := #0;
    done := FALSE;
    try := 0;
    IF ((Liner.Init <> '') AND (AnswerBaud = 0) AND (NOT LocalIOOnly)) THEN
    BEGIN
      IF (SysOpOn) AND (NOT BlankMenuNow) THEN
      BEGIN
        TextAttr := (15 + (16 * General.WFCBg));;
        GoToXY(1,17);
        ClrEOL;
        GoToXY(31,17);
        Write('Initializing Modem ...');
       END;
       rl := Timer;

       WHILE (KeyPressed) DO
         C := ReadKey;

       REPEAT
         Com_Set_Speed(Liner.InitBaud);
         Com_Flush_Recv;
         Com_Send_Str(Liner.Init);
         s := '';
         rl1 := Timer;
         REPEAT
           C := CInKey;
           IF (C > #0) THEN
           BEGIN
             WriteWFC(C);
             IF (Length(s) >= 160) THEN
               Delete(s,1,120);
             s := s + C;
             IF (Pos(Liner.OK, s) > 0) THEN
               Done := TRUE;
           END;
         UNTIL ((ABS(Timer - rl1) > 3) OR (done)) OR (KeyPressed);
         Com_Flush_Recv;
         Inc(try);
         IF (try > 10) THEN
           Done := TRUE;
       UNTIL ((done) OR (KeyPressed));
       IF (SysOpOn) AND (NOT BlankMenuNow) THEN
       BEGIN
         GoToXY(1,17);
         ClrEOL;
         TextAttr := (15 + (16 * General.WFCBg));
         WFCMessage := 'Waiting For Call';
       END;
    END;
    PhoneOffHook := FALSE;
    WFCMessage := 'Waiting For Call';
    LastInit := Timer;
    WHILE (KeyPressed) DO
      C := ReadKey;
    Com_Flush_Recv;
    TextAttr := (15 + (16 * General.WFCBg));;
  END;

  FUNCTION CPW: Boolean;
  VAR
    PW: Str20;
  BEGIN
    IF (NOT SysOpOn) THEN
    BEGIN
      TextAttr := 25;
      Write('Password: ');
      TextAttr := 17;
      GetPassword(PW,20);
      ClrScr;
      CPW := (PW = General.SysOpPW);
    END
    ELSE
      CPW := TRUE;
  END;

  PROCEDURE TakeOffHook(ShowIt: Boolean);
  BEGIN
    IF (NOT LocalIOOnly) THEN
    BEGIN
      DoPhoneOffHook(ShowIt);
      PhoneOffHook := TRUE;
      TextAttr := (15 + (16 * General.WFCBg));;
      WFCMessage := 'Modem Off Hook';
    END;
  END;

  PROCEDURE BeepHim;
  VAR
    C: Char;
    rl,
    rl1: LongInt;
  BEGIN
    TakeOffHook(FALSE);
    BeepEnd := FALSE;
    rl := Timer;
    REPEAT
      Sound(1500);
      Delay(20);
      Sound(1000);
      Delay(20);
      Sound(800);
      Delay(20);
      NoSound;
      rl1 := Timer;
      WHILE (ABS(rl1 - Timer) < 0.9) AND (NOT KeyPressed) DO;
    UNTIL (ABS(rl - Timer) > 30) OR (KeyPressed);
    IF (KeyPressed) THEN
      C := ReadKey;
    InitModem;
  END;

  PROCEDURE PackAllBases;
  BEGIN
    ClrScr;
    TempPause := FALSE;
    DoShowPackMessageAreas;
    SysOpLog('Message areas packed');
    WFCDraw;
  END;

  PROCEDURE ChkEvents;
  VAR
    EventNum: Byte;
    RCode: Integer;
  BEGIN
    IF (CheckEvents(0) <> 0) THEN
      FOR EventNum := 1 TO NumEvents DO
      BEGIN
        IF (CheckPreEventTime(EventNum,0)) THEN
          IF (NOT PhoneOffHook) THEN
          BEGIN
            TakeOffHook(FALSE);
            TextAttr := (15 + (16 * General.WFCBg));
            WFCMessage := 'Modem off hook in preparation for event at '+
                           Copy(CTim(MemEventArray[EventNum]^.EventStartTime),4,5)+':00';
          END;

        IF (CheckEventTime(EventNum,0)) THEN
          WITH MemEventArray[EventNum]^ DO
          BEGIN
            Assign(EventFile,General.DataPath+'EVENTS.DAT');
            InitModem;
            IF (EventIsOffHook IN EFlags) THEN
              TakeOffHook(TRUE);
            ClrScr;
            Write(Copy(CTim(EventStartTime),4,5)+':00 - Event: ');
            WriteLn('"'+EventDescription+'"');
            SL1('');
            SL1('Executing event: '+IntToStr(EventNum)+' '+EventDescription+' on '+DateStr+' '+TimeStr+
                ' from node '+IntToStr(ThisNode));
            IF (EventIsShell IN EFlags) THEN
            BEGIN
              CursorOn(TRUE);
              EventLastDate := Date2PD(DateStr);
              Reset(EventFile);
              Seek(EventFile,(EventNum - 1));
              Write(EventFile,MemEventArray[EventNum]^);
              Close(EventFile);
              ShellDOS(FALSE,EventShellPath+'.BAT',RCode);
              CursorOn(FALSE);
              SL1('Returned from '+EventDescription+' on '+DateStr+' '+TimeStr);
              DoPhoneHangup(TRUE);
              InitModem;
              WFCDraw;
            END
            ELSE IF (EventIsErrorLevel IN EFlags) THEN
            BEGIN
              CursorOn(TRUE);
              DoneDay := TRUE;
              ExitErrorLevel := EventErrorLevel;
              EventLastDate := Date2PD(DateStr);
              Reset(EventFile);
              Seek(EventFile,(EventNum - 1));
              Write(EventFile,MemEventArray[EventNum]^);
              Close(EventFile);
              CursorOn(FALSE);
            END
            ELSE IF (EventIsSortFiles IN EFlags) THEN
            BEGIN
              EventLastDate := Date2PD(DateStr);
              Reset(EventFile);
              Seek(EventFile,(EventNum - 1));
              Write(EventFile,MemEventArray[EventNum]^);
              Close(EventFile);
              CursorOn(FALSE);
              SortFilesOnly := TRUE;
              Sort;
              SortFilesOnly := FALSE;
              InitModem;
              WFCDraw;
            END
            ELSE IF (EventIsPackMsgAreas IN EFlags) THEN
            BEGIN
              EventLastDate := Date2PD(DateStr);
              Reset(EventFile);
              Seek(EventFile,(EventNum - 1));
              Write(EventFile,MemEventArray[EventNum]^);
              Close(EventFile);
              CursorOn(FALSE);
              PackAllBases;
              InitModem;
              WFCDraw;
            END
            ELSE IF (EventIsFilesBBS IN EFlags) THEN
            BEGIN
              EventLastDate := Date2PD(DateStr);
              Reset(EventFile);
              Seek(EventFile,(EventNum - 1));
              Write(EventFile,MemEventArray[EventNum]^);
              Close(EventFile);
              CursorOn(FALSE);
              CheckFilesBBS;
              InitModem;
              WFCDraw;
            END;
          END;
      END;
      LastError := IOResult;
  END;

BEGIN
  IF (NOT General.LocalSec) OR (General.NetworkMode) THEN
    SysOpOn := TRUE
  ELSE
    SysOpOn := FALSE;
  LastKeyPress := GetPackDateTime;
  InBox := FALSE;
  BlankMenuNow := FALSE;
  WantOut := TRUE;
  RedrawWFC := TRUE;

  Com_Install;

  WFCMDefine;

  WFCDraw;

  DTR(TRUE);
  InitModem;

  IF (NOT General.LocalSec) OR (General.NetworkMode) THEN
    SysOpOn := TRUE;
  IF (BeepEnd) THEN
    WFCMessage := 'Modem Off Hook - Paging Sysop';
  Randomize;
  TextAttr := (15 + (16 * General.WFCBg));;
  CursorOn(FALSE);
  LastMinute := (Timer - 61);
  CheckForConnection := FALSE;

  IF (AnswerBaud > 0) AND NOT (LocalIOOnly) THEN
  BEGIN
    C := 'A';
    InCom := Com_Carrier;
  END
  ELSE
  BEGIN
    C := #0;
    CallerIDNumber := '';
  END;

  IF (WFCMessage <> '') AND (SysOpOn) AND NOT (BlankMenuNow) THEN
  BEGIN
    GoToXY((80 - Length(WFCMessage)) DIV 2,17);
    TextAttr := (15 + (16 * General.WFCBg));;
{    Write('þþ '); }
    Write(WFCMessage);
{    Write(' þþ');   }
  END;

  TextAttr := 3;

  IF (BeepEnd) THEN
    BeepHim;

  IF (DoneAfterNext) THEN
  BEGIN
    TakeOffHook(TRUE);
    ExitErrorLevel := ExitNormal;
    HangUp := TRUE;
    DoneDay := TRUE;
    ClrScr;
  END;

  s := '';

  REPEAT
    InCom := FALSE;
    OutCom := FALSE;
    FastLogon := FALSE;
    ActualSpeed := 0;
    HangUp := FALSE;
    HungUp := FALSE;
    InResponseTo := '';
    LastAuthor := 0;
    CFO := FALSE;
    ComPortSpeed := 0;
    FreeTime := 0;
    ExtraTime := 0;
    ChopTime := 0;
    CreditTime := 0;
    LIL := 0;

    DailyMaint;

    ASM
      Int 28h
    END;

    IF (AnswerBaud = 0) THEN
    BEGIN
      IF ((Timer - LastMinute) > 60) OR ((Timer - LastMinute) < 0) THEN
      BEGIN
        LastMinute := Timer;
        IF (SysOpOn) AND NOT (BlankMenuNow) THEN
        BEGIN
          TextAttr := (15 + (16 * General.WFCBg));;
          GoToXY(4,1);
          Write(PadRightStr(TimeStr,8));
          GoToXY(68,1);
          Write(DateStr);
          TextAttr := (15 + (16 * General.WFCBg));;
        END;
        IF ((Timer - LastInit) > NoCallInitTime) THEN
        BEGIN
          LastInit := Timer;
          IF (NOT PhoneOffHook) AND (AnswerBaud = 0) THEN
          BEGIN
            Com_Deinstall;
            Com_Install;
            InitModem;
          END;
          IF (General.MultiNode) THEN
          BEGIN
            LoadURec(ThisUser,1);
            SaveGeneral(TRUE);
          END;
        END;
        IF (SysOpOn) AND (General.LocalSec) AND (NOT General.NetworkMode) THEN
          SysOpOn := FALSE;
        IF ((NOT BlankMenuNow) AND (General.WFCBlankTime > 0)) THEN
          IF ((GetPackDateTime - LastKeyPress) DIV 60 >= General.WFCBlankTime) THEN
          BEGIN
            BlankMenuNow := TRUE;
            ClrScr;
          END;
        IF (NumEvents > 0) THEN
          ChkEvents;
      END;
      C := Char(InKey);
    END;

    IF (InBox) AND (C > #0) THEN
    BEGIN
      IF (C IN [#9,#27]) THEN
      BEGIN
        InBox := FALSE;
        Window(1,1,MaxDisplayCols,MaxDisplayRows);
        GoToXY(32,17);
        ClrEOL;
      END
      ELSE
      BEGIN
        Com_send(C);
        WriteWFC(C);
      END;
      C := #0;
    END;

    IF (C > #0) THEN
    BEGIN
      TempPause := (Pause IN ThisUser.Flags);
      RedrawWFC := TRUE;
      IF (BlankMenuNow) THEN
      BEGIN
        BlankMenuNow := FALSE;
        WFCDraw;
        LastKeyPress := GetPackDateTime;
      END;

      C := UpCase(C);
      CursorOn(TRUE);
      IF (NOT SysOpOn) THEN
        CASE C OF
          'Q' : BEGIN
                  ExitErrorLevel := 255;
                  HangUp := TRUE;
                  DoneDay := TRUE;
                END;
          ' ' : BEGIN
                  SysOpOn := CPW;
                  IF (SysOpOn) THEN
                    WantOut := TRUE;
                  C := #1;
                END;
         ELSE
           RedrawWFC := FALSE;
         END
      ELSE
      BEGIN
        TextAttr := 7;
        CurrentColor := 7;
        IF (General.NetworkMode) AND (Answerbaud = 0) AND (Pos(C,'HIABCDEFJTV$PLNMOS!RUWXZ#') > 0) THEN
          C := #0;
        CASE C OF
           #9 : BEGIN
                  InBox := TRUE;
                  TextAttr := (15 + (16 * General.WFCBg));;
                  GoToXY(32,17);
                  Write('... talking to modem ...');
                  RedrawWFC := FALSE;
                END;

          'A' : IF (NOT LocalIOOnly) THEN
                  CheckForConnection := TRUE
                ELSE
                  RedrawWFC := FALSE;
          'B' : IF (CPW) THEN
                  MessageAreaEditor;
          'C' : TodaysCallers(0,'');
          'D' : SysOpShell;
          'E' : IF (CPW) THEN
                  EventEditor;
          'F' : IF (CPW) THEN
                  FileAreaEditor;
          'H' : BEGIN
                  DoPhoneHangup(TRUE);
                  RedrawWFC := FALSE;
                END;
          'I' : BEGIN
                  InitModem;
                  RedrawWFC := TRUE;
                END;
          'L' : BEGIN
                  ClrScr;
                  ShowLogs;
                  NL;
                  PauseScr(FALSE);
                END;
          'M' : IF (CPW) THEN
                BEGIN
                  ClrScr;
                  ReadAllMessages('');
                END;
          'N' : BEGIN
                  ClrScr;
                  lListNodes;
                  PauseScr(FALSE);
                END;
          'O' : BEGIN
                  TakeOffHook(TRUE);
                  RedrawWFC := FALSE;
                END;
          'P' : BEGIN
                  ClrScr;
                  IF (PYNQ('Pack the message areas? ',0,FALSE)) THEN
                    DoShowPackMessageAreas;
                END;
          'Q' : BEGIN
                  ExitErrorLevel := 255;
                  HangUp := TRUE;
                  DoneDay := TRUE;
                  RedrawWFC := FALSE;
                END;
          'R' : IF (CPW) THEN
                BEGIN
                  ClrScr;
                  NL;
                  Print(' ^5User''s private messages to read (1-'+IntToStr(MaxUsers - 1)+')?^1');
                  NL;
                  Print(' Enter User Number, Name, or Partial Search String.');
                  Prt(' : ');
                  lFindUserWS(UNum);
                  IF (UNum < 1) THEN
                  BEGIN
                    NL;
                    PauseScr(FALSE);
                  END
                  ELSE
                  BEGIN
                    ClrScr;
                    LoadURec(ThisUser,UNum);
                    UserNum := UNum;
                    ReadMail;
                    SaveURec(ThisUser,UNum);
                    LoadURec(ThisUser,1);
                    UserNum := 1;
                  END;
                END;
          'S' : IF (CPW) THEN
                  SystemConfigurationEditor;
          'T' : AllCallers(0,'');
          'U' : IF (CPW) THEN
                BEGIN
                  ClrScr;
                  UserEditor(UserNum);
                END;
          'V' : IF (CPW) THEN
                  VotingEditor;
          'W' : IF (CPW) THEN
                BEGIN
                  ClrScr;
                  NL;
                  Print('|03 User to send private message from (1-|11'+IntToStr(MaxUsers - 1)+'|03)?');
                  NL;
                  Print(' Enter User Number, Name, or Partial Search String.');
                  Prt(' : ');
                  lFindUserWS(UNum);
                  IF (UNum < 1) THEN
                  BEGIN
                    NL;
                    PauseScr(FALSE);
                  END
                  ELSE
                  BEGIN
                    LoadURec(ThisUser,UNum);
                    UserNum := UNum;
                    NL;
                    SMail(PYNQ(' Send mass mail? ',0,FALSE));
                    LoadURec(ThisUser,1);
                    UserNum := 1;
                  END;
                END;
          'X' : IF (CPW) THEN
                  ProtocolEditor;
          'Z' : IF (CPW) THEN
                  HistoryEditor;

          '$' : IF (CPW) THEN
                  ConferenceEditor;
          '!' : BEGIN
                  ClrScr;
                  ValidateFiles;
                END;
          '*' : LastCallerEditor;
          '#' : IF (CPW) THEN
                  MenuEditor;
          ' ' : BEGIN
                  IF (General.OffHookLocalLogon) THEN
                    TakeOffHook(TRUE);
                  GoToXY(32,17);
                  TextAttr := (15 + (16 * General.WFCBg));;
                  Write('Log On? (Y/N');
                  IF (NOT General.LocalSec) THEN
                    Write('/F) ')
                  ELSE
                    Write('): ');
                  rl2 := Timer;
                  WHILE (NOT KeyPressed) AND (ABS(Timer - rl2) < 10) DO;
                  IF (KeyPressed) THEN
                    C := UpCase(ReadKey)
                  ELSE
                    C := 'N';
                  WriteLn(C);
                  CASE C OF
                    'F' : IF (NOT General.LocalSec) THEN
                          BEGIN
                            FastLogon := TRUE;
                            C := ' ';
                          END;
                    'Y' : C := ' ';
                  ELSE
                  BEGIN
                    IF (SysOpOn) AND (NOT BlankMenuNow) THEN
                    BEGIN
                      GoToXY(1,17);
                      ClrEOL;
                    END;
                    IF (General.OffHookLocalLogon) THEN
                      InitModem;
                    RedrawWFC := FALSE;
                  END;
                END;
              END;
        ELSE
          RedrawWFC := FALSE;
        END;
        LastKeyPress := GetPackDateTime;
      END;
      IF (RedrawWFC) THEN
      BEGIN
        IF NOT (C IN ['A','I','H',' ']) THEN
        BEGIN
          CurrentColor := (15 + (16 * General.WFCBg));;
          TextAttr := CurrentColor;
          WFCDraw;
          InitModem;
        END;
      END;
    END;


    IF (NOT Com_IsRecv_Empty) THEN
    BEGIN
      c2 := CInKey;
      IF (c2 > #0) THEN
      BEGIN
        WriteWFC(c2);
        IF (Length(s) >= 160) THEN
          Delete(s,1,120);
        IF (c2 <> ^M) THEN
          s := s + c2
        ELSE
        BEGIN
          IF (Pos(Liner.CallerID,s) > 0) THEN
          BEGIN
            CallerIDNumber := Copy(s,Pos(Liner.CallerID,s) + Length(Liner.CallerID),40);
            s := '';
          END;
          IF (Pos(Liner.Ring, s) > 0) THEN
          BEGIN
            s := '';
            IF (RingNumber > 0) AND (ABS(Timer - LastRing) > 10) THEN
            BEGIN
              RingNumber := 0;
              CallerIDNumber := '';
              MultiRinging := FALSE;
            END;
            IF (ABS(Timer - LastRing) < 4) AND (NOT MultiRinging) THEN
              MultiRinging := TRUE
            ELSE
              Inc(RingNumber);
            LastRing := Timer;
            IF (RingNumber >= Liner.AnswerOnRing) AND (NOT Liner.MultiRing OR MultiRinging) THEN
              CheckForConnection := TRUE;
            s := '';
          END;
        END;
      END;
    END;
    IF (C > #0) OR (CheckForConnection) THEN
    BEGIN
      IF (NOT General.LocalSec) OR (General.NetworkMode) THEN
        SysOpOn := TRUE;
      IF (BlankMenuNow) THEN
      BEGIN
        BlankMenuNow := FALSE;
        WFCDraw;
      END;
      IF (NOT PhoneOffHook) AND (NOT LocalIOOnly) AND (CheckForConnection) THEN
      BEGIN
        GetConnection;
        CheckForConnection := FALSE;
        IF (NOT InCom) THEN
        BEGIN
          WFCDraw;
          InitModem;
          IF (QuitAfterDone) THEN
          BEGIN
            ExitErrorLevel := ExitNormal;
            HangUp := TRUE;
            DoneDay := TRUE;
          END;
        END;
      END;
    END;
    CursorOn(FALSE);
  UNTIL ((InCom) OR (C = ' ') OR (DoneDay));

  UploadKBytesToday := 0;
  DownloadKBytesToday := 0;
  UploadsToday := 0;
  PrivatePostsToday := 0;
  PublicPostsToday := 0;
  FeedbackPostsToday := 0;
  ChatAttempts := 0;
  ShutUpChatCall := FALSE;
  ChatChannel := 0;
  ContList := FALSE;
  BadDLPath := FALSE;
  UserNum := -1;
  TempSysOp := FALSE;

  Reset(SchemeFile);
  Read(SchemeFile,Scheme);
  Close(SchemeFile);

  CurrentColor := (15 + (16 * General.WFCBg));;
  TextAttr := CurrentColor;
  IF (InCom) THEN
  BEGIN
    Com_Flush_Recv;
    DTR(TRUE);
    OutCom := TRUE;
    Com_Set_Speed(ComPortSpeed);
  END
  ELSE
  BEGIN
    DTR(FALSE);
    OutCom := FALSE;
  END;
  IF (ActualSpeed = 0) THEN
    Rate := (Liner.InitBaud DIV 10)
  ELSE
    Rate := (ActualSpeed DIV 10);
  TimeOn := GetPackDateTime;
  ClrScr;
  Com_Flush_Recv;
  BeepEnd := FALSE;
  InWFCMenu := FALSE;

  Kill(General.TempPath+'MSG'+IntToStr(ThisNode)+'.TMP');
  NodeChatLastRec := 0;

  IF (ComPortSpeed = 0) AND (NOT WantOut) THEN
    WantOut := TRUE;

  IF (WantOut) THEN
    CursorOn(TRUE);

  SaveGeneral(TRUE);

  LastError := IOResult;
END;

END.