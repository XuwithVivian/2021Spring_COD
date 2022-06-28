`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:40:07
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
input [31:0] inst,       //指令的opcode
output reg Branch,    //控制是否实现beq指令
output reg bne,
output reg blt,
output reg bge,
output reg jal,        //控制是否实现jal指令
output reg [1:0] RegScr,   //控制三路选择器
output reg [3:0] ALUop,      //控制ALU的实现功能
output reg MemWrite,   //控制数据存储器
output reg ALUScr,     //控制输入ALU的数
output reg RegWrite,    //控制寄存器堆的使能
output reg Imm        //控制立即数的产生
    );
always@(*)
case(inst[6:0])
   7'b0110011:
   begin
   
   if(inst[14:12]==3'b000&&inst[31:25]==7'b0)  //add
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h0;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   else if((inst[14:12]==3'b000)&&inst[31:25]==7'b0100000)  //sub
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   else if((inst[14:12]==3'b100)&&inst[31:25]==7'b0000000)  //xor
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h4;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   else if((inst[14:12]==3'b110)&&inst[31:25]==7'b0000000)  //or
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h3;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   else if((inst[14:12]==3'b111)&&inst[31:25]==7'b0000000)   //and
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h2;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   else if((inst[14:12]==3'b001)&&inst[31:25]==7'b0000000)   //sll
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h5;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   else if((inst[14:12]==3'b101)&&inst[31:25]==7'b0000000)   //srl
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'b0;
     ALUop=4'h6;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   
   end
   7'b0010011:
   begin
   
   if(inst[14:12]==3'b000)     //addi
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd0;
     ALUop=4'h0;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   
   else if(inst[14:12]==3'b100)     //xori
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd0;
     ALUop=4'h4;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   
   else if(inst[14:12]==3'b110)     //ori
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd0;
     ALUop=4'h3;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   
   else if(inst[14:12]==3'b111)     //andi
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd0;
     ALUop=4'h2;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   
   else if(inst[14:12]==3'b001)     //slli
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd0;
     ALUop=4'h5;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   
   end
   7'b0100011:        //sw
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd1;
     ALUop=4'b0;
     MemWrite=1;
     ALUScr=1;
     RegWrite=0;
   end
   7'b0000011:            //lw
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd1;
     ALUop=4'b0;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   7'b1100011:            //beq
   begin
   
   if(inst[14:12]==3'b000)  //beq
   begin
     jal=0;
     Branch=1;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd3;
     ALUop=4'b1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
   
   else if(inst[14:12]==3'b001)   //bne
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=1;
     blt=0;
     bge=0;
     RegScr=2'd3;
     ALUop=4'b1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
   
   else if(inst[14:12]==3'b100)   //blt
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=1;
     bge=0;
     RegScr=2'd3;
     ALUop=4'b1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
   
   else if(inst[14:12]==3'b101)   //bge
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=1;
     RegScr=2'd3;
     ALUop=4'b1;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
   
   end
   7'b1101111:                  //jal
   begin
     jal=1;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd2;
     ALUop=4'b0;
     MemWrite=0;
     ALUScr=0;
     RegWrite=1;
   end
   7'b0010111:             //auipc
   begin
     jal=0;
     Branch=0;
     Imm=1;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd3;
     ALUop=4'b0;
     MemWrite=0;
     ALUScr=1;
     RegWrite=1;
   end
   default
   begin
     jal=0;
     Branch=0;
     Imm=0;
     bne=0;
     blt=0;
     bge=0;
     RegScr=2'd0;
     ALUop=4'b0;
     MemWrite=0;
     ALUScr=0;
     RegWrite=0;
   end
endcase
endmodule

