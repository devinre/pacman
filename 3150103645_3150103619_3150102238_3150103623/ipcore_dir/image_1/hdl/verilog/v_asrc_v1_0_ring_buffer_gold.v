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

`timescale 1ns / 10ps
module v_asrc_v1_0_ring_buffer_gold( 
  input                 mclk,
  input                 clkin,
  input                 reset,
  input [47:0]          input_sample,  // input sample stream
  input                 move_start_ptr,  // flag: update start pointer
  input [3:0]           start_ptr_step,  // amount to add to start pointer
  input                 go_fir,          // starts fir sequence
  input                 fetch_sample,    // request to get next sample 
  input [8:0]           fifo_set_point,  // state: optimal fifo level
  input                 reg_ratio_valid, // ratio valid. Start of fifo tracking 
  input [9:0]           in_period_div16, // number of mclks in 1/16 input period
  input [3:0]           delta_in_ctr_i, // fractional ouput pos. in units of isamp
  input                 buffer_reset,    // buffer reset for error recovery
  
  output  reg           data_valid,      // handshaking: data has been fetched
  output  [23:0]        isample_a,       // sample data out of module
  output  [23:0]        isample_b,       // sample data out of module
  output reg  [12:0]     fifo_level       // fifo level  9.4
);

  reg                   clkin_1;       // clkin delayed by  mclk
  reg                   clkin_2;       // to syncrhonize it into clock domain
  reg                   clkin_3;       // _3,4 registers for rising edge detect
  reg                   clkin_4;
  reg                   clkin_5;
  reg                   clkin_6;
  reg					fetch_sample_1; // fetch_sample delayed 
  reg   [8:0]           write_ptr;     // address counter
  reg   [8:0]           start_ptr;     // start pointer
  wire   [12:0]          start_ptr_subsamp; // fractional start_ptr  9.4
  wire   [12:0]          write_ptr_subsamp; // fractional write_ptr  9.4
  reg							write_en;	   // write enable to memory
  reg	[8:0]  			read_addr;		// read address to memory
  reg   [9:0]          fract_period_count; // counter to measure 1/16 input per.
  reg   [3:0]           delta_in_count;// counts 1/16 periods. Fractional pos
  
  wire                  clkin_rising;  // rising edge detect on clkin
  wire  [47:0]          write_data;    // sdelected data to be written to buffer
  wire  [47:0]          read_data;     // read data from buffer memory
  wire  [12:0]          pointer_diff;  // diff between write ptr & start ptr 9.4
  wire                  incr_delta_in; // term cnt for fract_period_count
  wire                  delta_in_sat;  // saturate flag for delta_in_count
  wire                  module_reset;  // combined reset for this module

 //  instantiate buffer memory 
  v_asrc_v1_0_buffer_mem_gold buffer_mem_gold(
	.addra(write_ptr),     // 9 bits
	.addrb(read_addr),     // 9 bits
	.clka(mclk),
	.dina(write_data),    // 48 bits
	.doutb(read_data),    // 48 bits
	.wea(write_en));

  assign module_reset = reset || buffer_reset;
  assign clkin_rising = clkin_1 & clkin_2 & !clkin_5 & !clkin_6
                        & (clkin_3 ^ clkin_4);
  assign write_data = input_sample;
  assign pointer_diff = write_ptr_subsamp- start_ptr_subsamp;
  assign isample_b = read_data[47:24];
  assign isample_a = read_data[23:0];
  assign start_ptr_subsamp =  {start_ptr, delta_in_ctr_i};
  assign write_ptr_subsamp =  {write_ptr, delta_in_count};
  assign incr_delta_in = (fract_period_count == in_period_div16);
  assign delta_in_sat = &delta_in_count;
  
  always  @(posedge mclk or posedge module_reset)begin 
    if ( module_reset)  begin
      write_ptr <= 16;  
      start_ptr <= 0;
      clkin_1   <= 0;
      clkin_2   <= 0;
      clkin_3   <= 0;
      clkin_4   <= 0;
      clkin_5   <= 0;
      clkin_6   <= 0;
      write_en  <= 0;   
    end          // reset
    else begin   // not reset
      //****************** synchronizing delay registers *****************
      clkin_1 <= clkin;
      clkin_2 <= clkin_1;
      clkin_3 <= clkin_2;
      clkin_4 <= clkin_3;
      clkin_5 <= clkin_4;
      clkin_6 <= clkin_5;
      //*************************** memory write *************************
      write_en <= clkin_rising ;
      // write pointer
      if (write_en ) 
        write_ptr <= write_ptr + 1; 
      // ******************** read controller ******************************
      if (go_fir)
        read_addr <= start_ptr;
        
      if (!reg_ratio_valid)             
        start_ptr <= write_ptr - fifo_set_point ;  // added for fast lock     
      else if (move_start_ptr)
        start_ptr <= start_ptr + start_ptr_step;
        
      if (fetch_sample)
        read_addr <=  read_addr - 1;
      fetch_sample_1 <= fetch_sample;
      data_valid <= fetch_sample_1; 
      //********************** fifo_level logic ****************************
        fifo_level <= pointer_diff; 
      // ********************* fractional input period count ***************
      if  (write_en || incr_delta_in)  
        fract_period_count <= 0;
      else
        fract_period_count <= fract_period_count+1;
        
      if (write_en)
        delta_in_count <= 0;
      else if ( incr_delta_in && !delta_in_sat)
        delta_in_count <= delta_in_count + 1;
      
    end    // not reset
  end      // always
  
     
endmodule

