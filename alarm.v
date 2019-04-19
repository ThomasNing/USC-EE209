`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:19 08/27/2016 
// Design Name: 
// Module Name:    alarm_top 
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
module alarm(
    input N,
    input X,
    input W,
    input D,
    input G,
    output A
	 
    );

	// Complete the design of the home alarm system
assign n1= W&D;
assign n2= X|n1;
assign n3=~(n2&G);
assign A=n3&N;

	

endmodule
