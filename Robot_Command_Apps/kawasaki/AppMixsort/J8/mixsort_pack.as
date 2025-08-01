;***********************************************************
;
; File Name: mixsort_pack.as
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2021 - 11 - 10
;   Modification Data    ==   2022 - 12 - 30
;
; Author: speedbot
;
; Version: 3.0
;***********************************************************

.program pg.mix_cfg_()

    MixShutReq                  = 2045      
    MixFinish                   = 2050
    MixAckReq                   = 2055
    MixAckRlt                   = 2056

    EDG_PICT                    = 1
    GET_PICT_POS                = 2
    LTN_PICT                    = 3
    GET_DATA                    = 4

    MOVE_NEXT                   = 1
    MOVE_PICT                   = 2
    MOVE_PK                     = 3
    MOVE_HOME                   = 4    

    ; 通讯定义
    BusInput[0]                 = 1129
    BusOutput[0]                = 129
    BusioTimeout			    = 120.0

    ; 机器人ID
    RobotId                     = 1

    ; TRUE  -- 眼在手上填
    ; FALSE -- 眼在手外
    EyeInHand                   = true

    ; TRUE  -- 码框
    ; FALSE -- 放传送带
    BoxOrConv                   = true

    ; 机器人轴数，自动获取
    NumAxis                     = 7

    ; 放置位置数量, 最多几个框或者传送带
    NumPlPoint                  = 2

    if NumAxis == 7 then

        ; 导轨轴上极限
        Jt7limUp                = 1000.0

        ; 导轨轴下极限
        Jt7LimDw                = -4200
    end


    if EyeInHand == true then
        
        ; 机器人坐标系和套料图坐标系的夹角, 不填
        point Pictframe         = trans(0, 0, 0, 0, 0, 0)

        if NumAxis == 7 then

            ; 1 -- 地轨轴与 +X 轴同向
            ; 2 -- 地轨轴与 +Y 轴同向
            PictCoordinate          = 1

            ; 拍照时抓手末端距离机器人的最小距离，值太小，在抓取时抓手可能撞本体
            PictMinDist             = 1600.0

            ; 决定左拍或者右拍时的地轨分界点
            PictRlE7Pos             = -1600.0
        end

        ; 拍照位置偏移 X
        PictOfsX                = 0

        ; 拍照位置偏移 Y
        PictOfsY                = 0

        ; 拍照位置极限定义, 存在导轨轴时，值需要包含导轨值
        PtSafetyMaxX            = 1306
        PtSafetyMinX            = -4320
        PtSafetyMaxY            = 3150.0
        PtSafetyMinY            = 1200
    end

    ; 抓取位置极限定义, 存在导轨轴时，值需要包含导轨值
    PkSafetyMaxX                = 1306
    PkSafetyMinX                = -4320
    PkSafetyMaxY                = 3150.0
    PkSafetyMinY                = 1200

    if BoxOrConv == true then 

        ; 码垛框 1 配置数据
        placeUpDst[0]           = 900                 ; 机器人每次进框和出框时的位置
        PlaceMaxX[0]            = 753.0                ; -- 码垛框位置极限定义, 存在导轨轴时，值需要包含导轨值
        PlaceMinX[0]            = -734               
        PlaceMaxY[0]            = -1666
        PlaceMinY[0]            = -2368                                                             ; --
        if NumAxis == 7 then
            
            placeE7Pos[0]       = -1386.222                   ; 码框时的导轨轴的位置
        end
        

        ; 码垛框 2 配置数据
        placeUpDst[1]           = 900
        PlaceMaxX[1]            = -2135
        PlaceMinX[1]            = -3618
        PlaceMaxY[1]            = -1635
        PlaceMinY[1]            = -2341
        if NumAxis == 7 then
            
            placeE7Pos[1]       = -1386.222
        end

        ; 码垛框 3 配置数据
        placeUpDst[2]           = 300.0
        PlaceMaxX[2]            = 2000.0
        PlaceMinX[2]            = -2000.0
        PlaceMaxY[2]            = 2000.0
        PlaceMinY[2]            = -2000.0
        if NumAxis == 7 then
            
            placeE7Pos[2]       = 0.0
        end

        ; 码垛框 4 配置数据
        placeUpDst[3]           = 300.0
        PlaceMaxX[3]            = 2000.0
        PlaceMinX[3]            = -2000.0
        PlaceMaxY[3]            = 2000.0
        PlaceMinY[3]            = -2000.0
        if NumAxis == 7 then
            
            placeE7Pos[3]       = 0.0
        end

        ; 码垛框 5 配置数据
        placeUpDst[4]           = 300.0
        PlaceMaxX[4]            = 2000.0
        PlaceMinX[4]            = -2000.0
        PlaceMaxY[4]            = 2000.0
        PlaceMinY[4]            = -2000.0
        if NumAxis == 7 then
            
            placeE7Pos[4]       = 0.0
        end

        ; 码垛框 6 配置数据
        placeUpDst[5]           = 300.0
        PlaceMaxX[5]            = 2000.0
        PlaceMinX[5]            = -2000.0
        PlaceMaxY[5]            = 2000.0
        PlaceMinY[5]            = -2000.0
        if NumAxis == 7 then
            
            placeE7Pos[5]       = 0.0
        end

        ; 码垛框 7 配置数据
        placeUpDst[6]           = 300.0
        PlaceMaxX[6]            = 2000.0
        PlaceMinX[6]            = -2000.0
        PlaceMaxY[6]            = 2000.0
        PlaceMinY[6]            = -2000.0
        if NumAxis == 7 then
            
            placeE7Pos[3]       = 0.0
        end

        ; 码垛框 8 配置数据
        placeUpDst[7]           = 300.0
        PlaceMaxX[7]            = 2000.0
        PlaceMinX[7]            = -2000.0
        PlaceMaxY[7]            = 2000.0
        PlaceMinY[7]            = -2000.0
        if NumAxis == 7 then
            
            placeE7Pos[7]       = 0.0
        end
    else

        ; 放置传送带 1 配置数据
        PlOfsMode[0]            = 1             
        MaxDpOfs[0]             = 100.0
        MinDpOfs[0]             = -100.0

        ; 放置传送带 2 配置数据
        PlOfsMode[1]            = 1
        MaxDpOfs[1]             = 100.0
        MinDpOfs[1]             = -100.0


    end

    ; 工具坐标系定义
    point MagTool               = trans(0, 0, 0, 0, 0, 0)
