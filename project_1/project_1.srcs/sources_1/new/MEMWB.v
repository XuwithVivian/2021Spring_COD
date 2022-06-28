`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 21:53:52
// Design Name: 
// Module Name: MEMWB
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


module MEMWB(
input clk,rst,en,
input [1:0] RegScr_MEM,
input [31:0] ALUout_MEM,
input [31:0] rd_MEM,
input [31:0] pc_MEM,
output reg [1:0] RegScr_WB,
output reg [31:0] ALUout_WB,
output reg [31:0] rd_WB,
output reg [31:0] pc_WB
    );
    
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    ALUout_WB<=32'b0;
    pc_WB<=32'b0;
    RegScr_WB<=2'b0;
    rd_WB<=32'b0;
  end
  else if(en)
  begin
    ALUout_WB<=ALUout_MEM;
    pc_WB<=pc_MEM;
    RegScr_WB<=RegScr_MEM;
    rd_WB<=rd_MEM;
  end
  else
  begin
    ALUout_WB<=ALUout_WB;
    pc_WB<=pc_WB;
    RegScr_WB<=RegScr_WB;
    rd_WB<=rd_WB;
  end
end    

endmodule
