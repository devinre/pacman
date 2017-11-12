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

module  v_asrc_v1_0_divide_sign_fract (
  input               clk_i,          // IN  clock
  input               reset_i,        // IN  1 = reset
  input               load_i,         // IN  1 clock pulse to start a new divide
  input               round_i,        // IN  1 = round remainder, 0 = no rounding
  input [26:0]        divisor_i,      // IN  Number to be divided
  input [26:0]        dividend_i,     // IN  Number to divide by
  output  reg [26:0]  quotient_o,     // OUT integer quotient
  output  reg [24:0]  remainder_o,    // OUT fractional remainder
  output  reg         done_o          // OUT 1 = results ready
  );
parameter       Q_COUNT_MAX      = 6'd27;     // number of counts for valid Quotient result
parameter       R_COUNT_MAX      = 6'd52;     // number of counts for valid Remainder result


  reg  [26:0]     a;
  reg  [26:0]     b;
  reg  [26:0]     acc;
  reg             add_op;
  reg             a_neg;
  reg             b_neg;
  reg             q_bits;
  reg             r_bits;
  reg             load_d1; 
  wire            result_neg; 
  wire [26:0]     sum;
  reg  [5:0]      count;
  reg  [26:0]     result;

  // determine if the output should be 2's compliment
  assign result_neg = a_neg ^ b_neg;
  // add or subtract values.
  assign sum[26:0] = acc[26:0] + (a[26:0] ^ {27{!add_op}}) + !add_op;

  // register the divisor_i into storage register a.

  always @(posedge clk_i) begin
    if (reset_i) begin
        a <= 0;
        a_neg <= 1'b0;
    end
    else if (load_i) begin
      if(divisor_i[25:0] == 0) begin
          a_neg <= 1'b0;
          a <= 27'h3ffffff;            // divide by zero error so divide by max
      end
      else if(divisor_i[26]) begin
          a_neg <= 1'b1;
          a <= {1'b0, ((~divisor_i[25:0]) + 1'b1)};   // -ve number convert to positive
      end
      else begin
          a_neg <= 1'b0;
          a <=  divisor_i[26:0];
      end
    end
    else
        a <=  a;
  end

  // load b with the dividend, but shift by one for the first subtraction.

  always @(posedge clk_i) begin
    if (reset_i) begin
        b <= 0;
        b_neg <= 1'b0;
    end
    else if (load_i) begin
      if(dividend_i[25:0] == 0) begin
        b_neg <= 1'b0;
        b <=  0;                                     // condition where dividend_i is 0
      end
      else if(dividend_i[26]) begin
        b_neg <= 1'b1;
        b <=  {((~dividend_i[25:0]) + 1'b1), 1'b0};  // -ve number convert to positive and shift
      end
      else begin
        b_neg <= 1'b0;
        b <=  {dividend_i[25:0], 1'b0};              // shift first time
      end
    end
    else
      b <=  {b[25:0] , 1'b0};                        // shift each time 
  end

  // load the bits of the dividend into the accumulator and shift through the dividend.

  always @(posedge clk_i) begin
    if (reset_i)
      acc <= 0;
    else if (load_i)
      acc <=  0;
    else
      acc <=	{sum[25:0] , b[26]};
  end

  // first operation is always a subtraction ( assumes positive values ).

  always @(posedge clk_i) begin
    if (reset_i)
      add_op <= 0;
    else if (load_i)
      add_op <=  1'b0;
    else
      add_op <= sum[26];
  end

  // delay line of one for capturing the result bits.

  always @(posedge clk_i) begin
    load_d1 <= load_i;
  end


  // counter for timing the storage of the results. not needed if done externally.

  always @(posedge clk_i) begin
    if (load_i | reset_i)
      count <= 'h0;
    else if (!(&count))  
      count <= count + 1'b1;
    else
      count <= count; 	  
  end


  // capture each bit as it is generated.

  always @(posedge clk_i) begin
    if (load_d1 | reset_i)
      result <=  'h0;
    else
      result <=  {result[25:0],  !sum[26]};
  end

  // look for a zero result serialy as each bit as it is generated.

  always @(posedge clk_i) begin
    if (load_d1 | reset_i) begin
      q_bits <= 1'b0;
      r_bits <= 1'b0;
    end
    else if (count <= Q_COUNT_MAX) begin 
      r_bits <= 1'b0;  
      q_bits <=  q_bits | result[0];
    end
    else if (count <= R_COUNT_MAX) begin 
      r_bits <=  r_bits | result[0];
    end
    else begin
      q_bits <=  q_bits;
      r_bits <=  r_bits;
    end
  end

  // capture the integer and fraction bits when they are alligned in the result register.

  always @(posedge clk_i) begin
    if (reset_i) begin
      quotient_o  <= 0;
      remainder_o <= 0;
    end
    else if (count == Q_COUNT_MAX) begin
      if (!(q_bits | result[0]))
          quotient_o <= 0;    
      else if(result_neg)
        quotient_o <=  {1'b1, ((~result[25:0]) + 1'b1)};
      else
        quotient_o <=  {1'b0, result[25:0]};        // fix sign bit to +ve
    end
    else if (count == R_COUNT_MAX) begin
      if(round_i) begin                   // rounding using 1 LSB
        if (!(r_bits | result[0]))
          remainder_o <= 0; 
        else begin   
          case ({result_neg , result[0]})
            2'b00: remainder_o <=  {1'b0, result[24:1]};             // +ve remainder no round 
            2'b01: remainder_o <=  {1'b0, result[24:1] + 1'b1};      // +ve remainder with round up   
            2'b10: remainder_o <=  {1'b1, ((~result[24:1]) + 1'b1)}; // -ve remainder no round 
            2'b11: remainder_o <=  {1'b1, ~result[24:1]};            // -ve remainder with round up 
            default : remainder_o <=  {1'b0, result[24:1]};          // +ve remainder no round 
          endcase
        end
      end
      else begin                          //no rounding
        if (!r_bits)
          remainder_o <= 0;    
        else if(result_neg)
          remainder_o <=  {1'b1, ((~result[24:1]) + 1'b1)};
        else 
          remainder_o <=  {1'b0, result[24:1]};
      end
    end
    else begin
      quotient_o  <= quotient_o;
      remainder_o <= remainder_o;
    end
  end

  always @(posedge clk_i) begin
    if (reset_i | load_i)
      done_o <= 1'b0;
    else if (count == R_COUNT_MAX)
      done_o <=  1'b1;
    else
      done_o <=  done_o;
  end


endmodule	 
   
