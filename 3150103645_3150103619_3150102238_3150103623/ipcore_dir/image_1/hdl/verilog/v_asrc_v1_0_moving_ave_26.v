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
// This module implements a moving average filter by adding new values as they
// enter the module and subtracting values after a fixed delay. Input data,
// data_in must be stable for at least one clock before data_en pulses 
// (i.e a multi-cycle path) in order to meet timing.  This is easily doable if 
// if data_en pulses a maximum of once per 2 clks. The ave_valid output is 
// delayed  by 2 from the input to accomodate the multi-cycle timing.
//------------------------------------------------------------------------------

`timescale 1ns / 10ps

module v_asrc_v1_0_moving_ave_26(
  input                 clk,
  input                 reset,
  input                 ptr_reset,
  input [25:0]          data_in, // input data to be averaged
  input                 data_en, // enable signal 1 = take data_in
  
  output wire [25:0]    ave_out, // averaged data 
  output reg            ave_valid // data to match                  
);
  reg                   ptr_reset_1;    // ptr_reset synchronized to clk
  reg                   ptr_reset_2; 
  reg    [25:0]         data_in_reg;   
  reg    [29:0]         moving_sum; // accumulator of  data in values
  wire   [25:0]         data_del; //data delayed through shift register
  reg                   data_en_1;  // data_en delayed
  reg                   data_en_2;
  wire   [26:0]         shift_d;    // data into shift register  
  wire   [26:0]         shift_q;    // data out of shift register
  wire                  shift_en;   // shift register enable
  wire                  preload_out;// preload signal delayed through shift reg
  reg                   preload;    // synchronous SR forces a preload 
   
  assign  shift_d =  {preload,data_in_reg};
  assign  shift_en = preload? 1'b1: data_en_1;
  assign  preload_out = shift_q[26];
  assign  data_del = shift_q[25:0];
  assign  ave_out = moving_sum[29:4];
  
// synchronize and delay control registers  
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      preload <= 0;
    end
    else begin
      if (ptr_reset_2)
        preload <= 1;
      else if (preload_out)
        preload <= 0;
    end
  end
  
  always @ (posedge clk) begin
    ptr_reset_1 <= ptr_reset;
    ptr_reset_2 <= ptr_reset_1;
    data_en_1 <= data_en;
    ave_valid <= data_en_1;
  
  
    if (!preload)
      data_in_reg <= data_in;
  end  
  
  // shift register to delay data
  v_asrc_v1_0_shift_reg_27x16 shift_reg_27x16 (
	.clk(clk),
	.d(shift_d),
	.q(shift_q),
	.ce(shift_en));


  always @ (posedge clk)
    if (preload) begin
      moving_sum <= data_in_reg << 4;
    end
    else begin
      if (data_en_1)
      moving_sum <= moving_sum - data_del[25:0] + data_in_reg;
    end
  
endmodule
