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
//------------------------------------------------------------------------------
// This is the top level module for the asyncronous sample rate converter 
// reference design.
// 
//------------------------------------------------------------------------------ 

`timescale 1ns / 10ps

module v_asrc_v1_0  #(
  parameter integer FIFO_SET_POINT = 9'h010,    // optimal fifo level
  parameter integer MAX_COUNT = 14'h03ff,       // number of clock cycles to average
  //From Coregen
  parameter  C_FAMILY = "virtex6"       // device family
)
(
  input                mclk,       // high frequency processing clock   
  input                clkin,     // Input and  rate clock
  input                clkout,    // Ouput rate clock
  input                reset,
  input                manual_ratio_en, // 1 = manual ratio, 0 = automatic
  input     [25:0]     manual_ratio,   // manual ratio (Fout/Fin)  4.22
  input     [23:0]     input_sample_a,      // input audio stream
  input     [23:0]     input_sample_b,      // input audio stream
  
  output    [23:0]     output_sample_a,   // calculated output sample
  output    [23:0]     output_sample_b,   // calculated output sample
  output    [8:0]      fifo_level_out,
  output    [25:0]     calc_ratio_out,
  output               locked,         // ratio is locked
  output               fifo_overflow   // input fifo has overflowed
);

  wire      [25:0]     reg_ratio;   // regulated output/input clk freq. ratio
  wire                 reg_ratio_valid; // flag: reg_ratio is valid
  wire                 go_fir;        // starts FIR sequence
  wire                 move_start_ptr;// update ring buffer start pointer
  wire       [3:0]     start_ptr_step;// amount to add to start pointer 
  wire       [29:0]    cf_if;         // conv. factor, 8.22
  wire       [30:0]    first_isample_f;// start pos. in filter 9.22
  wire       [22:0]    aux_a;         // auxiliary inputs to multiplier 1.22
  wire       [30:0]    aux_b;         //    9.22
  wire                 aux_mult_reset;// reset to multiplier in fir_gold
  wire                 aux_sel;       // selec aux inputs to multiplier 
  wire       [25:0]    calc_ratio;      // raw ratio divide, fout/fin  4.22
  wire       [25:0]    calc_ratio_filt; // calculated ratio after filtering
  wire                 take_calc_ratio;// calc_ratio is valid
  wire                 take_c_ratio_filt; // take  filtered calc ratio
  wire                 data_valid;      // handshaking: data has been fetched
  wire       [23:0]    isample_a;       // input sample data  from buffer
  wire       [23:0]    isample_b;       
  wire       [12:0]    fifo_level;      // fifo level  9.4
  wire       [24:0]    in_period_sync;  // in_period count synced w/out_period
  wire       [24:0]    out_period_sync; // latest out_period
  wire       [34:0]    coef_fir;        // Interpolated coefficient 
  wire       [2:0]     cycle;           // multiplier cycle
  wire       [1:0]     sub_cycle;       // multiplier sub-cycle 
  wire                 wait_3;          // third pass is complete
  wire       [34:0]    coef_accum;      // coefficient accumulator s3.31
  wire                 interp_done;      // all coef's have been interpolated
  wire                 fetch_sample;   // request for new input samples
  wire                 osamp_done;     // pulses when osample regs are loaded  
  wire        [69:0]   prod_out;        // multiplier product 
  wire        [8:0]    fifo_set_point = FIFO_SET_POINT;
  wire        [13:0]   max_count = MAX_COUNT;
  wire        [9:0]    in_period_div16; // number of mclks in 1/16 input period
  wire        [21:0]   delta_in_ctr_i;// fractional ouput pos. in units of isamp
  wire                 buffer_reset;  // reset ring buffer
  wire                 term_cnt_in;// input clock terminal count; new ratio
  wire                 norm_en;     
  wire     [23:0]      sum_inv;     
  wire     [1:0]       sum_shift;   
    
// Round enable wires
// Best linearity results are obtained by rounding in the divider 
// and not rounding the final result.   
  wire              divider_round_en  = 1'b1;
  wire              external_round_en = 1'b0;
  wire              ring_buf_reset = manual_ratio_en? reset: buffer_reset;
  
  assign  fifo_level_out = fifo_level[12:4];
  assign  calc_ratio_out = calc_ratio; 
  v_asrc_v1_0_timing_control_multi_ch timing_control_multi_ch(                          
    .mclk                (mclk),                          
    .clkout              (clkout),                        
    .reset               (reset),                         
    .ratio               (reg_ratio),                     
    .ratio_valid         (reg_ratio_valid ),              
    .osamp_done          (osamp_done),                    
    .product             (prod_out),                      
    .coef_accum          (coef_accum),                    
    .in_period_sync      (in_period_sync),                
    .out_period_sync     (out_period_sync), 
    .buffer_reset        (ring_buf_reset), 
    .divider_round_en    (divider_round_en),
    .manual_ratio_en     (manual_ratio_en),
    .manual_ratio        (manual_ratio  ),

    .go_fir              (go_fir),                        
    .move_start_ptr      (move_start_ptr),                
    .start_ptr_step      (start_ptr_step),                
    .cf_if               (cf_if),                         
    .first_isample_f     (first_isample_f ),              
    .aux_a               (aux_a),                         
    .aux_b               (aux_b),                         
    .aux_mult_reset      (aux_mult_reset),                
    .aux_sel             (aux_sel),                       
    .calc_ratio          (calc_ratio),                    
    .take_calc_ratio     (take_calc_ratio),               
    .norm_en             (norm_en  ),
    .sum_inv             (sum_inv  ),
    .sum_shift           (sum_shift),
    .delta_in_ctr_i      (delta_in_ctr_i)                               
  );                                                      
                                                                        
  // ratio filter
  v_asrc_v1_0_ratio_filt    ratio_filt(
    .mclk            (mclk),
    .reset           (reset),
    .ptr_reset       (1'b0),
    .locked          (locked),
    .calc_ratio      (calc_ratio),
    .take_calc_ratio (take_calc_ratio),
    .term_cnt_in     (term_cnt_in),
    
    .calc_ratio_filt (calc_ratio_filt),
    .tk_c_ratio_filt (take_c_ratio_filt)   
  );

  v_asrc_v1_0_ring_buffer_gold ring_buffer_gold_1(                        
    .mclk             (mclk),                               
    .clkin            (clkin),                              
    .reset            (reset),                              
    .input_sample     ( {input_sample_b, input_sample_a}),  
    .move_start_ptr   (move_start_ptr),                     
    .start_ptr_step   (start_ptr_step),                     
    .go_fir           (go_fir),                             
    .fetch_sample     (fetch_sample),                       
    .fifo_set_point   (fifo_set_point),                     
    .reg_ratio_valid  (reg_ratio_valid), 
    .in_period_div16  (in_period_div16), 
    .delta_in_ctr_i   (delta_in_ctr_i[21:18]),     
    .buffer_reset     (ring_buf_reset),
                                                            
    .data_valid       (),                                   
    .isample_a        (isample_a),                          
    .isample_b        (isample_b),                          
    .fifo_level       (fifo_level)                          
   );                                                       
                                                                  
  v_asrc_v1_0_ratio_calc ratio_calc(                       
    .mclk               (mclk ),               
    .clkin              (clkin),               
    .clkout             (clkout),              
    .reset              (reset),               
    .fifo_level         (fifo_level),          
    .fifo_set_point     (fifo_set_point),      
    .max_count          (max_count),           
    .calc_ratio         (calc_ratio_filt),          
    .take_calc_ratio    (take_c_ratio_filt),
    .move_start_ptr     (move_start_ptr),
    .start_ptr_step     (start_ptr_step),
    .mclk_divider       (6'b0),
                                                  
    .reg_ratio          (reg_ratio),           
    .reg_ratio_valid    (reg_ratio_valid),     
    .in_period_sync     (in_period_sync),      
    .out_period_sync    (out_period_sync),
    .locked             (locked),
    .in_period_div16    (in_period_div16),      
    .fifo_overflow      (fifo_overflow ),
    .buffer_reset       (buffer_reset),
    .term_cnt_in        (term_cnt_in)
  );                                           
                                               
  v_asrc_v1_0_filt_interp_gold filt_interp_gold(       
    .mclk               (mclk),            
    .reset              (reset),           
    .first_isample_f    (first_isample_f), 
    .cf_if              (cf_if),           
    .go_fir             (go_fir), 
    
    .coef_fir           (coef_fir),        
    .cycle              (cycle),           
    .sub_cycle          (sub_cycle),       
    .wait_3             (wait_3),          
    .coef_accum         (coef_accum),      
    .interp_done        (interp_done)      
   );                                      
                                           
  v_asrc_v1_0_fir_gold_4ch fir_gold_4ch (                      
    .mclk               (mclk ),           
    .reset              (reset),           
    .go_fir             (go_fir),          
    .cycle              (cycle),           
    .sub_cycle          (sub_cycle),       
    .wait_3             (wait_3),          
    .coef_fir           (coef_fir),        
    .isample_a          (isample_a),       
    .isample_b          (isample_b),       
    .isample_c          (),           
    .isample_d          (),           
    .aux_a              (aux_a),           
    .aux_b              (aux_b),           
    .aux_mult_reset     (aux_mult_reset),  
    .aux_sel            (aux_sel),
    .norm_en            (norm_en           ),
    .sum_inv            (sum_inv           ),
    .sum_shift          (sum_shift         ),
    .external_round_en  (external_round_en ),      
    .interp_done        (interp_done),     
                                           
    .fetch_sample       (fetch_sample),    
    .osamp_done         (osamp_done),      
    .output_samp_a      (output_sample_a),               
    .output_samp_b      (output_sample_b),               
    .output_samp_c      (),                              
    .output_samp_d      (),
    .prod_out           (prod_out)         
  );                                       
                                           
                                           
 
    
    
  
  endmodule	
