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
output reg Branch_ID,    //控制是否实现beq指令
output reg jal_ID,        //控制是否实现jal指令
output reg [1:0] RegScr_ID,   //控制三路选择器
output reg ALUop_ID,      //控制ALU的实现功能
output reg MemWrite_ID,   //控制数据存储器
output reg ALUScr_ID,     //控制输入ALU的数
output reg RegWrite_ID,    //控制寄存器堆的使能
output reg Imm_ID,        //控制立即数的产生
output reg rd1_ID,
output reg rd2_ID,
output reg Igen_ID,
output [31:0] pc_ID_EX,
output [31:0] inst_ID_EX
    );

endmodule
