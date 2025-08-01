module basic
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! File Name: basic
!
! Description:
!   Language             ==   Rapid for ABB ROBOT
!   Date                 ==   2021 - 10 - 14
!   Modification Data    ==   2024 - 08 - 30
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

const jointtarget Pounce01     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Pounce02     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Pounce03     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Pounce04     := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

proc main()
    var num ProgNo := 0;

    get_prog_num_ ProgNo;               ! Read the program number from the PLC
        
    test ProgNo

    case 1:                             ! Program number 1
        echo_prog_num_ 1;               ! Feedback program number 1
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program01" %;                ! Call the program01
    case 2:                             ! Program number 2
        echo_prog_num_ 2;               ! Feedback program number 2
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program02" %;                ! Call the program02
    case 3:                             ! Program number 3
        echo_prog_num_ 3;               ! Feedback program number 3
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program03" %;                ! Call the program03
    case 4:                             ! Program number 3
        echo_prog_num_ 4;               ! Feedback program number 4
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program04" %;                ! Call the program04
    case 5:                             ! Program number 5
        echo_prog_num_ 5;               ! Feedback program number 5
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program05" %;                ! Call the program05
    case 6:                             ! Program number 5
        echo_prog_num_ 6;               ! Feedback program number 6
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program06" %;                ! Call the program06
    case 21:                            ! Program number 21
        echo_prog_num_ 21;              ! Feedback program number 21
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program21" %;                ! Call the program21
    case 22:                            ! Program number 22
        echo_prog_num_ 22;              ! Feedback program number 22
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program22" %;                ! Call the program22
    case 23:                            ! Program number 23
        echo_prog_num_ 23;              ! Feedback program number 23
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program23" %;                ! Call the program23
    case 24:                            ! Program number 24
        echo_prog_num_ 24;              ! Feedback program number 24
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program24" %;                ! Call the program24
    case 25:                            ! Program number 25
        echo_prog_num_ 25;              ! Feedback program number 25
        check_home01_;                  ! Check if at HOME position
        speedrefresh 25;                ! Set global percentage speed
        % "Program25" %;                ! Call the program25
    default:
        log_error_ "Program number error", \ELOG, \Id := 99999, 
                   \RL2 := "The current input program number is " + num_to_str_(ProgNo \INTEGER);
        check_home01_;                  ! Check if at HOME position
    endtest

    ! Execute the MOVE TO HOME program
    % "mov_to_home01_" %;


endproc


!***********************************************************
! func mov_to_home01_()
!***********************************************************
proc mov_to_home01_()

    moveabsj HomePos01, v1500, fine, tool0;
    home01_io_;
endproc

!***********************************************************
! func mov_to_pounce01_()
!***********************************************************
proc mov_to_pounce01_()

    path_segment_ 1;
    moveabsj Pounce01, v1500, fine, tool0;
    req_to_continue_;
    if ContDicitionCode = 255 then 
        path_segment_ 2;
        mov_to_home01_;
        exitcycle;
    endif
endproc

endmodule