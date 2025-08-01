module sbt_comm010
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm010
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 05 - 21
!    Modification Data    ==   2024 - 05 - 21
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************
local const byte COMM010_FEEDBACK_DATA      := 201;     ! 数据状态反馈命令
local const byte COMM010_FEEDBACK_STATE     := 202;     ! 抓取状态反馈命令
local const byte COMM010_FEEDBACK_AREA      := 203;     ! 区域反馈命令

local const num COMM010_STATE_SUCCESS       := 0;       ! 抓取成功
local const num COMM010_STATE_MISS          := -1;      ! 丢失
local const num COMM010_STATE_PERSS         := -2;      ! 过压
local const num COMM010_STATE_FAILED        := -3;      ! 抓取失败

local const byte COMM010_POS_TYPE_NULL      := 0;       ! 坐标无效
local const byte COMM010_POS_TYPE_PICK      := 101;     ! 抓取坐标
local const byte COMM010_POS_TYPE_PLACE     := 102;     ! 码垛坐标
local const byte COMM010_POS_TYPE_OBLI      := 103;     ! 斜插坐标

local const num  COMM010_REQ_ONE            := 1;       ! 第一次请求位置，获取抓取坐标
local const num  COMM010_REQ_TWO            := 2;       ! 第二次请求位置，获取斜插和码垛坐标


local var cmd_typ01_t CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];
local var cmd_typ08_t CmdType08 := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0];
local var cmd_typ09_t CmdType09 := [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0];

local var byte ReqMode := 0;
proc main()

    GlobalResultId      := G_RESULT_UNKNOWN; 
    GlobalCommandId     := G_COMMAND_UNKNOWN;
    ToResultFlg         := false; 

    while true do

        test GlobalCommandId
        case G_COMMAND_UNKNOWN:

            ! 未知的命令
            ! 程序会一直阻塞在这里直到有新的命令输入
            waittime 0.01;

        case G_COMMAND_INIT:

            ! 执行初始化
            log_clear_;
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_INIT !!!";
            process_command_init_;

            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;

        case G_COMMAND_DATA1:

            ! 请求工件数据
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_DATA1 !!!";
            initialize_data_;
            process_command_request_data01_;

        case G_COMMAND_DATA2:
                        
            ! 请求垛上测量数据
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_DATA2 !!!";
            process_command_request_data02_;
                
        case G_COMMAND_DTFEEK:

            ! 可达性反馈
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_DTFEEK !!!";
            process_command_pick_data_feek_;

            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;

        case G_COMMAND_PKSU:

            ! 反馈抓取成功
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_PKSU !!!";
            process_command_pick_succ_;

            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;

        case G_COMMAND_MISS:

            ! 丢失反馈
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_MISS !!!";
            process_command_miss_;

            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;

        case G_COMMAND_PRESS:

            ! 反馈过压
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_PRESS !!!";
            process_command_press_;

            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;

        case G_COMMAND_PKFL:

            ! 反馈抓取失败
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_PKFL !!!";
            process_command_pick_failed_;

            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;

        case G_COMMAND_AREA:

            ! 反馈离开区域
            log_info_ \Tag := "COMM010", "g_command =  G_COMMAND_AREA !!!";
            process_command_area_;
        
            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;
        
        default:
            ! 未知命令报警
            errwrite "COMM010", "Unknow Command [Cmd :" + num_2str_(GlobalCommandId \INTEGER) + "] !!!";
            
            ! 命令恢复成未知状态
            GlobalCommandId := G_COMMAND_UNKNOWN;
        endtest
    endwhile
endproc

local proc process_command_init_()
    var errnum Status;
    
    bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

    CmdType08 := [RobotDataTable.WorkMode, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0];

    Status := bus_cmd027_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType08);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 30);

    if Status <> OK then
        log_error_ \Tag := "COMM010", "command_init_ NOTOK [WorkMode:" + num_2str_(RobotDataTable.WorkMode \ INTEGER) + "]";
        GlobalResultId := G_RESULT_NOTOK;
    else

        log_info_ \Tag := "COMM010", "command_init_ OK [WorkMode:" + num_2str_(RobotDataTable.WorkMode \ INTEGER) + "]";
        GlobalResultId := G_RESULT_OK;
    endif

    ToResultFlg := true;

endproc

