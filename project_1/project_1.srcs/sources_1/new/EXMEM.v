`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 21:17:07
// Design Name: 
// Module Name: EXMEM
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


module EXMEM(
input clk,rst,en,
input [31:0] wd_EX,
input [31:0] ALUout_EX,
input [31:0] ra2_EX,
input [31:0] pc_EX,
input MemWrite_EX,
input [1:0] RegScr_EX,
output reg [31:0] wd_MEM,
output reg [31:0] ALUout_MEM,
output reg [31:0] ra2_MEM,
output reg [31:0] pc_MEM,
output reg MemWrite_MEM,
output reg [1:0] RegScr_MEM
    );

always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    wd_MEM<=32'b0;
    ALUout_MEM<=32'b0;
    pc_MEM<=32'b0;
    MemWrite_MEM<=0;
    RegScr_MEM<=2'b0;
    ra2_MEM<=32'b0;
  end
  else if(en)
  begin
    wd_MEM<=wd_EX;
    ALUout_MEM<=ALUout_EX;
    pc_MEM<=pc_EX;
    MemWrite_MEM<=MemWrite_EX;
    RegScr_MEM<=RegScr_EX;
    ra2_MEM<=ra2_EX;
  end
  else
  begin
    wd_MEM<=wd_MEM;
    ALUout_MEM<=ALUout_MEM;
    pc_MEM<=pc_MEM;
    MemWrite_MEM<=MemWrite_MEM;
    RegScr_MEM<=RegScr_MEM;
    ra2_MEM<=ra2_MEM;
  end
end    
    
endmodule