.end



.program pg.mix_init_()

    VsnFromRobId                = 0

    VsnPictX                    = 0.0
    VsnPictY                    = 0.0

    VsnPartDist                 = 0.0

    for .I = 0 to 5
        VsnPkPosn[.I]           = 0.0
    end

    for .I = 0 to 5 
        VsnPlPosn[.I]           = 0.0
    end

    VsnDpOrt                    = 0.0   
    VsnDpRz                     = 0.0     
    VsnPlaceId                  = 0

    for .I = 0 to 7
        VsnMagPip[.I]           = 0
    end

    VsnThickness                = 0.0
    VsnWeight                   = 0.0

    VsnGripDist                 = 0.0

    AckSensorCmd                = 0
    AckContCmd                  = 0

    point VsnPictPos            = null
    point VsnPickPos            = null
    point VsnDropPos            = null
    point NewDropPosUp          = null
    point NewDropPos            = null

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    pulse Do32FocMagOff, 1
.end

.program pg.mixsort_main()

    call pg.mix_cfg_

    call pg.mix_init_

    call pg.move_pounce_

    call pg.run_sensor_

    if EyeInHand == true then  
        call pg.ack_mix_sr_(GET_PICT_POS)
    else
        call pg.ack_mix_sr_(GET_DATA)
    end