local proc process_command_request_data01_()
    var errnum Status;
    var robtarget Posn01;
    var robtarget Posn02;
    var num I;

    CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];
    CmdType08 := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0];
    CmdType09 := [0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    Status := bus_cmd021_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd148_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, CmdType08, \Timeout := BusTimeout);

    if Status = OK then 

        SensorDataTable.Mode        := CmdType08.byte01;
        SensorDataTable.TaskNum     := CmdType08.Int09;
        SensorDataTable.Area        := CmdType08.byte02;
        SensorDataTable.Pip         := CmdType08.byte03;
        SensorDataTable.BoxLenght   := CmdType08.Float13;
        SensorDataTable.BoxWidth    := CmdType08.Float14;
        SensorDataTable.BoxHigh     := CmdType08.Float15;

    else

        log_error_ \Tag := "COMM010", "Get Data01 Failed !!!";
        GlobalResultId := G_RESULT_NOTOK;
        GlobalCommandId := G_COMMAND_UNKNOWN;
        ToResultFlg := true;
        return;
    endif

    ! 
    if (SensorDataTable.Mode = COMM010_MODE_UNKNOWN) then

        log_info_ \Tag := "COMM010", "Finished !!!";
        GlobalResultId := G_RESULT_UNKNOWN;
        GlobalCommandId := G_COMMAND_UNKNOWN;
        ToResultFlg := true;
        return;
    endif

    if not ((SensorDataTable.Mode = COMM010_MODE_ONE) or (SensorDataTable.Mode = COMM010_MODE_TWO)) then

        errwrite "COMM010", "Unknow SensorDataTable.Mode [Mode :" + num_2str_(SensorDataTable.Mode \INTEGER) + "] !!!";
        ! GlobalResultId := G_RESULT_NOTOK;
        GlobalCommandId := G_COMMAND_UNKNOWN;
        ! ToResultFlg := true;
        return;
    else

        log_info_ \Tag := "COMM010", "Get Task Succ [Id:" + num_2str_(SensorDataTable.TaskNum \INTEGER) + "]";
    endif

    ReqMode := COMM010_REQ_ONE;

    ! CmdType01 := [ReqMode, 0, 0, 0, 0, 0, 0.0, 0.0];

    for I from 1 to 2 do 

        CmdType01 := [I, 0, 0, 0, 0, 0, 0.0, 0.0];

        Status := bus_cmd022_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
        Status := bus_cmd134_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, CmdType09, \Timeout := 3);

        if Status <> OK then

            log_error_ \Tag := "COMM010", "Get Data01 Failed !!!";
            GlobalResultId := G_RESULT_NOTOK;
            GlobalCommandId := G_COMMAND_UNKNOWN;
            ToResultFlg := true;
            return;
        else

            Posn01 := cur_pos_();
            Posn02 := cur_pos_();

            posn01.Trans.x := CmdType09.Float03;
            posn01.Trans.y := CmdType09.Float04;
            posn01.Trans.z := CmdType09.Float05;
            posn01.Rot := orientzyx(CmdType09.Float06, CmdType09.Float07, CmdType09.Float08);

            posn02.Trans.x := CmdType09.Float09;
            posn02.Trans.y := CmdType09.Float10;
            posn02.Trans.z := CmdType09.Float11;
            posn02.Rot := orientzyx(CmdType09.Float12, CmdType09.Float13, CmdType09.Float14);

            test CmdType09.Int01
            case COMM010_POS_TYPE_NULL:
            case COMM010_POS_TYPE_PICK:
                log_info_ \Tag := "COMM010", "Get Pick Pos OK !!!";     
                SensorDataTable.PickPos     := Posn01;
            case COMM010_POS_TYPE_PLACE:    
                log_info_ \Tag := "COMM010", "Get Place Pos OK !!!";    
                SensorDataTable.PlacePos    := Posn01;
            case COMM010_POS_TYPE_OBLI:    
                log_info_ \Tag := "COMM010", "Get Obli Pos OK !!!";    
                SensorDataTable.ObliPos     := Posn01;
            default:
                errwrite "COMM010", "Unknown Pos Type [Type :" + num_2str_(CmdType09.Int01 \INTEGER) + "] !!!";
                ! GlobalResultId := G_RESULT_NOTOK;
                GlobalCommandId := G_COMMAND_UNKNOWN;
                ! ToResultFlg := true;
                return;
            endtest

            test CmdType09.Int02
            case COMM010_POS_TYPE_NULL:
            case COMM010_POS_TYPE_PICK:
                log_info_ \Tag := "COMM010", "Get Pick Pos OK !!!";     
                SensorDataTable.PickPos     := Posn02;
            case COMM010_POS_TYPE_PLACE:    
                log_info_ \Tag := "COMM010", "Get Place Pos OK !!!";    
                SensorDataTable.PlacePos    := Posn02;
            case COMM010_POS_TYPE_OBLI:    
                log_info_ \Tag := "COMM010", "Get Obli Pos OK !!!";    
                SensorDataTable.ObliPos     := Posn02;
            default:
                errwrite "COMM010", "Unknown Pos Type [Type :" + num_2str_(CmdType09.Int02 \INTEGER) + "] !!!";
                ! GlobalResultId := G_RESULT_NOTOK;
                GlobalCommandId := G_COMMAND_UNKNOWN;
                ! ToResultFlg := true;
                return;
            endtest

            if SensorDataTable.Mode = COMM010_MODE_TWO then

                log_info_ \Tag := "COMM010", "command_request_data01_ OK !!!";
                GlobalCommandId := G_COMMAND_DTFEEK;
                return;
            endif

        endif

    endfor
    
    log_info_ \Tag := "COMM010", "command_request_data01_ OK !!!";
    GlobalCommandId := G_COMMAND_DTFEEK;

