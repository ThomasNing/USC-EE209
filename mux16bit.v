`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:37:57 11/09/2017 
// Design Name: 
// Module Name:    mux16bit 
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
module mux16bit(
   input [15:0]I0,
	input [15:0]I1,
	input S,
	output reg [15:0] Y
    );

always @*
  begin
   if(S==1) 
	Y=I1;
	else
	Y=I0;
	end
	  

endmodule
