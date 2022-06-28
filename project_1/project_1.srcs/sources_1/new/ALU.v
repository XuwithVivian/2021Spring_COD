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
input [31:0] a,b,      //����ʵ���������
input [3:0] f,            //����ʵ�ֹ���
output reg [31:0] y,   //������
output reg z        //�����
    );
always@(*)
begin
  if(f==4'b1)          //fΪ1ʱʵ�ּӷ�
      y=a+b;
  else if(f==4'b0)             //fΪ0ʱʵ�ּ���
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