endproc

local proc process_command_request_data02_()
    var errnum Status;
    var robtarget Posn01;
    var robtarget Posn02;
    var num I;


    ReqMode := COMM010_REQ_TWO;

    CmdType01 := [ReqMode, 0, 0, 0, 0, 0, 0.0, 0.0];
    CmdType09 := [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0];
    CmdType09 := [0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    for I from 1 to 1 do 

        Status := bus_cmd022_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
        Status := bus_cmd134_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, CmdType09, \Timeout := BusTimeout);

        if Status <> OK then

            log_error_ \Tag := "COMM010", "command_request_data02_ NOT OK !!!";
            GlobalResultId := G_RESULT_NOTOK;
            ToResultFlg := true;
            return;
        else

            Posn01 := cur_pos_();
            Posn02 := cur_pos_();

            posn01.Trans.x := CmdType09.Float03;
            posn01.Trans.y := CmdType09.Float04;
            posn01.Trans.z := CmdType09.Float05;
            posn01.Rot := orientzyx(CmdType09.Float06, CmdType09.Float07, CmdType09.Float08);

            posn02.Trans.x := CmdType09.Float09;
            posn02.Trans.y := CmdType09.Float10;
            posn02.Trans.z := CmdType09.Float11;
            posn02.Rot := orientzyx(CmdType09.Float12, CmdType09.Float13, CmdType09.Float14);

            test CmdType09.Int01
            case COMM010_POS_TYPE_NULL:
            case COMM010_POS_TYPE_PICK:
                log_info_ \Tag := "COMM010", "Get Pick Pos OK !!!";     
                SensorDataTable.PickPos     := Posn01;
            case COMM010_POS_TYPE_PLACE:    
                log_info_ \Tag := "COMM010", "Get Place Pos OK !!!";    
                SensorDataTable.PlacePos    := Posn01;
            case COMM010_POS_TYPE_OBLI:    
                log_info_ \Tag := "COMM010", "Get Obli Pos OK !!!";    
                SensorDataTable.ObliPos     := Posn01;
            default:
                errwrite "COMM010", "Unknown Pos Type [Type :" + num_2str_(CmdType09.Int01 \INTEGER) + "] !!!";
                ! GlobalResultId := G_RESULT_NOTOK;
                GlobalCommandId := G_COMMAND_UNKNOWN;
                ! ToResultFlg := true;
                return;
            endtest

            test CmdType09.Int02
            case COMM010_POS_TYPE_NULL:
            case COMM010_POS_TYPE_PICK:
                log_info_ \Tag := "COMM010", "Get Pick Pos OK !!!";     
                SensorDataTable.PickPos     := Posn02;
            case COMM010_POS_TYPE_PLACE:    
                log_info_ \Tag := "COMM010", "Get Place Pos OK !!!";    
                SensorDataTable.PlacePos    := Posn02;
            case COMM010_POS_TYPE_OBLI:    
                log_info_ \Tag := "COMM010", "Get Obli Pos OK !!!";    
                SensorDataTable.ObliPos     := Posn02;
            default:
                errwrite "COMM010", "Unknown Pos Type [Type :" + num_2str_(CmdType09.Int02 \INTEGER) + "] !!!";
                ! GlobalResultId := G_RESULT_NOTOK;
                GlobalCommandId := G_COMMAND_UNKNOWN;
                ! ToResultFlg := true;
                return;
            endtest

            GlobalCommandId := G_COMMAND_DTFEEK;
        endif
    endfor

    log_info_ \Tag := "COMM010", "command_request_data02_ OK !!!";

