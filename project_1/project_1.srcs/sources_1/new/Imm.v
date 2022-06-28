`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 16:39:32
// Design Name: 
// Module Name: Imm
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


module Imm
(
input [31:0] inst,           //传入指令
input imm,                    //使能
output reg [31:0] Idata      //输出立即数
   );
always@(*)
if(imm)
case(inst[6:0])
   7'b0010011:          //addi
   begin
     Idata[11:0]=inst[31:20];
     if(inst[31]==0)
       Idata[31:12]=20'b0;
     else
       Idata[31:12]=20'hfffff;
   end
   7'b0100011:          //sw
   begin
     Idata[4:0]=inst[11:7];
     Idata[11:5]=inst[31:25];
     if(inst[31]==0)
       Idata[31:12]=20'b0;
     else
       Idata[31:12]=20'hfffff;
   end
   7'b0000011:            //lw
   begin
     Idata[11:0]=inst[31:20];
     if(inst[31]==0)
       Idata[31:12]=20'b0;
     else
       Idata[31:12]=20'hfffff;
   end
   7'b1100011:              //beq
   begin
     Idata[0]=0;
     Idata[4:1]=inst[11:8];
     Idata[10:5]=inst[30:25];
     Idata[11]=inst[7];
     Idata[12]=inst[31];
     if(inst[31]==0)
       Idata[31:13]=19'b0;
     else
       Idata[31:13]=19'h7ffff;
   end
   7'b1101111:             //beq
   begin
     Idata[0]=0;
     Idata[10:1]=inst[30:21];
     Idata[11]=inst[20];
     Idata[19:12]=inst[19:12];
     Idata[20]=inst[31];
     if(inst[31]==0)
       Idata[31:21]=11'b0;
     else
       Idata[31:21]=11'h7ff;
   end
   default
   begin
     Idata=32'b0;
   end
endcase

endmodule
