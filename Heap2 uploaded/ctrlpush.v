`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:13 04/05/2017 
// Design Name: 
// Module Name:    ctrlpush 
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
module ctrlpush(
    input clk,
    input reset,
    input start,
    input [7:0] mdout,
    input [7:0] size,
	 input [7:0] din,
    output sizeinc,
    output mwen,
    output [7:0] maddr,
    output [7:0] mdin,
    output done
    );

// You complete
wire dinit, didle, dparent,ddone,dcomp;
wire qidle, qinit, qparent, qcomp,qdone;

dff1s idleState(clk,1'b0,reset,didle,qidle);
dff1s initState(clk,reset,1'b0,dinit,qinit);
dff1s parentState(clk,reset,1'b0,dparent,qparent);
dff1s compState(clk,reset,1'b0,dcomp,qcomp);
dff1s doneState(clk,reset,1'b0,ddone,qdone);

wire sizeBG0;
assign sizeBG0=(size[7:0]>0);
wire [1:0]madd;
pe4_2 maddren1(.I0(qparent),.I1(qcomp),.I2(qdone),.I3(1'b0),.Y(madd[1:0]),.V(v0));
wire [7:0]didx;
wire [7:0]idx;
//Let's solve the assign issue of didx
wire [1:0]didxencoder;
pe4_2 encoder(.I0(qinit),.I1(qcomp&LTP),.I2(1'b0),.I3(1'b0),.Y(didxencoder),.V(redun0));
mux3_8bit didxmux((size[7:0]+8'b00000001),{1'b0,idx[7:1]},8'b0,didxencoder,didx[7:0]);	

wire [1:0]mdinencoder;
pe4_2 mdinen(.I0(qcomp&LTP),.I1(qdone),.I2(1'b0),.I3(1'b0),.Y(mdinencoder[1:0]),.V(redun2));
mux3_8bit mdinmux(parent[7:0],din[7:0],8'd0,mdinencoder[1:0],mdin[7:0]);

reg8e idxRegister(clk,reset,qinit|(qcomp&LTP),didx[7:0],idx[7:0]);

wire [7:0]halfidx;	
assign halfidx={1'b0,idx[7:1]};
mux3_8bit maddren2(halfidx[7:0],idx[7:0],idx[7:0],madd[1:0],maddr[7:0]);
wire [7:0]parent;
reg8e parentRegister(clk,reset,qparent,mdout[7:0],parent);			
comp8 comp(din[7:0],parent,LTP,EQP,GTP);
wire halfidxeq1;
assign halfidxeq1=(halfidx==8'b00000001);




assign didle=(qdone|(qidle&~start));
assign dinit=(start&qidle);
assign dparent=(qinit&sizeBG0)|(qcomp&(LTP&~halfidxeq1));
assign dcomp=qparent;
assign ddone=(qcomp&(EQP|GTP|halfidxeq1))|(qinit&~sizeBG0);

assign sizeinc=qinit;
assign mwen=qdone|(qcomp&LTP); 	 		
assign done=qdone;




endmodule
