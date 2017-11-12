`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:32:57 01/02/2017 
// Design Name: 
// Module Name:    ghost2_control 
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
module ghost2_control(
      input wire clk,
      input wire sw,
      input rst,
		output wire[9:0] GhostPosition_x,//The left border of the ghost;
		output wire[9:0] GhostPosition_y,//The top border of the ghost;
		output wire[9:0] ghost_r,//The right border of the ghost;
		output wire[9:0] ghost_b,//The bottom border of the ghost;
		input wire[9:0] PacManPosition_x,//Input the location of Pacman;
		input wire[9:0] PacManPosition_y	//Input the location of Pacman;					
    );
reg [9:0] ghost_x, ghost_y;
reg [9:0] ghost_x_reg, ghost_y_reg;

wire [3:0] validDirection;//The direction that the ghost can go when it comes to a point on the map;
reg [3:0] BlinkyDirection;//The direction that the ghost decide to go when it comes to a point on the map;
initial BlinkyDirection=4'b0010;//Initial the BlinkyDirection;
//Translate the coordinate of ghost into pixel;
assign GhostPosition_x = 10*ghost_x-10;
assign ghost_r = 10*ghost_x;
assign GhostPosition_y = 10*ghost_y-10;
assign ghost_b = 10*ghost_y;

ghost_detect m5(
         .block_x_reg(ghost_x_reg), 
         .block_y_reg(ghost_y_reg),
			.valid(validDirection)
			);


always@ * begin
		
		case(validDirection)
			4'b0000: BlinkyDirection <= 4'b0000;	
			4'b0001: BlinkyDirection <= 4'b0001;
			4'b0010: BlinkyDirection <= 4'b0010;
			4'b0011: begin // can go Left or Right
							
							// if PacMan directly above go Left
							if(((ghost_x_reg == PacManPosition_x)) && ((ghost_y_reg > PacManPosition_y)))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly below go Right
							else if(((ghost_x_reg == PacManPosition_x)) && ((PacManPosition_y > ghost_y_reg)))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Right go Right
							else if(PacManPosition_x > ghost_x_reg)
								BlinkyDirection <= 4'b0010;
								
							// if PacMan to the Left go Left
							else if(ghost_x_reg > PacManPosition_x)
								BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
															
						end
			4'b0100: BlinkyDirection <= 4'b0100;
			4'b0101: begin // can go Up or Left
			
							// if PacMan directly above go Up
							if((ghost_x_reg == PacManPosition_x)  && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
							
							// if PacMan directly to the Left go Left
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly to the Right go Up
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0100;
								
							// if PacMan directly below go Left
							else if((ghost_x_reg == PacManPosition_x)  && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Left and Up and Up is closer go Up
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_y_reg - PacManPosition_y) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Left and Up and Left is closer go Left
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (ghost_y_reg - PacManPosition_y)))
							
									BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Down and Right is closer go Go Up
							else if((PacManPosition_y > ghost_y_reg) &&
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (PacManPosition_y - ghost_y_reg)))
								
									BlinkyDirection <= 4'b0100;
									
							// if PacMan Up and to the Right go Up
							else if((ghost_y_reg > PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0100;
							
							//if PacMan Down and to the Left go Left
							else if((PacManPosition_y > ghost_y_reg) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
	
															
							// if PacMan to the Right and Down and Down is closer go Go Left
							else if((PacManPosition_y > ghost_y_reg) &&
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_y - ghost_y_reg) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
				
						end
			4'b0110: begin // can go Up or Right
							
							// if PacMan directly above go Up
							if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
								
							// if PacMan directly to the Right go Right
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Up
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0100;
								
							// if PacMan directly below go Right
							else if((ghost_x_reg == PacManPosition_x)  && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Right and Up and Up is closer go Up
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((ghost_y_reg - PacManPosition_y) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Right and Up and Right is closer go Right
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (ghost_y_reg - PacManPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Left is closer go Up
							else if((PacManPosition_y > ghost_y_reg) &&
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (PacManPosition_y - ghost_y_reg)))
								
									BlinkyDirection <= 4'b0100;
									
							// if PacMan Up and to the Left go Up
							else if((ghost_y_reg > PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0100;
							
							//if PacMan Down and to the Right go Right
							else if((PacManPosition_y > ghost_y_reg) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Right
							else if((PacManPosition_y > ghost_y_reg) &&
								(ghost_x_reg > PacManPosition_x) && 
								((PacManPosition_y - ghost_y_reg) < (ghost_x_reg - PacManPosition_x)))
									
									BlinkyDirection <= 4'b0010;
									
							else
								BlinkyDirection <= BlinkyDirection;
						
						
						end
			4'b0111: begin // can go Left, Right, or Up
			
							// if PacMan directly above go Up
							if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
							
							// if PacMan directly to the Right go Right
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Left
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly below go Right
							else if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan below and to the Right go Right
							else if((PacManPosition_y > ghost_y_reg) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan below and to the Left go Left
							else if((PacManPosition_y > ghost_y_reg) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
														
							// if PacMan above and to the Right and Right is closer go Right
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (ghost_y_reg - PacManPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan above and to the Right and Up is closer go Up
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((ghost_y_reg - PacManPosition_y) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan above and to the Left and Left is closer go Left
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (ghost_y_reg - PacManPosition_y)))
									
									BlinkyDirection <= 4'b0001;
							
							// if PacMan above and to the Left and Up is closer go Up
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_y_reg - PacManPosition_y) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
								
							else
								BlinkyDirection <= BlinkyDirection;
															
						end
			4'b1000: BlinkyDirection <= 4'b1000;
			4'b1001: begin // can go Down or Left
							
							// if PacMan directly below go Down
							if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b1000;

							// if PacMan directly to the Left go Left
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan directly to the Right go Down
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan directly above go Left
							else if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((PacManPosition_y - ghost_y_reg) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (PacManPosition_y - ghost_y_reg)))
								
									BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Up and Right is closer go Down
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (ghost_y_reg - PacManPosition_y)))
									
									BlinkyDirection <= 4'b1000;
									
							// if PacMan Down and to the Right go Down
							else if((PacManPosition_y > ghost_y_reg) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan Up and to the Left go Left
							else if((ghost_y_reg > PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Up and Up is closer go Left
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((ghost_y_reg - PacManPosition_y) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
							
						end
			4'b1010: begin // can go Down or Right
			
							// if PacMan directly below go Down
							if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b1000;
								
							// if PacMan directly to the Right go Right
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
								
							// if PacMan directly above go Right
							else if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Down
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_y - ghost_y_reg) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (PacManPosition_y - ghost_y_reg)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Up and Left is closer go Down
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (ghost_y_reg - PacManPosition_y)))
									
									BlinkyDirection <= 4'b1000;
							
							// if PacMan Down and to the Left go Down
							else if((PacManPosition_y > ghost_y_reg) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if Pacman up and to the Right go Right
							else if((ghost_y_reg > PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Up and Up is closer go Right
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_y_reg - PacManPosition_y) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0010;
							
							else
								BlinkyDirection <= BlinkyDirection;
						
						end
			4'b1011: begin // can go Left, Right, or Down

						// if PacMan directly below go Down
							if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan directly to the Right go Right
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Left
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly above go Right
							else if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0010;
															
							// if PacMan above and to the Right go Right
							else if((ghost_y_reg > PacManPosition_y)  && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan above and to the Left go Left
							else if((ghost_y_reg > PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_y - ghost_y_reg) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (PacManPosition_y - ghost_y_reg)))
									
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((PacManPosition_y - ghost_y_reg) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg - PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (PacManPosition_y - ghost_y_reg)))
									
									BlinkyDirection <= 4'b0001;
					
							else
								BlinkyDirection <= BlinkyDirection;
								
						end
			4'b1100: begin // can go Down or Up
			
							// if PacMan directly to the Right go Up
							if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0100;
							
							// if PacMan directly to the Left go Down
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan below go Down
							else if(PacManPosition_y > ghost_y_reg)
								BlinkyDirection <= 4'b1000;
								
							// if PacMan above go Up
							else if(ghost_y_reg > PacManPosition_y)
								BlinkyDirection <= 4'b0100;
							
							else
								BlinkyDirection <= BlinkyDirection;
								
						end
			4'b1101: begin // can go Left, Down, or Up

						// if PacMan directly below go Down
						if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
							BlinkyDirection <= 4'b1000;
						
						// if PacMan directly above go Up
						else if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
							BlinkyDirection <= 4'b0100;
							
						// if PacMan directly to the Left go Left
						else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
						
						// if PacMan directly to the Right go Down
						else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b1000;
													
						// if PacMan above and to the Right go Up
						else if((ghost_y_reg > PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0100;
						
						// if PacMan below and to the Right go Down
						else if((PacManPosition_y > ghost_y_reg) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b1000;
						
						// if PacMan to the Left and Down and Down is closer go Down
						else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((PacManPosition_y - ghost_y_reg) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
						// if PacMan to the Left and Down and Left is closer go Left
						else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (PacManPosition_y - ghost_y_reg)))
									
									BlinkyDirection <= 4'b0001;
						
						// if PacMan to the Left and Up and Up is closer go Up
						else if((ghost_y_reg > PacManPosition_y) && 
							(ghost_x_reg > PacManPosition_x) && 
							((ghost_y_reg - PacManPosition_y) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
						// if PacMan to the Left and Up and Left is closer go Left
						else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (ghost_y_reg - PacManPosition_y)))
										
									BlinkyDirection <= 4'b0001;
									
						else
								BlinkyDirection <= BlinkyDirection;
												
						end
			4'b1110: begin // can go Right, Down, or Up

						// if PacMan directly below go Down
						if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
							BlinkyDirection <= 4'b1000;
						
						// if PacMan directly above go Up
						else if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
							BlinkyDirection <= 4'b0100;
							
						// if PacMan directly to the Right go Right
						else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
						
						// if PacMan directly to the Left go Down
						else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
													
						// if PacMan above and to the Left go Up
						else if((ghost_y_reg > PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0100;
						
						// if PacMan below and to the Left go Down
						else if((PacManPosition_y - ghost_y_reg) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
						
						// if PacMan to the Right and Down and Down is closer go Down
						else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_y - ghost_y_reg) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b1000;
							
						// if PacMan to the Right and Down and Right is closer go Right
						else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (PacManPosition_y - ghost_y_reg)))
									
									BlinkyDirection <= 4'b0010;
						
						// if PacMan to the Right and Up and Up is closer go Up
						else if((ghost_y_reg > PacManPosition_y) && 
							(PacManPosition_x > ghost_x_reg) && 
							((ghost_y_reg - PacManPosition_y) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b0100;
							
						// if PacMan to the Right and Up and Right is closer go Right
						else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (ghost_y_reg - PacManPosition_y)))
										
									BlinkyDirection <= 4'b0010;
									
						else
								BlinkyDirection <= BlinkyDirection;
							
						end
			4'b1111: begin // can go Right, Left, Down, or Up
							
							// if PacMan directly below go Down
							if((ghost_x_reg == PacManPosition_x) && (PacManPosition_y > ghost_y_reg))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan directly above go Up
							else if((ghost_x_reg == PacManPosition_x) && (ghost_y_reg > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
						
							// if PacMan directly to the Right go Right
							else if((ghost_y_reg == PacManPosition_y) && (PacManPosition_x > ghost_x_reg))
								BlinkyDirection <= 4'b0010;
								
							// if PacMan directly to the Left go Left
							else if((ghost_y_reg == PacManPosition_y) && (ghost_x_reg > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan to the Left and Up and Up is closer go Up
							else if((ghost_y_reg > PacManPosition_y) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_y_reg - PacManPosition_y) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Left and Up and Left is closer go Left
							else if((ghost_y_reg > PacManPosition_y) && 
									(ghost_x_reg > PacManPosition_x) && 
									((ghost_x_reg - PacManPosition_x) < (ghost_y_reg - PacManPosition_y)))
										
									BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Up and Up is closer go Up
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((ghost_y_reg - PacManPosition_y) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Right and Up and Right is closer go Right
							else if((ghost_y_reg > PacManPosition_y) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (ghost_y_reg - PacManPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_y - ghost_y_reg) < (PacManPosition_x - ghost_x_reg)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((PacManPosition_y > ghost_y_reg) && 
								(PacManPosition_x > ghost_x_reg) && 
								((PacManPosition_x - ghost_x_reg) < (PacManPosition_y - ghost_y_reg)))
									
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((PacManPosition_y - ghost_y_reg) < (ghost_x_reg - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((PacManPosition_y > ghost_y_reg) && 
								(ghost_x_reg > PacManPosition_x) && 
								((ghost_x_reg - PacManPosition_x) < (PacManPosition_y - ghost_y_reg)))
									
									BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;

							
						end

		endcase
	end
	wire [3:0] valid;
	assign valid=BlinkyDirection;
	always @(posedge clk)
    begin
        case (BlinkyDirection)
            4'b0100: 
                begin
                    //block_y = block_y - 1;
                    ghost_x_reg = ghost_x;
                   ghost_y_reg = ghost_y - valid[2];
                end
            4'b0001:
                begin
                    //block_x = block_x - 1;
                    ghost_x_reg = ghost_x - valid[0];
                    ghost_y_reg = ghost_y;
                end
            4'b1000:
                begin
                    //block_y = block_y + 1;
                    ghost_x_reg = ghost_x;
                    ghost_y_reg = ghost_y + valid[3];
                end
            4'b0010:
                begin
                    //block_x = block_x + 1;
                    ghost_x_reg = ghost_x + valid[1];
                    ghost_y_reg = ghost_y;
                end
            default:
                begin
                    ghost_x_reg = ghost_x;
                    ghost_y_reg = ghost_y;
                end
        endcase
        if (rst)
        begin
            ghost_x = 39;
            ghost_y = 2;
            ghost_x_reg =39;
            ghost_y_reg = 2;
        end
        else
        begin
            ghost_x = ghost_x_reg;
            ghost_y = ghost_y_reg;
        end
    end
	
endmodule
