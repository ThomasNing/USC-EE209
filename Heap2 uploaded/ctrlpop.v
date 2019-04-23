`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:23 04/05/2017 
// Design Name: 
// Module Name:    ctrlpop 
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
module ctrlpop(
    input clk,
    input reset,
    input start,
    input [7:0] mdout,
    input [7:0] size,
    output sizedec,
    output mwen,
    output [7:0] maddr,
    output [7:0] mdin,
    output done
    );

// You complete

wire didle,dinit,dchild1,drcomp,dpcomp,ddone;
wire qidle,qinit,qchild,qrcomp,qpcomp,qdone;

dff1s idlestate(clk,1'b0,reset,didle,qidle);
dff1s initstate(clk,reset,1'b0,dinit,qinit);
dff1s childstate(clk,reset,1'b0,dchild1,qchild);
dff1s rcompstate(clk,reset,1'b0,drcomp,qrcomp);
dff1s pcompstate(clk,reset,1'b0,dpcomp,qpcomp);
dff1s donestate(clk,reset,1'b0,ddone,qdone);


wire sizeBG2;
assign sizeBG2=(size[7:0]>8'b00000010);
assign sizedec=qinit;
wire [7:0]twcidx;
assign twcidx={cidx[6:0],1'b0};


wire [7:0]idx;
wire [7:0]cidx;
wire [7:0]didx;
wire [7:0]dcidx;
wire [7:0]parent;
reg8e idxRegister(clk,reset,(qinit|(qpcomp&(child<parent))),didx,idx);
reg8e cidxRegister(clk,reset,(qinit|(qrcomp&(mdout<child))|(qpcomp&(child<parent))),dcidx,cidx);

assign done=qdone;
assign dparent=mdout[7:0];
assign mwen=(qpcomp&(child<parent))|qdone;
//Let us deal with the mdin[7:0]
wire [1:0]mdinencoder;
pe4_2 mdinpe(.I0(qpcomp&(child<parent)),.I1(qdone),.I2(1'b0),.I3(1'b0),.Y(mdinencoder[1:0]),.V(redun2));
mux3_8bit mdinmux(child[7:0],parent[7:0],8'b00000000,mdinencoder[1:0],mdin[7:0]);
//Let us deal with the maddr
wire [1:0]maddrmux1;
wire [1:0]maddrmux2;
wire [7:0]condition;

pe4_2 maddr1(.I0(qrcomp),.I1(qpcomp),.I2(qdone),.I3(1'b0),.Y(maddrmux1[1:0]),.V(redun3));
mux3_8bit muxmaddr1((cidx[7:0]+8'b00000001),idx[7:0],idx[7:0],maddrmux1[1:0],condition[7:0]);
pe4_2 maddr2(.I0(qinit),.I1(qchild),.I2(qrcomp|qpcomp|qdone),.I3(1'b0),.Y(maddrmux2[1:0]),.V(redun4));
mux3_8bit muxmaddr2(size[7:0],cidx[7:0],condition[7:0],maddrmux2[1:0],maddr[7:0]);


wire [7:0]child;
wire [7:0]dchild;
wire [7:0]dparent;
reg8e parentRegister(clk,reset,qinit,dparent,parent);
reg8e childRegister(clk,reset,(qchild|(qrcomp&(mdout<child))),dchild,child);
wire [1:0]idxen,cidxen,parenten,childen;
pe4_2 index(.I0(qinit),.I1(qpcomp&(child<parent)),.I2(1'b0),.I3(1'b0),.Y(idxen[1:0]),.V(redun0));
pe4_2 cindex(.I0(qinit),.I1(qrcomp&(mdout<child)),.I2(qpcomp&(child<parent)),.I3(1'b0),.Y(cidxen[1:0]),.V(redun1));
mux3_8bit idxmux(8'b00000001,cidx[7:0],8'b00000000,idxen[1:0],didx[7:0]);
mux3_8bit cidxmux(8'b00000010,(cidx[7:0]+8'b00000001),twcidx,cidxen[1:0],dcidx[7:0]);

pe4_2 registerChild(.I0(qchild),.I1(qrcomp&(mdout[7:0]<child)),.I2(1'b0),.I3(1'b0),.Y(childen[1:0]),.V(redun2	));
mux3_8bit childmux(mdout[7:0],mdout[7:0],8'b0,childen[1:0],dchild[7:0]);


assign didle=(qdone|(qidle&~start));
assign dinit=qidle&start;
assign dchild1=(qinit&sizeBG2)|(qpcomp&(child<parent)&(twcidx<=size));
assign drcomp=qchild&~((cidx[7:0]+1)>size[7:0]);
assign dpcomp=qrcomp|(qchild&(cidx[7:0]+1)>size);
assign ddone=(~sizeBG2&qinit)|(qpcomp&((child>=parent)|(twcidx>size)));






	
endmodule
