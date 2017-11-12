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
// This module performs the ratio caclulation  for sample rate conversion
// including  rate regulation. 
// The shareed_divider in the timing_control module is used to pefrorm the 
// ratio dividion. 
// The main output is a  output/input conversion ratio to be  used by the 
// Re-Sampler.
// 
//------------------------------------------------------------------------------ 

`timescale 1ns / 10ps

module v_asrc_v1_0_ratio_calc (

  input                 mclk,       // high frequency processing clock   
  input                 clkin,     // Input and  rate clock
  input                 clkout,    // Ouput rate clock
  input                 reset,
  input     [12:0]       fifo_level,      // input fifo level  9.4
  input     [8:0]       fifo_set_point,  // optimal fifo level
  input     [13:0]      max_count,       // number of clock cycles to average
  input     [25:0]      calc_ratio,    // calculated output to input ratio 4.22
  input                 take_calc_ratio,  // pulse indicates calc_ratio is valid
  input                 move_start_ptr,   // flag: update start pointer
  input     [3:0]       start_ptr_step,  
  input     [5:0]       mclk_divider,     // divide factor for period_counts
  
//  output     [118:0]     cs_ratio_calc,   // chipscope  

  output reg   [25:0]   reg_ratio,   // regulated output/input clk freq. ratio
  output reg            reg_ratio_valid, // flag: reg_ratio is valid
  output reg   [24:0]   in_period_sync, // in_period count synced w/out_period
  output reg   [24:0]   out_period_sync, // latest out_period
  output reg            locked,         // locked mode flag  1= locked 0= varispeed
  output reg    [9:0]   in_period_div16,  // input period divided by 16
  output reg             buffer_reset,    // reset to ring buffer
  output reg             fifo_overflow,    // fifo has overflowed 
  output reg             term_cnt_in // flag: input_count = max_count

);
    parameter  LOCK_THRESH   = 4 *8;
    parameter  UNLOCK_THRESH = 6 *16;
    parameter  LOCK_DEADZONE = 2;
    parameter  VARI_DEADZONE = 0;
    parameter  LOCK_GAIN_LOG = 0;        // default = -1 , max = 4
    parameter  VARI_GAIN_LOG = 0;       // default = 0 , max = 4
    parameter  LOCK_SLEW = 1;
    parameter  LOCK_SLEW_DIVIDER =0; //
  
  reg                  term_cnt_out;  // flag: output_count = max_count
  reg                   clkout_1;   //sampled and delayed version of I/O clocks 
  reg                   clkout_2;
  reg                   clkout_3; 
  reg                   clkout_4; 
  reg                   clkout_5; 
  reg                   clkout_6; 
  reg                   clkin_1;
  reg                   clkin_2;
  reg                   clkin_3;
  reg                   clkin_4;
  reg                   clkin_5;
  reg                   clkin_6;
  reg                   clkout_rising;   //denotes a rising edge of clkout
  reg                   clkin_rising;    //denotes a rising edge of clkin
  reg   [13:0]          input_count;
  reg   [13:0]          output_count;
  reg   [24:0]          in_period;      // period of input clock 
  reg   [24:0]          out_period;     // period of output clock
  reg   [25:0]          calc_ratio_reg; // registered calc_ratio 4.22
  
  reg   [25:0]          sum_lock;        // intermedeiate sum of calc_ratio and err
  wire  [25:0]			sum_vari;		  // intermediate sum in varispeed mode
  reg                   err_below_thresh; //syncronous SR FF  detects error
  reg                   ebt_1;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_2;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_3;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_4;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_5;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_6;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_7;         // error_below_thresh delayed  1 term cnt
  reg                   ebt_8;         // error_below_thresh delayed  1 term cnt
  reg   [25:0]          locked_ratio;       // error term per locked mode
  wire   [12:0]         error_term;     // combinatorial  9.4
  wire                  error_sign;     // combinatorial
  reg                   error_sign_reg; // error_sign_reg
  reg    [12:0]         error_mag_reg;      // error magnitude reg   9.4
  reg   [23:0]         error_mag_vari;   // registered after_deadzone_subtr
  wire   [16:0]         error_mag_lock;   // combinatorial after deadzone subtr
  reg    [3:0]         slew_ltd_err;    // error_mag_lock  slew limited 
  reg                   first_in_cnt;    // first in_cnt has been taken
  reg                   in_cnt_valid;    // flag: in_cnt is valid
  reg				    in_out_cnt_valid;  // input and output counts are valid
  wire   [3:0]          vari_gain;         // gain factor per error magnitude
  wire   [3:0]          vari_gain_sat;     // gain factor saturated to max 
  reg                   move_start_ptr_1;// register delays                    
  reg                   move_start_ptr_2;
  reg                   move_start_ptr_3;
  reg                   move_start_ptr_4;
  reg                   buffer_reset_1;
  reg                   buffer_reset_2;
  reg                   buffer_reset_3;
  wire                  module_reset;      // reset for this module
  reg   [9:0]           samp_counter;
  reg                   change_ratio;
  reg   [5:0]           mclk_counter;
  reg                   mclk_en;
  reg                   incr_lock_ratio;
  reg                   decr_lock_ratio;
  
  assign cs_ratio_calc =  {
    in_cnt_valid,           //108
    buffer_reset,           // 107
    clkin,                  // 106
    clkout,                 //105
    clkin_rising ,          //104
    clkout_rising,          //103
    reg_ratio_valid,        //102
    take_calc_ratio,        //101
    change_ratio,           //100
    move_start_ptr_4,      // 99
    1'b0,                  //98
    error_sign_reg,         //97
    error_mag_reg [7:0],    //96:89
    error_mag_lock[7:0],  // 88:81
    slew_ltd_err[2:0],   // 80:78 
    calc_ratio[25:0],       // 77:52
//    26'b0,
    locked_ratio[25:0],   // 51:26
    reg_ratio[25:0]       // 25:00
              
};
  
  assign vari_gain =  { 1'b0, 
                        (|error_mag_reg[12:5]),
                        (|error_mag_reg[12:4]),
                        (|error_mag_reg[12:3])
                        };
  assign module_reset = reset;
  always @(posedge mclk or posedge module_reset)  begin
    if (module_reset) begin 
       calc_ratio_reg   <= 0;
       output_count     <= 0;
       input_count      <= 0;
       in_period        <= 0;
       out_period       <= 0;
       in_cnt_valid     <= 0;
       in_out_cnt_valid <= 0;
       reg_ratio_valid  <= 0;
    end
    else begin   // not reset
      move_start_ptr_1 <= move_start_ptr && (start_ptr_step != 0);  
                                             // delay move_start_ptr 
      move_start_ptr_2 <= move_start_ptr_1;  // so that the fifo_level change     
      move_start_ptr_3 <= move_start_ptr_2;  // can ripple through       
      move_start_ptr_4 <= move_start_ptr_3;         
            
      clkout_1 <= clkout;
      clkout_2 <= clkout_1;     // sample output clock in mclk domain
      clkout_3 <= clkout_2;
      clkout_4 <= clkout_3;
      clkout_5 <= clkout_4;
      clkout_6 <= clkout_5;
      clkout_rising <= clkout_1 && clkout_2 && !clkout_5 & !clkout_6
                       && (clkout_3 ^ clkout_4); // rising edge detect
      clkin_1  <= clkin;
      clkin_2  <= clkin_1;      // sample intput clock in mclk domain
      clkin_3  <= clkin_2;
      clkin_4  <= clkin_3;
      clkin_5  <= clkin_4;
      clkin_6  <= clkin_5;
      clkin_rising <= clkin_1 && clkin_2 && !clkin_5 && !clkin_6 
                      && (clkin_3 ^ clkin_4);
                      
       error_sign_reg <= error_sign;               
       error_mag_reg <= error_sign? ( {1'b0,~error_term[11:0]} +1)
                                      : error_term[11:0];
       term_cnt_in <= (input_count == max_count) && clkin_rising;
       term_cnt_out <= (output_count == max_count) && clkout_rising;
                      
      // load in ratio_calc
      if (take_calc_ratio)
        calc_ratio_reg <= calc_ratio;

      // Input clock count
      if (term_cnt_in)  begin
        input_count <= 0;
        in_period <= 1;
        in_period_sync <= in_period;
        in_cnt_valid <= 1;
      end
      else  begin
        if (mclk_en)
          in_period <= in_period + 1;
        if (clkin_rising)
          input_count <= input_count +1; 
      end
        //in_period_div16 is the input clock period divided by 16. 
        // shift right 10 for max_count, 4 for divide by 16. 
        // - 1 to account for the reset cycle  of the fractional period counter
        // note:  max in_period count is only 24 bits for this functionality
      in_period_div16 <= in_period_sync[23:14] - 1; 

      // Output clock count
      if (term_cnt_out) begin 
        output_count <= 0;
        out_period  <= 1;
        out_period_sync <=  out_period;
        if (in_cnt_valid) begin 
          in_out_cnt_valid <= 1;
          reg_ratio_valid <= in_out_cnt_valid;  // allow for additional latency
        end
      end  
      else  begin
        if (mclk_en)
		  out_period <= out_period +1; 
		if (clkout_rising) 
          output_count <= output_count +1;
      end 
      // determine if locked ratio should be bumped up or down
      incr_lock_ratio <= (|slew_ltd_err && 
                          (reg_ratio < sum_lock) && error_sign_reg);
      decr_lock_ratio <= (|slew_ltd_err && 
                          (reg_ratio > sum_lock) && !error_sign_reg); 
      
      // calculate error magnitude for vari-speed case 
      error_mag_vari <=   (error_mag_reg > VARI_DEADZONE )? 
                        (error_mag_reg << (vari_gain + VARI_GAIN_LOG)) :
                         0;  
      // calculate slew limited error for locked mode                          
      slew_ltd_err <= (error_mag_lock > LOCK_SLEW )? LOCK_SLEW: error_mag_lock;
    end  // not reset  
  end // always
// ***************** Gain and BW Control ****************************
    assign error_term = fifo_level - {fifo_set_point, 4'b000};
    assign error_sign = error_term[12];
    assign error_mag_lock =   (error_mag_reg > LOCK_DEADZONE )? 
                         (error_mag_reg - LOCK_DEADZONE) << LOCK_GAIN_LOG:
                          0; 

                                                                            
  wire [25:0] sum_vari_add = calc_ratio_reg + error_mag_vari;
  wire [25:0] sum_vari_sub = calc_ratio_reg - error_mag_vari;
  assign sum_vari = error_sign_reg? sum_vari_add: sum_vari_sub;
  always @* begin
    if (incr_lock_ratio && change_ratio)
      locked_ratio = reg_ratio  + slew_ltd_err;                 
    else if (decr_lock_ratio && change_ratio)
      locked_ratio = reg_ratio - slew_ltd_err;                     
    else
	   locked_ratio = reg_ratio;   
  end
  always @(posedge mclk or posedge module_reset)  begin
    if (module_reset) begin 
      locked <= 0;
      err_below_thresh <= 1;
      reg_ratio <=    26'h0400000 ;       // ratio = 1
      samp_counter <= 0;
      mclk_counter <= 0;
    end			  //reset
    else begin   // not reset 
      if (mclk_counter == mclk_divider) begin
        mclk_counter <= 0;
        mclk_en <=1;
      end
      else begin
        mclk_counter <= mclk_counter + 1;
        mclk_en <= 0;
      end
    
      if (clkout_rising) begin
        if (samp_counter == LOCK_SLEW_DIVIDER ) begin
          samp_counter <= 0;
          change_ratio <= 1;
        end
        else begin
           samp_counter <= samp_counter + 1;
           change_ratio <= 0;
        end 
      end 
      
      if (term_cnt_out)  begin
        err_below_thresh <= 0;
        ebt_1 <= err_below_thresh;
        ebt_2 <= ebt_1;
        ebt_3 <= ebt_2;
        ebt_4 <= ebt_3;
        ebt_5 <= ebt_4;
        ebt_6 <= ebt_5;
        ebt_7 <= ebt_6;
        ebt_8 <= ebt_7;
        if (ebt_1 & ebt_2 & ebt_3 & ebt_4& ebt_5 & ebt_6 & ebt_7 & ebt_8)
          locked <= 1;
      end   // if(term_cnt_out)
      else  begin
        if (error_mag_reg < (LOCK_THRESH))
          err_below_thresh <= 1;
        if (move_start_ptr_4 && (error_mag_reg > (UNLOCK_THRESH)))
          locked <= 0;        
      end 	// else

      sum_lock <= error_sign_reg? calc_ratio_reg + error_mag_lock:
                              calc_ratio_reg - error_mag_lock;  
      if (move_start_ptr_4) 
           reg_ratio <= (locked)? locked_ratio: sum_vari;
// calculate buffer error recovery terms 
      if (error_mag_reg[12:4] > fifo_set_point)
         fifo_overflow <= 1;
      else 
        fifo_overflow <=0;
      // if error too great, reset buffer  
      if (reset | buffer_reset_3)
        buffer_reset <= 0 ;
      else if (|error_mag_reg[12:11] )
        buffer_reset <=1 ;
        
      buffer_reset_1 = buffer_reset;    // pulse the buffer_reset
      buffer_reset_2 = buffer_reset_1;  //
      buffer_reset_3 = buffer_reset_2;
                                         


    end  // not reset  
  end // always
   
   
  endmodule	