10
    wait (sig(MixAckRlt) == true)

    signal -MixAckRlt

    case AckContCmd of

    value MOVE_NEXT:


        call pg.move_wpos_
        goto 10

    value MOVE_PICT:

        call pg.mov_pict_

        twait 0.5

        ;call pg.zone_(&VsnPictPos, 900.0, 100.0)
        call pg.ack_mix_sr_(LTN_PICT)
        ;call lib.exit_zone_(1)
        ;call lib.exit_zone_(2)
        twait 1

        goto 10

    value MOVE_PK:

        call pg.dt_to_plc_(VsnMagPip[0], VsnMagPip[1], VsnMagPip[2], VsnMagPip[3], round(VsnGripDist / 10.0), round(VsnPartDist / 10.0))
        call pg.assig_data_
        call pg.mov_pick_

        if BoxOrConv == true then  

            case VsnPlaceId of

            value 1:
                call pg.move_box1_
            value 2:
                call pg.move_box2_
            value 3:
                call pg.move_box3_
            value 4:
                call pg.move_box4_
            value 5:
                call pg.move_box5_
            value 6:
                call pg.move_box6_
            value 7:
                call pg.move_box7_
            value 8:
                call pg.move_box8_

            end

        else

            case VsnPlaceId of

            value 1:
                call pg.move_conv1_
            value 2:
                call pg.move_conv2_
            end
        end

        goto 10

    value MOVE_HOME:

        goto 20

    any :

        halt
    end

20

    call lib.mov_home_

.end 

.program pg.run_sensor_()

    pcabort 2:
    twait 0.1

    signal -MixShutReq, -MixAckReq, -MixAckRlt

    call lib.bus_init_(BusInput[], BusOutput[], RobotId, PTC_ST_PK)

    ;pcabort 2:
    ;twait 0.1

    call lib.log_info_("MX", "Run Sensor Task ...")
    pcexecute 2:pg.pk_sensor_, 1

.end 

