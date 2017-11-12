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
module v_asrc_v1_0_fir_gold_4ch (
  input                 mclk,       // high frequency processing clock   
  input                 reset,
  input                 go_fir,     //start the fir sequence
  input     [2:0]       cycle,      // multiplier cycle
  input     [1:0]       sub_cycle,  // multiplier sub-cycle (4 clks/35x35 mult)
  input                 wait_3,     // indicates that
  input     [34:0]      coef_fir,   //filter coefficient S1.33
  input     [23:0]      isample_a,    //input samples
  input     [23:0]      isample_b,    
  input     [23:0]      isample_c,   
  input     [23:0]      isample_d, 
  input     [22:0]      aux_a,       // auxiliary inputs to multiplier 1.22
  input     [30:0]      aux_b,       //    9.22
  input                 aux_mult_reset, 
  input                 aux_sel,     // 1 = aux. 
  input                 norm_en,     // enable bit for normalization cycle
  input     [23:0]      sum_inv,     // inverse (reciprocated) sum of coefficients
  input     [1:0]       sum_shift,   // shift value (exponent) used for sum_inv. 
  input                 external_round_en, //enable rounding on final output sample
  input                 interp_done, // interpolations done for an output sample
 
  output reg            fetch_sample,   // request for new input samples
  output reg            osamp_done,     // pulses when osample regs are loaded
  output reg   [23:0]   output_samp_a,   // completed output samples
  output reg   [23:0]   output_samp_b,   
  output reg   [23:0]   output_samp_c,   
  output reg   [23:0]   output_samp_d,    
  output       [69:0]   prod_out        // product out

 );
  reg   [34:0]      m_a;           // external reg for multiplier A input
  reg   [34:0]      m_b;           // external reg for multiplier B input
  reg               inputs_valid;  // input coeficient and samples are valid
  reg               accums_valid;  // output sample accumulator data is valid
  reg               reset_mult_1;  // reset multiplier state machine
  reg	  [11:0]		  state_bits;	  // state machine do-it bits
  wire  [34:0]      prod_out_for_accum; // prod_out formatted for  accumulators
  reg   [25:0]      normalized_samp; // prod_out formatted for normalization 
  reg   [25:0]      clamped_samp;
  reg   [25:0]      rounded_samp;
  reg   [34:0]      osamp_accum_a;  // output sample accumulators s3.31
  reg   [34:0]      osamp_accum_b;
  reg   [34:0]      osamp_accum_c;
  reg   [34:0]      osamp_accum_d;
  
  
  // stete machine bits            
  wire   [1:0]      mult_input_sel   = state_bits[11:10];
  wire              reset_mult       = state_bits[9];
  wire              take_accum_a     = state_bits[8];
  wire              take_accum_b     = state_bits[7];
  wire              take_accum_c     = state_bits[6];
  wire              take_accum_d     = state_bits[5];
  wire              get_isample      = state_bits[4];
  wire              take_outsamp_a   = state_bits[3];
  wire              take_outsamp_b   = state_bits[2];
  wire              take_outsamp_c   = state_bits[1];
  wire              take_outsamp_d   = state_bits[0];
  
  assign prod_out_for_accum =  {{3{prod_out[68]}}, prod_out[67:36]};
  // shift normalized output and round
  always @ (posedge mclk) begin
    case (sum_shift)
      0:  normalized_samp <= prod_out[65:40];    
      1:  normalized_samp <= prod_out[66:41];
      2:  normalized_samp <= prod_out[67:42];
      default: normalized_samp <= prod_out[68:43];
    endcase
  end
  always @ * begin
    if (external_round_en)
      rounded_samp = normalized_samp +( normalized_samp[25]? 
                                       26'h3_ffffff    // -1
                                      :26'h0_000001 );  // +1 
    else 
      rounded_samp = normalized_samp;
      
   if (rounded_samp[25:24] == 2'b10)
      clamped_samp =  26'h1000000;            //clamp to large neg
    else if (rounded_samp[25:24] == 2'b01)
      clamped_samp =  26'h0ffffff;            //clamp to large pos
   else 
      clamped_samp =  rounded_samp ;
             
  end  // always
// ********************* instance multipliers ******************************
    mult35x35_hdl  multiplier(
     .clk       (mclk),
     .rst       (reset),
     .rst_state (reset_mult_1),
     .a_in      (m_a),
     .b_in      (m_b),
     .prod_out  (prod_out)
   );
   
  always @ (posedge mclk)  begin
    // Mux reset_mult bits.  Don't reset during active convolution
    case ({norm_en, aux_sel})
      1:  reset_mult_1 <=  aux_mult_reset;      //aux
      2:  reset_mult_1 <=  0;                   // norm_en
      default: reset_mult_1 <= reset_mult && !inputs_valid; // convolution
    endcase
    //  Begin and End sequence bits
    if (go_fir) begin
      inputs_valid <= 0;
      accums_valid <= 0;
      osamp_done <= 0;
    end
    else begin
      osamp_done <= !inputs_valid && accums_valid && take_accum_a;
      if (cycle == 3 && sub_cycle == 3) begin // last state of cycle
        if (wait_3 && !interp_done)
          inputs_valid <= 1;
        else 
          inputs_valid <= 0;
          
        accums_valid <= inputs_valid;
      end  
    end 
    //  assign state bits 
    case  ({cycle, sub_cycle})
      // ms to ls
     //  take_accum_b
      5'h0f: state_bits <= 23'b 00_00_0100_0000; //0 0
      5'h00: state_bits <= 23'b 00_00_0000_0010; //0 1 
      5'h01: state_bits <= 23'b 00_00_0000_0000; //0 2 
      5'h02: state_bits <= 23'b 01_00_0000_0000; //0 3 
      
      5'h03: state_bits <= 23'b 01_00_0010_0000; //1 0 
      5'h04: state_bits <= 23'b 01_00_0000_0001; //1 1 
      5'h05: state_bits <= 23'b 01_00_0000_0000; //1 2 
      5'h06: state_bits <= 23'b 10_00_0000_0000; //1 3 
      
      5'h07: state_bits <= 23'b 10_01_0000_0000; //2 0 
      5'h08: state_bits <= 23'b 10_00_0000_1000; //2 1 
      5'h09: state_bits <= 23'b 10_00_0000_0000; //2 2 
      5'h0a: state_bits <= 23'b 11_00_0001_0000; //2 3 
      
      5'h0b: state_bits <= 23'b 11_00_1000_0000; //3 0 
      5'h0c: state_bits <= 23'b 11_00_0000_0100; //3 1 
      5'h0d: state_bits <= 23'b 11_10_0000_0000; //3 2 
      5'h0e: state_bits <= 23'b 00_00_0000_0000; //3 3 
      default:
             state_bits <= 23'b 11_11_1111_1111;     
    endcase
       
    // fetch input sample logic
    fetch_sample <= get_isample && inputs_valid;

    // Multiplier input registers
    case ({norm_en,aux_sel})
      0: m_a <= coef_fir;
      1: m_a <= {aux_a, 12'h000};
      2: m_a <= {1'b0,sum_inv, 10'h000};
      default:  m_a <= coef_fir;
    endcase
    case({norm_en,aux_sel})          
    1: 
       m_b <= {aux_b, 4'h0};
    2:  
       case (mult_input_sel)
       0: m_b <= osamp_accum_a; 
       1: m_b <= osamp_accum_b;
       2: m_b <= osamp_accum_c;
       default: m_b <= osamp_accum_d;
       endcase
    default:              // cases 0,3
      case (mult_input_sel)
        0: m_b <= {isample_a, 11'h000};
        1: m_b <= {isample_b, 11'h000}; 
        2: m_b <= {isample_c, 11'h000};
        default:  m_b <= {isample_d, 11'h000};
      endcase
    
    endcase 
    
    // Multiplier output registers 
    if (take_accum_a) begin
      if (!wait_3) begin
        osamp_accum_a <= 0;
        osamp_accum_b <= 0;
        osamp_accum_c <= 0;
        osamp_accum_d <= 0;
      end
      else if (inputs_valid)    
          osamp_accum_a <= osamp_accum_a + prod_out_for_accum;
    end
			 else begin
			   if (take_accum_b && inputs_valid)
                osamp_accum_b <= osamp_accum_b + prod_out_for_accum;
			   if (take_accum_c && accums_valid)
                osamp_accum_c <= osamp_accum_c + prod_out_for_accum;
			   if (take_accum_d && accums_valid)
                osamp_accum_d <= osamp_accum_d + prod_out_for_accum;
			 end
    
    // Final output registers 
    if (take_outsamp_a & norm_en)
      output_samp_a <= clamped_samp[24:1];
    if (take_outsamp_b & norm_en)
      output_samp_b <= clamped_samp[24:1];
    if (take_outsamp_c & norm_en)
      output_samp_c <= clamped_samp[24:1];
    if (take_outsamp_d & norm_en)
      output_samp_d <= clamped_samp[24:1];
               
  end  //always
   
endmodule	
