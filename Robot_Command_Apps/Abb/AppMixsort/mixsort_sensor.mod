module mixsort_sensor
!***********************************************************
!
! file Name: mixsort_sensor
! 
!  Copyright 2018 - 2024 speedbot All Rights reserved.
! 
!  Description:
!    Language             ==   Karel for ABB ROBOT
!    Date                 ==   2022 - 06 - 25
!    Modification Data    ==   2024 - 03 - 29
! 
!  Author: speedbot
! 
!  Version: 4.0
! ***********************************************************

local var errnum MixStatus := OK;
local var agt_data_t CurAgentData;

local var robtarget CartPos1;
local var robtarget CartPos2;

local var num PosDataArray{6};

proc main()
    
    ToRobotCmd                  := 0; 
    ToSensorCmd                 := 0;
    ToRobotFlg                  := true; 
    ToSensorFlg                 := true;

    while true do

        log_info_ "Waiting For New Command ...";
        waittestandset ToSensorFlg;                     ! 等待前台任务触发
                                                        ! 触发后 ToSensorFlg 会马上被置位

        MixStatus               := OK;
        BusOutput.RobMsgType    := 0;
        BusOutput.JobId         := ToSensorCmd;         ! 任务号从前台指令中传输输入
        
        log_info_ "New Command Is " + num_to_str_(BusOutput.JobId \INTEGER) + " ...";
        test BusOutput.JobId 

        case MIX_BUSIO_INIT:              ! 初始化

            log_info_ " Bus I/O Init ...";

            ! 调用总线初始化接口
            bus_init_ BusInput, BusOutput \RobId := MixPkCfg.RobotId \ProtId := PTC_ST_PK;

            mixsort_init_data_ \PICT_DATA, CurAgentData;        ! 初始化后台拍照数据
            mixsort_init_data_ \PART_DATA, CurAgentData;        ! 初始化后台抓取数据
            mixsort_init_data_ \PICT_DATA, AgentData;           ! 初始化前台拍照数据
            mixsort_init_data_ \PART_DATA, AgentData;           ! 初始化前台抓取数据

            log_info_ " Bus I/O Init Complete ...", \ELOG;
            ! 初始化完成
            mixsort_ack_robot_ \ROBOT_TO_NEXT;              ! 通知前台任务继续执行任务

        case MIX_EDG_PIT:           ! 粗定位拍照，此版本已经不再使用

            incr BusOutput.RobMsgType;

            log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
            MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := BusTimeout);       ! 等待软件反馈数据
            if MixStatus = OK then
        
                log_info_ "Edg Picture Successful ...";

                ! 粗定位拍照完成
                mixsort_ack_robot_ \ROBOT_TO_NEXT;  
            endif
        case MIX_PIT_DAT:           ! 从软件接口获取新的拍照位置

            mixsort_init_data_ \PICT_DATA, CurAgentData;

            incr BusOutput.RobMsgType;
            
            log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
            MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := BusTimeout);       ! 等待软件反馈数据
            if MixStatus = OK then  

                bus_uptin_ BusInput;

                if BusInput.Finished = 1 then 

                    log_info_ "All Finished ...", \ELOG;

                    ! 全部完成，通知机器人结束任务回原点
                    mixsort_ack_robot_ \ROBOT_TO_HOME;
                else

                    log_info_ "Get Pict Data Successful ...";
                    CurAgentData.PictData.PictVec := [bus_gdata_(BUS_TYP_FLOAT2, 1), bus_gdata_(BUS_TYP_FLOAT2, 5), bus_gdata_(BUS_TYP_FLOAT2, 9)]; 

                    CartPos1 := MixPkCfg.PictCfg.RefPictPos;

                    CartPos1.Trans := [CurAgentData.PictData.PictVec.x, CurAgentData.PictData.PictVec.y, CurAgentData.PictData.PictVec.z];

                    CurAgentData.PictData.PictPos := mixsort_cnv_pos_(CartPos1);

                    CurAgentData.PictData.IsUnrefId := 0;

                    if (CurAgentData.PictData.PictPos.Trans.x > MixPkCfg.PictCfg.PtMaxData.x) or (CurAgentData.PictData.PictPos.Trans.x < MixPkCfg.PictCfg.PtMinData.x) then

                        CurAgentData.PictData.IsUnrefId := 101;
                        log_warn_ "Picture Pos X Is Unref ...", \ELOG, \Id := CurAgentData.PictData.IsUnrefId,
                                  \RL2 := "X[" + num_to_str_(CurAgentData.PictData.PictPos.Trans.x) + "]" + " MaxX[" + num_to_str_(MixPkCfg.PictCfg.PtMaxData.x) + "]",
                                  \RL3 := "X[" + num_to_str_(CurAgentData.PictData.PictPos.Trans.x) + "]" + " MinX[" + num_to_str_(MixPkCfg.PictCfg.PtMinData.x) + "]";
                        goto PICTURE_ACK;
                    endif


                    if (CurAgentData.PictData.PictPos.Trans.y > MixPkCfg.PictCfg.PtMaxData.y) or (CurAgentData.PictData.PictPos.Trans.y < MixPkCfg.PictCfg.PtMinData.y) then

                        CurAgentData.PictData.IsUnrefId := 102;
                        log_warn_ "Picture Pos Y Is Unref ...", \ELOG, \Id := CurAgentData.PictData.IsUnrefId,
                                  \RL2 := "Y[" + num_to_str_(CurAgentData.PictData.PictPos.Trans.y) + "]" + " MaxY[" + num_to_str_(MixPkCfg.PictCfg.PtMaxData.y) + "]",
                                  \RL3 := "Y[" + num_to_str_(CurAgentData.PictData.PictPos.Trans.y) + "]" + " MinY[" + num_to_str_(MixPkCfg.PictCfg.PtMinData.y) + "]";
                        goto PICTURE_ACK;
                    endif

                    if not chk_pos_(CurAgentData.PictData.PictPos, tool0) then

                        CurAgentData.PictData.IsUnrefId := 103;
                        log_warn_ "Picture Pos Is Unref ...", \ELOG, \Id := CurAgentData.PictData.IsUnrefId;
                        goto PICTURE_ACK;
                    endif

                    PICTURE_ACK:

                    bus_sdata_ BUS_TYP_BYTE, 1, CurAgentData.PictData.IsUnrefId;
                    incr BusOutput.RobMsgType;
                    log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
                    MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := 3);            ! 等待软件反馈数据
                    if MixStatus = OK then
                        if CurAgentData.PictData.IsUnrefId <> 0 then  

                            ! log_warn_ "Picture Pos Is Unref ...";

                            ! Code Modified on 2025.05.02
                            ! 不可达时修改为获取任务，而不是获取拍照数据
                            
                            ! mixsort_ack_agent_ \GET_PICTURE_DATA;
                            mixsort_ack_agent_ \GET_TASK;
                            !
                        else

                            log_info_ "Robot Move To Pict Pos ...";
                            AgentData := CurAgentData;
                            mixsort_ack_robot_ \ROBOT_TO_PICTURE;
                        endif
                    endif
                endif
            endif

        case MIX_LTN_PIT:               ! 通知软件进行精定位拍照

            bus_scartp_ 1, cur_pos_();

            incr BusOutput.RobMsgType;
            log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
            MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := BusTimeout);           ! 等待软件反馈数据
            if MixStatus = OK then

                log_info_ "Ltn Picture Successful ...";
                mixsort_ack_robot_ \ROBOT_TO_NEXT;
            endif
        case MIX_PIK_DAT:               ! 从软件获取抓取数据

            mixsort_init_data_ \PART_DATA, CurAgentData;

            BusInput.Finished       := 0;

            ! Code added on 2025.05.02
            ! 反馈上一个零件的抓取状态
            if IsPicking then  
                bus_sdata_ BUS_TYP_BYTE, 1, 1;      ! 反馈上一个零件成功抓取
            else
                bus_sdata_ BUS_TYP_BYTE, 1, 0;      ! 反馈上一个零件没有成功抓取
            endif
            !

            while (MixStatus = OK) and (BusInput.Finished = 0) and (BusOutput.RobMsgType < 3) do

                incr BusOutput.RobMsgType; 
                log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
                MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := BusTimeout);           ! 等待软件反馈数据
                
                if MixStatus = OK then
                
                    test BusOutput.RobMsgType

                    case 1:
                        CurAgentData.PartData.FromRobId := bus_gdata_(BUS_TYP_BYTE, 1);
                        CurAgentData.PartData.PartLen   := round(bus_gdata_(BUS_TYP_INT, 2));
                        CurAgentData.PartData.OfsOrt    := bus_gdata_(BUS_TYP_INT, 4) / 10.0;
                        CurAgentData.PartData.OfsRz     := bus_gdata_(BUS_TYP_INT, 6) / 10.0;
                        CurAgentData.PartData.MagPip    := [bus_gdata_(BUS_TYP_BYTE, 8),
                                                            bus_gdata_(BUS_TYP_BYTE, 9),
                                                            bus_gdata_(BUS_TYP_BYTE, 10),
                                                            bus_gdata_(BUS_TYP_BYTE, 11),
                                                            bus_gdata_(BUS_TYP_BYTE, 12),
                                                            bus_gdata_(BUS_TYP_BYTE, 13),
                                                            bus_gdata_(BUS_TYP_BYTE, 14),
                                                            bus_gdata_(BUS_TYP_BYTE, 15)];
                        CurAgentData.PartData.GripDist1 := round(bus_gdata_(BUS_TYP_INT, 16) / 10.0);
                        CurAgentData.PartData.Thickness := bus_gdata_(BUS_TYP_INT, 18) / 10.0;
                        CurAgentData.PartData.Weight    := bus_gdata_(BUS_TYP_INT, 20) / 10.0;
                        CurAgentData.PartData.PlaceId   := bus_gdata_(BUS_TYP_BYTE, 22);
                        CurAgentData.PartData.GripDist2 := round(bus_gdata_(BUS_TYP_INT, 23) / 10.0);

                        log_info_ "Get Part Data Successful ...";
                    case 2:

                        PosDataArray    := [bus_gdata_(BUS_TYP_FLOAT2, 1),
                                            bus_gdata_(BUS_TYP_FLOAT2, 5),
                                            bus_gdata_(BUS_TYP_FLOAT2, 9),
                                            bus_gdata_(BUS_TYP_FLOAT2, 13),
                                            bus_gdata_(BUS_TYP_FLOAT2, 17),
                                            bus_gdata_(BUS_TYP_FLOAT2, 21)];

                        CartPos1 := trans_pos_(\Dim1Ary := PosDataArray);

                        log_info_ "Get Pick Pos Successful ...";
                    case 3:
                        PosDataArray    := [bus_gdata_(BUS_TYP_FLOAT2, 1),
                                            bus_gdata_(BUS_TYP_FLOAT2, 5),
                                            bus_gdata_(BUS_TYP_FLOAT2, 9),
                                            bus_gdata_(BUS_TYP_FLOAT2, 13),
                                            bus_gdata_(BUS_TYP_FLOAT2, 17),
                                            bus_gdata_(BUS_TYP_FLOAT2, 21)];

                        CartPos2 := trans_pos_(\Dim1Ary := PosDataArray);

                        log_info_ "Get Place Pos Successful ...";
                    endtest
                    bus_uptin_ BusInput;    
                endif            
            endwhile

            if (MixStatus = OK) and (BusInput.Finished = 1) then  

                log_info_ "Finished ...";
                if MixPkCfg.EyeInHand then 

                    mixsort_ack_agent_ \GET_PICTURE_DATA;
                else

                    mixsort_ack_robot_ \ROBOT_TO_HOME;
                endif
            endif

            if (MixStatus = OK) and (BusInput.Finished <> 1) then 
                
                CurAgentData.PartData.PkPos := mixsort_cnv_pos_(CartPos1);

                ! 复位坐标异常状态
                CurAgentData.PartData.IsUnrefId := 0;

                ! 判断放置位置是否超过最大的设定值      
                if (CurAgentData.PartData.PlaceId > MixPkCfg.NumPlPoint) then
                    CurAgentData.PartData.IsUnrefId := 1;
                    log_warn_ "Place Id > Num Place Point ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId;
                    goto PICK_ACK;
                endif

                if not chk_pos_(CurAgentData.PartData.PkPos, MixTool) then
                    CurAgentData.PartData.IsUnrefId := 2;
                    log_warn_ "Pick Pos Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId;
                    goto PICK_ACK;
                endif

                if (CurAgentData.PartData.PkPos.Trans.x > MixPkCfg.PickCfg.PkMaxData.x) or (CurAgentData.PartData.PkPos.Trans.x < MixPkCfg.PickCfg.PkMinData.x) then
                    CurAgentData.PartData.IsUnrefId := 5;
                    log_warn_ "Pick X Pos Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId,
                               \RL2 := "X[" + num_to_str_(CurAgentData.PartData.PkPos.Trans.x) + "]" + " MaxX[" + num_to_str_(MixPkCfg.PickCfg.PkMaxData.x) + "]",
                               \RL3 := "X[" + num_to_str_(CurAgentData.PartData.PkPos.Trans.x) + "]" + " MinX[" + num_to_str_(MixPkCfg.PickCfg.PkMinData.x) + "]";
                    goto PICK_ACK;
                endif

                if (CurAgentData.PartData.PkPos.Trans.y > MixPkCfg.PickCfg.PkMaxData.y) or (CurAgentData.PartData.PkPos.Trans.y < MixPkCfg.PickCfg.PkMinData.y) then
                    CurAgentData.PartData.IsUnrefId := 6;
                    log_warn_ "Pick Y Pos Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId,
                              \RL2 := "Y[" + num_to_str_(CurAgentData.PartData.PkPos.Trans.y) + "]" + " MaxY[" + num_to_str_(MixPkCfg.PickCfg.PkMaxData.y) + "]",
                              \RL3 := "Y[" + num_to_str_(CurAgentData.PartData.PkPos.Trans.y) + "]" + " MinY[" + num_to_str_(MixPkCfg.PickCfg.PkMinData.y) + "]";
                    goto PICK_ACK;
                endif                

                if (MixPkCfg.BoxOrConv) and (CurAgentData.PartData.IsUnrefId = 0) then  


                    CurAgentData.PartData.PlPos := CartPos2;

                    CartPos2.Trans.z := BoxConfig{CurAgentData.PartData.PlaceId}.PlaceUpDst;

                    if (MixPkCfg.NumAxis > 6)
                        CurAgentData.PartData.PlPos.extax.eax_a := BoxConfig{CurAgentData.PartData.PlaceId}.PlaceE7Pos;

                    if (CurAgentData.PartData.PlPos.Trans.x > BoxConfig{CurAgentData.PartData.PlaceId}.PlMaxData.x) or (CurAgentData.PartData.PlPos.Trans.x < BoxConfig{CurAgentData.PartData.PlaceId}.PlMinData.x) then
                        CurAgentData.PartData.IsUnrefId := 201;
                        log_warn_ "Place X Pos Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId,
                                  \RL2 := "X[" + num_to_str_(CurAgentData.PartData.PlPos.Trans.x) + "]" + " MaxX[" + num_to_str_(BoxConfig{CurAgentData.PartData.PlaceId}.PlMaxData.x) + "]",
                                  \RL3 := "X[" + num_to_str_(CurAgentData.PartData.PlPos.Trans.x) + "]" + " MinX[" + num_to_str_(BoxConfig{CurAgentData.PartData.PlaceId}.PlMinData.x) + "]";
                        goto PICK_ACK;
                    endif
                    

                    if (CurAgentData.PartData.PlPos.Trans.y > BoxConfig{CurAgentData.PartData.PlaceId}.PlMaxData.y) or (CurAgentData.PartData.PlPos.Trans.y < BoxConfig{CurAgentData.PartData.PlaceId}.PlMinData.y) then
                        CurAgentData.PartData.IsUnrefId := 202;
                        log_warn_ "Place Y Pos Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId,
                                  \RL2 := "Y[" + num_to_str_(CurAgentData.PartData.PlPos.Trans.y) + "]" + " MaxY[" + num_to_str_(BoxConfig{CurAgentData.PartData.PlaceId}.PlMaxData.y) + "]",
                                  \RL3 := "Y[" + num_to_str_(CurAgentData.PartData.PlPos.Trans.y) + "]" + " MinY[" + num_to_str_(BoxConfig{CurAgentData.PartData.PlaceId}.PlMinData.y) + "]";
                        goto PICK_ACK;
                    endif


                    if not chk_pos_(CurAgentData.PartData.PlPos, MixTool) then
                        CurAgentData.PartData.IsUnrefId := 203;
                        log_warn_ "Place Pos Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId;
                        goto PICK_ACK;
                    endif

                    if not chk_pos_(CartPos2, MixTool) then
                        CurAgentData.PartData.IsUnrefId := 204;
                        log_warn_ "Place Pos Up Is Unref ...", \ELOG, \Id := CurAgentData.PartData.IsUnrefId;
                        goto PICK_ACK;
                    endif

                endif

                PICK_ACK:

                bus_sdata_ BUS_TYP_BYTE, 1, CurAgentData.PartData.IsUnrefId;
                incr BusOutput.RobMsgType;
                log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
                MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := 3);                ! 等待软件反馈数据

                if MixStatus = OK then 
                    if CurAgentData.PartData.IsUnrefId <> 0 then  
                        
                        ! log_warn_ "Is Unref ...";

                        ! Code Modified on 2025.05.02
                        ! 不可达时修改为获取任务，而不是获取抓取数据
                        ! mixsort_ack_agent_ \GET_PICK_DATA;
                        mixsort_ack_agent_ \GET_TASK;
                        !
                    else

                        log_info_ "Robot Working ...";
                        AgentData := CurAgentData;
                        mixsort_ack_robot_ \ROBOT_TO_PICK;
                    endif
                endif
            endif

        ! Code added on 2025.05.02
        ! 新增获取任务接口
        case MIX_GET_TASK:               ! 从软件获取下一个任务
            log_info_ "Get Task ...";

            incr BusOutput.RobMsgType;
            
            log_info_ "Wait Tell " + num_to_str_(BusOutput.JobId \INTEGER) + " " + num_to_str_(BusOutput.RobMsgType \INTEGER) + " ...";
            MixStatus := bus_ntell_(BusInput, BusOutput, \Timeout := BusTimeout);       ! 等待软件反馈数据
            if MixStatus = OK then
                log_info_ "Get Task Id![Id:" + num_to_str_(BusInput.JobId \INTEGER) + "]";
                GlobalTaskId := BusInput.JobId;
                test GlobalTaskId
                case 1: mixsort_ack_agent_ \GET_PICTURE_DATA;
                case 2: mixsort_ack_agent_ \GET_PICK_DATA;
                case 3: mixsort_ack_agent_ \GET_PICK_DATA;
                case 4: mixsort_ack_agent_ \GET_PICK_DATA;
                case 5: mixsort_ack_agent_ \GET_PICK_DATA;
                endtest
            endif
        !
        endtest

        if (not MixStatus = OK) then
            log_warn_ "Mixsort Process Error ...";
            mixsort_ack_robot_ \ROBOT_TO_HOME;
        endif

    endwhile