.program pg.pk_sensor_()

    
    while sig(MixShutReq) == false do

        call lib.log_info_("SR", "Waiting for AcK Or ShutDown ...")
        wait (sig(MixAckReq) == true) or (sig(MixShutReq) == true)

        if sig(MixAckReq) == true then

            signal -MixAckReq

            BusOutput[GO_ROBOTMSGTYPE]  = 0
            BusOutput[GO_JOBID]         = AckSensorCmd

            case BusOutput[GO_JOBID] of

            value EDG_PICT:

                call lib.log_info_("SR", "Edg Picture ...")
                BusOutput[GO_ROBOTMSGTYPE] = BusOutput[GO_ROBOTMSGTYPE] + 1
                call lib.bus_ntell_(BusInput[], BusOutput[], BusioTimeout, MixStatus)

                if MixStatus == 0 then

                    call lib.log_info_("SR", "Edg Picture End ...")
                    AckContCmd = MOVE_NEXT
                    signal MixAckRlt
                end
            
            value LTN_PICT:
        
                call lib.log_info_("SR", "Ltn Picture ...")
                call lib.cur_pos_(&null, &null, .&PictHere)
                decompose .PictArray[0] = .PictHere
                call lib.bus_sfloat2_(BusOutput[BUSIO_ST] + 64, .PictArray[0])
                call lib.bus_sfloat2_(BusOutput[BUSIO_ST] + 96, .PictArray[1])
                call lib.bus_sfloat2_(BusOutput[BUSIO_ST] + 128, .PictArray[2])
                call lib.bus_sfloat2_(BusOutput[BUSIO_ST] + 160, .PictArray[3])
                call lib.bus_sfloat2_(BusOutput[BUSIO_ST] + 192, .PictArray[4])
                call lib.bus_sfloat2_(BusOutput[BUSIO_ST] + 224, .PictArray[5])
                BusOutput[GO_ROBOTMSGTYPE] = BusOutput[GO_ROBOTMSGTYPE] + 1
                call lib.bus_ntell_(BusInput[], BusOutput[], BusioTimeout, MixStatus)
                if MixStatus == 0 then

                    call lib.log_info_("SR", "Ltn Picture End ...")
                    AckContCmd = MOVE_NEXT
                    signal MixAckRlt
                end

            value GET_PICT_POS:

                call lib.log_info_("SR", "Get Picture Posn ...")
                BusOutput[GO_ROBOTMSGTYPE] = BusOutput[GO_ROBOTMSGTYPE] + 1
                call lib.bus_ntell_(BusInput[], BusOutput[], BusioTimeout, MixStatus)


                if MixStatus == 0 then

                    call lib.bus_uptin_(BusInput[])
                    if BusInput[DI_FINISHED] == true then

                        call lib.log_info_("SR", "All Finished ...")
                        AckContCmd = MOVE_HOME
                        signal MixShutReq
                    else

                        call lib.log_info_("SR", "Get Picture Posn Successful ...")
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 64, VsnPictX)
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 96, VsnPictY)
                        call pg.cnv_pt_posn_(VsnPictX, VsnPictY, PictOfsX, PictOfsY, NumAxis, PictCoordinate, &Pictframe, &PictBase, Jt7limUp, Jt7LimDw, PictMinDist, PictRlE7Pos, &VsnPictPos)
                        call pg.safety_chk_(&VsnPictPos, NumAxis, PtSafetyMinX, PtSafetyMaxX, PtSafetyMinY, PtSafetyMaxY, MixUnref)

                        if MixUnref == 0 then 

                            call lib.bus_sbyte_(BusOutput[BUSIO_ST] + 64, 0)
                        else

                            call lib.bus_sbyte_(BusOutput[BUSIO_ST] + 64, 1)
                        end

                        BusOutput[GO_ROBOTMSGTYPE] = BusOutput[GO_ROBOTMSGTYPE] + 1
                        call lib.bus_ntell_(BusInput[], BusOutput[], 5, MixStatus)
                           
                        if MixStatus == 0 then 
                            if MixUnref <> 0 then 
                                call lib.log_info_("SR", "Picture Posn Unref ...")
                                AckSensorCmd = GET_PICT_POS
                                signal MixAckReq
                            else
                        
                                call lib.log_info_("SR", "Get Picture Posn End ...")
                                AckContCmd = MOVE_PICT
                                signal MixAckRlt
                            end
                        end
                    end
                end

            value GET_DATA:

                call lib.log_info_("SR", "Get Data ...")

                BusInput[DI_FINISHED] = false

                while (MixStatus == 0) and (BusInput[DI_FINISHED] == false) and (BusOutput[GO_ROBOTMSGTYPE] < 3)

                    BusOutput[GO_ROBOTMSGTYPE] = BusOutput[GO_ROBOTMSGTYPE] + 1
                    call lib.bus_ntell_(BusInput[], BusOutput[], BusioTimeout, MixStatus)

                    case BusOutput[GO_ROBOTMSGTYPE] of

                    value 1:
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 64, VsnFromRobId)
                        call lib.bus_gsint_(BusInput[BUSIO_ST] + 72, VsnPartDist)
                        call lib.bus_gsint_(BusInput[BUSIO_ST] + 88, VsnDpOrt)
                        call lib.bus_gsint_(BusInput[BUSIO_ST] + 104, VsnDpRz)
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 120, VsnMagPip[0])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 128, VsnMagPip[1])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 136, VsnMagPip[2])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 144, VsnMagPip[3])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 152, VsnMagPip[4])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 160, VsnMagPip[5])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 168, VsnMagPip[6])
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 176, VsnMagPip[7])
                        call lib.bus_gsint_(BusInput[BUSIO_ST] + 184, VsnGripDist)
                        call lib.bus_gsint_(BusInput[BUSIO_ST] + 200, VsnThickness)
                        call lib.bus_gsint_(BusInput[BUSIO_ST] + 216, VsnWeight)
                        call lib.bus_gbyte_(BusInput[BUSIO_ST] + 232, VsnPlaceId)

                        call lib.log_info_("SR", "Get Part Data Successful ...")
                    value 2:

                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 64, VsnPkPosn[0])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 96, VsnPkPosn[1])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 128, VsnPkPosn[2])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 160, VsnPkPosn[3])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 192, VsnPkPosn[4])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 224, VsnPkPosn[5])

                        call lib.log_info_("SR", "Get Pick Pos Successful ...")
                    value 3:
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 64, VsnPlPosn[0])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 96, VsnPlPosn[1])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 128, VsnPlPosn[2])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 160, VsnPlPosn[3])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 192, VsnPlPosn[4])
                        call lib.bus_gfloat2_(BusInput[BUSIO_ST] + 224, VsnPlPosn[5])

                        call lib.log_info_("SR", "Get Drop Pos Successful ...")
                    any :

                    end
                    
                    call lib.bus_uptin_(BusInput[])
                end

                if BusInput[DI_FINISHED] == true then

                    call lib.log_info_("SR", "Get Data Is Finish ...")

                    if EyeInHand == true then

                        AckSensorCmd = GET_PICT_POS
                        signal MixAckReq
                    else

                        AckContCmd = MOVE_HOME
                        signal MixAckRlt, MixShutReq
                    end

                end


                if (MixStatus == 0) and (BusInput[DI_FINISHED] == false) then

                    point VsnPickPos = trans(VsnPkPosn[0], VsnPkPosn[1], VsnPkPosn[2], VsnPkPosn[3], VsnPkPosn[4], VsnPkPosn[5])

                    if NumAxis == 7 then
                        point/8 VsnPickPos = VsnPictPos
                    end

                    call pg.cnv_pk_posn_(NumAxis, PictCoordinate, &VsnPickPos, Jt7limUp, Jt7LimDw, PictMinDist, PictRlE7Pos, &VsnPickPos)

                    call pg.safety_chk_(&VsnPickPos, NumAxis, PkSafetyMinX, PkSafetyMaxX, PkSafetyMinY, PkSafetyMaxY, MixUnref)

                    if (BoxOrConv == true) and (MixUnref == 0) then  

                        point VsnDropPos = trans(VsnPlPosn[0], VsnPlPosn[1], VsnPlPosn[2], VsnPlPosn[3], VsnPlPosn[4], VsnPlPosn[5])

                        if NumAxis == 7 then
                            point/8 VsnDropPos = trans(VsnPlPosn[0], VsnPlPosn[1], VsnPlPosn[2], VsnPlPosn[3], VsnPlPosn[4], VsnPlPosn[5], 0, PlaceE7Pos[VsnPlaceId - 1])
                        end

                        call pg.safety_chk_(&VsnDropPos, NumAxis, PlaceMinX[VsnPlaceId - 1], PlaceMaxX[VsnPlaceId - 1], PlaceMinY[VsnPlaceId - 1], PlaceMaxY[VsnPlaceId - 1], MixUnref)

                    end

                    if VsnPlaceId > NumPlPoint then  

                        MixUnref = -1
                    end


                    if MixUnref == 0 then 

                        call lib.bus_sbyte_(BusOutput[BUSIO_ST] + 64, 0)
                    else

                        call lib.bus_sbyte_(BusOutput[BUSIO_ST] + 64, 1)
                    end

                    BusOutput[GO_ROBOTMSGTYPE] = BusOutput[GO_ROBOTMSGTYPE] + 1
                    call lib.bus_ntell_(BusInput[], BusOutput[], 3, MixStatus)
                       
                    if MixStatus == 0 then 
                        if MixUnref <> 0 then 
                            call lib.log_info_("SR", "Pick Posn Unref ...")
                            AckSensorCmd = GET_DATA
                            signal MixAckReq
                        else
                    
                            call lib.log_info_("SR", "Get Data End ...")
                            AckContCmd = MOVE_PK
                            signal MixAckRlt
                        end
                    end                
                end

            any :

                halt
            
            end

            if MixStatus <> 0 then 
                signal MixShutReq
            end
        end

    end

    AckContCmd = MOVE_HOME
    signal MixAckRlt

    if MixStatus == 0 then 
        call lib.log_info_("SR", "Exit ...")
    else

        call lib.log_err_("SR", "Ack Agent Error ...")
    end

