`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 14:11:07
// Design Name: 
// Module Name: ID
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


module ID(
input [31:0] pc_ID,
input [31:0] inst_ID,
output reg Branch_ID,    //�����Ƿ�ʵ��beqָ��
output reg jal_ID,        //�����Ƿ�ʵ��jalָ��
output reg [1:0] RegScr_ID,   //������·ѡ����
output reg ALUop_ID,      //����ALU��ʵ�ֹ���
output reg MemWrite_ID,   //�������ݴ洢��
output reg ALUScr_ID,     //��������ALU����
output reg RegWrite_ID,    //���ƼĴ����ѵ�ʹ��
output reg Imm_ID,        //�����������Ĳ���
output reg rd1_ID,
output reg rd2_ID,
output reg Igen_ID,
output [31:0] pc_ID_EX,
output [31:0] inst_ID_EX
    );

endmodule
