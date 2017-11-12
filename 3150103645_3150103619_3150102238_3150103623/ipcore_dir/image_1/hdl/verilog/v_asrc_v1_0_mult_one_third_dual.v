// (c) Copyright 2012 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module performs a constant coefficient multiply of a 24 bit signed number. 
it is specifically targeted at the ASRC design as part of the filter coefficient 
interpolation.

The constant multiplier is 555555hex,  which is equivalent to a divide by 3 for 
the purposes of the filter interepolater. This module is used to obtain the h0/3 and 
h3/3 factors used in coefficient interpolation.

It is implemented by doing 6 successive 
operations over 6 states.  In each state, the multiplicand is multiplied by 5 and added
to the accumulator.  The multiplicand is also left shifted by 4 each state in preparation
for the next. The full multiplication cycle takes 7 clocks, so two can be done in
the 16-state coefficient interpolation cycle.

Control signals for muxes and the accumulator are inputs to the module and
are designed to be driven bythe main state machine in the coefficient interpolater.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 10ps


module v_asrc_v1_0_mult_one_third_dual(	
  input wire            clk,
  input wire            input_sel,
  input wire            mult_sel,
  input wire            clear_accum, 
  input wire  [23:0]    input0,
  input wire  [23:0]    input1,
  
  output wire [46:0]    p_out
);

  reg  [46:0]            cur_multiplicand;
  reg  [46:0]            accum;
  
  assign p_out = accum;
  
  always @(posedge clk) begin
    if (clear_accum) 
      accum <= 0;
    else
      accum <= accum + cur_multiplicand + {cur_multiplicand[44:0],2'b0}; // * 5
  end
    
  always @(posedge clk) begin
      if (mult_sel)
        cur_multiplicand <= input_sel? {{23{input1[23]}},input1}
                                     : {{23{input0[23]}},input0};
      else
        cur_multiplicand <= cur_multiplicand << 4;     
  end  //always
  
endmodule



