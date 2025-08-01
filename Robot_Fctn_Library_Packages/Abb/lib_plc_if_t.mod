module lib_plc_if_t
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! File Name: lib_plc_if_t
!
! Description:
!   Language             ==   Rapid for ABB ROBOT
!   Date                 ==   2021 - 10 - 14
!   Modification Data    ==   2024 - 03 - 30
!
! Author: speedbot
!
! Version: 2.0
!*********************************************************************************************************!
!                                                                                                         !
!                                                      .^^^                                               !
!                                               .,~<c+{{{{{{t,                                            ! 
!                                       `^,"!t{{{{{{{{{{{{{{{{+,                                          !
!                                 .:"c+{{{{{{{{{{{{{{{{{{{{{{{{{+,                                        !
!                                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{~                                       !
!                               ^{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{!.  `^                                    !
!                               c{{{{{{{{{{{{{c~,^`  `.^:<+{{{!.  `<{{+,                                  !
!                              ^{{{{{{{{{{{!^              `,.  `<{{{{{{+:                                !
!                              t{{{{{{{{{!`                    ~{{{{{{{{{{+,                              !
!                             ,{{{{{{{{{:      ,uDWMMH^        `c{{{{{{{{{{{~                             !
!                             +{{{{{{{{:     ,XMMMMMMw           t{{{{{{{{{{t                             !
!                            ,{{{{{{{{t     :MMMMMMMMM"          ^{{{{{{{{{{~                             !
!                            +{{{{{{{{~     8MMMMMMMMMMWD8##      {{{{{{{{{+                              !
!                           :{{{{{{{{{~     8MMMMMMMMMMMMMMH      {{{{{{{{{~                              !
!                           +{{{{{{{{{c     :MMMMMMMMMMMMMMc     ^{{{{{{{{+                               !
!                          ^{{{{{{{{{{{,     ,%MMMMMMMMMMH"      c{{{{{{{{:                               !
!                          `+{{{{{{{{{{{^      :uDWMMMX0"       !{{{{{{{{+                                !
!                           `c{{{{{{{{{{{"                    ^t{{{{{{{{{,                                !
!                             ^c{{{{{{{{{{{".               ,c{{{{{{{{{{t                                 !
!                               ^c{{{{{{{{{{{+<,^`     .^~c{{{{{{{{{{{{{,                                 !
!                                 ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t                                  !
!                                   ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t`                                  !
!                                     ^c{{{{{{{{{{{{{{{{{{{{{{{{{{+c"^                                    !                         
!                                       ^c{{{{{{{{{{{{{{{{{+!":^.                                         !
!                                         ^!{{{{{{{{t!",^`                                                !
!                                                                                                         !
!*********************************************************************************************************!
!



var signaldi DiMotorOffReq;           ! [DI] Motor OFF
var signaldi DiMotorOnReq;            ! [DI] Motor ON
var signaldi DiQuickStopReq;          ! [DI] Quick stop
var signaldi DiStopReq;               ! [DI] Stop
var signaldi DiRstExecErrReq;         ! [DI] Error reset
var signaldi DiStartAtMainReq;        ! [DI] Start program from MAIN
var signaldi DiStartReq;              ! [DI] Program start
var signaldi DiPpToMainReq;           ! [DI] Program pointer to MAIN
var signaldi DiEStopReq;              ! [DI] Emergency stop reset
var signaldi DiSysRestartReq;         ! [DI] Control cabinet restart

var signaldi DiZone1Ready;            ! [DI] Zone 1 interference cleared
var signaldi DiZone2Ready;            ! [DI] Zone 2 interference cleared
var signaldi DiZone3Ready;            ! [DI] Zone 3 interference cleared
var signaldi DiZone4Ready;            ! [DI] Zone 4 interference cleared
var signaldi DiZone5Ready;            ! [DI] Zone 5 interference cleared
var signaldi DiZone6Ready;            ! [DI] Zone 6 interference cleared
var signaldi DiZone7Ready;            ! [DI] Zone 7 interference cleared
var signaldi DiZone8Ready;            ! [DI] Zone 8 interference cleared
var signaldi DiZone9Ready;            ! [DI] Zone 9 interference cleared
var signaldi DiZone10Ready;           ! [DI] Zone 10 interference cleared
var signaldi DiZone11Ready;           ! [DI] Zone 11 interference cleared
var signaldi DiZone12Ready;           ! [DI] Zone 12 interference cleared
var signaldi DiEndOfSegMent;          ! [DI] Path segment passage allowed
var signaldi DiReserved42;            ! [DI] Reserved
var signaldi DiReserved43;            ! [DI] Reserved
var signaldi DiReserved44;            ! [DI] Reserved
var signaldi DiToolEcho01;            ! [DI] Tool information feedback 01
var signaldi DiToolEcho02;            ! [DI] Tool information feedback 02
var signaldi DiToolEcho03;            ! [DI] Tool information feedback 03
var signaldi DiToolEcho04;            ! [DI] Tool information feedback 04
var signaldi DiToolEcho05;            ! [DI] Tool information feedback 05
var signaldi DiToolEcho06;            ! [DI] Tool information feedback 06
var signaldi DiToolEcho07;            ! [DI] Tool information feedback 07
var signaldi DiToolEcho08;            ! [DI] Tool information feedback 08
var signaldi DiToolEcho09;            ! [DI] Tool information feedback 09
var signaldi DiToolEcho10;            ! [DI] Tool information feedback 10
var signaldi DiToolEcho11;            ! [DI] Tool information feedback 11
var signaldi DiToolEcho12;            ! [DI] Tool information feedback 12
var signaldi DiExtAxis1Echo;          ! [DI] External axis 1 position feedback
var signaldi DiExtAxis2Echo;          ! [DI] External axis 2 position feedback
var signaldi DiExtAxis3Echo;          ! [DI] External axis 3 position feedback
var signaldi DiReserved60;            ! [DI] Reserved
var signaldi DiReserved61;            ! [DI] Reserved
var signaldi DiReserved62;            ! [DI] Reserved
var signaldi DiReserved63;            ! [DI] Reserved
var signaldi DiReserved64;            ! [DI] Reserved
var signaldi DiReserved65;            ! [DI] Reserved
var signaldi DiReserved66;            ! [DI] Reserved
var signaldi DiReserved67;            ! [DI] Reserved
var signaldi DiCarme1Pict;            ! [DI] Camera 1 has taken a picture
var signaldi DiCarme2Pict;            ! [DI] Camera 2 has taken a picture
var signaldi DiCarme3Pict;            ! [DI] Camera 3 has taken a picture
var signaldi DiLaser1On;              ! [DI] Laser 1 is on
var signaldi DiLaser2On;              ! [DI] Laser 2 is on
var signaldi DiExtDevEcho01;          ! [DI] External device information feedback 01
var signaldi DiExtDevEcho02;          ! [DI] External device information feedback 02
var signaldi DiExtDevEcho03;          ! [DI] External device information feedback 03
var signaldi DiExtDevEcho04;          ! [DI] External device information feedback 04
var signaldi DiExtDevEcho05;          ! [DI] External device information feedback 05
var signaldi DiExtDevEcho06;          ! [DI] External device information feedback 06
var signaldi DiExtDevEcho07;          ! [DI] External device information feedback 07
var signaldi DiExtDevEcho08;          ! [DI] External device information feedback 08
var signaldi DiExtDevEcho09;          ! [DI] External device information feedback 09
var signaldi DiExtDevEcho10;          ! [DI] External device information feedback 10
var signaldi DiExtDevEcho11;          ! [DI] External device information feedback 11
var signaldi DiExtDevEcho12;          ! [DI] External device information feedback 12
var signaldi DiReserved85;            ! [DI] Reserved
var signaldi DiReserved86;            ! [DI] Reserved
var signaldi DiReserved87;            ! [DI] Reserved
var signaldi DiReserved88;            ! [DI] Reserved
var signaldi DiReserved89;            ! [DI] Reserved
var signaldi DiReserved90;            ! [DI] Reserved
var signaldi DiReserved91;            ! [DI] Reserved
var signaldi DiReserved92;            ! [DI] Reserved
var signaldi DiReserved93;            ! [DI] Reserved
var signaldi DiReserved94;            ! [DI] Reserved
var signaldi DiReserved95;            ! [DI] Reserved
var signaldi DiReserved96;            ! [DI] Reserved

var signalgi GiProgNo;                ! [GI] Input program number
var signalgi GiDicisionCode;          ! [GI] Path segment selection
var signalgi GiJobInfo01;             ! [GI] Job information feedback 01
var signalgi GiJobInfo02;             ! [GI] Job information feedback 02
var signalgi GiJobInfo03;             ! [GI] Job information feedback 03
var signalgi GiJobInfo04;             ! [GI] Job information feedback 04
var signalgi GiAxis01;                ! [GI] External axis 1 position

var signaldo DoMotorOff;              ! [DO] Motor OFF
var signaldo DoMotorOn;               ! [DO] Motor ON
var signaldo DoTaskExecuting;         ! [DO] Task executing
var signaldo DoMotorOffState;         ! [DO] Motor OFF state
var signaldo DoMotorOnState;          ! [DO] Motor ON state
var signaldo DoExecutionError;        ! [DO] Execution error
var signaldo DoAtHome;                ! [DO] At home
var signaldo DoInAuto;                ! [DO] In auto mode
var signaldo DoEStop;                 ! [DO] Emergency stop
var signaldo DoSysInBusy;             ! [DO] System busy
var signaldo DoCycleOn;               ! [DO] Cycle mode on
var signaldo DoReqZone1;              ! [DO] Zone 1 interference cleared
var signaldo DoReqZone2;              ! [DO] Zone 2 interference cleared
var signaldo DoReqZone3;              ! [DO] Zone 3 interference cleared
var signaldo DoReqZone4;              ! [DO] Zone 4 interference cleared
var signaldo DoReqZone5;              ! [DO] Zone 5 interference cleared
var signaldo DoReqZone6;              ! [DO] Zone 6 interference cleared
var signaldo DoReqZone7;              ! [DO] Zone 7 interference cleared
var signaldo DoReqZone8;              ! [DO] Zone 8 interference cleared
var signaldo DoReqZone9;              ! [DO] Zone 9 interference cleared
var signaldo DoReqZone10;             ! [DO] Zone 10 interference cleared
var signaldo DoReqZone11;             ! [DO] Zone 11 interference cleared
var signaldo DoReqZone12;             ! [DO] Zone 12 interference cleared
var signaldo DoEndOfSegMentReq;       ! [DO] Path end request
var signaldo DoReserved42;            ! [DO] Reserved
var signaldo DoReserved43;            ! [DO] Reserved
var signaldo DoReserved44;            ! [DO] Reserved
var signaldo DoToolCtrl01;            ! [DO] Tool control 01
var signaldo DoToolCtrl02;            ! [DO] Tool control 02
var signaldo DoToolCtrl03;            ! [DO] Tool control 03
var signaldo DoToolCtrl04;            ! [DO] Tool control 04
var signaldo DoToolCtrl05;            ! [DO] Tool control 05
var signaldo DoToolCtrl06;            ! [DO] Tool control 06
var signaldo DoToolCtrl07;            ! [DO] Tool control 07
var signaldo DoToolCtrl08;            ! [DO] Tool control 08
var signaldo DoToolCtrl09;            ! [DO] Tool control 09
var signaldo DoToolCtrl10;            ! [DO] Tool control 10
var signaldo DoToolCtrl11;            ! [DO] Tool control 11
var signaldo DoToolCtrl12;            ! [DO] Tool control 12
var signaldo DoExtAxis1Ctrl;          ! [DO] External axis 1 control
var signaldo DoExtAxis2Ctrl;          ! [DO] External axis 2 control
var signaldo DoExtAxis3Ctrl;          ! [DO] External axis 3 control
var signaldo DoReserved60;            ! [DO] Reserved
var signaldo DoReserved61;            ! [DO] Reserved
var signaldo DoReserved62;            ! [DO] Reserved
var signaldo DoReserved63;            ! [DO] Reserved
var signaldo DoReserved64;            ! [DO] Reserved
var signaldo DoReserved65;            ! [DO] Reserved
var signaldo DoReserved66;            ! [DO] Reserved
var signaldo DoReserved67;            ! [DO] Reserved
var signaldo DoCarme1Pict;            ! [DO] Camera 1 trigger picture
var signaldo DoCarme2Pict;            ! [DO] Camera 2 trigger picture
var signaldo DoCarme3Pict;            ! [DO] Camera 3 trigger picture
var signaldo DoLaser1On;              ! [DO] Laser 1 on
var signaldo DoLaser2On;              ! [DO] Laser 2 on
var signaldo DoExtDevCtrl01;          ! [DO] External device control 01
var signaldo DoExtDevCtrl02;          ! [DO] External device control 02
var signaldo DoExtDevCtrl03;          ! [DO] External device control 03
var signaldo DoExtDevCtrl04;          ! [DO] External device control 04
var signaldo DoExtDevCtrl05;          ! [DO] External device control 05
var signaldo DoExtDevCtrl06;          ! [DO] External device control 06
var signaldo DoExtDevCtrl07;          ! [DO] External device control 07
var signaldo DoExtDevCtrl08;          ! [DO] External device control 08
var signaldo DoExtDevCtrl09;          ! [DO] External device control 09
var signaldo DoExtDevCtrl10;          ! [DO] External device control 10
var signaldo DoExtDevCtrl11;          ! [DO] External device control 11
var signaldo DoExtDevCtrl12;          ! [DO] External device control 12
var signaldo DoReserved85;            ! [DO] Reserved
var signaldo DoReserved86;            ! [DO] Reserved
var signaldo DoReserved87;            ! [DO] Reserved
var signaldo DoReserved88;            ! [DO] Reserved
var signaldo DoReserved89;            ! [DO] Reserved
var signaldo DoReserved90;            ! [DO] Reserved
var signaldo DoReserved91;            ! [DO] Reserved
var signaldo DoReserved92;            ! [DO] Reserved
var signaldo DoReserved93;            ! [DO] Reserved
var signaldo DoReserved94;            ! [DO] Reserved
var signaldo DoReserved95;            ! [DO] Reserved
var signaldo DoReserved96;            ! [DO] Reserved
var signaldo DoInZone01;              ! [DO] Entered zone 1
var signaldo DoInZone02;              ! [DO] Entered zone 2
var signaldo DoInZone03;              ! [DO] Entered zone 3
var signaldo DoInZone04;              ! [DO] Entered zone 4
var signaldo DoInZone05;              ! [DO] Entered zone 5
var signaldo DoInZone06;              ! [DO] Entered zone 6
var signaldo DoInZone07;              ! [DO] Entered zone 7
var signaldo DoInZone08;              ! [DO] Entered zone 8
var signaldo DoInZone09;              ! [DO] Entered zone 9
var signaldo DoInZone10;              ! [DO] Entered zone 10
var signaldo DoInZone11;              ! [DO] Entered zone 11
var signaldo DoInZone12;              ! [DO] Entered zone 12

var signalgo GoProgNo;                ! [GO] Output program number
var signalgo GoPathSegment;           ! [GO] Path segment feedback
var signalgo GoJobInfo01;             ! [GO] Job information feedback 01
var signalgo GoJobInfo02;             ! [GO] Job information feedback 02
var signalgo GoJobInfo03;             ! [GO] Job information feedback 03
var signalgo GoJobInfo04;             ! [GO] Job information feedback 04
var signalgo GoChannel01;             ! [GO] Channel feedback 01
var signalgo GoChannel02;             ! [GO] Channel feedback 02
var signalgo GoChannel03;             ! [GO] Channel feedback 03
var signalgo GoChannel04;             ! [GO] Channel feedback 04
var signalgo GoAxis01;                ! [GO] Axis 1 position

! 1st HOME position
const jointtarget HomePos01     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
! 2st HOME position
const jointtarget HomePos02     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
! 3st HOME position
const jointtarget HomePos03     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
! 4st HOME position
const jointtarget HomePos04     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

var byte ContDicitionCode := 0;

endmodule