endproc


local proc mixsort_init_data_(\switch PICT_DATA | switch PART_DATA, inout agt_data_t ThisData)

    if present(PICT_DATA) then  
        ThisData.PictData.IsUnrefId := 0;
        ThisData.PictData.PictVec   := [0.0, 0.0, 0.0];
        ThisData.PictData.PictPos   := null_pos_();
    endif

    if present(PART_DATA) then 
        ThisData.PartData.IsUnrefId := 0;
        ThisData.PartData.FromRobId := -1;
        ThisData.PartData.PartLen   := 0.0;
        ThisData.PartData.PkPos     := null_pos_();
        ThisData.PartData.PlPos     := null_pos_();
        ThisData.PartData.OfsOrt    := 0.0;
        ThisData.PartData.OfsRz     := 0.0;
        ThisData.PartData.MagPip    := [0, 0, 0, 0, 0, 0, 0, 0];
        ThisData.PartData.GripDist1 := 0.0;
        ThisData.PartData.GripDist2 := 0.0;
        ThisData.PartData.Thickness := 0.0;
        ThisData.PartData.Weight    := 0.0;
        ThisData.PartData.PlaceId   := 0;
    endif
endproc

local func robtarget mixsort_cnv_pos_(robtarget ThisPos)
    var robtarget CnvPos;
    
    CnvPos := ThisPos;

    if MixPkCfg.NumAxis > 6 then  

        test MixPkCfg.ExtCfg.E7Coordinate
        
        case 1:

            CnvPos.extax.eax_a := CnvPos.Trans.x;

            if abs(CnvPos.Trans.y) < abs(MixPkCfg.PictCfg.PtMinDist) then

                if CnvPos.extax.eax_a > MixPkCfg.PictCfg.PtRlE7Pos then

                    CnvPos.extax.eax_a := CnvPos.extax.eax_a - sqrt(MixPkCfg.PictCfg.PtMinDist * MixPkCfg.PictCfg.PtMinDist - CnvPos.Trans.y * CnvPos.Trans.y);
                else

                    CnvPos.extax.eax_a := CnvPos.extax.eax_a + sqrt(MixPkCfg.PictCfg.PtMinDist * MixPkCfg.PictCfg.PtMinDist - CnvPos.Trans.y * CnvPos.Trans.y);
                endif
            
            endif

        case 2:

            CnvPos.extax.eax_a := CnvPos.Trans.y;

            if abs(CnvPos.Trans.x) < abs(MixPkCfg.PictCfg.PtMinDist) then

                if CnvPos.extax.eax_a > MixPkCfg.PictCfg.PtRlE7Pos then

                    CnvPos.extax.eax_a := CnvPos.extax.eax_a - sqrt(MixPkCfg.PictCfg.PtMinDist * MixPkCfg.PictCfg.PtMinDist - CnvPos.Trans.x * CnvPos.Trans.x);
                else

                    CnvPos.extax.eax_a := CnvPos.extax.eax_a + sqrt(MixPkCfg.PictCfg.PtMinDist * MixPkCfg.PictCfg.PtMinDist - CnvPos.Trans.x * CnvPos.Trans.x);
                endif
            
            endif


        endtest


    endif

    return(CnvPos);
