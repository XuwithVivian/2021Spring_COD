`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 14:03:24
// Design Name: 
// Module Name: ALU
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


module ALU
(
input [31:0] a,b,      //用于实现运算的数
input [3:0] f,            //控制实现功能
output reg [31:0] y,   //运算结果
output reg z        //零符号
    );
always@(*)
begin
  if(f==4'b1)          //f为1时实现加法
      y=a+b;
  else if(f==4'b0)             //f为0时实现减法
      y=a-b;
  else if(f==4'h2)
      y=a&b;
  else if(f==4'h3)
      y=a|b;
  else if(f==4'h4)
      y=a^b;
  else if(f==4'h5)
      y=a<<b;
  else if(f==4'h6)
      y=a>>b;
end

always@(*)
begin
   if(y==0)
      z=1;
   else
      z=0;
end

endmodule