endproc

local proc process_command_pick_data_feek_()
    var errnum Status;
    var byte CheckStatus := 0;

    if SensorDataTable.Area <= 0 or SensorDataTable.Area > 8 then
        errwrite "COMM010", "SensorDataTable.Area Error [Area :" + num_2str_(SensorDataTable.Area \INTEGER) + "] !!!";
        return;
    endif

    test RobotDataTable.WorkMode

    case G_WORK_MODE_STACK:

        log_info_ \Tag := "COMM010", "Check Pick Pos !!!";
        if ((SensorDataTable.PickPos.Trans.x > LimitUp{1}.x) or (SensorDataTable.PickPos.Trans.x < LimitDown{1}.x) or
            (SensorDataTable.PickPos.Trans.y > LimitUp{1}.y) or (SensorDataTable.PickPos.Trans.y < LimitDown{1}.y)or
            (SensorDataTable.PickPos.Trans.z > LimitUp{1}.z) or (SensorDataTable.PickPos.Trans.z < LimitDown{1}.z)) then

            log_error_ \Tag := "COMM010", "Pick Pos Out Of Range !!!";
            CheckStatus := COMM010_POS_TYPE_PICK;
            goto LBL_ACK;
        endif 

        if (ReqMode = COMM010_REQ_TWO) or (SensorDataTable.Mode = COMM010_MODE_ONE) then

            log_info_ \Tag := "COMM010", "Check Place Pos !!!";
            if ((SensorDataTable.PlacePos.Trans.x > LimitUp{SensorDataTable.Area}.x) or (SensorDataTable.PlacePos.Trans.x < LimitDown{SensorDataTable.Area}.x) or
                (SensorDataTable.PlacePos.Trans.y > LimitUp{SensorDataTable.Area}.y) or (SensorDataTable.PlacePos.Trans.y < LimitDown{SensorDataTable.Area}.y)or
                (SensorDataTable.PlacePos.Trans.z > LimitUp{SensorDataTable.Area}.z) or (SensorDataTable.PlacePos.Trans.z < LimitDown{SensorDataTable.Area}.z)) then

                log_error_ \Tag := "COMM010", "Place Pos Out Of Range !!!";
                CheckStatus := COMM010_POS_TYPE_PLACE;
                goto LBL_ACK;
            endif 
            log_info_ \Tag := "COMM010", "Obli Place Pos !!!";
            if ((SensorDataTable.ObliPos.Trans.x > LimitUp{SensorDataTable.Area}.x) or (SensorDataTable.ObliPos.Trans.x < LimitDown{SensorDataTable.Area}.x) or
                (SensorDataTable.ObliPos.Trans.y > LimitUp{SensorDataTable.Area}.y) or (SensorDataTable.ObliPos.Trans.y < LimitDown{SensorDataTable.Area}.y)or
                (SensorDataTable.ObliPos.Trans.z > LimitUp{SensorDataTable.Area}.z) or (SensorDataTable.ObliPos.Trans.z < LimitDown{SensorDataTable.Area}.z)) then

                log_error_ \Tag := "COMM010", "Obli Pos Out Of Range !!!";
                CheckStatus := COMM010_POS_TYPE_OBLI;
                goto LBL_ACK;
            endif 
        endif    


    case G_WORK_MODE_UNSTACK:

        log_info_ \Tag := "COMM010", "Check Pick Pos !!!";
        if ((SensorDataTable.PickPos.Trans.x > LimitUp{SensorDataTable.Area}.x) or (SensorDataTable.PickPos.Trans.x < LimitDown{SensorDataTable.Area}.x) or
            (SensorDataTable.PickPos.Trans.y > LimitUp{SensorDataTable.Area}.y) or (SensorDataTable.PickPos.Trans.y < LimitDown{SensorDataTable.Area}.y)or
            (SensorDataTable.PickPos.Trans.z > LimitUp{SensorDataTable.Area}.z) or (SensorDataTable.PickPos.Trans.z < LimitDown{SensorDataTable.Area}.z)) then

            log_error_ \Tag := "COMM010", "Pick Pos Out Of Range !!!";
            CheckStatus := COMM010_POS_TYPE_PICK;
            goto LBL_ACK;
        endif 

    endtest

    LBL_ACK:

    CmdType01 := [COMM010_FEEDBACK_DATA, CheckStatus, 0, 0, 0, 0, 0.0, 0.0];
    Status := bus_cmd026_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 3);

    
    if (CheckStatus = 0) and (Status = OK) then

        log_info_ \Tag := "COMM010", "command_pick_data_feek_ OK !!!";
        GlobalResultId := G_RESULT_OK;
        ToResultFlg := true;
    else

        errwrite "COMM010", "Failed process_command_pick_data_feek_ [Status :" + num_2str_(Status \INTEGER) + "] !!!";
        ! GlobalResultId := G_RESULT_NOTOK;
        ! ToResultFlg := true;
    endif