endfunc


local proc mixsort_ack_robot_(\switch ROBOT_TO_NEXT | switch ROBOT_TO_PICTURE | switch ROBOT_TO_PICK | switch ROBOT_TO_HOME)

    if present(ROBOT_TO_NEXT)       ToRobotCmd := TO_TP_NEXT;           
    if present(ROBOT_TO_PICTURE)    ToRobotCmd := TO_TP_PICT;
    if present(ROBOT_TO_PICK)       ToRobotCmd := TO_TP_PK;
    if present(ROBOT_TO_HOME)       ToRobotCmd := TO_TP_HOME;
    ToRobotFlg := false;
endproc

local proc mixsort_ack_agent_(\switch BUSIO_INIT | switch TAKING_EDG_PICTURE | switch GET_PICTURE_DATA | switch TAKING_LTN_PICTURE | switch GET_PICK_DATA | switch GET_TASK)
    
    if present(BUSIO_INIT)              ToSensorCmd := MIX_BUSIO_INIT;
    if present(TAKING_EDG_PICTURE)      ToSensorCmd := MIX_EDG_PIT;
    if present(GET_PICTURE_DATA)        ToSensorCmd := MIX_PIT_DAT;
    if present(TAKING_LTN_PICTURE)      ToSensorCmd := MIX_LTN_PIT;
    if present(GET_PICK_DATA)           ToSensorCmd := MIX_PIK_DAT;

    ! Code added on 2025.05.02
    ! 添加获取任务指令
    if present(GET_TASK)                ToSensorCmd := MIX_GET_TASK;
    !

    ToSensorFlg := false;

    if present(BUSIO_INIT)              waittestandset ToRobotFlg;
endproc



endmodule