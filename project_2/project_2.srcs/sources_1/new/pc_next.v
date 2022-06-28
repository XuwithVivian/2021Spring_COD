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
input clk,           //时钟
input rst,           //复位信号
input [31:0] imm,     //立即数
input f,            //控制信号
output reg [31:0] pc,  //输出pc的值
output [31:0] pc_4   //pc+4的值
    );
reg [31:0] next_pc;   //存储下一个pc的值
assign pc_4=pc+4;

always@(negedge clk or posedge rst)
begin
  if(rst==1)
    pc<=32'h3000;  //复位
  else  
    pc<=next_pc;
end

always@(*)
begin
if(f==0)            //决定PC是否跳转
  next_pc=pc+4;
else
  next_pc=pc+imm;
end
endmodule