.end

.program pg.assig_data_()

    point ThisPkPos = VsnPickPos

    decompose .PkPosAry[0] = ThisPkPos
    if .PkPosAry[0] > 600.0 then  

        .PkPosAry[0] = 600.0
    end
    if .PkPosAry[0] < -900.0 then  

        .PkPosAry[0] = -900.0
    end
    
    point .SafePos = trans(.PkPosAry[0], .PkPosAry[1], .PkPosAry[2], .PkPosAry[3], .PkPosAry[4], .PkPosAry[5], .PkPosAry[6], .PkPosAry[7])

    point/X OrentPkPos = .SafePos

    if NumAxis == 7 then  
        point/8 OrentPkPos = ThisPkPos
    end
    
    point .SafePos = trans(.PkPosAry[0], .PkPosAry[1], .PkPosAry[2], .PkPosAry[3], .PkPosAry[4], .PkPosAry[5], .PkPosAry[6], .PkPosAry[7])
    
    ;if NumAxis == 7 then  
    
    ;end

    if BoxOrConv == true then
        point NewDropPos    = VsnDropPos
        point NewDropPosUp  = VsnDropPos

        point/Z NewDropPosUp = trans(0, 0, placeUpDst[VsnPlaceId - 1], 0, 0, 0)

        if NumAxis == 7 then  

            point/8 NewDropPos = trans(0, 0, 0, 0, 0, 0, 0, PlaceE7Pos[VsnPlaceId - 1])
            point/8 NewDropPosUp = trans(0, 0, 0, 0, 0, 0, 0, PlaceE7Pos[VsnPlaceId - 1])

            point PkTransPos2 = shift(VsnPickPos by 0, 0, 100)
            point/8 PkTransPos2 = trans(0, 0, 0, 0, 0, 0, 0, PlaceE7Pos[VsnPlaceId - 1])
        end

    else

        VsnDpOrt    = VsnDpOrt / 10.0
        VsnDpRz     = VsnDpRz / 10.0

        if VsnDpOrt > MaxDpOfs[VsnPlaceId - 1] then  

            VsnDpOrt = MaxDpOfs[VsnPlaceId - 1]
        end

        if VsnDpOrt < MinDpOfs[VsnPlaceId - 1] then  

            VsnDpOrt = MinDpOfs[VsnPlaceId - 1]
        end

        if PlOfsMode[VsnPlaceId - 1] == 1 then 

            point NewDropPos = trans(VsnDpOrt, 0, 0, 0, 0, 0) + ConvDropPos[VsnPlaceId - 1] + trans(0, 0, 0, 0, 0, VsnDpRz * (-1))
        else

            point NewDropPos = trans(0, VsnDpOrt, 0, 0, 0, 0) + ConvDropPos[VsnPlaceId - 1] + trans(0, 0, 0, 0, 0, VsnDpRz * (-1))
        end

        if NumAxis == 7 then  
            point/8 NewDropPos = ConvDropPos[VsnPlaceId - 1]
        end
    end
