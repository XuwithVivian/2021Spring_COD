`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:43:13
// Design Name: 
// Module Name: pc_next
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


module pc_next(
input clk,           //ʱ��
input rst,           //��λ�ź�
input [31:0] imm,     //������
input f,            //�����ź�
output reg [31:0] pc,  //���pc��ֵ
output [31:0] pc_4   //pc+4��ֵ
    );
reg [31:0] next_pc;   //�洢��һ��pc��ֵ
assign pc_4=pc+4;

always@(negedge clk or posedge rst)
begin
  if(rst==1)
    pc<=32'h3000;  //��λ
  else  
    pc<=next_pc;
end

always@(*)
begin
if(f==0)            //����PC�Ƿ���ת
  next_pc=pc+4;
else
  next_pc=pc+imm;
end
endmodule

