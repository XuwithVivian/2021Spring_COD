`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/14 16:53:00
// Design Name: 
// Module Name: cpu_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////////////rdm,rdw;/////////////////////////////////////////////////////////


module cpu_sim();
reg rst,clk;
wire [31:0] pc;
//wire [31:0] pc,pcd,pcin,ir,pce,a,b,imm,ctrl,y,bm,ctrlm,yw,mdr,ctrlw;
//wire [4:0] rd,rdm,rdw;
//CPU CPU(.rst(rst),.clk(clk),.pc(pc),.pcin(pcin),.pcd(pcd),.ir(ir),.pce(pce),.a(a),.b(b),.imm(imm),.ctrl(ctrl),.y(y),.bm(bm),.ctrlm(ctrlm),.yw(yw),.mdr(mdr),.ctrlw(ctrlw),.rd(rd),.rdm(rdm),.rdw(rdw));
CPU CPU(.rst(rst),.clk(clk),.pc(pc));
initial clk=0;
begin
  always #2 clk=~clk;
end

initial
begin
     rst=1;
  #1 rst=0;
end

endmodule