endproc

local proc process_command_pick_succ_()
    var errnum Status;
    
    CmdType01 := [COMM010_FEEDBACK_STATE, 0, 0, 0, COMM010_STATE_SUCCESS, 0, 0.0, 0.0];
    Status := bus_cmd026_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 3);
    if Status <> OK then

        errwrite "COMM010", "Failed process_command_pick_succ_ [Status :" + num_2str_(Status \INTEGER) + "] !!!";
    else

        log_info_ \Tag := "COMM010", "command_pick_succ_ OK !!!";
    endif
endproc

local proc process_command_miss_()
    var errnum Status;
    
    CmdType01 := [COMM010_FEEDBACK_STATE, 0, 0, 0, COMM010_STATE_MISS, 0, 0.0, 0.0];
    Status := bus_cmd026_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 3);
    if Status <> OK then

        errwrite "COMM010", "Failed process_command_miss_ [Status :" + num_2str_(Status \INTEGER) + "] !!!";
    else

        log_info_ \Tag := "COMM010", "command_miss_ OK !!!";
    endif
endproc

local proc process_command_press_()
    var errnum Status;
    
    CmdType01 := [COMM010_FEEDBACK_STATE, 0, 0, 0, COMM010_STATE_PERSS, 0, 0.0, 0.0];
    Status := bus_cmd026_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 3);
    if Status <> OK then

        errwrite "COMM010", "Failed process_command_press_ [Status :" + num_2str_(Status \INTEGER) + "] !!!";
    else

        log_info_ \Tag := "COMM010", "command_press_ OK !!!";
    endif
endproc

local proc process_command_pick_failed_()
    var errnum Status;
    
    CmdType01 := [COMM010_FEEDBACK_STATE, 0, 0, 0, COMM010_STATE_FAILED, 0, 0.0, 0.0];
    Status := bus_cmd026_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 3);
    if Status <> OK then

        errwrite "COMM010", "Failed process_command_pick_failed_ [Status :" + num_2str_(Status \INTEGER) + "] !!!";
    else

        log_info_ \Tag := "COMM010", "command_pick_failed_ OK !!!";
    endif
endproc

local proc process_command_area_()
    var errnum Status;
    
    CmdType01 := [COMM010_FEEDBACK_AREA, RobotDataTable.Area, 0, 0, 0, 0, 0.0, 0.0];
    Status := bus_cmd026_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
    Status := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := 3);
    if Status <> OK then

        errwrite "COMM010", "Failed process_command_area_ [Status :" + num_2str_(Status \INTEGER) + "] !!!";
    else

        log_info_ \Tag := "COMM010", "command_area_ OK !!!";
    endif
endproc

local proc initialize_data_()

    SensorDataTable.Mode := 0;
    SensorDataTable.TaskNum := 0;
    SensorDataTable.Area := 0;
    SensorDataTable.Pip := 0;
    SensorDataTable.BoxLenght := 0.0;
    SensorDataTable.BoxWidth := 0.0;
    SensorDataTable.BoxHigh := 0.0;
    SensorDataTable.ObliPos := null_pos_();
    SensorDataTable.PickPos := null_pos_();
    SensorDataTable.PlacePos := null_pos_();
endproc


endmodule