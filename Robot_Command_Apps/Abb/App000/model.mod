MODULE model
	CONST robtarget Photo01:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget Photo02:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget Photo03:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    CONST robtarget Start01:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget Start02:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget Start03:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    CONST robtarget Stop01:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget Stop02:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget Stop03:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    CONST robtarget Ready:=[[364.35,0.00,594.00],[0.5,0,0.866025,0],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    PERS robtarget GivePos:=[[10,20,30],[0.999471000956725,0.00826538314875117,0.017674160904073,0.0260197179904538],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    LOCAL VAR wobjdata WOBJ01 := [FALSE, TRUE, "", [ [0, 0, 0], [1, 0, 0 ,0] ], [ [0, 0, 0], [1, 0, 0 ,0] ] ];
    LOCAL VAR wobjdata WOBJ02 := [FALSE, TRUE, "", [ [300, 600, 200], [1, 0, 0 ,0] ], [ [0, 0, 0], [1, 0, 0 ,0] ] ];
	TASK PERS wobjdata wobj10:=[FALSE,TRUE,"",[[10,20,10],[0.999471000956725,0.0260197179904538,0.0176741609040729,0.00826538314875118]],[[0,0,0],[1,0,0,0]]];
	TASK PERS wobjdata wobj20:=[FALSE,TRUE,"",[[20.7531,38.593,40.6377],[0.9982,0.0345808,0.0347209,0.0345808]],[[0,0,0],[1,0,0,0]]];
    
    local VAR num Rz;
    local VAR num Ry;
    local VAR num Rx;
    
    LOCAL VAR errnum STA_ERR;
    
PROC main000()
    
    sbt_comm000_\CALIB_START\PictureId:=1;
    
    MoveJ Photo01, v200, fine, tool0;
    sbt_comm000_\CALIB_PICT;
    
    MoveJ Photo02, v200, fine, tool0;
    sbt_comm000_\CALIB_PICT;
    
    MoveJ Photo03, v200, fine, tool0;
    sbt_comm000_\CALIB_PICT;
    
    MoveJ Ready, v200, fine, tool0;
    sbt_comm000_\CALIB_END;
    
ENDPROC
PROC main002a()

    sbt_comm002_\CMD_VPARAM\Pid:=1\Vin:=VinComm002;
    
    MoveJ Photo01, v200, fine, tool0;
    sbt_comm002_\CMD_TRIG\PictureId:=1;
    
    MoveJ Photo02, v200, fine, tool0;
    sbt_comm002_\CMD_TRIG\PictureId:=1;
    
    MoveJ Photo03, v200, fine, tool0;
    sbt_comm002_\CMD_TRIG\PictureId:=2;
    
    MoveJ Ready, v200, fine, tool0;
    sbt_comm002_\CMD_END;
    
ENDPROC

PROC main002b()

    sbt_comm002_\CMD_VPARAM\Pid:=1\Vin:=VinComm002;
    
    MoveJ Start01, v200, fine, tool0;
    sbt_comm002_\CMD_SCANSRT\PictureId:=1;
    MoveL Stop01,v100,fine,tool0;
    sbt_comm002_\CMD_SCANSTP;
    
    MoveJ Start02, v200, fine, tool0;
    sbt_comm002_\CMD_SCANSRT\PictureId:=2;
    MoveL Stop02,v100,fine,tool0;
    sbt_comm002_\CMD_SCANSTP;
    
    MoveJ Start03, v200, fine, tool0;
    sbt_comm002_\CMD_SCANSRT\PictureId:=3;
    MoveL Stop03,v100,fine,tool0;
    sbt_comm002_\CMD_SCANSTP;
    
    MoveJ Ready, v200, fine, tool0;
    sbt_comm002_\CMD_END;
    
ENDPROC

PROC main003a()

    sbt_comm003_\CMD_VPARAM\Pid:=1\Vin:=VinComm003;
    
    sbt_comm003_\CMD_POS;
    
    IF StatusComm003 = TRUE THEN
        
        sbt_comm003_\CMD_GFRAME\Gframe:=wobj10\Sframe:=wobj20\ThisPos:=GivePosCommm003;
    
        MoveJ Photo01, v200, fine, tool0,\WObj:=wobj20;
        sbt_comm003_\CMD_TRIG\PictureId:=1;

        MoveJ Photo02, v200, fine, tool0,\WObj:=wobj20;
        sbt_comm003_\CMD_TRIG\PictureId:=2;
  
    ENDIF
    
    MoveJ Ready, v200, fine, tool0;
    sbt_comm003_\CMD_END;
    
ENDPROC

PROC main003b()
    
    sbt_comm003_\CMD_VPARAM\Pid:=1\Vin:=VinComm003;
    
    sbt_comm003_\CMD_POS;
    
    IF StatusComm003 = TRUE THEN
        
        sbt_comm003_\CMD_GFRAME\Gframe:=wobj10\Sframe:=wobj20\ThisPos:=GivePosCommm003;
    
        MoveJ Start01,v200,fine,tool0,\WObj:=wobj20;
        sbt_comm003_\CMD_SCANSRT\PictureId:=1;
        MoveL Stop01,v100,fine,tool0,\WObj:=wobj20;
        sbt_comm003_\CMD_SCANSTP;
        
        MoveJ Start02,v200,fine,tool0,\WObj:=wobj20;
        sbt_comm003_\CMD_SCANSRT\PictureId:=2;
        MoveL Stop02,v100,fine,tool0,\WObj:=wobj20;
        sbt_comm003_\CMD_SCANSTP;
        
    ENDIF
    
    MoveJ Ready, v200, fine, tool0;
    sbt_comm003_\CMD_END;
    
ENDPROC

PROC main005()

    sbt_comm005_\CMD_VPARAM\Pid:=1\Vin:= VinComm005;
    
    MoveJ Photo01,v200,fine,tool0;
    sbt_comm005_\CMD_PICTURE;
    
    MoveJ Photo02,v200,fine,tool0;
    sbt_comm005_\CMD_PICTURE;
    
    MoveJ Photo03,v200,fine,tool0;
    sbt_comm005_\CMD_PICTURE;
    
    MoveJ Ready, v200, fine, tool0;
    sbt_comm005_\CMD_END;  
    
ENDPROC



PROC TEST001()
    

    
    !GivePos.rot := OrientZYX(3, 2, 1);
    
    
    Changer_frame_\Gframe:=wobj10, wobj20, GivePos;
    Changer_frame_ wobj10, GivePosCommm003;
    
    Rx := EulerZYX(\X, wobj20.uframe.rot);
    Ry := EulerZYX(\Y, wobj20.uframe.rot);
    Rz := EulerZYX(\Z, wobj20.uframe.rot);
    
endproc
	PROC main()
        
        VAR num i;
        i:=0;
        STA_ERR:=-1;
        
        BookErrNo STA_ERR;
        
        WHILE (i=100) DO
            
            IF i=50 THEN
                RAISE STA_ERR;
            endif
            
            i := i+1;
        
        ENDWHILE
        
        ERROR
        
        IF ERRNO = STA_ERR THEN
            TPWrite "error num:"\Num:=STA_ERR;
        endif
        
	ENDPROC

ENDMODULE