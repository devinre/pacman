`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:37 12/30/2016 
// Design Name: 
// Module Name:    PS2_Control 
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
module Pacman_Control(
	input [7:0] ps2_byte,    // input key ascii code
	input ps2_state,			//ps2 input done signal
   input wire rst,         //reset signal
	output wire [9:0] pacman_l,
	output wire [9:0] pacman_r,
	output wire [9:0] pacman_b,
	output wire [9:0] pacman_t,
	output wire [9:0] block1_x,//currnt x location (0,39)
	output wire [9:0] block1_y//current y location (1,28)
    );
reg [9:0] block_x, block_y;
reg [9:0] block_x_reg, block_y_reg;
wire [3:0] valid;
assign block1_x=block_x_reg;
assign block1_y=block_y_reg;

assign pacman_l = 10*block_x_reg-10;//assign the left boundary of pacman
assign pacman_r = 10*block_x_reg;//assign the right boundary of pacman
assign pacman_b = 10*block_y_reg-10;//assign the bottom of pacman
assign pacman_t = 10*block_y_reg;//assign the top of pacman

always @(negedge ps2_state or posedge rst)
begin
	if (rst)//Initialize the location
	begin
		block_x_reg = 20;
		block_y_reg = 16;
	end
	else
		case (ps2_byte)
			8'h48: //Up
				begin
					block_x_reg = block_x_reg;
					block_y_reg = block_y_reg - valid[2];
				end
			8'h4B://Left
				begin
					block_x_reg = block_x_reg - valid[0];
					block_y_reg = block_y_reg;
				end
			8'h50://Down
				begin
					block_x_reg = block_x_reg;
					block_y_reg = block_y_reg + valid[3];
				end
			8'h4D://Right
				begin
					block_x_reg = block_x_reg + valid[1];
					block_y_reg = block_y_reg;
				end
			default://don't move
				begin
					block_x_reg = block_x_reg;
					block_y_reg = block_y_reg;
				end
		endcase
end

	//Find the direction that pacman can walk
	walk_detect m4(.block_x_reg(block_x_reg), .block_y_reg(block_y_reg),.valid(valid)); 
endmodule
