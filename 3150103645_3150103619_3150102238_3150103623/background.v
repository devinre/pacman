`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:15 12/25/2016 
// Design Name: 
// Module Name:    background 
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
module Object_Display(
	input wire p_tick,//VGA display frequency
   input wire sw,//keyboard enable signal
   input wire rst,//reset signal
	input wire [9:0] p_x, p_y,
	input [7:0] ps2_byte,
	input ps2_state,
	//pacman area
   input wire [9:0] pacman_l,
	input wire [9:0] pacman_r,
	input wire [9:0] pacman_b,
	input wire [9:0] pacman_t,
	//ghost1 area
	input wire [9:0] ghost_x_l,
	input wire [9:0] ghost_x_r,
	input wire [9:0] ghost_y_t,
	input wire [9:0] ghost_y_b,
	//ghost2 area 
	input wire [9:0] ghost2_x_l,
	input wire [9:0] ghost2_x_r,
	input wire [9:0] ghost2_y_t,
	input wire [9:0] ghost2_y_b,
	//ghost3 area
	input wire [9:0] ghost3_x_l,
	input wire [9:0] ghost3_x_r,
	input wire [9:0] ghost3_y_t,
	input wire [9:0] ghost3_y_b,
	//ghost4 area
	input wire [9:0] ghost4_x_l,
	input wire [9:0] ghost4_x_r,
	input wire [9:0] ghost4_y_t,
	input wire [9:0] ghost4_y_b,
	output wire [11:0] rgb,
	output wire [15:0] score
    );

wire wall_on;
reg [11:0] RGB = 0;
assign rgb = RGB;//RGB;

//Wall Display
//Wall area defination
	parameter wall_1_l=20;parameter wall_1_r=180;parameter wall_1_t = 260;parameter wall_1_b = 240;
	parameter wall_2_l=20;parameter wall_2_r= 90;parameter wall_2_t = 230;parameter wall_2_b = 180;
	parameter wall_3_l=100;parameter wall_3_r= 120;parameter wall_3_t = 240;parameter wall_3_b = 210;
	parameter wall_4_l=190;parameter wall_4_r= 200;parameter wall_4_t = 260;parameter wall_4_b = 230;
   parameter wall_5_l=130;parameter wall_5_r= 200;parameter wall_5_t = 230;parameter wall_5_b = 210;
	parameter wall_6_l=100;parameter wall_6_r= 180;parameter wall_6_t = 200;parameter wall_6_b = 180;
	parameter wall_7_l=10;parameter wall_7_r= 90;parameter wall_7_t = 170;parameter wall_7_b = 80;
	parameter wall_8_l=100;parameter wall_8_r= 120;parameter wall_8_t = 170;parameter wall_8_b = 130;
	parameter wall_9_l=190;parameter wall_9_r=200; parameter wall_9_t=200; parameter wall_9_b = 170;
	parameter wall_10_l=130;parameter wall_10_r=200; parameter wall_10_t=170; parameter wall_10_b=160;
	parameter wall_11_l=130;parameter wall_11_r=200;parameter wall_11_t=150;parameter wall_11_b=140;
	parameter wall_12_l=130;parameter wall_12_r=140;parameter wall_12_t=140;parameter wall_12_b=120;
	parameter wall_13_l=130;parameter wall_13_r=190;parameter wall_13_t=120;parameter wall_13_b=110;
	parameter wall_14_l=100;parameter wall_14_r=120;parameter wall_14_t=120;parameter wall_14_b=60;
	parameter wall_15_l=120;parameter wall_15_r=180;parameter wall_15_t=100;parameter wall_15_b=90;
	parameter wall_16_l=20;parameter wall_16_r=90;parameter wall_16_t=70;parameter wall_16_b=60;
	parameter wall_17_l=130;parameter wall_17_r=200;parameter wall_17_t=80;parameter wall_17_b=60;
	parameter wall_18_l=190;parameter wall_18_r=200;parameter wall_18_t=100;parameter wall_18_b=80;
	parameter wall_19_l=20;parameter wall_19_r=90;parameter wall_19_t=50;parameter wall_19_b=20;
	parameter wall_20_l=100;parameter wall_20_r=180;parameter wall_20_t=50;parameter wall_20_b=20;
	parameter wall_21_l=190;parameter wall_21_r=200;parameter wall_21_t=50;parameter wall_21_b=10;

 //wall display signal
	assign wall_on =(((wall_1_b<=p_y&&p_y<=wall_1_t)&&((wall_1_l<=p_x&&p_x<=wall_1_r)||(wall_1_l<=400-p_x&&400-p_x<=wall_1_r))) 
						||((wall_2_b<=p_y&&p_y<=wall_2_t)&&((wall_2_l<=p_x&&p_x<=wall_2_r)||(wall_2_l<=400-p_x&&400-p_x<=wall_2_r))) 
						||((wall_3_b<=p_y&&p_y<=wall_3_t)&&((wall_3_l<=p_x&&p_x<=wall_3_r)||(wall_3_l<=400-p_x&&400-p_x<=wall_3_r))) 
						||((wall_4_b<=p_y&&p_y<=wall_4_t)&&((wall_4_l<=p_x&&p_x<=wall_4_r)||(wall_4_l<=400-p_x&&400-p_x<=wall_4_r))) 
						||((wall_5_b<=p_y&&p_y<=wall_5_t)&&((wall_5_l<=p_x&&p_x<=wall_5_r)||(wall_5_l<=400-p_x&&400-p_x<=wall_5_r))) 
						||((wall_6_b<=p_y&&p_y<=wall_6_t)&&((wall_6_l<=p_x&&p_x<=wall_6_r)||(wall_6_l<=400-p_x&&400-p_x<=wall_6_r))) 
						||((wall_7_b<=p_y&&p_y<=wall_7_t)&&((wall_7_l<=p_x&&p_x<=wall_7_r)||(wall_7_l<=400-p_x&&400-p_x<=wall_7_r))) 
						||((wall_8_b<=p_y&&p_y<=wall_8_t)&&((wall_8_l<=p_x&&p_x<=wall_8_r)||(wall_8_l<=400-p_x&&400-p_x<=wall_8_r))) 
						||((wall_9_b<=p_y&&p_y<=wall_9_t)&&((wall_9_l<=p_x&&p_x<=wall_9_r)||(wall_9_l<=400-p_x&&400-p_x<=wall_9_r))) 
						||((wall_10_b<=p_y&&p_y<=wall_10_t)&&((wall_10_l<=p_x&&p_x<=wall_10_r)||(wall_10_l<=400-p_x&&400-p_x<=wall_10_r))) 
						||((wall_11_b<=p_y&&p_y<=wall_11_t)&&((wall_11_l<=p_x&&p_x<=wall_11_r)||(wall_11_l<=400-p_x&&400-p_x<=wall_11_r))) 
						||((wall_12_b<=p_y&&p_y<=wall_12_t)&&((wall_12_l<=p_x&&p_x<=wall_12_r)||(wall_12_l<=400-p_x&&400-p_x<=wall_12_r))) 
						||((wall_13_b<=p_y&&p_y<=wall_13_t)&&((wall_13_l<=p_x&&p_x<=wall_13_r)||(wall_13_l<=400-p_x&&400-p_x<=wall_13_r))) 
						||((wall_14_b<=p_y&&p_y<=wall_14_t)&&((wall_14_l<=p_x&&p_x<=wall_14_r)||(wall_14_l<=400-p_x&&400-p_x<=wall_14_r))) 
						||((wall_15_b<=p_y&&p_y<=wall_15_t)&&((wall_15_l<=p_x&&p_x<=wall_15_r)||(wall_15_l<=400-p_x&&400-p_x<=wall_15_r))) 
						||((wall_16_b<=p_y&&p_y<=wall_16_t)&&((wall_16_l<=p_x&&p_x<=wall_16_r)||(wall_16_l<=400-p_x&&400-p_x<=wall_16_r))) 
						||((wall_17_b<=p_y&&p_y<=wall_17_t)&&((wall_17_l<=p_x&&p_x<=wall_17_r)||(wall_17_l<=400-p_x&&400-p_x<=wall_17_r))) 
						||((wall_18_b<=p_y&&p_y<=wall_18_t)&&((wall_18_l<=p_x&&p_x<=wall_18_r)||(wall_18_l<=400-p_x&&400-p_x<=wall_18_r))) 
						||((wall_19_b<=p_y&&p_y<=wall_19_t)&&((wall_19_l<=p_x&&p_x<=wall_19_r)||(wall_19_l<=400-p_x&&400-p_x<=wall_19_r))) 
						||((wall_20_b<=p_y&&p_y<=wall_20_t)&&((wall_20_l<=p_x&&p_x<=wall_20_r)||(wall_20_l<=400-p_x&&400-p_x<=wall_20_r))) 
						||((wall_21_b<=p_y&&p_y<=wall_21_t)&&((wall_21_l<=p_x&&p_x<=wall_21_r)||(wall_21_l<=400-p_x&&400-p_x<=wall_21_r))) 
						||(((0<=p_x&&p_x<=10||390<=p_x&&p_x<=400)&&0<=p_y&&p_y<=280)||((0<=p_y&&p_y<=10||270<=p_y&&p_y<=280)&&0<=p_x&&p_x<=400)));
	
	 wire [11:0] wall_rgb, pacman_rgb, bgc;
	 wire sq_pacman_on; 
	 reg rd_pacman_on;
	 
	 //Wall rgb ip-core
	 zhuanqiang_400_280 ip1(.clka(p_tick), .wea(), .addra(400*(280-p_y)+p_x), .dina(), .douta(wall_rgb));
	 
	 assign bgc = 12'b0000_0000_0000;
	 assign pacman_rgb = 12'b0010_1111_1111;
	 assign sq_pacman_on = (pacman_l<p_x&&p_x<pacman_r)&&(pacman_b<p_y&&p_y<pacman_t);
	 
	 //PacMan Image ROM (Left)
	 //parameter defination
	 wire rd_pacman_left_on; 
	 wire [3:0] rom_addr, rom_col; 
	 wire rom_bit;
	
	 assign rom_addr = p_y - pacman_b;	//rom address
	 assign rom_col = p_x - pacman_l;	//rom colum
	 assign rom_bit = rom_data[rom_col];//rom bit
	 assign rd_pacman_left_on = sq_pacman_on&rom_bit;	//whether to display or not
	 
	 reg [9:0] rom_data;
	 always @*
		 case (rom_addr)
			4'h0: rom_data = 10'b0000000000;//
			4'h1: rom_data = 10'b0011111100;//  ******
			4'h2: rom_data = 10'b0111111111;// *********
			4'h3: rom_data = 10'b1111111100;//********
			4'h4: rom_data = 10'b1111111000;//*******
			4'h5: rom_data = 10'b1111111000;//*******
			4'h6: rom_data = 10'b1111111100;//*********
			4'h7: rom_data = 10'b0111111111;// *********
			4'h8: rom_data = 10'b0011111100;//  ******
			4'h9: rom_data = 10'b0000000000;//
		 endcase
		 
	//Pacman Up
	 wire rd_pacman_up_on;
	 wire [3:0] pacman_up_addr, pacman_up_col; 
	 wire pacman_up_bit;
	
	 assign pacman_up_addr = p_y - pacman_b;
	 assign pacman_up_col = p_x - pacman_l;
	 assign pacman_up_bit = pacman_up_data[pacman_up_col];
	 assign rd_pacman_up_on = sq_pacman_on&pacman_up_bit;
	 
	 reg [9:0] pacman_up_data;
	 always @*
		 case (pacman_up_addr)
			4'h0: pacman_up_data = 10'b0010000100;//  *    *
			4'h1: pacman_up_data = 10'b0010000100;//  *    *
			4'h2: pacman_up_data = 10'b0111001110;// ***  ***
			4'h3: pacman_up_data = 10'b0111111110;// ********
			4'h4: pacman_up_data = 10'b0111111110;// ********
			4'h5: pacman_up_data = 10'b0111111110;// ********
			4'h6: pacman_up_data = 10'b0111111110;// ********
			4'h7: pacman_up_data = 10'b0111111110;// ********
			4'h8: pacman_up_data = 10'b0011111100;//  ******
			4'h9: pacman_up_data = 10'b0001111000;//   ****
		 endcase
		 
	//Pacman Right
	 wire rd_pacman_right_on;
	 wire [3:0] pacman_right_addr, pacman_right_col; 
	 wire pacman_right_bit;
	
	 assign pacman_right_addr = p_y - pacman_b;
	 assign pacman_right_col = p_x - pacman_l;
	 assign pacman_right_bit = pacman_right_data[pacman_right_col];
	 assign rd_pacman_right_on = sq_pacman_on&pacman_right_bit;
	 
	 reg [9:0] pacman_right_data;
	 always @*
		 case (pacman_right_addr)
			4'h0: pacman_right_data = 10'b0000000000;//
			4'h1: pacman_right_data = 10'b0111111100;// *******
			4'h2: pacman_right_data = 10'b1111111110;//*********
			4'h3: pacman_right_data = 10'b0111111110;// ********
			4'h4: pacman_right_data = 10'b0001111111;//   *******
			4'h5: pacman_right_data = 10'b0001111111;//   *******
			4'h6: pacman_right_data = 10'b0111111110;// ********
			4'h7: pacman_right_data = 10'b1111111110;//*********
			4'h8: pacman_right_data = 10'b0111111100;// *******
			4'h9: pacman_right_data = 10'b0000000000;//
		 endcase
		 
	//Pacman Down
	 wire rd_pacman_down_on;
	 wire [3:0] pacman_down_addr, pacman_down_col; 
	 wire pacman_down_bit;
	
	 assign pacman_down_addr = p_y - pacman_b;
	 assign pacman_down_col = p_x - pacman_l;
	 assign pacman_down_bit = pacman_down_data[pacman_down_col];
	 assign rd_pacman_down_on = sq_pacman_on&pacman_down_bit;
	 
 	 reg [9:0] pacman_down_data;
	 always @*
		 case (pacman_down_addr)
			4'h0: pacman_down_data = 10'b0000110000;//    **
			4'h1: pacman_down_data = 10'b0011111100;//  ******
			4'h2: pacman_down_data = 10'b0111111110;// ********
			4'h3: pacman_down_data = 10'b0111111110;// ********
			4'h4: pacman_down_data = 10'b0111111110;// ********
			4'h5: pacman_down_data = 10'b0111111110;// ********
			4'h6: pacman_down_data = 10'b0111111110;// ********
			4'h7: pacman_down_data = 10'b0111001110;// ***  ***
			4'h8: pacman_down_data = 10'b0111001110;// ***  ***
			4'h9: pacman_down_data = 10'b0010000100;//   *  *
		 endcase
	reg [7:0] direc;
	initial begin
		direc = 8'h4B;
	end
	
 //Bean Image
 	 
	 wire [11:0] bean_rgb;
	 assign bean_rgb = 12'b1111_1111_1111;
//Bean area defination
	 parameter bean1_l = 10;parameter bean1_b = 10;
	 parameter bean2_l = 380;parameter bean2_b = 10;
	 parameter bean3_l = 10;parameter bean3_b = 260;
	 parameter bean4_l = 380;parameter bean4_b = 260;
	 parameter bean5_l = 90;parameter bean5_b = 50;
	 parameter bean6_l = 300;parameter bean6_b = 50;
	 parameter bean7_l = 90;parameter bean7_b = 230;
	 parameter bean8_l = 300;parameter bean8_b = 230;
	 parameter bean9_l = 120;parameter bean9_b = 100;
	 parameter bean10_l = 270;parameter bean10_b = 100;
    parameter bean11_l = 110;parameter bean11_b = 260;
    parameter bean12_l = 280;parameter bean12_b = 260;
    parameter bean13_l = 110;parameter bean13_b = 10;
    parameter bean14_l = 280;parameter bean14_b = 10;
    parameter bean15_l = 140;parameter bean15_b = 130;
    parameter bean16_l = 250;parameter bean16_b = 130;
	 parameter fake_bean_l = 20; parameter fake_bean_b = 10;

	 reg [16:0] eaten; //Eaten or not reg
	 //each bean area on
	 wire bean1_on, bean2_on, bean3_on, bean4_on, bean5_on, bean6_on, bean7_on, bean8_on, bean9_on, bean10_on, bean11_on, bean12_on, bean13_on, bean14_on, bean15_on, bean16_on;
	 //bean area on
	 wire rd_bean_on;
	 assign rd_bean_on = bean1_on||bean2_on||bean3_on||bean4_on||bean5_on||bean6_on||bean7_on||bean8_on||bean9_on||bean10_on||bean11_on||bean12_on||bean13_on||bean14_on||bean15_on||bean16_on;
	 //initial all beans not eaten
	 initial begin
		eaten = 16'b0000_0000_0000_0000;
	 end
	
	//fetch each bean display information
	Bean_Rom b1(.p_x(p_x), .p_y(p_y), .bean_l(bean1_l), .bean_b(bean1_b), .eaten(!eaten[0]), .rd_bean_on(bean1_on)); 
	Bean_Rom b2(.p_x(p_x), .p_y(p_y), .bean_l(bean2_l), .bean_b(bean2_b), .eaten(!eaten[1]), .rd_bean_on(bean2_on));
	Bean_Rom b3(.p_x(p_x), .p_y(p_y), .bean_l(bean3_l), .bean_b(bean3_b), .eaten(!eaten[2]), .rd_bean_on(bean3_on));
	Bean_Rom b4(.p_x(p_x), .p_y(p_y), .bean_l(bean4_l), .bean_b(bean4_b), .eaten(!eaten[3]), .rd_bean_on(bean4_on));
	Bean_Rom b5(.p_x(p_x), .p_y(p_y), .bean_l(bean5_l), .bean_b(bean5_b), .eaten(!eaten[4]), .rd_bean_on(bean5_on));
	Bean_Rom b6(.p_x(p_x), .p_y(p_y), .bean_l(bean6_l), .bean_b(bean6_b), .eaten(!eaten[5]), .rd_bean_on(bean6_on));
	Bean_Rom b7(.p_x(p_x), .p_y(p_y), .bean_l(bean7_l), .bean_b(bean7_b), .eaten(!eaten[6]), .rd_bean_on(bean7_on));
	Bean_Rom b8(.p_x(p_x), .p_y(p_y), .bean_l(bean8_l), .bean_b(bean8_b), .eaten(!eaten[7]), .rd_bean_on(bean8_on));
	Bean_Rom b9(.p_x(p_x), .p_y(p_y), .bean_l(bean9_l), .bean_b(bean9_b), .eaten(!eaten[8]), .rd_bean_on(bean9_on));
	Bean_Rom b10(.p_x(p_x), .p_y(p_y), .bean_l(bean10_l), .bean_b(bean10_b), .eaten(!eaten[9]), .rd_bean_on(bean10_on));
   Bean_Rom b11(.p_x(p_x), .p_y(p_y), .bean_l(bean11_l), .bean_b(bean11_b), .eaten(!eaten[10]), .rd_bean_on(bean11_on)); 
	Bean_Rom b12(.p_x(p_x), .p_y(p_y), .bean_l(bean12_l), .bean_b(bean12_b), .eaten(!eaten[11]), .rd_bean_on(bean12_on));
	Bean_Rom b13(.p_x(p_x), .p_y(p_y), .bean_l(bean13_l), .bean_b(bean13_b), .eaten(!eaten[12]), .rd_bean_on(bean13_on));
	Bean_Rom b14(.p_x(p_x), .p_y(p_y), .bean_l(bean14_l), .bean_b(bean14_b), .eaten(!eaten[13]), .rd_bean_on(bean14_on));
	Bean_Rom b15(.p_x(p_x), .p_y(p_y), .bean_l(bean15_l), .bean_b(bean15_b), .eaten(!eaten[14]), .rd_bean_on(bean15_on));
	Bean_Rom b16(.p_x(p_x), .p_y(p_y), .bean_l(bean16_l), .bean_b(bean16_b), .eaten(!eaten[15]), .rd_bean_on(bean16_on));

	 //Ghost1 Image
	 wire sq_ghost_on,rd_ghost_on;
	 wire [11:0] ghost_rgb;
	 wire [3:0] ghost_addr, ghost_col;
	 wire ghost_bit;
	 //enable the sq_ghost
	 assign sq_ghost_on = (ghost_x_l<=p_x)&&(p_x<=ghost_x_r)&&(ghost_y_t<=p_y)&&(p_y<=ghost_y_b);
	 //the location of the ghost;
	 assign ghost_addr = p_y-ghost_y_t;
	 assign ghost_col = p_x-ghost_x_l;
	 assign ghost_bit=ghost_data[ghost_col];
	 assign rd_ghost_on = sq_ghost_on & ghost_bit;
	 assign ghost_rgb = 12'b1111_0000_1111;

	 reg [9:0] ghost_data;
	 //ROM used to store the image of the ghost;
	 always @*
	 case (ghost_addr)
	    4'h0: ghost_data = 10'b0001111100;//   *****  
		 4'h1: ghost_data = 10'b0111111110;// ******** 
		 4'h2: ghost_data = 10'b1111111111;//**********
		 4'h3: ghost_data = 10'b1111111111;//**********
		 4'h4: ghost_data = 10'b1100110011;//**  **  **
		 4'h5: ghost_data = 10'b1100110011;//**  **  **
		 4'h6: ghost_data = 10'b1111111111;//**********
		 4'h7: ghost_data = 10'b1111111111;//**********
		 4'h8: ghost_data = 10'b1011001101;//* **  ** *
		 4'h9: ghost_data = 10'b1001000101;//*  *   * *
	 endcase
	 //Ghost2 Image
	 wire sq_ghost2_on,rd_ghost2_on;
	 wire [11:0] ghost2_rgb;
	 wire [3:0] ghost2_addr, ghost2_col;
	 wire ghost2_bit;
	 //enable the sq_ghost
	 assign sq_ghost2_on = (ghost2_x_l<=p_x)&&(p_x<=ghost2_x_r)&&(ghost2_y_t<=p_y)&&(p_y<=ghost2_y_b);
	 //the location of the ghost;
	 assign ghost2_addr = p_y-ghost2_y_t;
	 assign ghost2_col = p_x-ghost2_x_l;
	 assign ghost2_bit=ghost2_data[ghost2_col];
	 assign rd_ghost2_on = sq_ghost2_on & ghost2_bit;
	 assign ghost2_rgb = 12'b1111_1111_0000;

	 reg [9:0] ghost2_data;
	 //ROM used to store the image of the ghost;
	 always @*
	 case (ghost2_addr)
	    4'h0: ghost2_data = 10'b0001111100;
		 4'h1: ghost2_data = 10'b0111111110;
		 4'h2: ghost2_data = 10'b1111111111;
		 4'h3: ghost2_data = 10'b1111111111;
		 4'h4: ghost2_data = 10'b1100110011;
		 4'h5: ghost2_data = 10'b1100110011;
		 4'h6: ghost2_data = 10'b1111111111;
		 4'h7: ghost2_data = 10'b1111111111;
		 4'h8: ghost2_data = 10'b1011001101;
		 4'h9: ghost2_data = 10'b1001000101;
	 endcase
	 
	 //Ghost3 Image
	 wire sq_ghost3_on,rd_ghost3_on;
	 wire [11:0] ghost3_rgb;
	 wire [3:0] ghost3_addr, ghost3_col;
	 wire ghost3_bit;
	 //enable the sq_ghost
	 assign sq_ghost3_on = (ghost3_x_l<=p_x)&&(p_x<=ghost3_x_r)&&(ghost3_y_t<=p_y)&&(p_y<=ghost3_y_b);
	 //the location of the ghost;
	 assign ghost3_addr = p_y-ghost3_y_t;
	 assign ghost3_col = p_x-ghost3_x_l;
	 assign ghost3_bit=ghost3_data[ghost3_col];
	 assign rd_ghost3_on = sq_ghost3_on & ghost3_bit;
	 assign ghost3_rgb = 12'b1100_1100_1100;

	 reg [9:0] ghost3_data;
	  //ROM used to store the image of the ghost;
	 always @*
	 case (ghost3_addr)
	    4'h0: ghost3_data = 10'b0001111100;
		 4'h1: ghost3_data = 10'b0111111110;
		 4'h2: ghost3_data = 10'b1111111111;
		 4'h3: ghost3_data = 10'b1111111111;
		 4'h4: ghost3_data = 10'b1100110011;
		 4'h5: ghost3_data = 10'b1100110011;
		 4'h6: ghost3_data = 10'b1111111111;
		 4'h7: ghost3_data = 10'b1111111111;
		 4'h8: ghost3_data = 10'b1011001101;
		 4'h9: ghost3_data = 10'b1001000101;
	 endcase
	 
	 //Ghost4 Image
	 wire sq_ghost4_on,rd_ghost4_on;
	 wire [11:0] ghost4_rgb;
	 wire [3:0] ghost4_addr, ghost4_col;
	 wire ghost4_bit;
	 //enable the sq_ghost
	 assign sq_ghost4_on = (ghost4_x_l<=p_x)&&(p_x<=ghost4_x_r)&&(ghost4_y_t<=p_y)&&(p_y<=ghost4_y_b);
	  //the location of the ghost;
	 assign ghost4_addr = p_y-ghost4_y_t;
	 assign ghost4_col = p_x-ghost4_x_l;
	 assign ghost4_bit=ghost4_data[ghost4_col];
	 assign rd_ghost4_on = sq_ghost4_on & ghost4_bit;
	 assign ghost4_rgb = 12'b0000_0000_1111;

	 reg [9:0] ghost4_data;
	 //ROM used to store the image of the ghost;
	 always @*
	 case (ghost4_addr)
	    4'h0: ghost4_data = 10'b0001111100;
		 4'h1: ghost4_data = 10'b0111111110;
		 4'h2: ghost4_data = 10'b1111111111;
		 4'h3: ghost4_data = 10'b1111111111;
		 4'h4: ghost4_data = 10'b1100110011;
		 4'h5: ghost4_data = 10'b1100110011;
		 4'h6: ghost4_data = 10'b1111111111;
		 4'h7: ghost4_data = 10'b1111111111;
		 4'h8: ghost4_data = 10'b1011001101;
		 4'h9: ghost4_data = 10'b1001000101;
	 endcase
	
	reg [16:0] Score = 0;
	assign score = Score;
	wire [11:0] pacman_death_rgb;
	wire [11:0] game_win_rgb;
	wire [11:0] pacman_loading_rgb;
	reg gameloading = 1;
	reg gamewin = 0;
	reg gameover = 0;
	reg temp;
	//ip-core with loading the game
	pacman_loading ip2(.clka(p_tick), .ena(1), .addra(400*(280-p_y)+p_x), .douta(pacman_loading_rgb));
	//ip-core with winning the game
	game_win ip3(.clka(p_tick), .ena(gamewin), .addra(400*(280-p_y)+p_x), .douta(game_win_rgb));
	//ip-core with pacman death
	pacman_death_400_280 ip4(.clka(p_tick), .addra(400*(280-p_y)+p_x), .douta(pacman_death_rgb));
	
	wire boundary_in;
	assign boundary_in = 0<=p_x&&p_x<=400&&0<=p_y&&p_y<=280;
	
	//judge the direction of pacman
	always @*
	begin
		if ((ps2_byte==8'h48)||(ps2_byte==8'h4B)||(ps2_byte==8'h50)||(ps2_byte==8'h4D)) direc = ps2_byte;
		else direc = direc;
		case (direc)
			8'h48: 
					rd_pacman_on = rd_pacman_up_on;
			8'h4B:
					rd_pacman_on = rd_pacman_left_on;
			8'h50:
					rd_pacman_on = rd_pacman_down_on;
			8'h4D:
					rd_pacman_on = rd_pacman_right_on;
			default:
					rd_pacman_on = rd_pacman_on;
		endcase
		//score number
		Score = eaten[0]+eaten[1]+eaten[2]+eaten[3]+eaten[4]+eaten[5]+eaten[6]+eaten[7]+eaten[8]+eaten[9]+eaten[10]+eaten[11]+eaten[12]+eaten[13]+eaten[14]+eaten[15];
		
		if (!eaten[16]&&pacman_l==fake_bean_l&&pacman_b==fake_bean_b) eaten[16] = 1; //fake bean used to cope with undefined bug
		else if (!eaten[0]&&pacman_l==bean1_l&&pacman_b==bean1_b) eaten[0] = 1;
		else if (!eaten[1]&&pacman_l==bean2_l&&pacman_b==bean2_b) eaten[1] = 1;
		else if (!eaten[2]&&pacman_l==bean3_l&&pacman_b==bean3_b) eaten[2] = 1;
		else if (!eaten[3]&&pacman_l==bean4_l&&pacman_b==bean4_b) eaten[3] = 1;
		else if (!eaten[4]&&pacman_l==bean5_l&&pacman_b==bean5_b) eaten[4] = 1;
		else if (!eaten[5]&&pacman_l==bean6_l&&pacman_b==bean6_b) eaten[5] = 1;
		else if (!eaten[6]&&pacman_l==bean7_l&&pacman_b==bean7_b) eaten[6] = 1;
		else if (!eaten[7]&&pacman_l==bean8_l&&pacman_b==bean8_b) eaten[7] = 1;
		else if (!eaten[8]&&pacman_l==bean9_l&&pacman_b==bean9_b) eaten[8] = 1;
      else if (!eaten[9]&&pacman_l==bean10_l&&pacman_b==bean10_b) eaten[9] = 1;
		else if (!eaten[10]&&pacman_l==bean11_l&&pacman_b==bean11_b) eaten[10] = 1;
		else if (!eaten[11]&&pacman_l==bean12_l&&pacman_b==bean12_b) eaten[11] = 1;
		else if (!eaten[12]&&pacman_l==bean13_l&&pacman_b==bean13_b) eaten[12] = 1;
		else if (!eaten[13]&&pacman_l==bean14_l&&pacman_b==bean14_b) eaten[13] = 1;
		else if (!eaten[14]&&pacman_l==bean15_l&&pacman_b==bean15_b) eaten[14] = 1;
      else if (!eaten[15]&&pacman_l==bean16_l&&pacman_b==bean16_b) eaten[15] = 1;
		
		//Win the game
		if (Score==16) gamewin = 1;
      //Reset the game
		if (rst==1) gameloading = 1;
		else if (sw==1) gameloading = 0;
      //Game over  
		if ((pacman_l==ghost_x_l&&pacman_t==ghost_y_b)||(pacman_l==ghost2_x_l&&pacman_t==ghost2_y_b)||(pacman_l==ghost3_x_l&&pacman_t==ghost3_y_b)||(pacman_l==ghost4_x_l&&pacman_t==ghost4_y_b))
			gameover = 1;
      
		//All rgb display
		if (gameloading&&boundary_in)
			RGB = pacman_loading_rgb;
		else if (gamewin&&boundary_in)
			RGB = game_win_rgb;
		else if (gameover&&boundary_in)
			RGB = pacman_death_rgb;
		else if (rd_pacman_on)
			RGB = pacman_rgb;
		else if (wall_on) 
			RGB = wall_rgb;
		else if (rd_ghost_on)
		   RGB = ghost_rgb;
		else if (rd_ghost2_on)
		   RGB = ghost2_rgb;
		else if (rd_ghost3_on)
		   RGB = ghost3_rgb;
		else if (rd_ghost4_on)
		   RGB = ghost4_rgb;
      else if (rd_bean_on)
           RGB = bean_rgb;
      else
		   RGB = 12'b0000_0000_0000;
		
		// reset operations
      if (rst) begin
         gamewin = 0;
         gameover = 0;
         eaten = 16'b0;
			direc = 8'h4B;
      end
	end
    
endmodule
