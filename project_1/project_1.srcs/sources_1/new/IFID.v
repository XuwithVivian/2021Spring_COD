`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 15:51:12
// Design Name: 
// Module Name: IFID
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


module IFID(
input clk,rst,en,
input [31:0] pc_IF,
input [31:0] inst_IF,
output reg [31:0] pc_ID,
output reg [31:0] inst_ID
    );
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    pc_ID<=32'b0;
    inst_ID<=32'b0;
  end
  else if(en)
  begin
    pc_ID<=pc_IF;
    inst_ID<=inst_IF;
  end
  else
  begin
    pc_ID<=pc_ID;
    inst_ID<=inst_ID;
  end
end
endmodule