.end

.program pg.move_wpos_()

    base null
    tool null

    call lib.mtn_def_(20, 100, 50, 50)

    point SafeWaitPos = here
    ;point/Y SafeWaitPos = orentpkpos
    point/Z SafeWaitPos = trans(0, 0, 1450, 0, 0, 0, 0, 0)

    ;lmove shift(SafeWaitPos by 0, 0, 150)

    call pg.ack_mix_sr_(GET_DATA)

.end 

.program pg.mov_pict_()

    base null
    tool null

    call lib.mtn_def_(80, 1, 100, 100)

    lmove VsnPictPos

    break
    
.end        

.program pg.mov_pick_()
    base null
    tool MagTool

    speed 100 always
    accuracy 150 always
    ;Pick
    ;call lib.mtn_def_(100, 150, 100, 100)
    ;lmove OrentPkPos

    ;Enter Zone 1 2 With Rob2 Rob3
    ;call pg.zone_(&ThisPkPos, 1000.0, 0.0)

    lmove shift(ThisPkPos by 0, 0, 100)

    call lib.wait_servo_

    speed 50 always
    accuracy 1 always
    ;call lib.mtn_def_(100, 1, 100, 100)

    lmove ThisPkPos

    call lib.magnet_on_

    speed 100 always
    accuracy 150 always
    ;call lib.mtn_def_(100, 50, 100, 100)

    lmove shift(ThisPkPos by 0, 0, 100)
    ;lmove shift(ThisPkPos by 0, 0, 300)

    ;call lib.mtn_def_(100, 100, 100, 100)

    ;lmove OrentPkPos
    
    ;Exit Zone 1 2 With Rob2 Rob3
    ;call lib.exit_zone_(1)
    ;call lib.exit_zone_(2)

    lmove PkTransPos2

