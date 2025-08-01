module sbt_comm010_t
!***********************************************************
!
! file Name: sbt_comm010_t
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


record sensor_data_table_t
    byte        Mode;               ! 任务模式 [通常模式和垛上测量模式]
    num         TaskNum;            ! 任务编号
    byte        Area;               ! 区域号
    byte        Pip;                ! 吸盘通道
    num         BoxLenght;          ! 工件长
    num         BoxWidth;           ! 工件宽
    num         BoxHigh;            ! 工件高
    robtarget   ObliPos;            ! 斜插点
    robtarget   PickPos;            ! 抓取点
    robtarget   PlacePos;           ! 码垛点
endrecord

record robot_data_table_t
    byte        WorkMode;           ! 工作模式 [拆垛或者码垛]
    byte        TaskNum;            ! 当前任务号
    byte        Area;               ! 当前区域号
endrecord

const byte G_WORK_MODE_STACK            := 1;                   ! 工作模式 --> 码垛模式
const byte G_WORK_MODE_UNSTACK          := 2;                   ! 工作模式 --> 拆垛模式


const byte G_COMMAND_UNKNOWN            := 0;                   ! 未知命令
const byte G_COMMAND_INIT               := 255;                 ! 初始化命令
const byte G_COMMAND_DATA1              := 1;                   ! 请求工件数据命令
const byte G_COMMAND_DATA2              := 2;                   ! 请求垛上测量数据命令
const byte G_COMMAND_DTFEEK             := 3;                   ! 可达反馈命令
const byte G_COMMAND_PKSU               := 4;                   ! 抓取成功命令
const byte G_COMMAND_MISS               := 5;                   ! 丢件命令
const byte G_COMMAND_PRESS              := 6;                   ! 过压命令
const byte G_COMMAND_PKFL               := 7;                   ! 抓取失败命令
const byte G_COMMAND_AREA               := 8;                   ! 离开区域命令

const byte G_RESULT_UNKNOWN             := 0;                   ! 结果未知
const byte G_RESULT_OK                  := 129;                 ! 结果 OK
const byte G_RESULT_NOTOK               := 130;                 ! 结果 NOT OK

const byte  COMM010_MODE_UNKNOWN        := 0;                   ! 未知抓取模式
const byte  COMM010_MODE_ONE            := 11;                  ! 通常模式
const byte  COMM010_MODE_TWO            := 12;                  ! 垛上测量模式


pers busin_t BusInput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
pers busout_t BusOutput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

pers sensor_data_table_t SensorDataTable;
pers robot_data_table_t RobotDataTable;
pers pos LimitUp{8};
pers pos LimitDown{8};

pers num BusTimeout                 := 60;                      ! 通讯超时时间 sec


pers byte GlobalResultId            := 0;
pers byte GlobalCommandId           := 0;
pers bool ToResultFlg               := false;               

pers tooldata StackTool             := [true, [[0, 0, 0], [1, 0, 0, 0]],
                                       [0.001, [0, 0, 0.001], [1, 0, 0, 0], 0, 0, 0]];

endmodule