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

This module replaces the mult35x35_sequential_pipe module in the asyncrhonous 
sample rate converter. It uses hdl to infer DSP elements.
This module performs a 35 x 35 multiply in with a latency of 7 states. New 
multiplicands can be registered in every 4 states.  

--------------------------------------------------------------------------------
*/
`timescale 1ns / 10ps


module mult35x35_hdl(	
  input wire                clk, 
  input wire                rst, 
  input wire                rst_state,   // rst_state resets the state counter
  input wire signed [34:0]  a_in,
  input wire signed [34:0]  b_in,
  
  output reg signed [69:0] prod_out = 0
);

  reg signed [34:0] a_in_reg = 0;
  reg signed [34:0] b_in_reg = 0;
  reg        [1:0]  cntr4;
  wire              counter_reset;
  
  // DSP internal regs
  reg signed  [17:0]   dsp0_a_reg;
  reg signed  [17:0]   dsp0_b_reg;
  reg signed  [17:0]   dsp1_a_reg;
  reg signed  [17:0]   dsp1_b_reg;
  reg signed  [17:0]   dsp2_a_reg;
  reg signed  [17:0]   dsp2_b_reg;
  reg signed  [17:0]   dsp3_a_reg;
  reg signed  [17:0]   dsp3_b_reg;
  reg signed  [35:0]   dsp1_m_reg;
  reg signed  [35:0]   dsp2_m_reg;
  reg signed  [35:0]   dsp3_m_reg;
  reg signed  [47:0]   dsp0_p_reg;
  reg signed  [47:0]   dsp1_p_reg;
  reg signed  [47:0]   dsp2_p_reg;
  reg signed  [47:0]   dsp3_p_reg;
  
  wire signed  [17:0]  a_ms;
  wire signed  [17:0]  a_ls;
  wire signed  [17:0]  b_ms;
  wire signed  [17:0]  b_ls;

assign counter_reset = rst | rst_state;

assign a_ms = a_in_reg[34:17];
assign a_ls = {1'b0,a_in_reg[16:0]};
assign b_ms = b_in_reg[34:17];
assign b_ls = {1'b0,b_in_reg[16:0]};

always @ (posedge clk)      //define counter
   begin
   if (counter_reset)
       begin
       cntr4 <= 2'b11;
       end
   else if (cntr4 < 2'b11)
       begin
       cntr4 <= cntr4 + 1;
       end
   else 
       begin
       cntr4 <= 2'b00;
       end
   end


always @ (posedge clk)
   begin
   if (rst)
     begin
      a_in_reg  <= 18'b0; 
      b_in_reg  <= 18'b0;
      prod_out  <= 70'b0;
     end
   else begin
     case (cntr4[1:0])
       0: begin
       end
       
       1: begin
         prod_out <= {dsp3_p_reg[34:0],dsp2_p_reg[16:0],dsp0_p_reg[16:0]};
       end
       
       2: begin
       end
       
       3: begin
         a_in_reg <= a_in; 
         b_in_reg <= b_in;
       end
       
       default: begin
       end
     endcase
   end
 end // always
   
// define DSP functionality

always @ (posedge clk) begin

  // DSP 0
  dsp0_a_reg <= a_ls;
  dsp0_b_reg <= b_ls;
  dsp0_p_reg <= dsp0_a_reg * dsp0_b_reg;

  // DSP 1
  dsp1_a_reg <= a_in_reg[34:17];
  dsp1_b_reg <= {1'b0,b_in_reg[16:0]};
  dsp1_m_reg <= dsp1_a_reg * dsp1_b_reg;
  dsp1_p_reg <= dsp1_m_reg + (dsp0_p_reg >>> 17);

  // DSP 2
  dsp2_a_reg <= a_ls;
  dsp2_b_reg <= b_ms;
  dsp2_m_reg <= dsp2_a_reg * dsp2_b_reg;
  dsp2_p_reg <= dsp2_m_reg + dsp1_p_reg;

  // DSP 3
  dsp3_a_reg <= a_ms;
  dsp3_b_reg <= b_ms;
  dsp3_m_reg <= dsp3_a_reg * dsp3_b_reg;
  dsp3_p_reg <= dsp3_m_reg + (dsp2_p_reg >>> 17);

end // always       


endmodule



