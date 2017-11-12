`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:37:34 12/29/2016 
// Design Name: 
// Module Name:    PacMan_Display 
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
module PacMan_Display(
	input wire p_tick, 
	input wire [9:0] p_x, p_y,
	output wire [11:0] graph_rgb
    );
	 
	 reg  Graph_rgb;
	 assign graph_rgb = Graph_rgb;
	 parameter pacman_l = 190;
	 parameter pacman_r = 200;
	 parameter pacman_b = 150;
	 parameter pacman_t = 160;
	 //PacMan Image ROM
	 assign sq_pacman_on = (pacman_l<=p_x&&p_x<=pacman_r)&&(pacman_b<=p_y&&p_y<=pacman_t);
		 
	 assign rom_addr = p_y - pacman_b;
	 assign rom_col = p_x - pacman_l;
	 assign rom_bit = rom_data[rom_col];
	 assign rd_pacman_on = sq_pacman_on&rom_bit;
	 assign pacman_rgb = 12'b1111_0000_1111;
	 assign bgc = 12'b0000_0000_0000;
	 
	 reg [9:0] rom_data;
	 always @*
		 case (rom_addr)
			4'h0: rom_data = 10'b0000000000;
			4'h1: rom_data = 10'b0011111000;
			4'h2: rom_data = 10'b0111111111;
			4'h3: rom_data = 10'b1111111100;
			4'h4: rom_data = 10'b1111111000;
			4'h5: rom_data = 10'b1111111000;
			4'h6: rom_data = 10'b1111111100;
			4'h7: rom_data = 10'b0111111111;
			4'h8: rom_data = 10'b0011111000;
			4'h9: rom_data = 10'b0000000000;
		 endcase
		 
	always @(posedge p_tick)
	begin 
		if (rd_pacman_on) Graph_rgb = pacman_rgb;
		else Graph_rgb = bgc;
	end
endmodule