.end

.program pg.move_pounce_()

    base null
    tool null

    call lib.mtn_def_(50, 1, 100, 100)
    
    jmove #PouncePos

.end

.program pg.move_box1_()
    base null
    tool MagTool

    speed 100 always
    accuracy 200 always
    jmove #DpBox1Pos1
    jmove #DpBox1Pos2

    ;Drop
    ;call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    ;call lib.mtn_def_(100, 1, 100, 100)
    speed 30 always
    accuracy 1 always
    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    ;call lib.mtn_def_(100, 50, 100, 100)
    speed 100 always
    accuracy 200 always
    lmove NewDropPosUp

    ;call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox1Pos3
    jmove #DpBox1Pos4
    jmove #DpBox1Pos5

.end

.program pg.move_box2_()
    base null
    tool MagTool
    
    speed 100 always
    accuracy 200 always
    jmove #DpBox2Pos1
    jmove #DpBox2Pos2

    ;Drop
    ;call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    ;call lib.mtn_def_(100, 1, 100, 100)
    speed 30 always
    accuracy 1 always
    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    ;call lib.mtn_def_(100, 50, 100, 100)
    speed 100 always
    accuracy 200 always
    lmove NewDropPosUp

    ;call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox2Pos3
    jmove #DpBox2Pos4
    jmove #DpBox2Pos5

.end

.program pg.move_box3_()
    base null
    tool MagTool

    jmove #DpBox3Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox3Pos2
    jmove #DpBox3Pos3

.end

.program pg.move_box4_()
    base null
    tool MagTool

    jmove #DpBox4Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox4Pos2
    jmove #DpBox4Pos3

.end

.program pg.move_box5_()
    base null
    tool MagTool

    jmove #DpBox5Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox5Pos2
    jmove #DpBox5Pos3

.end

.program pg.move_box6_()
    base null
    tool MagTool

    jmove #DpBox6Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox6Pos2
    jmove #DpBox6Pos3

.end

.program pg.move_box7_()
    base null
    tool MagTool

    jmove #DpBox7Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox7Pos2
    jmove #DpBox7Pos3

.end

.program pg.move_box8_()
    base null
    tool MagTool

    jmove #DpBox8Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove NewDropPosUp

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpBox8Pos2
    jmove #DpBox8Pos3

.end

.program pg.move_conv1_()
    base null
    tool MagTool

    jmove #DpConv1Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove shift(NewDropPos by 0, 0, 100)

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove shift(NewDropPos by 0, 0, 100)

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpConv1Pos2
    jmove #DpConv1Pos3

.end

