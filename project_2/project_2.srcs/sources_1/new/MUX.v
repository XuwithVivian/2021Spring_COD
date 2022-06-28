`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:44:07
// Design Name: 
// Module Name: MUX
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


module MUX(    //Ë«Â·Ñ¡ÔñÆ÷
input [31:0] a,b,
input z,
output reg [31:0] y
    );
always@(*)
begin
 if(z==0)
  y=a;
 else
  y=b;
end
endmodule

