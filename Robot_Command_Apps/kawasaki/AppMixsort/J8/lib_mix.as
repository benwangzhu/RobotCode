;***********************************************************
;
; File Name: lib_mix.as
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


.program pg.dt_to_plc_(.MagData1, .MagData2, .MagData3, .MagData4, .ServoData, .PartData)

    bits GoMagPip1St, GoMagPip1Len = .MagData1
    bits GoMagPip2St, GoMagPip2Len = .MagData2
    bits GoMagPip3St, GoMagPip3Len = .MagData3
    bits GoMagPip4St, GoMagPip4Len = .MagData4
    bits GoGripDistSt, GoGripDistLen = .ServoData
    bits GoPartSizeSt, GoPartSizeLen = .PartData
    pulse Do39GropMove
.end 

.program pg.ack_mix_sr_(.AckNo)

    signal -MixAckReq, -MixAckRlt
    AckSensorCmd = .AckNo
    signal MixAckReq
.end

.program pg.cnv_pt_posn_(.Vx, .Vy, .Ox, .Oy, .NumAs, .E7CoordMode, .&PFrame, .&InPosn, .MaxJ7, .MinJ7, .MinDist, .RlE7Pos, .&OutPosn) 
    .MaxJp7 = .MaxJ7 - 50
    .minjp7 = .MinJ7 + 50

    point .PosTrans = -.&PFrame + .&InPosn

    decompose .InPosAry[0] = .PosTrans
    .OutPosAry[0] = .InPosAry[0] + .Vx + .Ox
    .OutPosAry[1] = .InPosAry[1] + .Vy + .Oy
    .OutPosAry[2] = .InPosAry[2]
    .OutPosAry[3] = .InPosAry[3]
    .OutPosAry[4] = .InPosAry[4]
    .OutPosAry[5] = .InPosAry[5]

    if .NumAs == 7 then 

        .OutPosAry[7] = .InPosAry[7]

        case .E7CoordMode of

        value 2:

            .OutPosAry[7] = .OutPosAry[7] + .OutPosAry[1]
            .OutPosAry[1] = 0.0

            if (abs(.OutPosAry[0]) < abs(.MinDist)) and (.OutPosAry[7] < .RlE7Pos) then  

                .OutPosAry[1] = sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0]) * (-1)
                .OutPosAry[7] = .OutPosAry[7] + sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0])
            else
                if (abs(.OutPosAry[0]) < abs(.MinDist)) and (.OutPosAry[7] >= .RlE7Pos) then

                    .OutPosAry[1] = sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0])
                    .OutPosAry[7] = .OutPosAry[7] - sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0])
                end
            end

            if .OutPosAry[7] <= .MinJp7 then
                .OutPosAry[1] = .OutPosAry[1] + .OutPosAry[7] - .MinJp7
                .OutPosAry[7] = .MinJp7
            end
            if .OutPosAry[7] >= .MaxJp7 then
                .OutPosAry[1] = .OutPosAry[1] + .OutPosAry[7] - .MaxJp7
                .OutPosAry[7] = .MaxJp7
            end

        value 1:

            .OutPosAry[7] = .OutPosAry[7] + .OutPosAry[0]
            .OutPosAry[0] = 0.0

            if (abs(.OutPosAry[1]) < abs(.MinDist)) and (.OutPosAry[7] < .RlE7Pos) then  

                .OutPosAry[0] = sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1]) * (-1)
                .OutPosAry[7] = .OutPosAry[7] + sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1])
            else
                if (abs(.OutPosAry[1]) < abs(.MinDist)) and (.OutPosAry[7] >= .RlE7Pos) then

                    .OutPosAry[0] = sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1])
                    .OutPosAry[7] = .OutPosAry[7] - sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1])
                end
            end

            if .OutPosAry[7] <= .MinJp7 then
                .OutPosAry[0] = .OutPosAry[0] + .OutPosAry[7] - .MinJp7
                .OutPosAry[7] = .MinJp7
            end
            if .OutPosAry[7] >= .MaxJp7 then
                .OutPosAry[0] = .OutPosAry[0] + .OutPosAry[7] - .MaxJp7
                .OutPosAry[7] = .MaxJp7
            end
        any :

            halt  
        end  
    end
    
    point .PosTrans = trans(.OutPosAry[0], .OutPosAry[1], .OutPosAry[2], .OutPosAry[3], .OutPosAry[4], .OutPosAry[5])
    point .&OutPosn = .&PFrame + .PosTrans

    if .NumAs == 7 then

        point/8 .&OutPosn = trans(0, 0, 0, 0, 0, 0, 0, .OutPosAry[7])
    end

.end

