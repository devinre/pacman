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

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    xilinxcorelib_ver_m_00000000001358910285_1931483398_init();
    xilinxcorelib_ver_m_00000000001687936702_0446655728_init();
    xilinxcorelib_ver_m_00000000000277421008_3103779408_init();
    xilinxcorelib_ver_m_00000000001603977570_3267510641_init();
    work_m_00000000000403262735_0948587506_init();
    work_m_00000000002981410868_2840143635_init();
    xilinxcorelib_ver_m_00000000001358910285_3435366373_init();
    xilinxcorelib_ver_m_00000000000277421008_1281806566_init();
    xilinxcorelib_ver_m_00000000001603977570_2572724653_init();
    work_m_00000000003869038185_3667112705_init();
    xilinxcorelib_ver_m_00000000000277421008_3762382130_init();
    xilinxcorelib_ver_m_00000000001603977570_2656948623_init();
    work_m_00000000003869038185_0492301423_init();
    xilinxcorelib_ver_m_00000000000277421008_3871796534_init();
    xilinxcorelib_ver_m_00000000001603977570_0613927743_init();
    work_m_00000000000403262735_4280567758_init();
    work_m_00000000003318716546_0342269696_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003318716546_0342269696");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
