`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:40:48
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


module ALU(
input [31:0] a,b,      //����ʵ���������
input [3:0] f,            //����ʵ�ֹ���
output reg [31:0] y,   //������
output reg [1:0] z        //�����
    );
always@(*)
begin
  if(f==4'h0)          //fΪ1ʱʵ�ּӷ�
      y=a+b;
  else if(f==4'h1)             //fΪ0ʱʵ�ּ���
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
      z=2'b0;
   else if(a>b)
      z=2'b1;
   else if(a<b)
      z=2'b10;
end
endmodule