.program pg.cnv_pk_posn_(.NumAs, .E7CoordMode, .&InPosn, .MaxJ7, .MinJ7, .MinDist, .RlE7Pos, .&OutPosn) 
    .MaxJp7 = .MaxJ7 - 50
    .minjp7 = .MinJ7 + 50

    point .PosTrans = .&InPosn

    decompose .InPosAry[0] = .PosTrans
    .OutPosAry[0] = .InPosAry[0]
    .OutPosAry[1] = .InPosAry[1]
    .OutPosAry[2] = .InPosAry[2]
    .OutPosAry[3] = .InPosAry[3]
    .OutPosAry[4] = .InPosAry[4]
    .OutPosAry[5] = .InPosAry[5]

    if .NumAs == 7 then 

        .OutPosAry[7] = .InPosAry[7]

        case .E7CoordMode of

        value 2:

            .OutPosAry[7] = .OutPosAry[7] + .OutPosAry[1]
            .OutPosAry[1] = 0.0

            if (abs(.OutPosAry[0]) < abs(.MinDist)) and (.OutPosAry[7] < .RlE7Pos) then  

                .OutPosAry[1] = sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0]) * (-1)
                .OutPosAry[7] = .OutPosAry[7] + sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0])
            else
                if (abs(.OutPosAry[0]) < abs(.MinDist)) and (.OutPosAry[7] >= .RlE7Pos) then

                    .OutPosAry[1] = sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0])
                    .OutPosAry[7] = .OutPosAry[7] - sqrt(.MinDist * .MinDist - .OutPosAry[0] * .OutPosAry[0])
                end
            end

            if .OutPosAry[7] <= .MinJp7 then
                .OutPosAry[1] = .OutPosAry[1] + .OutPosAry[7] - .MinJp7
                .OutPosAry[7] = .MinJp7
            end
            if .OutPosAry[7] >= .MaxJp7 then
                .OutPosAry[1] = .OutPosAry[1] + .OutPosAry[7] - .MaxJp7
                .OutPosAry[7] = .MaxJp7
            end

        value 1:

            .OutPosAry[7] = .OutPosAry[7] + .OutPosAry[0]
            .OutPosAry[0] = 0.0

            if (abs(.OutPosAry[1]) < abs(.MinDist)) and (.OutPosAry[7] < .RlE7Pos) then  

                .OutPosAry[0] = sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1]) * (-1)
                .OutPosAry[7] = .OutPosAry[7] + sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1])
            else
                if (abs(.OutPosAry[1]) < abs(.MinDist)) and (.OutPosAry[7] >= .RlE7Pos) then

                    .OutPosAry[0] = sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1])
                    .OutPosAry[7] = .OutPosAry[7] - sqrt(.MinDist * .MinDist - .OutPosAry[1] * .OutPosAry[1])
                end
            end

            if .OutPosAry[7] <= .MinJp7 then
                .OutPosAry[0] = .OutPosAry[0] + .OutPosAry[7] - .MinJp7
                .OutPosAry[7] = .MinJp7
            end
            if .OutPosAry[7] >= .MaxJp7 then
                .OutPosAry[0] = .OutPosAry[0] + .OutPosAry[7] - .MaxJp7
                .OutPosAry[7] = .MaxJp7
            end
        any :

            halt  
        end  
    end
    
    point .PosTrans = trans(.OutPosAry[0], .OutPosAry[1], .OutPosAry[2], .OutPosAry[3], .OutPosAry[4], .OutPosAry[5])
    point .&OutPosn = .PosTrans

    if .NumAs == 7 then

        point/8 .&OutPosn = trans(0, 0, 0, 0, 0, 0, 0, .OutPosAry[7])
    end

.end


.program pg.safety_chk_(.&NeedChkPos, .NumOfAxis, .MinX, .MaxX, .MinY, .MaxY, .Status)

    decompose .InPosAry[0] = .NeedChkPos
    point .ChkPosAxis6 = trans(.InPosAry[0], .InPosAry[1], .InPosAry[2], .InPosAry[3], .InPosAry[4], .InPosAry[5])

    if inrange(.ChkPosAxis6, #here) then
        .Status = -1
        return
    end

    if .NumOfAxis == 7 then 
        
        .SafetyX = .InPosAry[0] + .InPosAry[7]
    else

        .SafetyX = .InPosAry[0]
    end

    if (.SafetyX < .MinX) or (.SafetyX > .MaxX) then
        .Status = -2
        return
    end

    .SafetyY = .InPosAry[1]

    if (.SafetyY < .MinY) or (.SafetyY > .MaxY) then
        .Status = -3
        return
    end

    .Status = 0

.end



