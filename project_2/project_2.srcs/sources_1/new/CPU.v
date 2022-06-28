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
input clk,    //ʱ���ź�
input rst,    //��λ�ź�
output [7:0] io_addr,    //I/O����ĵ�ַ
output [31:0] io_dout,   //CPU��led��seg���������
output io_we,         //CPU��led��seg���ʱ��ʹ���ź�
input [31:0] io_din,   //CPU�����������뻺��Ĵ�����sw��������

input [7:0] m_rf_addr, //�洢��(MEM)��Ĵ�����(RF)�ĵ��Զ��ڵ�ַ
output [31:0] rf_data,  //��RF��ȡ������
output [31:0] m_data,  //��MEM��ȡ������
output [31:0] pc      //pc������
    );
wire [31:0] spo;     //ָ��洢��������ָ��
//�����źŴ���������Ŀ����ź�
wire RegWrite,jal,Branch,Imm,ALUScr,MemWrite,bge,blt,bne;
wire [3:0] ALUop;
wire [1:0] RegScr;
wire [31:0] rd1,rd2,wd;  //�Ĵ����ѵĶ������ݽӿ�
wire [31:0] rs,rd;
wire [31:0] Idata;      //������
wire [1:0] zero;           //���ź�
wire [31:0] data,data_mux;  
wire [31:0] next_pc;   //pc+4

assign io_dout=rd2;
assign io_we=rd[10]&MemWrite;
assign io_addr=rd[7:0];
//����ָ��洢��
dist_mem_gen_0 dist_mem_gen_0(.a(pc[9:2]),.spo(spo));
//���üĴ�����
RF RF(.clk(clk),.we(RegWrite),.wa(spo[11:7]),.wd(wd),.ra1(spo[19:15]),.ra2(spo[24:20]),.ra3(m_rf_addr[4:0]),.rd1(rd1),.rd2(rd2),.rd3(rf_data));
//���ÿ����źŴ�����
control control(.inst(spo),.jal(jal),.Branch(Branch),.Imm(Imm),.RegScr(RegScr),.ALUop(ALUop),.ALUScr(ALUScr),.RegWrite(RegWrite),.MemWrite(MemWrite),.bne(bne),.blt(blt),.bge(bge));
//����ALU
ALU ALU(.a(rd1),.b(rs),.f(ALUop),.z(zero),.y(rd));
//�������ݴ洢��
dist_mem_gen_1 dist_mem_gen_1(.a(rd[7:0]),.d(rd2),.we(MemWrite&(~rd[10])),.clk(clk),.dpra(m_rf_addr),.spo(data),.dpo(m_data));
//����˫·ѡ����
MUX MUX(.a(data),.b(io_din),.y(data_mux),.z(rd[10]));
//������·ѡ����
MUX3to1 MUX3to1(.a(rd),.b(data_mux),.c(next_pc),.z(RegScr),.y(wd));

//����Imm Gen
Igen Igen(.inst(spo),.Imm(Imm),.Idata(Idata));
//����˫·ѡ����
mux_alu mux_alu(.a(rd2),.b(Idata),.z(ALUScr),.y(rs));
//����PC
pc_next pc_next(.clk(clk),.rst(rst),.imm(Idata),.f((zero!=2'b0&bne)|(zero==2'b10&blt)|((zero==2'b1|zero==2'b0)&bge)|(zero==2'b0&Branch)|jal),.pc(pc),.pc_4(next_pc));
endmodule

