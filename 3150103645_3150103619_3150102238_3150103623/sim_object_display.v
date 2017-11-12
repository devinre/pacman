`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:59:33 01/06/2017
// Design Name:   Object_Display
// Module Name:   C:/Users/CST/Desktop/Pac-Man0.78/sim_object_display.v
// Project Name:  Pac-Man
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Object_Display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sim_object_display;

	// Inputs
	reg p_tick;
	reg sw;
	reg rst;
	reg [9:0] p_x;
	reg [9:0] p_y;
	reg [7:0] ps2_byte;
	reg ps2_state;
	reg [9:0] pacman_l;
	reg [9:0] pacman_r;
	reg [9:0] pacman_b;
	reg [9:0] pacman_t;
	reg [9:0] ghost_x_l;
	reg [9:0] ghost_x_r;
	reg [9:0] ghost_y_t;
	reg [9:0] ghost_y_b;
	reg [9:0] ghost2_x_l;
	reg [9:0] ghost2_x_r;
	reg [9:0] ghost2_y_t;
	reg [9:0] ghost2_y_b;
	reg [9:0] ghost3_x_l;
	reg [9:0] ghost3_x_r;
	reg [9:0] ghost3_y_t;
	reg [9:0] ghost3_y_b;
	reg [9:0] ghost4_x_l;
	reg [9:0] ghost4_x_r;
	reg [9:0] ghost4_y_t;
	reg [9:0] ghost4_y_b;

	// Outputs
	wire [11:0] rgb;
	wire [15:0] score;

	// Instantiate the Unit Under Test (UUT)
	Object_Display uut (
		.p_tick(p_tick), 
		.sw(sw), 
		.rst(rst), 
		.p_x(p_x), 
		.p_y(p_y), 
		.ps2_byte(ps2_byte), 
		.ps2_state(ps2_state), 
		.pacman_l(pacman_l), 
		.pacman_r(pacman_r), 
		.pacman_b(pacman_b), 
		.pacman_t(pacman_t), 
		.ghost_x_l(ghost_x_l), 
		.ghost_x_r(ghost_x_r), 
		.ghost_y_t(ghost_y_t), 
		.ghost_y_b(ghost_y_b), 
		.ghost2_x_l(ghost2_x_l), 
		.ghost2_x_r(ghost2_x_r), 
		.ghost2_y_t(ghost2_y_t), 
		.ghost2_y_b(ghost2_y_b), 
		.ghost3_x_l(ghost3_x_l), 
		.ghost3_x_r(ghost3_x_r), 
		.ghost3_y_t(ghost3_y_t), 
		.ghost3_y_b(ghost3_y_b), 
		.ghost4_x_l(ghost4_x_l), 
		.ghost4_x_r(ghost4_x_r), 
		.ghost4_y_t(ghost4_y_t), 
		.ghost4_y_b(ghost4_y_b), 
		.rgb(rgb), 
		.score(score)
	);

	initial begin
		// Initialize Inputs
		p_tick = 0;
		sw = 0;
		rst = 1;
		p_x = 0;
		p_y = 0;
		ps2_byte = 0;
		ps2_state = 0;
		pacman_l = 0;
		pacman_r = 0;
		pacman_b = 0;
		pacman_t = 0;
		ghost_x_l = 0;
		ghost_x_r = 0;
		ghost_y_t = 0;
		ghost_y_b = 0;
		ghost2_x_l = 0;
		ghost2_x_r = 0;
		ghost2_y_t = 0;
		ghost2_y_b = 0;
		ghost3_x_l = 0;
		ghost3_x_r = 0;
		ghost3_y_t = 0;
		ghost3_y_b = 0;
		ghost4_x_l = 0;
		ghost4_x_r = 0;
		ghost4_y_t = 0;
		ghost4_y_b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		p_x = 15;
		p_x = 15;
		ps2_byte = 0;
		ps2_state = 0;
		pacman_l = 60;
		pacman_r = 70;
		pacman_b = 10;
		pacman_t = 20;
		ghost_x_l = 10;
		ghost_x_r = 20;
		ghost_y_t = 20;
		ghost_y_b = 30;
		ghost2_x_l = 20;
		ghost2_x_r = 30;
		ghost2_y_t = 10;
		ghost2_y_b = 20;
		ghost3_x_l = 30;
		ghost3_x_r = 40;
		ghost3_y_t = 10;
		ghost3_y_b = 20;
		ghost4_x_l = 40;
		ghost4_x_r = 50;
		ghost4_y_t = 10;
		ghost4_y_b = 20;
		#100;
		pacman_l = 20;
		pacman_r = 30;
		pacman_b = 10;
		pacman_t = 20;
		#100;
		pacman_l = 10;
		pacman_r = 20;
		pacman_b = 10;
		pacman_t = 20;
		#100;
		pacman_l = 10;
		pacman_r = 20;
		pacman_b = 10;
		pacman_t = 20;
		ghost_x_l = 10;
		ghost_x_r = 20;
		ghost_y_t = 10;
		ghost_y_b = 20;
	end
      
endmodule

