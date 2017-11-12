`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:58 01/01/2017 
// Design Name: 
// Module Name:    walk_detect 
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
module ghost_detect(
	input wire [9:0] block_x_reg,//input the location of the ghost;
	input wire [9:0] block_y_reg,
	output reg [3:0] valid
    );
//We divide the whole map into 40*28 small blocks;
//The ghost can only move up,left,right or down by one block;
//When the ghost walk past a certain block,the following codes will analyse its cordinate and judge which direciton it can go;	 
 always @*
begin
		  if(block_x_reg==2&&block_y_reg==2)//if the ghost is at (2,2)
	 valid <= 4'b1010;//it can go down or right;
	 else if(41-block_x_reg==2&&block_y_reg==2)//if the ghost is at (39,2)
	 valid <= 4'b1001;//it can go down or left;
	//the following is same
	 else if((block_y_reg==2&&3<=block_x_reg&&block_x_reg<=9)||(block_y_reg==2&&3<=41-block_x_reg&&41-block_x_reg<=9))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==10&&block_y_reg==2)||(41-block_x_reg==10&&block_y_reg==2))
	 valid <= 4'b1011;
	 
	 else if((block_y_reg==2&&11<=block_x_reg&&block_x_reg<=18)||(block_y_reg==2&&11<=41-block_x_reg&&41-block_x_reg<=18))
	 valid <= 4'b0011;
	 
	 else if(block_y_reg==2&&block_x_reg==19)
	 valid <= 4'b1001;
	 else if(block_y_reg==2&&41-block_x_reg==19)
	 valid <= 4'b1010;
	 
	 else if((block_x_reg==2&&3<=block_y_reg&&block_y_reg<=5)||(41-block_x_reg==2&&3<=block_y_reg&&block_y_reg<=5))
	 valid <= 4'b1100;
	 
	 else if((block_x_reg==10&&3<=block_y_reg&&block_y_reg<=5)||(41-block_x_reg==10&&3<=block_y_reg&&block_y_reg<=5))
	 valid <= 4'b1100;
	 
	 else if((block_x_reg==19&&3<=block_y_reg&&block_y_reg<=5)||(41-block_x_reg==19&&3<=block_y_reg&&block_y_reg<=5))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==2&&block_y_reg==6)
	 valid <= 4'b1110;
	 else if(block_y_reg==6&&41-block_x_reg==2)
	 valid <= 4'b1101;
	 
	 else if((3<=block_x_reg&&block_x_reg<=9&&block_y_reg==6)||(3<=41-block_x_reg&&41-block_x_reg<=9&&block_y_reg==6))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==10&&block_y_reg==6)||(41-block_x_reg==10&&block_y_reg==6))
	 valid <= 4'b1111;
	 
	 else if((11<=block_x_reg&&block_x_reg<=12&&block_y_reg==6)||(11<=41-block_x_reg&&41-block_x_reg<=12&&block_y_reg==6))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==13&&block_y_reg==6)||(41-block_x_reg==13&&block_y_reg==6))
	 valid <= 4'b1011;
	 
	 else if((14<=block_x_reg&&block_x_reg<=18&&block_y_reg==6)||(14<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==6))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==19&&block_y_reg==6)||(41-block_x_reg==19&&block_y_reg==6))
	 valid <= 4'b0111;
	 
	 else if((block_x_reg==20&&block_y_reg==6)||(41-block_x_reg==20&&block_y_reg==6))
	 valid <= 4'b0011;
	 
    else if((block_x_reg==2&&block_y_reg==7)||(41-block_x_reg==2&&block_y_reg==7))
	 valid <= 4'b1100;
	 

	 
	    else if((block_x_reg==10&&block_y_reg==7)||(41-block_x_reg==10&&block_y_reg==7))
	 valid <= 4'b1100;
	 

	 
	 else if((block_x_reg==13&&7<=block_y_reg&&block_y_reg<=8)||(41-block_x_reg==13&&7<=block_y_reg&&block_y_reg<=8))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==2&&block_y_reg==8)
	 valid <= 4'b0110;
	 else if(41-block_x_reg==2&&block_y_reg==8)
	 valid <= 4'b0101;
	 
	 else if((3<=block_x_reg&&block_x_reg<=9&&block_y_reg==8)||(3<=41-block_x_reg&&41-block_x_reg<=9&&block_y_reg==8))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==10&&block_y_reg==8)
	 valid <= 4'b1101;
	 else if(41-block_x_reg==10&&block_y_reg==8)
	 valid <= 4'b1110;
	 
	 else if((block_x_reg==10&&9<=block_y_reg&&block_y_reg<=12)||(41-block_x_reg==10&&9<=block_y_reg&&block_y_reg<=12))
	 valid <= 4'b1100;
	 
	 else if (block_x_reg==10&&block_y_reg==13)
	 valid <= 4'b1110;
	 else if (41-block_x_reg==10&&block_y_reg==13)
	 valid <= 4'b1101;
	 
	 else if((block_x_reg==10&&14<=block_y_reg&&block_y_reg<=17)||(41-block_x_reg==10&&14<=block_y_reg&&block_y_reg<=17))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==13&&block_y_reg==9)
	 valid <= 4'b0110;
	 else if(41-block_x_reg==13&&block_y_reg==9)
	 valid <= 4'b0101;
	 
	 else if((14<=block_x_reg&&block_x_reg<=18&&block_y_reg==9)||(14<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==9))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==19&&block_y_reg==9)
	 valid <= 4'b1001;
	 else if(41-block_x_reg==19&&block_y_reg==9)
	 valid <= 4'b1010;
	 
	 else if((block_x_reg==19&&block_y_reg==10)||(41-block_x_reg==19&&block_y_reg==10))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==13&&block_y_reg==11)
	 valid <= 4'b1010;
	 else if(41-block_x_reg==13&&block_y_reg==11)
	 valid <= 4'b1001;
	 
	 else if((14<=block_x_reg&&block_x_reg<=18&&block_y_reg==11)||(14<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==11))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==19&&block_y_reg==11)||(41-block_x_reg==19&&block_y_reg==11))
	 valid <= 4'b0111;
	 
	 else if((block_x_reg==20&&block_y_reg==11)||(41-block_x_reg==20&&block_y_reg==11))
	 valid <= 4'b1011;
	 
	 else if((block_x_reg==13&&block_y_reg==12)||(41-block_x_reg==13&&block_y_reg==12))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==20&&block_y_reg==12)
	 valid <= 4'b1110;
	 else if(41-block_x_reg==20&&block_y_reg==12)
	 valid <= 4'b1101;
	 
	 else if((11<=block_x_reg&&block_x_reg<=12&&block_y_reg==13)||(11<=41-block_x_reg&&41-block_x_reg<=12&&block_y_reg==13))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==13&&block_y_reg==13)
	 valid <= 4'b1101;
	 else if(41-block_x_reg==13&&block_y_reg==13)
	 valid <= 4'b1110;
	 
	 else if(block_x_reg==15&&block_y_reg==13)
	 valid <= 4'b1010;
	 else if(41-block_x_reg==15&&block_y_reg==13)
	 valid <= 4'b1001;
	 
	 else if((16<=block_x_reg&&block_x_reg<=19&&block_y_reg==13)||(16<=41-block_x_reg&&41-block_x_reg<=19&&block_y_reg==13))
	 valid <= 4'b1011;
	 
	 else if((block_x_reg==20&&block_y_reg==13)||(41-block_x_reg==20&&block_y_reg==13))
	 valid <= 4'b1111;
	 
	 else if((block_x_reg==13&&14<=block_y_reg&&block_y_reg<=15)||(41-block_x_reg==13&&14<=block_y_reg&&block_y_reg<=15))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==13&&block_y_reg==16)
	 valid<=4'b1110;
	 else if(41-block_x_reg==13&&block_y_reg==16)
	 valid<=4'b1101;

	 else if(block_x_reg==13&&block_y_reg==17)
	 valid<=4'b1100;
	 else if(41-block_x_reg==13&&block_y_reg==17)
	 valid<=4'b1100;
	 
	 else if(block_x_reg==15&&block_y_reg==14)
	 valid <= 4'b0110;
	 else if(41-block_x_reg==15&&block_y_reg==14)
	 valid <= 4'b0101;
	 
	 else if((16<=block_x_reg&&block_x_reg<=19&&block_y_reg==14)||(16<=41-block_x_reg&&41-block_x_reg<=19&&block_y_reg==14))
	 valid <= 4'b0111;
	 
	 else if((block_x_reg==20&&block_y_reg==14)||(41-block_x_reg==20&&block_y_reg==14))
	 valid <= 4'b0111;
	 
	 else if((14<=block_x_reg&&block_x_reg<=20&&block_y_reg==16)||(14<=41-block_x_reg&&41-block_x_reg<=20&&block_y_reg==16))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==2&&block_y_reg==18)
	 valid <= 4'b1010;
	 else if(41-block_x_reg==2&&block_y_reg==18)
	 valid <= 4'b1001;
	 
	 else if((3<=block_x_reg&&block_x_reg<=9&&block_y_reg==18)||(3<=41-block_x_reg&&41-block_x_reg<=9&&block_y_reg==18))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==10&&block_y_reg==18)||(41-block_x_reg==10&&block_y_reg==18))
	 valid <= 4'b1111;
	 
	 else if((11<=block_x_reg&&block_x_reg<=12&&block_y_reg==18)||(11<=41-block_x_reg&&41-block_x_reg<=12&&block_y_reg==18))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==13&&block_y_reg==18)||(41-block_x_reg==13&&block_y_reg==18))
	 valid <= 4'b0111;
	 
	 else if((14<=block_x_reg&&block_x_reg<=18&&block_y_reg==18)||(14<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==18))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==19&&block_y_reg==18)
	 valid <= 4'b1001;
	 else if(41-block_x_reg==19&&block_y_reg==18)
	 valid <= 4'b1010;
	 
	 else if((block_x_reg==2&&19<=block_y_reg&&block_y_reg<=23)||(41-block_x_reg==2&&19<=block_y_reg&&block_y_reg<=23))
	 valid <= 4'b1100;
	 
	 else if((block_x_reg==10&&19<=block_y_reg&&block_y_reg<=20)||(41-block_x_reg==10&&19<=block_y_reg&&block_y_reg<=20))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==10&&block_y_reg==21)
	 valid <= 4'b1110;
	  else if(41-block_x_reg==10&&block_y_reg==21)
	 valid <= 4'b1101;
	 
	 else if((block_x_reg==10&&22<=block_y_reg&&block_y_reg<=23)||(41-block_x_reg==10&&22<=block_y_reg&&block_y_reg<=23))
	 valid <= 4'b1100;
	 
	 else if((block_x_reg==19&&19<=block_y_reg&&block_y_reg<=20)||(41-block_x_reg==19&&19<=block_y_reg&&block_y_reg<=20))
	 valid <= 4'b1100;
	 
	 else if((11<=block_x_reg&&block_x_reg<=12&&block_y_reg==21)||(11<=41-block_x_reg&&41-block_x_reg<=12&&block_y_reg==21))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==13&&block_y_reg==21)||(41-block_x_reg==13&&block_y_reg==21))
	 valid <= 4'b1011;
	 
	 else if((14<=block_x_reg&&block_x_reg<=18&&block_y_reg==21)||(14<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==21))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==19&&block_y_reg==21)||(41-block_x_reg==19&&block_y_reg==21))
	 valid <= 4'b0111;
	 
	 else if((block_x_reg==20&&block_y_reg==21)||(41-block_x_reg==20&&block_y_reg==21))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==13&&22<=block_y_reg&&block_y_reg<=23)||(41-block_x_reg==13&&22<=block_y_reg&&block_y_reg<=23))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==2&&block_y_reg==24)
	 valid <= 4'b1110;
	 else if(41-block_x_reg==2&&block_y_reg==24)
	 valid <= 4'b1101;
	 
	 else if((3<=block_x_reg&&block_x_reg<=9&&block_y_reg==24)||(3<=41-block_x_reg&&41-block_x_reg<=9&&block_y_reg==24))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==10&&block_y_reg==24)
	 valid <= 4'b0101;
	 else if(41-block_x_reg==10&&block_y_reg==24)
	 valid <= 4'b0110;
	 
	 else if(block_x_reg==13&&block_y_reg==24)
	 valid <= 4'b0110;
	 else if(41-block_x_reg==13&&block_y_reg==24)
	 valid <= 4'b0101;
	 
	 else if((14<=block_x_reg&&block_x_reg<=18&&block_y_reg==24)||(14<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==24))
	 valid <= 4'b0011;
	 
	 else if(block_x_reg==19&&block_y_reg==24)
	 valid <= 4'b1001;
	 else if(41-block_x_reg==19&&block_y_reg==24)
	 valid <= 4'b1010;
	 
	 else if((block_x_reg==2&&25<=block_y_reg&&block_y_reg<=26)||(41-block_x_reg==2&&25<=block_y_reg&&block_y_reg<=26))
	 valid <= 4'b1100;
	 
	 else if((block_x_reg==19&&25<=block_y_reg&&block_y_reg<=26)||(41-block_x_reg==19&&25<=block_y_reg&&block_y_reg<=26))
	 valid <= 4'b1100;
	 
	 else if(block_x_reg==2&&block_y_reg==27)
	 valid <= 4'b0110;
	 else if(41-block_x_reg==2&&block_y_reg==27)
	 valid <= 4'b0101;
	 
	 else if((3<=block_x_reg&&block_x_reg<=18&&block_y_reg==27)||(3<=41-block_x_reg&&41-block_x_reg<=18&&block_y_reg==27))
	 valid <= 4'b0011;
	 
	 else if((block_x_reg==19&&block_y_reg==27)||(41-block_x_reg==19&&block_y_reg==27))
	 valid <= 4'b0111;
	 
	 else if((block_x_reg==20&&block_y_reg==27)||(41-block_x_reg==20&&block_y_reg==27))
		valid <= 4'b0011;
end

endmodule
