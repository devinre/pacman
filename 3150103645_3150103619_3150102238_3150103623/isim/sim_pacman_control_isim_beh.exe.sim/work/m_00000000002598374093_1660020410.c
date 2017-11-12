/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/CST/Desktop/Pac-Man0.78/PS2_Control.v";
static int ng1[] = {10, 0};
static int ng2[] = {20, 0};
static int ng3[] = {16, 0};
static unsigned int ng4[] = {72U, 0U};
static int ng5[] = {2, 0};
static unsigned int ng6[] = {75U, 0U};
static int ng7[] = {0, 0};
static unsigned int ng8[] = {80U, 0U};
static int ng9[] = {3, 0};
static unsigned int ng10[] = {77U, 0U};
static int ng11[] = {1, 0};



static void Cont_35_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;

LAB0:    t1 = (t0 + 2456U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 1840);
    t3 = (t2 + 36U);
    t4 = *((char **)t3);
    t5 = (t0 + 3608);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    memset(t9, 0, 8);
    t10 = 1023U;
    t11 = t10;
    t12 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t10 = (t10 & t13);
    t14 = *((unsigned int *)t12);
    t11 = (t11 & t14);
    t15 = (t9 + 4);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 | t10);
    t17 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t17 | t11);
    xsi_driver_vfirst_trans(t5, 0, 9);
    t18 = (t0 + 3516);
    *((int *)t18) = 1;

LAB1:    return;
}

static void Cont_36_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;

LAB0:    t1 = (t0 + 2600U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(36, ng0);
    t2 = (t0 + 1932);
    t3 = (t2 + 36U);
    t4 = *((char **)t3);
    t5 = (t0 + 3644);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    memset(t9, 0, 8);
    t10 = 1023U;
    t11 = t10;
    t12 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t10 = (t10 & t13);
    t14 = *((unsigned int *)t12);
    t11 = (t11 & t14);
    t15 = (t9 + 4);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 | t10);
    t17 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t17 | t11);
    xsi_driver_vfirst_trans(t5, 0, 9);
    t18 = (t0 + 3524);
    *((int *)t18) = 1;

LAB1:    return;
}

