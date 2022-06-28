`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 16:06:39
// Design Name: 
// Module Name: IDEX
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


module IDEX(
input clk,rst,en,
input Branch_ID,    //控制是否实现beq指令
input jal_ID,        //控制是否实现jal指令
input [1:0] RegScr_ID,   //控制三路选择器
input ALUop_ID,      //控制ALU的实现功能
input MemWrite_ID,   //控制数据存储器
input ALUScr_ID,     //控制输入ALU的数
input RegWrite_ID,    //控制寄存器堆的使能
input Imm_ID,        //控制立即数的产生
input rd1_ID,
input rd2_ID,
input Igen_ID,
input pc_ID,
input inst_ID,
output reg Branch_EX,    //控制是否实现beq指令
output reg jal_EX,        //控制是否实现jal指令
output reg [1:0] RegScr_EX,   //控制三路选择器
output reg ALUop_EX,      //控制ALU的实现功能
output reg MemWrite_EX,   //控制数据存储器
output reg ALUScr_EX,     //控制输入ALU的数
output reg RegWrite_EX,    //控制寄存器堆的使能
output reg Imm_EX,        //控制立即数的产生
output reg [31:0] rd1_EX,
output reg [31:0] rd2_EX,
output reg [31:0] Igen_EX,
output reg [31:0] pc_EX,
output reg [31:0] inst_EX
    );

always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    Branch_EX<=0;
    jal_EX<=0;
    RegScr_EX<=2'b0;
    ALUop_EX<=0;
    MemWrite_EX<=0;
    ALUScr_EX<=0;
    RegWrite_EX<=0;
    Imm_EX<=0;
    rd1_EX<=32'b0;
    rd2_EX<=32'b0;
    Igen_EX<=32'b0;
    pc_EX<=32'b0;
    inst_EX<=32'b0;
  end
  else if(en)
  begin
    Branch_EX<=Branch_ID;
    jal_EX<=jal_ID;
    RegScr_EX<=RegScr_ID;
    ALUop_EX<=ALUop_ID;
    MemWrite_EX<=MemWrite_ID;
    ALUScr_EX<=ALUScr_ID;
    RegWrite_EX<=RegWrite_ID;
    Imm_EX<=Imm_ID;
  end
  else
  begin
    Branch_EX<=Branch_EX;
    jal_EX<=jal_EX;
    RegScr_EX<=RegScr_EX;
    ALUop_EX<=ALUop_EX;
    MemWrite_EX<=MemWrite_EX;
    ALUScr_EX<=ALUScr_EX;
    RegWrite_EX<=RegWrite_EX;
    Imm_EX<=Imm_EX;
    rd1_EX<=rd1_EX;
    rd2_EX<=rd2_EX;
    Igen_EX<=Igen_EX;
    pc_EX<=pc_EX;
    inst_EX<=inst_EX;
  end
end

endmodule
