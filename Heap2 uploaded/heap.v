`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:03:49 04/03/2017 
// Design Name: 
// Module Name:    heap 
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
module heap(
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] din,
    output [7:0] dout,
	 output [7:0] size,
    output done,
	 output valid
    );

	wire [7:0] maddr;
	wire [7:0] mdin;
	wire [7:0] mdout;
   wire       mren;
	wire       mwen;
	
	wire [7:0] pushmaddr, popmaddr;
	wire [7:0] pushmdin, popmdin;
	wire [1:0] opsel;
	wire       pushdone, popdone;
	wire       sizeinc, sizedec;
	wire       pushstart, popstart;
   reg        done_int;
	reg        pushworking, popworking;
	wire       top;
	
// size counter
 cntr8 size_cntr( .clk(clk), .reset(reset), .inc(sizeinc), .dec(sizedec), .q(size));

// memory 
 mem256x8 hmem( .addr(maddr), .clk(clk), .din(mdin), .dout(mdout), .wen(mwen));	 
 assign dout = mdout;

// memory input muxes 
 pe4_2 goenc( .I0(top), .I1(popworking), .I2(pushworking), .I3(1'b0), .Y(opsel), .V());
 mux3_8bit hmaddr_mux( .I0(8'd1), .I1(popmaddr), .I2(pushmaddr), .S(opsel), .Y(maddr));
 mux3_8bit hmdin_mux( .I0(8'd0), .I1(popmdin), .I2(pushmdin), .S(opsel), .Y(mdin));
 assign mwen =  pushmwen | popmwen;
 
// control signal generation 
 assign pushstart = push & (size < 8'b11111111);
 assign popstart = pop & (size != 8'b00000000);

 always @(posedge clk)
 begin
   if(reset == 1) begin
	  pushworking <= 1'b0;
	  popworking <= 1'b0;
	end
	else if(pushstart == 1) begin
	  pushworking <= 1'b1;
	end
	else if(popstart == 1) begin
	  popworking <= 1'b1;
	end
	else if(done_int == 1) begin
	  pushworking <= 1'b0;
	  popworking <= 1'b0;
	end
 end
 // delay done 1 cycle to match with when all values will be written
 //  to memory.
 always @(posedge clk)
 begin
    done_int <= 	pushdone | 
						popdone | 
						(push & (size == 8'b11111111)) | 
						(pop & (size == 8'b00000000));
 end 
 assign done = done_int;

 assign valid = (size != 8'd0) & ~pushworking & ~popworking ;
 assign top = ~pushworking & ~popworking;

// Push controller
 ctrlpush push_control(
    .clk(clk),
    .reset(reset),
    .start(pushstart),
    .mdout(mdout),
    .size(size),
	 .din(din),
    .sizeinc(sizeinc),
    .mwen(pushmwen),
    .maddr(pushmaddr),
    .mdin(pushmdin),
    .done(pushdone)
    );

// Pop controller
 ctrlpop pop_control(
    .clk(clk),
    .reset(reset),
    .start(popstart),
    .mdout(mdout),
    .size(size),
    .sizedec(sizedec),
    .mwen(popmwen),
    .maddr(popmaddr),
    .mdin(popmdin),
    .done(popdone) 
	);
endmodule