.program pg.move_conv2_()
    base null
    tool MagTool

    jmove #DpConv2Pos1

    ;Drop
    call lib.mtn_def_(100, 50, 100, 100)

    lmove shift(NewDropPos by 0, 0, 100)

    call lib.mtn_def_(100, 1, 100, 100)

    lmove NewDropPos

    call pg.ack_mix_sr_(GET_DATA)

    call lib.magnet_off_

    twait 0.5

    call lib.mtn_def_(100, 50, 100, 100)

    lmove shift(NewDropPos by 0, 0, 100)

    call lib.mtn_def_(100, 150, 100, 100)

    jmove #DpConv2Pos2
    jmove #DpConv2Pos3

.end

.program pg.go_home()

    ;call lib.enter_zone_(1)
    ;call lib.enter_zone_(2)
    base null
    tool null


    call lib.mtn_def_(30, 10, 100, 100)

    pulse Do32FocMagOff, 1

    twait 1.5

    decompose .P[1] = here
    
    point .npos = here
    
    if .P[3] < 1200 then  

        point .npos =  trans(.P[1], .P[2], 1200, .P[4], .P[5], .P[6], .P[7], .P[8])
        lmove .npos
    end

    decompose .Home[1] = #Home(1)
    point .Home1 = #Home(1)

    if (distance(.Home1, here)) < 100 goto pass2


   ; for .i_z = .Ho[3] to 50 step -1
   ;     point .NPos = trans(.P[1], .P[2], .i_z, .P[4], .P[5], .P[6])
   ;     point/ext .NPos = here
    ;    if inrange(.NPos) == 0 goto pass1
    ;end

pass1:
    lmove .npos
    break
    twait 0.5
    decompose .N[1] = #here
    jmove #ppoint(.N[1], .N[2], .N[3], .N[4], .N[5], .N[6], .Home[7], .Home[8])
    break
    jmove #ppoint(.N[1], .Home[2], .Home[3], .N[4], .Home[5], .N[6], .Home[7], .Home[8])
    break
    jmove #ppoint(.N[1], .Home[2], .Home[3], .Home[4], .Home[5], .Home[6], .Home[7], .Home[8])
    break

pass2:
    call lib.mov_home_
    ;call lib.exit_zone_(1)
    ;call lib.exit_zone_(2)
.end

.program pg.point_teach_()

    base null
    tool MagTool

    lmove #PouncePos

    lmove PictBase

    lmove OrentPkPos

    lmove ThisPkPos

    lmove PkTransPos2

    lmove ConvDropPos[0]

    lmove ConvDropPos[1]

    ; 放置传动带 1 固定轨迹示教
    lmove #DpConv1Pos1
    
    lmove #DpConv1Pos2

    lmove #DpConv1Pos3

    ; 放置传动带 2 固定轨迹示教
    lmove #DpConv2Pos1
    
    lmove #DpConv2Pos2

    lmove #DpConv2Pos3

    ; 放置框 1 固定轨迹示教
    lmove #DpBox1Pos1

    lmove #DpBox1Pos2

    lmove #DpBox1Pos3

    ; 放置框 2 固定轨迹示教
    lmove #DpBox2Pos1

    lmove #DpBox2Pos2

    lmove #DpBox2Pos3

    ; 放置框 3 固定轨迹示教
    lmove #DpBox3Pos1

    lmove #DpBox3Pos2

    lmove #DpBox3Pos3

    ; 放置框 4 固定轨迹示教
    lmove #DpBox4Pos1

    lmove #DpBox4Pos2

    lmove #DpBox4Pos3

    ; 放置框 5 固定轨迹示教
    lmove #DpBox5Pos1

    lmove #DpBox5Pos2

    lmove #DpBox5Pos3

    ; 放置框 6 固定轨迹示教
    lmove #DpBox6Pos1

    lmove #DpBox6Pos2

    lmove #DpBox6Pos3

    ; 放置框 7 固定轨迹示教
    lmove #DpBox7Pos1

    lmove #DpBox7Pos2

    lmove #DpBox7Pos3

    ; 放置框 8 固定轨迹示教
    lmove #DpBox8Pos1

    lmove #DpBox8Pos2

    lmove #DpBox8Pos3

    tool null
    lmove PictBase
.end 













