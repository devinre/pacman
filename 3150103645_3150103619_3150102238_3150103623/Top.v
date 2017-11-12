`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:22 12/26/2016 
// Design Name: 
// Module Name:    Top 
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
module top(
			input wire clk,  //100Mhz signal
         input wire rst,	//reset signal
			input wire ps2k_clk,	//ps2_clk
			input wire ps2k_data, //ps2_data
			input wire sw,		//keyboard enable signal
         output wire HSync, VSync, //VGA sync      
         output wire [11:0] rgb,   //RGB output
			output wire Buzzer,		
			output wire [7:0] LED,	
			output wire [3:0] AN,	
			output wire [7:0] SEGMENT 
);
	 
assign LED = 8'b11111111;	
assign Buzzer = 1'b1;
	 
wire [9:0] p_x, p_y; 	// pixel x,y
wire [9:0] pac_x, pac_y;//pacman location	 
wire p_tick;				//25Mhz signal
wire clk_1s;				//1s frequency divider
wire [9:0] pacman_l, pacman_r, pacman_b, pacman_t;//the left, right, bottom and top boundaries of pacman
wire [9:0] ghost_x_l, ghost_x_r, ghost_y_t, ghost_y_b;//boundaries of ghost1
wire [9:0] ghost2_x_l,ghost2_x_r,ghost2_y_t,ghost2_y_b;//boundaries of ghost2
wire [9:0] ghost3_x_l,ghost3_x_r,ghost3_y_t,ghost3_y_b;//boundaries of ghost3
wire [9:0] ghost4_x_l,ghost4_x_r,ghost4_y_t,ghost4_y_b;//boundaries of ghost4
wire [7:0] ps2_byte;		//ascii code for keyboard buffer
wire ps2_state;			//keyboard input signal
wire [15:0] score;		//pacman score

//clk divider
counter_1s m0(
	.clk(clk),
	.clk_1s(clk_1s)
);

//VGA syncchronization
VGA_Sync m1(
	.clk(clk),
	.hs(HSync),
	.vs(VSync),
	.p_tick(p_tick),
	.p_x(p_x),
	.p_y(p_y)
);
	
//Keyboard buffer
ps2scan m2(
	.clk(clk), 
	.rst(sw), 
	.ps2k_clk(ps2k_clk), 
	.ps2k_data(ps2k_data), 
	.ps2_byte(ps2_byte), 
	.ps2_state(ps2_state)
);

//Calculate the position of pacman
Pacman_Control m3(
   .rst(rst),
	.ps2_byte(ps2_byte),
	.ps2_state(ps2_state),
	.pacman_l(pacman_l),
	.pacman_r(pacman_r),
	.pacman_b(pacman_b),
	.pacman_t(pacman_t),
	.block1_x(pac_x),
	.block1_y(pac_y)
);

//The 1st ghost control
ghost_control m4(
    .clk(clk_1s),
    .sw(sw),
    .rst(rst),
    .GhostPosition_x(ghost_x_l),
	 .GhostPosition_y(ghost_y_t),
	 .ghost_r(ghost_x_r),
	 .ghost_b(ghost_y_b),
	 .PacManPosition_x(pac_x),
	 .PacManPosition_y(pac_y)
);

//The 2nd ghost control
ghost2_control m5(
    .clk(clk_1s),
    .sw(sw),
    .rst(rst),
    .GhostPosition_x(ghost2_x_l),
	 .GhostPosition_y(ghost2_y_t),
	 .ghost_r(ghost2_x_r),
	 .ghost_b(ghost2_y_b),
	 .PacManPosition_x(pac_x),
	 .PacManPosition_y(pac_y)
);

//The 3rd ghost control
ghost3_control m6(
    .clk(clk_1s),
    .sw(sw),
    .rst(rst),
    .GhostPosition_x(ghost3_x_l),
	 .GhostPosition_y(ghost3_y_t),
	 .ghost_r(ghost3_x_r),
	 .ghost_b(ghost3_y_b),
	 .PacManPosition_x(pac_x),
	 .PacManPosition_y(pac_y)
);

//The 4th ghost control
ghost4_control m7(
    .clk(clk_1s),
    .sw(sw),
    .rst(rst),
    .GhostPosition_x(ghost4_x_l),
	 .GhostPosition_y(ghost4_y_t),
	 .ghost_r(ghost4_x_r),
	 .ghost_b(ghost4_y_b),
	 .PacManPosition_x(pac_x),
	 .PacManPosition_y(pac_y)
);

//Display all objects on the monitor with VGA
Object_Display m8(
	.p_tick(p_tick),
    .sw(sw),
    .rst(rst),
	.p_x(p_x-120),
	.p_y(p_y-100),
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
	
//Display the score on Sword
ScoreBoard m9(
	.clk(clk),
	.score(score),
	.AN(AN),
	.SEGMENT(SEGMENT)
);

endmodule