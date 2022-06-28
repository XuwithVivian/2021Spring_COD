`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:31:22
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
input [4:0] ra1,    //���˿�1
input [4:0] ra2,    //���˿�2
input [4:0] ra3,    //���˿�3
input [4:0] wa,     //д��˿�
input we,         //дʹ��
input [31:0] wd,    //д������
output [31:0] rd1,  //�˿�1����
output [31:0] rd2,  //�˿�2����
output [31:0] rd3  //�˿�3����
    );
reg [31:0] regfile[0:31];
initial regfile[0]=32'd0;  //ʹx0�㶨Ϊ0
always@(*)
  regfile[0]=32'b0;
assign rd1=regfile[ra1];
assign rd2=regfile[ra2];
assign rd3=regfile[ra3];

always@(negedge clk)   //ȡʱ���½��أ���ˮ�߿ɼ�������ת��
begin
   if(we&&wa!=5'b0)
     regfile[wa]<=wd;
end
endmodule

