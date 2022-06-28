`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:45:43
// Design Name: 
// Module Name: MUX3to1
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


module MUX3to1(  //ÈýÂ·Ñ¡ÔñÆ÷
input [31:0] a,b,c,
input [1:0] z,
output reg [31:0] y
    );
always@(*)
case(z)
  2'd0:y=a;
  2'd1:y=b;
  2'd2:y=c;
  2'd3:y=32'b0;
endcase
endmodule

