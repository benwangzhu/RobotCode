/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mpmotion.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2022 - 01 - 11
  Modification Data    ==   2022 - 01 - 11

Author: speedbot

Version: 1.0
--*********************************************************************************************************--
--                                                                                                         --
--                                                      .^^^                                               --
--                                               .,~<c+{{{{{{t,                                            -- 
--                                       `^,"!t{{{{{{{{{{{{{{{{+,                                          --
--                                 .:"c+{{{{{{{{{{{{{{{{{{{{{{{{{+,                                        --
--                                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{~                                       --
--                               ^{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{!.  `^                                    --
--                               c{{{{{{{{{{{{{c~,^`  `.^:<+{{{!.  `<{{+,                                  --
--                              ^{{{{{{{{{{{!^              `,.  `<{{{{{{+:                                --
--                              t{{{{{{{{{!`                    ~{{{{{{{{{{+,                              --
--                             ,{{{{{{{{{:      ,uDWMMH^        `c{{{{{{{{{{{~                             --
--                             +{{{{{{{{:     ,XMMMMMMw           t{{{{{{{{{{t                             --
--                            ,{{{{{{{{t     :MMMMMMMMM"          ^{{{{{{{{{{~                             --
--                            +{{{{{{{{~     8MMMMMMMMMMWD8##      {{{{{{{{{+                              --
--                           :{{{{{{{{{~     8MMMMMMMMMMMMMMH      {{{{{{{{{~                              --
--                           +{{{{{{{{{c     :MMMMMMMMMMMMMMc     ^{{{{{{{{+                               --
--                          ^{{{{{{{{{{{,     ,%MMMMMMMMMMH"      c{{{{{{{{:                               --
--                          `+{{{{{{{{{{{^      :uDWMMMX0"       !{{{{{{{{+                                --
--                           `c{{{{{{{{{{{"                    ^t{{{{{{{{{,                                --
--                             ^c{{{{{{{{{{{".               ,c{{{{{{{{{{t                                 --
--                               ^c{{{{{{{{{{{+<,^`     .^~c{{{{{{{{{{{{{,                                 --
--                                 ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t                                  --
--                                   ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t`                                  --
--                                     ^c{{{{{{{{{{{{{{{{{{{{{{{{{{+c"^                                    --                         
--                                       ^c{{{{{{{{{{{{{{{{{+!":^.                                         --
--                                         ^!{{{{{{{{t!",^`                                                --
--                                                                                                         --
--*********************************************************************************************************--
--  

2022 - 04 - 13 ++ enable_dynamic_() ==> STATUS

2022 - 04 - 13 ++ disable_dynamic_() ==> STATUS

2022 - 04 - 13 ++ set_dynamic_frame_() ==> STATUS

2022 - 04 - 13 ++ set_dynamic_axis_() ==> STATUS

*/

#include "motoPlus.h"
#include "lib_mpdyn_corr.h"
#include "lib_mptp_if.h"

STATUS enable_static_dynamic_(MP_EXPOS_DATA *ThisDynamicSch)
{
    memset(ThisDynamicSch, CLEAR, sizeof(MP_EXPOS_DATA));
    ThisDynamicSch->ctrl_grp = 1;
    return(set_variable_byte_(DYN_ENABLE_BREG_NO, 1));
}

STATUS disable_static_dynamic_(MP_EXPOS_DATA *ThisDynamicSch)
{
    memset(ThisDynamicSch, CLEAR, sizeof(MP_EXPOS_DATA));
    return(set_variable_byte_(DYN_ENABLE_BREG_NO, 0));
}

STATUS set_static_dynamic_frame_(MP_EXPOS_DATA *ThisDynamicSch, UCHAR OffsFrame, SHORT UframeNo, SHORT UtoolNo)
{
    ThisDynamicSch->grp_pos_info->pos_tag.data[2] = (UCHAR)UtoolNo;
    ThisDynamicSch->grp_pos_info->pos_tag.data[3] = OffsFrame;
    ThisDynamicSch->grp_pos_info->pos_tag.data[4] = (UCHAR)UframeNo;

    return(OK);
}

STATUS set_static_dynamic_axis_(MP_EXPOS_DATA *ThisDynamicSch, UCHAR AxisNo)
{
    ThisDynamicSch->grp_pos_info->pos_tag.data[0] = AxisNo;

    return(OK);
}

STATUS static_dyn_correction_(MP_EXPOS_DATA *ThisDynamicSch, mp_dym_offset_t OffsetVal)
{

    
    memcpy(&ThisDynamicSch->grp_pos_info->pos, &OffsetVal, sizeof(mp_dym_offset_t));

    return(OK);
}