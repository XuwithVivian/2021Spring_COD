`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/12 18:46:36
// Design Name: 
// Module Name: CPU
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


module CPU(
input clk,    //时钟信号
input rst,    //复位信号
output [7:0] io_addr,    //I/O外设的地址
output [31:0] io_dout,   //CPU向led和seg输出的数据
output io_we,         //CPU向led和seg输出时的使能信号
input [31:0] io_din,   //CPU接收来自输入缓冲寄存器的sw输入数据

input [7:0] m_rf_addr, //存储器(MEM)或寄存器堆(RF)的调试读口地址
output [31:0] rf_data,  //从RF读取的数据
output [31:0] m_data,  //从MEM读取的数据
output [31:0] pc      //pc的内容
    );
wire [31:0] spo;     //指令存储器传出的指令
//控制信号处理器输出的控制信号
wire RegWrite,jal,Branch,Imm,ALUScr,MemWrite,bge,blt,bne;
wire [3:0] ALUop;
wire [1:0] RegScr;
wire [31:0] rd1,rd2,wd;  //寄存器堆的对于数据接口
wire [31:0] rs,rd;
wire [31:0] Idata;      //立即数
wire [1:0] zero;           //零信号
wire [31:0] data,data_mux;  
wire [31:0] next_pc;   //pc+4

assign io_dout=rd2;
assign io_we=rd[10]&MemWrite;
assign io_addr=rd[7:0];
//调用指令存储器
dist_mem_gen_0 dist_mem_gen_0(.a(pc[9:2]),.spo(spo));
//调用寄存器堆
RF RF(.clk(clk),.we(RegWrite),.wa(spo[11:7]),.wd(wd),.ra1(spo[19:15]),.ra2(spo[24:20]),.ra3(m_rf_addr[4:0]),.rd1(rd1),.rd2(rd2),.rd3(rf_data));
//调用控制信号处理器
control control(.inst(spo),.jal(jal),.Branch(Branch),.Imm(Imm),.RegScr(RegScr),.ALUop(ALUop),.ALUScr(ALUScr),.RegWrite(RegWrite),.MemWrite(MemWrite),.bne(bne),.blt(blt),.bge(bge));
//调用ALU
ALU ALU(.a(rd1),.b(rs),.f(ALUop),.z(zero),.y(rd));
//调用数据存储器
dist_mem_gen_1 dist_mem_gen_1(.a(rd[7:0]),.d(rd2),.we(MemWrite&(~rd[10])),.clk(clk),.dpra(m_rf_addr),.spo(data),.dpo(m_data));
//调用双路选择器
MUX MUX(.a(data),.b(io_din),.y(data_mux),.z(rd[10]));
//调用三路选择器
MUX3to1 MUX3to1(.a(rd),.b(data_mux),.c(next_pc),.z(RegScr),.y(wd));

//调用Imm Gen
Igen Igen(.inst(spo),.Imm(Imm),.Idata(Idata));
//调用双路选择器
mux_alu mux_alu(.a(rd2),.b(Idata),.z(ALUScr),.y(rs));
//调用PC
pc_next pc_next(.clk(clk),.rst(rst),.imm(Idata),.f((zero!=2'b0&bne)|(zero==2'b10&blt)|((zero==2'b1|zero==2'b0)&bge)|(zero==2'b0&Branch)|jal),.pc(pc),.pc_4(next_pc));
endmodule

