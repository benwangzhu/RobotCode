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
    byte        Mode;               ! ����ģʽ [ͨ��ģʽ�Ͷ��ϲ���ģʽ]
    num         TaskNum;            ! ������
    byte        Area;               ! �����
    byte        Pip;                ! ����ͨ��
    num         BoxLenght;          ! ������
    num         BoxWidth;           ! ������
    num         BoxHigh;            ! ������
    robtarget   ObliPos;            ! б���
    robtarget   PickPos;            ! ץȡ��
    robtarget   PlacePos;           ! ����
endrecord

record robot_data_table_t
    byte        WorkMode;           ! ����ģʽ [���������]
    byte        TaskNum;            ! ��ǰ�����
    byte        Area;               ! ��ǰ�����
endrecord

const byte G_WORK_MODE_STACK            := 1;                   ! ����ģʽ --> ���ģʽ
const byte G_WORK_MODE_UNSTACK          := 2;                   ! ����ģʽ --> ���ģʽ


const byte G_COMMAND_UNKNOWN            := 0;                   ! δ֪����
const byte G_COMMAND_INIT               := 255;                 ! ��ʼ������
const byte G_COMMAND_DATA1              := 1;                   ! ���󹤼���������
const byte G_COMMAND_DATA2              := 2;                   ! ������ϲ�����������
const byte G_COMMAND_DTFEEK             := 3;                   ! �ɴﷴ������
const byte G_COMMAND_PKSU               := 4;                   ! ץȡ�ɹ�����
const byte G_COMMAND_MISS               := 5;                   ! ��������
const byte G_COMMAND_PRESS              := 6;                   ! ��ѹ����
const byte G_COMMAND_PKFL               := 7;                   ! ץȡʧ������
const byte G_COMMAND_AREA               := 8;                   ! �뿪��������

const byte G_RESULT_UNKNOWN             := 0;                   ! ���δ֪
const byte G_RESULT_OK                  := 129;                 ! ��� OK
const byte G_RESULT_NOTOK               := 130;                 ! ��� NOT OK

const byte  COMM010_MODE_UNKNOWN        := 0;                   ! δ֪ץȡģʽ
const byte  COMM010_MODE_ONE            := 11;                  ! ͨ��ģʽ
const byte  COMM010_MODE_TWO            := 12;                  ! ���ϲ���ģʽ


pers busin_t BusInput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
pers busout_t BusOutput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

pers sensor_data_table_t SensorDataTable;
pers robot_data_table_t RobotDataTable;
pers pos LimitUp{8};
pers pos LimitDown{8};

pers num BusTimeout                 := 60;                      ! ͨѶ��ʱʱ�� sec


pers byte GlobalResultId            := 0;
pers byte GlobalCommandId           := 0;
pers bool ToResultFlg               := false;               

pers tooldata StackTool             := [true, [[0, 0, 0], [1, 0, 0, 0]],
                                       [0.001, [0, 0, 0.001], [1, 0, 0, 0], 0, 0, 0]];

endmodule