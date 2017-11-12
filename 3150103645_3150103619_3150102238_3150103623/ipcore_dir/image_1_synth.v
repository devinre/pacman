/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used solely      *
*     for design, simulation, implementation and creation of design files      *
*     limited to Xilinx devices or technologies. Use with non-Xilinx           *
*     devices or technologies is expressly prohibited and immediately          *
*     terminates your license.                                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY     *
*     FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY     *
*     PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE              *
*     IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS       *
*     MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY       *
*     CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY        *
*     RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY        *
*     DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE    *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A    *
*     PARTICULAR PURPOSE.                                                      *
*                                                                              *
*     Xilinx products are not intended for use in life support appliances,     *
*     devices, or systems.  Use in such applications are expressly             *
*     prohibited.                                                              *
*                                                                              *
*     (c) Copyright 1995-2016 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/

/*******************************************************************************
*     Generated from core with identifier: xilinx.com:ip:v_asrc:1.0            *
*                                                                              *
*     asynchronous sample rate converter (ASRC) converts stereo audio from     *
*     one sample frequency to another                                          *
*******************************************************************************/
// Source Code Wrapper
// This file is provided to wrap around the source code (if appropriate)

module image_1 (
  mclk,
  clkin,
  clkout,
  reset,
  manual_ratio_en,
  manual_ratio,
  input_sample_a,
  input_sample_b,
  output_sample_a,
  output_sample_b,
  fifo_level_out,
  calc_ratio_out,
  locked,
  fifo_overflow
);

  input mclk;
  input clkin;
  input clkout;
  input reset;
  input manual_ratio_en;
  input [25 : 0] manual_ratio;
  input [23 : 0] input_sample_a;
  input [23 : 0] input_sample_b;
  output [23 : 0] output_sample_a;
  output [23 : 0] output_sample_b;
  output [8 : 0] fifo_level_out;
  output [25 : 0] calc_ratio_out;
  output locked;
  output fifo_overflow;

  v_asrc_v1_0 #(
    .C_FAMILY("kintex7"),
    .FIFO_SET_POINT(16),
    .MAX_COUNT(1023)
  ) inst (
    .mclk(mclk),
    .clkin(clkin),
    .clkout(clkout),
    .reset(reset),
    .manual_ratio_en(manual_ratio_en),
    .manual_ratio(manual_ratio),
    .input_sample_a(input_sample_a),
    .input_sample_b(input_sample_b),
    .output_sample_a(output_sample_a),
    .output_sample_b(output_sample_b),
    .fifo_level_out(fifo_level_out),
    .calc_ratio_out(calc_ratio_out),
    .locked(locked),
    .fifo_overflow(fifo_overflow)
  );

endmodule

