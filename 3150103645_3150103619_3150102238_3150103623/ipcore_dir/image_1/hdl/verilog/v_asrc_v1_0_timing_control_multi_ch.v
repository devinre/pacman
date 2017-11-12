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
//  This module has the following modification from the original timing_control.v
//     It uses an HDL based, non-pipelined divider (i.e inputs must stay constant
//     until the division is finished)  
//
//  It controls overall ciming of the ASRC cycle.   
//------------------------------------------------------------------------------
`timescale 1ns / 10ps

module v_asrc_v1_0_timing_control_multi_ch (
  input                 mclk,       // high frequency processing clock   
  input                 clkout,     // Ouput rate clock
  input                 reset,
  input     [25:0]      ratio,       // Fout/Fin ratio 4.22
  input                 ratio_valid, // flag: reg_ratio is valid
  input                 osamp_done,  // FIR has completed the output sample
  input     [69:0]      product,     // product from  external multiplier
  input     [34:0]      coef_accum,  // coefficient accumulator s3.31
  input     [24:0]      in_period_sync,  // in_period count synced w/out_period
  input     [24:0]      out_period_sync, // latest out_period
  input                 buffer_reset,   // buffer reset from ratio_calc
  input                 divider_round_en, // round enable for divider
  input                 manual_ratio_en,  // 1= manual ratio,  0 = auto ratio
  input    [25:0]       manual_ratio,     // manual ratio (Fout/Fin) 4.22
  
  output reg            go_fir,        // starts FIR sequence
  output reg            move_start_ptr,// update ring buffer start pointer
  output reg  [3:0]     start_ptr_step,// amount to add to start pointer 
  output reg  [29:0]    cf_if,         // conv. factor, 8.22
  output reg  [30:0]    first_isample_f,// start pos. in filter 9.22
  output reg  [22:0]    aux_a,         // a input to external multiplier 1.22
  output reg  [30:0]    aux_b,         // b input to external multiplier 9.22
  output reg            aux_mult_reset,// reset to external multiplier
  output reg            aux_sel,       // select external multiplier
  output reg  [25:0]    calc_ratio,      // output of divider, fout/fin  4.22
  output reg            take_calc_ratio, // calc_ratio is valid
  output reg            norm_en,       // enable bit for normalization cycle
  output reg  [23:0]    sum_inv,       // inverse (reciprocated) sum of coefficients
  output reg  [1:0]     sum_shift,     // shift value (exponent) used for sum_inv. 
  output wire [21:0]    delta_in_ctr_i // fractional portion of center position
  );
  parameter   RATIO       = 1;    // degenerate for now
  parameter   POSITIONS   = 2;
  parameter   INIT_FIR    = 3;    // degenerate for now
  parameter   FIR         = 6;
  parameter   SCALE       = 7;
  parameter   ATTENUATE   = 8;    // degenerate for now
  parameter   LOG_NUM_PHASES = 6;         // num_phases = 64 for Gold
  parameter   DIVIDER_LATENCY = 8'd53;    // 27 + 26
  parameter   RIPPLE_BIAS    = 8;  // Shift value for scaling output 
    
  wire              module_reset = reset || buffer_reset;
  reg    [3:0]      state;                  // state  machine state
  reg    [6:0]      state_count;            // counter for state machine
  reg    [6:0]      state_dly;              // counter that allows each state to complete 
  reg    [3:0]      next_state;             // next_state  combinatorial  variable
  reg               clkout_rising;          // one shot indicates rising edge of outclk
  reg    [6:0]      next_state_dly;         //state length assoc. with next next_state
  reg    [34:0]    center_pos_i;            // center position in isample space 13.22 
  wire    [12:0]    in_indexa_i;            // integer portion of center position
  reg     [12:0]    in_indexa_i_prev;       // first isample from previous FIR
  reg     [13:0]    diff_in_index;          // raw differnece in isample
 
  reg     [25:0]    ratio_mod;              // modified ratio 4.22  
  reg               state_count_tc;         // Terminal count for state counter
  wire              change_state;           // State will change at next clock
  reg     [26:0]    dividend;               // dividend for divider  S26
  reg     [26:0]    divisor;                // divisor  for divider S26
  wire    [26:0]    quot;                   // integer quotient from divider
  wire    [24:0]    remd;                   // fractional remainder from divider s24
  wire              rfd;                    // ready for data flag from divider
  reg     [7:0]     latency_cnt;            // divider latency counter from rfd
  reg     [34:0]    coef_accum_scaled;      // scaled to avoid output saturation
  reg     [26:0]    norm_sum;               // coef_accum_scaled shifted to have 1 as msb
  reg               clkout_1;               // sync and delay registers for clkout
  reg               clkout_2;
  reg               clkout_3;
  reg               clkout_4;
  reg               clkout_5;
  reg               clkout_6;
  reg               ratio_div_start;
  reg               fir_div_start;
  reg               aud_a_div_start;
  reg               start_div_a;
  reg				get_new_sample;	        // 1 = request to calculate new output sample
  reg				osamp_done_reg;         // osamp_done registered tor state machine use
  reg				state_machine_reset;    // reset SR for state machine 
  reg    [25:0]     inv_ratio;              // 1 / ratio
  wire   [25:0]     operating_ratio;

v_asrc_v1_0_divide_sign_fract DIV_A(
    .clk_i          (mclk), 
    .reset_i        (reset),
    .load_i         (start_div_a),
    .round_i        (divider_round_en),
    .dividend_i     (dividend),  
    .divisor_i      (divisor), 
    .quotient_o     (quot), 
    .remainder_o    (remd),
    .done_o         () 
    );

assign  change_state = state_count_tc && (next_state != state);     
assign  in_indexa_i    = center_pos_i[34:22];
assign  delta_in_ctr_i = center_pos_i[21:0];
assign  norm_samp_wire = {remd[24], (remd[24]^quot[0]), remd[23:0]};
assign  operating_ratio = manual_ratio_en? manual_ratio: ratio;

always @ (posedge mclk) 
  coef_accum_scaled <= coef_accum + (coef_accum >> RIPPLE_BIAS); 

// calculate shift logic
always @ * begin
   if (coef_accum_scaled[33]) begin   
     sum_shift = 3;
     norm_sum = coef_accum_scaled[34:8];
   end
   else if (coef_accum_scaled[32]) begin
     sum_shift = 2;
     norm_sum = coef_accum_scaled[33:7];
   end
   else if (coef_accum_scaled[31]) begin
     sum_shift = 1;
     norm_sum = coef_accum_scaled[32:6];
   end
   else  begin
     sum_shift = 0;
     norm_sum = coef_accum_scaled[31:5];
   end
end
  
 // ***************************** Next State Logic  **************************  
 
always @ (posedge mclk)  begin
  state_count_tc <= (state_count == state_dly); 
  if (state_machine_reset )  begin    // start  no_reset on clkout_rising
    next_state <= RATIO;
    next_state_dly <= 15;
  end 
  else begin   // regular operation                      
    case (state)
      RATIO:  begin
        if   (ratio_valid  && get_new_sample)  begin
          next_state <= POSITIONS;
          next_state_dly <= 14;
        end
        else       begin
          next_state <= RATIO;
          next_state_dly <= 3;
        end
      end  // RATIO
      POSITIONS:   begin
        next_state <= FIR;
        next_state_dly <= 3;
      end
      FIR:      begin
         if (osamp_done_reg)  begin
          next_state <= SCALE;
          next_state_dly <= 95;    // divider latency + Normalize multiplies
        end
        else begin
       next_state <= FIR;
        next_state_dly <= 3;
        end
      end     // FIR:
      SCALE:      begin
        next_state <= ATTENUATE;
        next_state_dly <= 3;
      end
      ATTENUATE:   begin  
        next_state <= RATIO;
        next_state_dly <= 3;
      end
      default:     begin
        next_state <= RATIO;
        next_state_dly <= 3;
      end
    endcase
  end          // regular operation
end    // always
// ******************************** state change logic ************************
always @ (posedge mclk or posedge module_reset) begin
  if (module_reset) begin  // reset
    state <= 0;
    state_dly <= 0;
    state_count <= 0;
  end               // reset
  else   begin  // not reset
    if (state_count_tc)  begin
      state <= next_state ;
      state_dly <= next_state_dly;
      state_count <= 0;
    end
    else
      state_count <= state_count +1;
  end   // not reset
     
end  // always

// ***************************** state variable Logic **********************
always @ (posedge mclk or posedge module_reset)  begin
  if (module_reset) begin
    aux_sel <= 0;
    aux_mult_reset <= 0;
    calc_ratio <= 26'h0400000;
  end   // reset
  else begin // not reset
    if (change_state) begin
      case (next_state)
  // *************************** calculate new ratio  ***********************
        RATIO:  begin
          aux_sel <= 0;
          take_calc_ratio <= 1;
        end

  //*********************** calculate new positions *************************
        POSITIONS: begin
          aux_sel <= 1;
          move_start_ptr <= 1;
        end
  //*********************** FIR filter  *************************************
        INIT_FIR: begin
          aux_sel <=0;
        end
   
    // *********** (FIR loop) Multiply and accum. coef. * input value *******
        FIR:  begin
          if (state != FIR) 
            go_fir  <= 1;
            
          aux_sel <=0;
        end

  // ************** Divide result of FIR by Sum of Coefficients *************
        SCALE:     begin
        end
  // ************** Multiply  result by scale factor ************************
        ATTENUATE:  begin
        end
        default:;
      endcase
    end  // if (state_count_tc )
    else  begin   // if (! state_count_tc)
    
    go_fir <= 0 ;   // fir_go pulses at the start of the FIR state only
    take_calc_ratio <= 0; //  take pulses at the start of the SCALE state only
    move_start_ptr <= 0;  // putlses at start of POSITIONS state
    
    // ******************* perform function of each state 
      case (state)
  // *************************** calculate new ratio  
        RATIO:  begin 
           norm_en <= 0;
        // calculate inverse ratio
           dividend <= 27'h0400000 ; // 1
           divisor  <= {1'b0,operating_ratio}; 
           inv_ratio <= {quot [3:0], remd[23:2]};
        end  // Ratio

  //*********************** calculate new positions 
        POSITIONS: begin
          case (state_count) 
            0:  begin
                aux_a <=   {1'b0, delta_in_ctr_i} ;
                aux_b <=   {1'b0, cf_if} ;
                aux_mult_reset <= 0;
              end
            1: 
              aux_mult_reset <= 1;
            2: 
              aux_mult_reset <= 0;
            12:                   // allow 9 states -resets to output + 1 extra
              first_isample_f <=  product [68:38];
            default:
              ;
            
          endcase
        end    // Positions
  //*********************** FIR filter  
        INIT_FIR: begin
        end
   
    // *********** (FIR loop) Multiply and accum. coef. * input value 
        FIR:  begin
          if (state_count == 0) begin   // hold divider inputs through the state
            dividend <= in_period_sync;//in period count s 
            divisor  <= out_period_sync;// latest out period  count
          end 
          calc_ratio <=  {quot [3:0], remd[23:2]};  // output  new calc_ratio
        end

  // ************** Reciprocate sum of coefficients and send result to FIR section
  // ************** to scale FIR accumulator results

  //Divide result of FIR by Sum of Coefficients 
        SCALE:     begin
          dividend <= 27'h2000000;
          divisor <= norm_sum;
          if (state_count == 0)  begin
            latency_cnt <= 0;
            aud_a_div_start <= 1'b1;
          end
          else begin
            latency_cnt <= latency_cnt + 1;
            aud_a_div_start <= 1'b0;
            case (latency_cnt)
              DIVIDER_LATENCY + 4: begin
                // check for overflow (denominator <= numerator i.e. quotient /= 0)
                if (quot[0] == 0)
                  sum_inv <= remd[23:0];  // Get Result, all fractional
                else 
                  sum_inv <= 24'hFFFFFF;   // clamp to maximum value
                norm_en <= 1;
              end
            default: ;
				endcase
          end
        end
  // ************** Multiply  result by scale factor 
        ATTENUATE:  begin
        end
        default:;
      endcase
    end           // if ( ! state_count_tc)
  end // not reset
end // always
//  other calculations
always @(posedge mclk or posedge module_reset) begin
  if (module_reset) begin
    center_pos_i  <= 0;
    get_new_sample <= 0;
    clkout_rising <= 0;
    clkout_1 <= 0;
    clkout_2 <= 0;
    clkout_3 <= 0;
	osamp_done_reg <= 0;
    start_ptr_step <= 0;
    in_indexa_i_prev <= 0;
  end  // if reset
  else  begin // not reset
    // detect rising edge of output clock and assert get_new_sample
    clkout_1 <= clkout;
    clkout_2 <= clkout_1;     // sample output clock in mclk domain
    clkout_3 <= clkout_2;
    clkout_4 <= clkout_3;
    clkout_5 <= clkout_4;
    clkout_6 <= clkout_5;
    clkout_rising <= clkout_1 && clkout_2 && !clkout_5 & !clkout_6
                     && (clkout_3 ^ clkout_4); // rising edge detect
//    clkout_rising <= (clkout_2 && !clkout_3);
    
    if (clkout_rising) 
      get_new_sample <= 1;
    else if (state == POSITIONS)
      get_new_sample <= 0;

	 // hold osamp_done until state change
	if (osamp_done)
	   osamp_done_reg <= 1;
    else if (state != FIR)
	   osamp_done_reg <= 0;
    // hold state_machine reset until state machine goes to Ratio state
    if (module_reset || clkout_rising)
	   state_machine_reset <= 1;
    else if (state == RATIO)
	   state_machine_reset <= 0;
    
    // modify ratio if necessary
    if (ratio <  26'h400000)   // ratio  < 1   (4.22)
        ratio_mod <= operating_ratio;
    else
        ratio_mod <= 26'h400000;
    // Conversion factors
    cf_if <= ratio_mod << LOG_NUM_PHASES;
    // Center position relative to input samples
    if (go_fir)  begin
      center_pos_i <= center_pos_i + inv_ratio;
      in_indexa_i_prev <= in_indexa_i;
    end
    diff_in_index[12:0] <= in_indexa_i - in_indexa_i_prev ;
    start_ptr_step <= diff_in_index[3:0];
        
  end         // not reset
end  // always

// Divider start pulse
always @(posedge mclk) begin
    if(reset) begin
        start_div_a     <= 1'b0;
        ratio_div_start <= 1'b0;
        fir_div_start   <= 1'b0;
    end
    else begin
        ratio_div_start <= take_calc_ratio;
        fir_div_start   <= go_fir;
        start_div_a     <= ratio_div_start | fir_div_start | aud_a_div_start; 
    end
end


endmodule	

