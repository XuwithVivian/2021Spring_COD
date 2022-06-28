`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 20:46:11
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
wire [31:0] io_dout,io_din,rf_data,m_data;
wire io_we;
wire [31:0] pcin, pc, pcd, pce;
wire [31:0] ir, imm, mdr;
wire [31:0] a, b, y, bm, yw;
wire [4:0]  rd, rdm, rdw;
wire [31:0] ctrl, ctrlm, ctrlw;    
wire clk_out1,locked;

//clk_wiz_0 clk_wiz_0(.clk_in1(clk),.clk_out1(clk_out1),.reset(rst),.locked(locked));
//调用CPU
CPU CPU(.clk(clk_cpu),.rst(rst),.io_addr(io_addr),.io_dout(io_dout),.io_we(io_we),.io_din(io_din),.m_rf_addr(m_rf_addr),.pc(pc),.rf_data(rf_data),.m_data(m_data),.pcd(pcd),.ir(ir),.pcin(pcin),.pce(pce),.a(a),.b(b),.imm(imm),.rd(rd),.ctrl(ctrl),.y(y),.bm(bm),.rdm(rdm),.ctrlm(ctrlm),.yw(yw),.mdr(mdr),.rdw(rdw),.ctrlw(ctrlw));
//调用PDU
pdu pdu_pl_0511(.clk(clk),.rst(rst),.io_addr(io_addr),.io_dout(io_dout),.io_we(io_we),.io_din(io_din),.m_rf_addr(m_rf_addr),.pc(pc),.rf_data(rf_data),.m_data(m_data),.run(run),.step(step),.clk_cpu(clk_cpu),.valid(valid),.in(in),.check(chk),.out0(out0),.an(an),.seg(seg),.ready(ready),.pcd(pcd),.ir(ir),.pcin(pcin),.pce(pce),.a(a),.b(b),.imm(imm),.rd(rd),.ctrl(ctrl),.y(y),.bm(bm),.rdm(rdm),.ctrlm(ctrlm),.yw(yw),.mdr(mdr),.rdw(rdw),.ctrlw(ctrlw));

endmodule
