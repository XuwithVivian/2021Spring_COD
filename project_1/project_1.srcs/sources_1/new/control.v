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
input [6:0] inst,       //指令的opcode
output reg Branch,    //控制是否实现beq指令
output reg jal,        //控制是否实现jal指令
output reg [1:0] RegScr,   //控制三路选择器
output reg ALUop,      //控制ALU的实现功能
output reg MemWrite,   //控制数据存储器
output reg ALUScr,     //控制输入ALU的数
output reg RegWrite,    //控制寄存器堆的使能
output reg Imm        //控制立即数的产生
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
