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
//
//  This module interpolates FIR coefficients from the prototype filter based 
//  on the position of the output sample with respect to the input sample
//  as indicated by first_isample_f.  
//
//  In this version, Version 2, the timing has been modified slighly to allow
//  for an extra output register on the filter memory ROM.  The total latency 
//  through filt_mem_gold is now 2 clocks.
//
//------------------------------------------------------------------------------


`timescale 1ns / 10ps
module v_asrc_v1_0_filt_interp_gold (
  input                 mclk,       // high frequency processing clock   
  input                 reset,
  input     [30:0]      first_isample_f, //start pos. in filter (9.22)
  input     [29:0]      cf_if,        // filter coefs/ input sample (8.22)
  input                 go_fir,       // Clear accumulators for FIR sequence
  
  output reg  [34:0]    coef_fir,      // Output coefficients  S1.33
  output reg  [2:0]     cycle,      // multiplier cycle
  output reg  [1:0]     sub_cycle,  // multiplier sub-cycle (4 clks/35x35 mult)
  output reg            wait_3,     // third pass is complete
  output reg  [34:0]    coef_accum,    // coefficient accumulator s3.31
  output reg            interp_done    //  all coef's have been interpolated

 );
parameter   CENTER_COEF = 24'h7bfbdf;
parameter   D_ONE   = 24'h400000; 
parameter   D_TWO   = 24'h800000; 
parameter   D_THREE = 24'hC00000; 
 

  reg    [35:0]     curr_pos_f;   //current position in filter, 14.22
  reg    [23:0]     h0;         // ROM coefficient h0  
  reg    [23:0]     h1;         // ROM coefficient h1
  reg    [23:0]     h2;         // ROM coefficient h2
  reg    [23:0]     h3;         // ROM coefficient h3   
  reg    [25:0]     h0_div3;    // h0 divided by 3
  reg    [25:0]     h3_div3;    // h3 divided by 3
  reg    [13:0]     addr_counter; // address counter for filt mem, 13 bits+ wrap
  reg    [34:0]     m1_a;         // registers holding data for multipliers
  reg    [34:0]     m1_b;
  reg    [34:0]     m2_a;
  reg    [34:0]     m2_b; 
  reg    [24:0]     delta;       // delta registers
  reg    [24:0]     neg_d_minus1;
  reg    [24:0]     d_minus1_div2;
  reg    [24:0]     d_minus2_reg;
  reg    [24:0]     neg_d_minus3;
  reg    [24:0]     d_minus3_div2;
  reg    [34:0]     m1_p1;          // intermediate products for interpolation 
  reg    [34:0]     m1_p1_buf;       
  reg    [34:0]     m1_p2;
  reg    [34:0]     m1_p2_buf;
  reg    [34:0]     m1_p3;                       
  reg    [34:0]     m2_p1;  
  reg    [34:0]     m2_p1_buf;  
  reg    [34:0]     m2_p2;
  reg    [34:0]     m2_p2_buf;
  reg    [34:0]     m2_p3;                       
  reg    [32:0]     coef;            //  final coeffiecient after interp S1.31
  reg    [26:0]     state_bits;      // state bits to control muxes and takes
  reg               first_pass;     // indicates first pass for new output samp
  reg               wait_1;         // first pass is complete
  reg               wait_2;         // second pass is complete
  reg               addr_overflow;  // address into  filter has overflowed.
  reg               addr_overflow_1;    // delayed addr_overflow
  reg               last_coef;      // this pass finises last coef.  for osample

  // stete machine bits
  wire              div3_clear_accum = state_bits[26];
  wire              div3_mult_sel    = state_bits[25];
  wire              div3_input_sel   = state_bits[24];            
  wire   [1:0]      mult_input_sel   = state_bits[23:22];
  wire              reset_mult       = state_bits[21];
  wire              load_addr        = state_bits[20];
  wire              incr_addr        = state_bits[19];
  wire              take_h0          = state_bits[18];
  wire              take_h1          = state_bits[17];
  wire              take_h2          = state_bits[16];
  wire              take_h3          = state_bits[15];
  wire              take_deltas      = state_bits[14];
  wire              take_h0_div3     = state_bits[13];
  wire              take_h3_div3     = state_bits[12];
  wire              take_p1          = state_bits[11];
  wire              take_p2          = state_bits[10] ;
  wire              accum_p2         = state_bits[9];
  wire              take_p1_p2_buf   = state_bits[8] ;
  wire              take_p3          = state_bits[7] ;
  wire              take_coef        = state_bits[6] ;
  wire              take_coef_fir    = state_bits[5] ;
  wire              take_coef_accum  = state_bits[4] ;
  
  reg  [10:0]        mem_addr;       // memory address
  reg               center_coef;    // center coefficient flag
  reg               center_coef_1;  // center coefficient flag delayed
  reg               center_coef_2;  // center coefficient flag delayed
  reg               out_of_range;   //	1= filt mem addr out of range
  reg               out_of_range_1; //	out_of_range delayed 1
  reg               out_of_range_2; //	out_of_range delayed 2
  wire [23:0]       mem_out;        // output from filter memory
  wire [69:0]       prod_1_out;     // output form multipier 1
  wire [69:0]       prod_2_out;     // output form multipier 2
  wire [24:0]       d_minus1;       // result of subtract, delta - 1
  wire [24:0]       d_minus2;       // result of subtract, delta - 2
  wire [24:0]       d_minus3;       // result of subtract, delta - 3
  wire [13:0]       filt_index_f;   // integer part of curr_pos_f
  wire [21:0]       delta_interp_f; // fractional part of curr_pos_f
  reg  [22:0]       delta_interp_f_reg; // registered version to match address
  wire [46:0]       div3_p_out;           // output of divider
  wire [25:0]       h_div_out;     // useful bits from hO_divider
  wire [35:0]       sum_p3;         // sum of P3 registers
  wire              reset_mult_state; // reset multiplier state to match cycles
  
// *********************  inastance filter memory ****************************  
  v_asrc_v1_0_filter_mem_gold filter_mem_gold (
	.addra   (mem_addr),
	.clka    (mclk),
	.douta   (mem_out));

// ********************* instance multipliers ******************************
   mult35x35_hdl  multiplier_1(
     .clk       (mclk),
     .rst       (reset),
     .rst_state (reset_mult_state),
     .a_in      (m1_a),
     .b_in      (m1_b),
     .prod_out  (prod_1_out)
   );
    mult35x35_hdl  multiplier_2(
     .clk       (mclk),
     .rst       (reset),
     .rst_state (reset_mult_state),
     .a_in      (m2_a),
     .b_in      (m2_b),
     .prod_out  (prod_2_out)
   );
  
   v_asrc_v1_0_mult_one_third_dual h_divider (
     .clk          (mclk),
     .input_sel    (div3_input_sel),
     .mult_sel     (div3_mult_sel),
     .clear_accum  (div3_clear_accum),
     .input0       (h0),
     .input1       (h3),
     .p_out        (div3_p_out)
   );
   
  assign h_div_out = div3_p_out[46:21];    
  assign filt_index_f = curr_pos_f [35:22];
  assign delta_interp_f = curr_pos_f [21:0];
  assign d_minus1 = delta_interp_f_reg - D_ONE;
  assign d_minus2 = delta_interp_f_reg - D_TWO;
  assign d_minus3 = delta_interp_f_reg - D_THREE;
  assign sum_p3 =  {m1_p3[34], m1_p3} + {m2_p3[34], m2_p3};
  assign reset_mult_state = reset_mult && first_pass;
     
  always @ (posedge mclk or posedge reset)  begin
    if (reset) begin
    end  // reset
    else begin   // not reset
      // cycle and subcycle counters,  Begin and End sequence bits
      if (go_fir) begin
        cycle <= 0;
        sub_cycle <= 0;
        first_pass <= 1;
        wait_1 <= 0;
        wait_2 <= 0;
        wait_3 <= 0;
        addr_overflow_1 <= 0;
        last_coef <= 0;
        interp_done <= 0;
      end
      else begin
        sub_cycle <= sub_cycle + 1;
        if (sub_cycle == 3)  begin   // end of cycle
          if (cycle ==3) begin   // end of pass
            wait_1 <= first_pass | wait_1;
            wait_2 <= wait_1;
            wait_3 <= wait_2;
            addr_overflow_1 <= addr_overflow_1 | addr_overflow;
            last_coef <= last_coef | addr_overflow_1;
            interp_done <= interp_done | last_coef;
			first_pass <= 0;
            cycle <= 0;
          end
          else
            cycle <= cycle + 1;
        end  // sub_cycle == 3
      end 
      if (interp_done)
        state_bits <=0;      // suppress state bits when interp is done
      else  begin
        //  assign state bits 
        case  ({cycle, sub_cycle})
          // ms to ls
         //  take_accum_b
          5'h0f: state_bits <= 27'b 000_00_00_0000_0000_0001_0000_0000; //0 0
          5'h00: state_bits <= 27'b 000_00_00_0000_0000_0000_0000_0000; //0 1 
          5'h01: state_bits <= 27'b 000_00_01_0000_0000_0000_0000_0000; //0 2 
          5'h02: state_bits <= 27'b 000_01_00_1000_0000_0000_1000_0000; //0 3 
        
          5'h03: state_bits <= 27'b 000_01_00_1000_0000_0000_0000_0000; //1 0 
          5'h04: state_bits <= 27'b 000_01_00_1000_0001_0000_0100_0000; //1 1 
          5'h05: state_bits <= 27'b 000_01_00_0100_0000_0000_0000_0000; //1 2 
          5'h06: state_bits <= 27'b 110_10_00_0010_0000_1000_0001_0000; //1 3 
        
          5'h07: state_bits <= 27'b 000_10_00_0001_0000_0000_0000_0000; //2 0 
          5'h08: state_bits <= 27'b 000_10_00_0000_1000_0000_0000_0000; //2 1 
          5'h09: state_bits <= 27'b 000_10_00_0000_0000_0000_0000_0000; //2 2 
          5'h0a: state_bits <= 27'b 000_11_00_0000_0100_0100_0000_0000; //2 3 
        
          5'h0b: state_bits <= 27'b 000_11_00_0000_0000_0000_0000_0000; //3 0 
          5'h0c: state_bits <= 27'b 000_11_00_0000_0000_0000_0000_0000; //3 1 
          5'h0d: state_bits <= 27'b 111_11_00_0000_0010_0000_0010_0000; //3 2 
          5'h0e: state_bits <= 27'b 000_00_10_0000_0000_0110_0000_0000; //3 3 
          default:
                 state_bits <= 27'b 111_11_11_1111_1111_1111_1111_1111;     
        endcase 
      end
       // current position accumulator
          if (go_fir) 
            curr_pos_f <= {5'h0, first_isample_f} - D_ONE;
          else if (take_p3 & !addr_overflow)  // take_p3 used for proper timing.
            curr_pos_f <= curr_pos_f + cf_if;
            
         if (go_fir)
           addr_overflow <= 0;
         else if (take_p3 & !filt_index_f[13] &(filt_index_f[12:0] > 4096)) 
           addr_overflow <= 1;                 // take_p3 used tor proper timing.
         
       // Address counter 
        if (load_addr) begin
          addr_counter <= filt_index_f ;
          delta_interp_f_reg <= { 1'b1, delta_interp_f } ; //interp between 1,2
        end
        else if (incr_addr & !addr_overflow)
          addr_counter <= addr_counter + 1;
      // address translation
        if (!addr_counter[11] & !addr_counter[12])
          mem_addr <= addr_counter;
        else 
          mem_addr <= 4096 - addr_counter;
          
        if (addr_counter == 2048)	// check for center
          center_coef <= 1;
        else
          center_coef <= 0;
        
        center_coef_1 <= center_coef;  // match ROM delay
        center_coef_2 <= center_coef_1;  // match ROM delay
          
        if (addr_counter[13] || addr_counter > 4096)
          out_of_range <= 1;
        else 
          out_of_range <= 0;
                     
          
        out_of_range_1 <= out_of_range; // match ROM delay
        out_of_range_2 <= out_of_range_1; // match ROM delay
      //coefficients from filter mem
        if (take_h0)  begin
          if (center_coef_2)
            h0 <= CENTER_COEF;
          else if (out_of_range_2)
            h0 <= 0;
          else
            h0 <= mem_out;
        end
            
        if (take_h1) begin
          if (center_coef_2)
            h1 <= CENTER_COEF;
          else if (out_of_range_2)
            h1 <= 0;
          else
            h1 <= mem_out;
        end
        
        if (take_h2)  begin
          if (center_coef_2)
            h2 <= CENTER_COEF;
          else if (out_of_range_2)
            h2 <= 0;
          else
            h2 <= mem_out;
         end
         
        if (take_h3)  begin
          if (center_coef_2)
            h3 <= CENTER_COEF;
          else if (out_of_range_2)
            h3 <= 0;
          else
            h3 <= mem_out;
         end
         
         // h divide by 3 registers
         if (take_h0_div3) 
           h0_div3 <=  {h_div_out[25], h_div_out[25:1]};  // right shift by 1 
         if (take_h3_div3) 
           h3_div3 <=  {h_div_out[25], h_div_out[25:1]};  // 
                  
         //  delta registers
         if (take_deltas) begin
           delta <=  {3'h0, delta_interp_f_reg };
           neg_d_minus1  <=  ~d_minus1 + 1;
           d_minus1_div2 <=  {d_minus1[24],d_minus1[24:1]};
           d_minus2_reg  <=  d_minus2;
           neg_d_minus3  <=  ~d_minus3 + 1;
           d_minus3_div2   <=  {d_minus3[24],d_minus3[24:1]};
         end
         
         // Multiplier input registers
         if (sub_cycle == 3)  begin  // change mult inputs only at cycle change
           case (mult_input_sel)
             0: begin
               m1_a <= {d_minus2_reg,   10'h000};
               m1_b <= {d_minus3_div2, 10'h000};
               m2_a <= {delta,          10'h000} ;
               m2_b <= {d_minus1_div2,  10'h000};
             end
             1: begin
               m1_a <= {neg_d_minus1,   10'h000};
//               m1_b <= {{2{h0_div3[25]}}, h0_div3, 7'h00} ;
               m1_b <= {{2{h0_div3[25]}}, h0_div3, h0_div3[24:18]} ;
               m2_a <= {neg_d_minus3,   10'h000};
               m2_b <= {{2{h2[23]}}, h2, 9'h00};
             end
             2: begin
               m1_a <= {delta,          10'h000};
               m1_b <= {{2{h1[23]}}, h1, 9'h00};
               m2_a <= {d_minus2_reg,   10'h000};
//               m2_b <= {{2{h3_div3[25]}}, h3_div3, 7'h00};
               m2_b <= {{2{h3_div3[25]}}, h3_div3, h3_div3[24:18]};
             end
             default : begin
               m1_a <= m1_p1_buf;
               m1_b <= m1_p2_buf;
               m2_a <= m2_p1_buf;
               m2_b <= m2_p2_buf;
             end           
           endcase
         end
         
         // Multiplier output registers
         if (take_p1) begin
           m1_p1 <=  prod_1_out[66:32];
           m2_p1 <=  prod_2_out[66:32] ;
         end
         if (take_p2) begin
           if (accum_p2) begin
             m1_p2 <= m1_p2 + prod_1_out[66:32]; // msb of sum can be ignored
             m2_p2 <= m2_p2 + prod_2_out[66:32]; 
           end
           else begin
             m1_p2 <=  prod_1_out[66:32];
             m2_p2 <=  prod_2_out[66:32] ;
           end
         end
         if (take_p3) begin
           m1_p3 <=  prod_1_out[67:33];
           m2_p3 <=  prod_2_out[67:33];
         end

			// P1 and P2 buffer registers
			if (take_p1_p2_buf) begin
			  m1_p1_buf <= m1_p1;
			  m1_p2_buf <= m1_p2;
			  m2_p1_buf <= m2_p1;
			  m2_p2_buf <= m2_p2;
			end
         
         // Coefficient registers
         if (take_coef) begin
           coef <=  sum_p3[32:0];
         end
         if (take_coef_fir) begin
           coef_fir <= {coef, 2'h0};         
         end
         // Coefficient accumulator
         if  (take_coef_accum)
           if (wait_2 & !wait_3)   // reset the pass befor coef is valid
              coef_accum <= 0;
           else if (wait_3 & !interp_done)
              coef_accum <= coef_accum + {coef[32],coef[32],coef}; //sign smear
         
           
    end          // not reset
  end  //always
  
  
endmodule	
