`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:02:55 12/30/2016 
// Design Name: 
// Module Name:    Ghost_Display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Ghost_Display(
    );

 //Ghost Display
  localparam ghost_size = 10;
  wire [9:0] ghost_x_l, ghost_x_r;
  wire [9:0] ghost_y_t, ghost_y_b;
  reg [9:0] ghost_x_reg, ghost_y_reg;
  wire [9:0] ghost_x_next, ghost_y_next;
  reg [9:0] x_delta_reg, x_delta_next;
  reg [9:0] y_delta_reg, y_delta_next;
  localparam ghost_v_p = 2;
  localparam ghost_v_n = -2;
  wire [3:0] rom_addr, rom_col;
  reg [15:0] rom_data;
  wire rom_bit;
  
  initial begin
		ghost_x_reg = 190;
		ghost_y_reg = 100;
  end
  
  always @*
  case (rom_addr)
		4'h0: rom_data = 10'b0001111100000000;
		4'h1: rom_data = 10'b0111111110000000;
		4'h2: rom_data = 10'b1111111111000000;
		4'h3: rom_data = 10'b1111111111000000;
		4'h4: rom_data = 10'b1100110011000000;
		4'h5: rom_data = 10'b1100110011000000;
		4'h6: rom_data = 10'b1111111111000000;
		4'h7: rom_data = 10'b1111111111000000;
		4'h8: rom_data = 10'b1011001101000000;
		4'h9: rom_data = 10'b1001000101000000;
		4'hA: rom_data = 10'b0000000000000000;
		4'hB: rom_data = 10'b0000000000000000;
		4'hC: rom_data = 10'b0000000000000000;
		4'hD: rom_data = 10'b0000000000000000;
		4'hE: rom_data = 10'b0000000000000000;
		4'hF: rom_data = 10'b0000000000000000;
  endcase
  always @(posedge p_tick)
     begin
      ghost_x_reg <= ghost_x_next;
      ghost_y_reg <= ghost_y_next;
      x_delta_reg <= x_delta_next;
      y_delta_reg <= y_delta_next;
   end
  assign ghost_x_l = ghost_x_reg;
  assign ghost_x_t = ghost_y_reg;
  assign ghost_x_r = ghost_x_l + ghost_size - 1;
  assign ghost_x_b = ghost_y_t + ghost_size - 1;
  assign ghost_on = (ghost_x_l<=p_x)&&(p_x<=ghost_x_r)&&(ghost_y_t<=p_y)&&(p_y<=ghost_y_b);
  assign rom_addr = p_y[3:0]-ghost_y_t[3:0];
  assign rom_col = p_x[3:0]-ghost_x_l[3:0];
  assign rd_ghost_on = ghost_on & rom_bit;
  assign ghost_rgb = 12'b1111_0000_0000;s
endmodule
