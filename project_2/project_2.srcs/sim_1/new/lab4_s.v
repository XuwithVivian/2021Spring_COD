`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:53:42
// Design Name: 
// Module Name: lab4_s
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


module lab4_s();
reg rst,clk;

CPU CPU(.rst(rst),.clk(clk));
initial clk=0;
begin
  always #5 clk=~clk;
end

initial
begin
     rst=1;
  #2 rst=0;
end

endmodule

