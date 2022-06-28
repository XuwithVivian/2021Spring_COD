`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 14:34:07
// Design Name: 
// Module Name: control
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


module control(
input [6:0] inst,       //ָ���opcode
output reg Branch,    //�����Ƿ�ʵ��beqָ��
output reg jal,        //�����Ƿ�ʵ��jalָ��
output reg [1:0] RegScr,   //������·ѡ����
output reg ALUop,      //����ALU��ʵ�ֹ���
output reg MemWrite,   //�������ݴ洢��
output reg ALUScr,     //��������ALU����
output reg RegWrite,    //���ƼĴ����ѵ�ʹ��
output reg Imm        //�����������Ĳ���
    );
always@(*)
case(inst)
   7'b0110011:     //add
   begin
     jal=0;
     Branch=0;
     Imm=0;
     RegScr=2'b0;
     ALUop=1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   7'b0010011:      //addi
   begin
     jal=0;
     Branch=0;
     Imm=1;
     RegScr=2'd0;
     ALUop=1;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   7'b0100011:        //sw
   begin
     jal=0;
     Branch=0;
     Imm=1;
     RegScr=2'd1;
     ALUop=1;
     MemWrite=1;
     ALUScr=1;
     RegWrite=0;
   end
   7'b0000011:            //lw
   begin
     jal=0;
     Branch=0;
     Imm=1;
     RegScr=2'd1;
     ALUop=1;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   7'b1100011:            //beq
   begin
     jal=0;
     Branch=1;
     Imm=1;
     RegScr=2'd3;
     ALUop=0;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
   7'b1101111:                  //jal
   begin
     jal=1;
     Branch=0;
     Imm=1;
     RegScr=2'd2;
     ALUop=1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   default
   begin
     jal=0;
     Branch=0;
     Imm=0;
     RegScr=2'd0;
     ALUop=0;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
endcase
endmodule
