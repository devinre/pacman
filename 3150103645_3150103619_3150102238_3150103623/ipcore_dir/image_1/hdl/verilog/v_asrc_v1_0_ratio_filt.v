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
// This module  performs an averaging filter on the calculated ratio.
//------------------------------------------------------------------------------

`timescale 1ns / 10ps

module v_asrc_v1_0_ratio_filt(
  input                 mclk,       // high frequency processing clock   
  input                 reset, 
  input                 ptr_reset,  // pointer_reset
  input                 locked,     // ratio locked flag
  input    [25:0]       calc_ratio,    // calculated output to input ratio 4.22
  input                 take_calc_ratio, // pulse indicates calc_ratio is valid
  input                 term_cnt_in, // input clock terminal count:new ratio
      
  output wire   [25:0]  calc_ratio_filt,// calc_ratio after low pass_filter
  output wire           tk_c_ratio_filt // Pulse: take calc_ratio_filt
);
    

  reg                   new_ratio_pending;// the next ratio calculation is new
  reg                   take_new_ratio;   // signals a new calculated ratio
  reg                   ave_reset;        // resets the average to current input
  
  
// determine the timing of a new ratio calculation
  always @ (posedge mclk or posedge reset)  begin
    if (reset) begin
      new_ratio_pending <= 0;
      take_new_ratio  <= 0;
      ave_reset <= 0;
    end
    else begin
       take_new_ratio <= new_ratio_pending && take_calc_ratio;         

      if (term_cnt_in)
        new_ratio_pending <= 1;
      else if (take_new_ratio)
        new_ratio_pending <= 0;  
        
      ave_reset <= ptr_reset | (take_calc_ratio && !locked);          
    end
  end
  
  
 
  
  // ratio filter
  v_asrc_v1_0_moving_ave_26 moving_ave_26(
    .clk             (mclk),
    .reset           (reset),
    .ptr_reset       (ave_reset),
    .data_in         (calc_ratio),
    .data_en         (take_new_ratio),
    
    .ave_out         (calc_ratio_filt),
    .ave_valid       (tk_c_ratio_filt)   
  );
   
  endmodule	