static void Cont_38_2(char *t0)
{
    char t6[8];
    char t8[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;

LAB0:    t1 = (t0 + 2744U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(38, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1840);
    t4 = (t3 + 36U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    xsi_vlog_unsigned_multiply(t6, 32, t2, 32, t5, 10);
    t7 = ((char*)((ng1)));
    memset(t8, 0, 8);
    xsi_vlog_unsigned_minus(t8, 32, t6, 32, t7, 32);
    t9 = (t0 + 3680);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    memset(t13, 0, 8);
    t14 = 1023U;
    t15 = t14;
    t16 = (t8 + 4);
    t17 = *((unsigned int *)t8);
    t14 = (t14 & t17);
    t18 = *((unsigned int *)t16);
    t15 = (t15 & t18);
    t19 = (t13 + 4);
    t20 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t20 | t14);
    t21 = *((unsigned int *)t19);
    *((unsigned int *)t19) = (t21 | t15);
    xsi_driver_vfirst_trans(t9, 0, 9);
    t22 = (t0 + 3532);
    *((int *)t22) = 1;

LAB1:    return;
}

static void Cont_39_3(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;

LAB0:    t1 = (t0 + 2888U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(39, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1840);
    t4 = (t3 + 36U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    xsi_vlog_unsigned_multiply(t6, 32, t2, 32, t5, 10);
    t7 = (t0 + 3716);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 40U);
    t11 = *((char **)t10);
    memset(t11, 0, 8);
    t12 = 1023U;
    t13 = t12;
    t14 = (t6 + 4);
    t15 = *((unsigned int *)t6);
    t12 = (t12 & t15);
    t16 = *((unsigned int *)t14);
    t13 = (t13 & t16);
    t17 = (t11 + 4);
    t18 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t18 | t12);
    t19 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t19 | t13);
    xsi_driver_vfirst_trans(t7, 0, 9);
    t20 = (t0 + 3540);
    *((int *)t20) = 1;

LAB1:    return;
}

static void Cont_40_4(char *t0)
{
    char t6[8];
    char t8[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;

LAB0:    t1 = (t0 + 3032U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(40, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1932);
    t4 = (t3 + 36U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    xsi_vlog_unsigned_multiply(t6, 32, t2, 32, t5, 10);
    t7 = ((char*)((ng1)));
    memset(t8, 0, 8);
    xsi_vlog_unsigned_minus(t8, 32, t6, 32, t7, 32);
    t9 = (t0 + 3752);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    memset(t13, 0, 8);
    t14 = 1023U;
    t15 = t14;
    t16 = (t8 + 4);
    t17 = *((unsigned int *)t8);
    t14 = (t14 & t17);
    t18 = *((unsigned int *)t16);
    t15 = (t15 & t18);
    t19 = (t13 + 4);
    t20 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t20 | t14);
    t21 = *((unsigned int *)t19);
    *((unsigned int *)t19) = (t21 | t15);
    xsi_driver_vfirst_trans(t9, 0, 9);
    t22 = (t0 + 3548);
    *((int *)t22) = 1;

LAB1:    return;
}

static void Cont_41_5(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;

LAB0:    t1 = (t0 + 3176U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(41, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1932);
    t4 = (t3 + 36U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    xsi_vlog_unsigned_multiply(t6, 32, t2, 32, t5, 10);
    t7 = (t0 + 3788);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 40U);
    t11 = *((char **)t10);
    memset(t11, 0, 8);
    t12 = 1023U;
    t13 = t12;
    t14 = (t6 + 4);
    t15 = *((unsigned int *)t6);
    t12 = (t12 & t15);
    t16 = *((unsigned int *)t14);
    t13 = (t13 & t16);
    t17 = (t11 + 4);
    t18 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t18 | t12);
    t19 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t19 | t13);
    xsi_driver_vfirst_trans(t7, 0, 9);
    t20 = (t0 + 3556);
    *((int *)t20) = 1;

LAB1:    return;
}

static void Always_43_6(char *t0)
{
    char t14[8];
    char t18[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    int t13;
    char *t15;
    char *t16;
    char *t17;
    char *t19;
    char *t20;

LAB0:    t1 = (t0 + 3320U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(43, ng0);
    t2 = (t0 + 3564);
    *((int *)t2) = 1;
    t3 = (t0 + 3348);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(44, ng0);

LAB5:    xsi_set_current_line(45, ng0);
    t4 = (t0 + 784U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(51, ng0);
    t2 = (t0 + 600U);
    t3 = *((char **)t2);

LAB10:    t2 = ((char*)((ng4)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 8, t2, 8);
    if (t13 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng6)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 8, t2, 8);
    if (t13 == 1)
        goto LAB13;

LAB14:    t2 = ((char*)((ng8)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 8, t2, 8);
    if (t13 == 1)
        goto LAB15;

LAB16:    t2 = ((char*)((ng10)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 8, t2, 8);
    if (t13 == 1)
        goto LAB17;

LAB18:
LAB20:
LAB19:    xsi_set_current_line(73, ng0);

LAB26:    xsi_set_current_line(74, ng0);
    t2 = (t0 + 1840);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t11 = (t0 + 1840);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 10);
    xsi_set_current_line(75, ng0);
    t2 = (t0 + 1932);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t11 = (t0 + 1932);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 10);

LAB21:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(46, ng0);

LAB9:    xsi_set_current_line(47, ng0);
    t11 = ((char*)((ng2)));
    t12 = (t0 + 1840);
    xsi_vlogvar_assign_value(t12, t11, 0, 0, 10);
    xsi_set_current_line(48, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 1932);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 10);
    goto LAB8;

LAB11:    xsi_set_current_line(53, ng0);

LAB22:    xsi_set_current_line(54, ng0);
    t4 = (t0 + 1840);
    t5 = (t4 + 36U);
    t11 = *((char **)t5);
    t12 = (t0 + 1840);
    xsi_vlogvar_assign_value(t12, t11, 0, 0, 10);
    xsi_set_current_line(55, ng0);
    t2 = (t0 + 1932);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t11 = (t0 + 1428U);
    t12 = *((char **)t11);
    t11 = (t0 + 1404U);
    t15 = (t11 + 44U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng5)));
    xsi_vlog_generic_get_index_select_value(t14, 10, t12, t16, 2, t17, 32, 1);
    memset(t18, 0, 8);
    xsi_vlog_unsigned_minus(t18, 10, t5, 10, t14, 10);
    t19 = (t0 + 1932);
    xsi_vlogvar_assign_value(t19, t18, 0, 0, 10);
    goto LAB21;

LAB13:    xsi_set_current_line(58, ng0);

LAB23:    xsi_set_current_line(59, ng0);
    t4 = (t0 + 1840);
    t5 = (t4 + 36U);
    t11 = *((char **)t5);
    t12 = (t0 + 1428U);
    t15 = *((char **)t12);
    t12 = (t0 + 1404U);
    t16 = (t12 + 44U);
    t17 = *((char **)t16);
    t19 = ((char*)((ng7)));
    xsi_vlog_generic_get_index_select_value(t14, 10, t15, t17, 2, t19, 32, 1);
    memset(t18, 0, 8);
    xsi_vlog_unsigned_minus(t18, 10, t11, 10, t14, 10);
    t20 = (t0 + 1840);
    xsi_vlogvar_assign_value(t20, t18, 0, 0, 10);
    xsi_set_current_line(60, ng0);
    t2 = (t0 + 1932);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t11 = (t0 + 1932);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 10);
    goto LAB21;

LAB15:    xsi_set_current_line(63, ng0);

LAB24:    xsi_set_current_line(64, ng0);
    t4 = (t0 + 1840);
    t5 = (t4 + 36U);
    t11 = *((char **)t5);
    t12 = (t0 + 1840);
    xsi_vlogvar_assign_value(t12, t11, 0, 0, 10);
    xsi_set_current_line(65, ng0);
    t2 = (t0 + 1932);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t11 = (t0 + 1428U);
    t12 = *((char **)t11);
    t11 = (t0 + 1404U);
    t15 = (t11 + 44U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng9)));
    xsi_vlog_generic_get_index_select_value(t14, 10, t12, t16, 2, t17, 32, 1);
    memset(t18, 0, 8);
    xsi_vlog_unsigned_add(t18, 10, t5, 10, t14, 10);
    t19 = (t0 + 1932);
    xsi_vlogvar_assign_value(t19, t18, 0, 0, 10);
    goto LAB21;

