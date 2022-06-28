`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:51:57
// Design Name: 
// Module Name: CPU_PDU
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


module CPU_PDU(
input run,     //控制运行方式
input step,
//输入sw端口
input valid,
input [4:0] in,
input rst,    //复位信号
input clk,    //时钟信号
//数码管
output [2:0] an,
output [3:0] seg,
output ready,
output [4:0] out0,
output [1:0] chk  //查看类型
    );
wire clk_cpu;
wire [7:0] io_addr,m_rf_addr;
wire [31:0] io_dout,io_din,rf_data,m_data,pc;
wire io_we;

//调用CPU
CPU CPU(.clk(clk_cpu),.rst(rst),.io_addr(io_addr),.io_dout(io_dout),.io_we(io_we),.io_din(io_din),.m_rf_addr(m_rf_addr),.pc(pc),.rf_data(rf_data),.m_data(m_data));
//调用PDU
pdu_1cycle pdu_1cycle(.clk(clk),.rst(rst),.io_addr(io_addr),.io_dout(io_dout),.io_we(io_we),.io_din(io_din),.m_rf_addr(m_rf_addr),.pc(pc),.rf_data(rf_data),.m_data(m_data),.run(run),.step(step),.clk_cpu(clk_cpu),.valid(valid),.in(in),.check(chk),.out0(out0),.an(an),.seg(seg),.ready(ready));
endmodule

