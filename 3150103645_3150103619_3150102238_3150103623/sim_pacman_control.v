`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:42:27 01/06/2017
// Design Name:   Pacman_Control
// Module Name:   C:/Users/CST/Desktop/Pac-Man0.78/sim_pacman_control.v
// Project Name:  Pac-Man
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Pacman_Control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sim_pacman_control;

	// Inputs
	reg [7:0] ps2_byte;
	reg ps2_state;
	reg rst;
	// Outputs
	wire [9:0] pacman_l;
	wire [9:0] pacman_r;
	wire [9:0] pacman_b;
	wire [9:0] pacman_t;
	wire [9:0] block1_x;
	wire [9:0] block1_y;

	// Instantiate the Unit Under Test (UUT)
	Pacman_Control uut (
		.ps2_byte(ps2_byte), 
		.ps2_state(ps2_state), 
		.rst(rst), 
		.pacman_l(pacman_l), 
		.pacman_r(pacman_r), 
		.pacman_b(pacman_b), 
		.pacman_t(pacman_t), 
		.block1_x(block1_x), 
		.block1_y(block1_y)
	);

	initial begin
		rst = 1;
		#50;
		rst = 0;
		ps2_byte = 8'h48;
		ps2_state = 1;
		#50;
		ps2_state = 0;
		#50;
		ps2_byte = 8'h4B;
		ps2_state = 1;
		#50;
		ps2_byte = 8'h50;
		ps2_state = 1;
		#50;
		ps2_state = 0;
		#50;
		ps2_byte = 8'h4D;
		ps2_state = 1;
		#50;
		ps2_state = 0;
		#50;
		rst = 1;

		#100;

	end
      
endmodule