LAB17:    xsi_set_current_line(68, ng0);

LAB25:    xsi_set_current_line(69, ng0);
    t4 = (t0 + 1840);
    t5 = (t4 + 36U);
    t11 = *((char **)t5);
    t12 = (t0 + 1428U);
    t15 = *((char **)t12);
    t12 = (t0 + 1404U);
    t16 = (t12 + 44U);
    t17 = *((char **)t16);
    t19 = ((char*)((ng11)));
    xsi_vlog_generic_get_index_select_value(t14, 10, t15, t17, 2, t19, 32, 1);
    memset(t18, 0, 8);
    xsi_vlog_unsigned_add(t18, 10, t11, 10, t14, 10);
    t20 = (t0 + 1840);
    xsi_vlogvar_assign_value(t20, t18, 0, 0, 10);
    xsi_set_current_line(70, ng0);
    t2 = (t0 + 1932);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t11 = (t0 + 1932);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 10);
    goto LAB21;

}


extern void work_m_00000000002598374093_1660020410_init()
{
	static char *pe[] = {(void *)Cont_35_0,(void *)Cont_36_1,(void *)Cont_38_2,(void *)Cont_39_3,(void *)Cont_40_4,(void *)Cont_41_5,(void *)Always_43_6};
	xsi_register_didat("work_m_00000000002598374093_1660020410", "isim/sim_pacman_control_isim_beh.exe.sim/work/m_00000000002598374093_1660020410.didat");
	xsi_register_executes(pe);
}
