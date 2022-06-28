`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 13:53:37
// Design Name: 
// Module Name: RF
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
//////////////////////////////////////////////////////////////////////////////////


module RF
(
input clk,
input [4:0] ra1,    //读端口1
input [4:0] ra2,    //读端口2
input [4:0] ra3,    //读端口3
input [4:0] wa,     //写入端口
input we,         //写使能
input [31:0] wd,    //写入数据
output [31:0] rd1,  //端口1数据
output [31:0] rd2,  //端口2数据
output [31:0] rd3  //端口3数据
    );
reg [31:0] regfile[0:31];
initial regfile[0]=32'd0;  //使x0恒定为0
always@(*)
  regfile[0]=32'b0;

assign rd1=regfile[ra1];
assign rd2=regfile[ra2];
assign rd3=regfile[ra3];

always@(negedge clk)
begin
   if(we&&wa!=5'b0)
   begin
    if(wa==ra1)
     regfile[wa]<=rd1;
    if(wa==ra2)
     regfile[wa]<=rd2;
    if(wa==ra3)
     regfile[wa]<=rd3;
    else
     regfile[wa]<=wd;
   end
end

endmodule
