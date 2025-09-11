/PROG  POLISH_INIT
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Com12_HeadInit";
PROG_SIZE	= 478;
CREATE		= DATE 25-08-01  TIME 11:12:48;
MODIFIED	= DATE 25-09-10  TIME 13:49:28;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 12;
MEMORY_SIZE	= 810;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
LOCAL_REGISTERS	= 0,0,0;
/MN
   1:  !******************************** ;
   2:  !GRIND MACRO  ;
   2:  !POLISH_INIT ;
   3:  !******************************** ;
   3:  !Link grinding head to config ;
   4:   ;
   5:   ;
   6:  CALL HEAD_INIT("Head ID"=1," Tool Num"=1," Do Addr"=257," Di Addr"=257," Max Speed"=6000," ENABLE"=1) ;
   7:   ;
   8:  CALL HEAD_INIT("Head ID"=2," Tool Num"=0," Do Addr"=0," Di Addr"=0," Max Speed"=6000," DISABLE"=0) ;
   9:   ;
  10:  CALL HEAD_INIT("Head ID"=3," Tool Num"=0," Do Addr"=0," Di Addr"=0," Max Speed"=6000," DISABLE"=0) ;
  11:   ;
  12:  CALL HEAD_INIT("Head ID"=4," Tool Num"=0," Do Addr"=0," Di Addr"=0," Max Speed"=6000," ENABLE"=1) ;
/POS
/END
