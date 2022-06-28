`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 20:43:11
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
  input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led和seg的地址
  output [31:0] io_dout,     //输出led和seg的数据
  output io_we,                 //输出led和seg数据时的使能信号
  input [31:0] io_din,        //来自sw的输入数据

  //Debug_BUS
  input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
  output [31:0] rf_data,    //从RF读取的数据
  output [31:0] m_data,    //从MEM读取的数据

  //PC/IF/ID 流水段寄存器
  output [31:0] pc,
  output [31:0] pcd,
  output [31:0] ir,
  output [31:0] pcin,

  //ID/EX 流水段寄存器
  output [31:0] pce,
  output [31:0] a,
  output [31:0] b,
  output [31:0] imm,
  output [4:0] rd,
  output [31:0] ctrl,

  //EX/MEM 流水段寄存器
  output [31:0] y,
  output [31:0] bm,
  output [4:0] rdm,
  output [31:0] ctrlm,

  //MEM/WB 流水段寄存器
  output [31:0] yw,
  output [31:0] mdr,
  output [4:0] rdw,
  output [31:0] ctrlw

    );

reg [31:0] pc_IF,inst_IF,pcin_IF,pcd_IF,pc_ID,inst_ID,pcd_ID,pcin_ID;
reg [31:0] pc_EX,a_ID,b_ID,imm_ID,ctrl_ID,a_EX,b_EX,imm_EX,ctrl_EX,ctrl_MEM,ctrl_WB;
reg [31:0] y_EX,bm_EX,y_MEM,bm_MEM;
reg [31:0] y_WB,mdr_MEM,mdr_WB,pcd_EX,pcd_MEM,pcd_WB;
reg [4:0] rd_ID,rd_EX,rd_MEM,rd_WB,rs1_ID,rs2_ID,rs1_EX,rs2_EX;
reg pc_en,IFID_en,IFID_flush,IDEX_en,IDEX_flush,EXMEM_en,EXMEM_flush,MEMWB_en,MEMWB_flush,HazardSel; 
reg [1:0] zero;
reg [31:0] control;
reg [31:0] rdata,wdata;   //WB选择器得到的数据
reg [1:0] aforward,bforward;
reg [31:0] adata,bdata;
reg [31:0] op1,op2;
wire [31:0] data;
wire [7:0] pc_s;
wire [31:0] inst;
wire [31:0] wd;
wire [31:0] ra,rb;      //寄存器堆读出的值
wire [31:0] wop1,wop2,ALUout;  //ALU加数
wire z;

assign pc=pc_ID;
assign pcd=pcd_ID;
assign pcin=pcin_ID;
assign ir=inst_ID;

assign pce=pc_EX;
assign a=a_EX;
assign b=b_EX;
assign imm=imm_EX;
assign rd=rd_EX;
assign ctrl=ctrl_EX;

assign y=y_MEM;
assign bm=bm_MEM;
assign rdm=rd_MEM;
assign ctrlm=ctrl_MEM;

assign yw=y_WB;
assign mdr=mdr_WB;
assign rdw=rd_WB;
assign ctrlw=ctrl_WB;

assign pc_s=pc_IF[9:2];
assign wd=wdata;
assign wop1=op1;
assign wop2=op2;

assign io_dout=bm_MEM;
assign io_addr=y_MEM[7:0];
assign io_we=y_MEM[10]&ctrlm[12];

always@(posedge clk or posedge rst)
begin
  if(rst==1)
    pc_IF<=32'h0;  //复位
  else if(pc_en)
    pc_IF<=pcin_IF;
  else
    pc_IF=pc_IF;
end

always@(*)
begin
if(((zero==2'b0&&ctrl_EX[8])||ctrl_EX[9]||((zero==2'b10||zero==2'b11)&&ctrl_EX[6])||(zero==2'b10&&ctrl_EX[7])||((zero==2'b11||zero==2'b0)&&ctrl_EX[10]))==0)            //决定PC是否跳转
  pcin_IF=pc_IF+4;
else
  pcin_IF=y_EX;
end

dist_mem_gen_0 dist_mem_gen_0(.a(pc_s),.spo(inst));

always@(*)
begin
  inst_IF=inst;
  pcd_IF=pc_IF+4;
end
/*
always@(*)
begin
  if(IFID_flush==0)
    inst_IF=inst;
  else
    inst_IF=0;
end
*/
//IFID
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    pc_ID<=32'b0;
    inst_ID<=32'b0;
    pcd_ID<=32'b0;
    pcin_ID<=32'b0;
  end
  else if(IFID_flush)
  begin
    pc_ID<=32'b0;
    inst_ID<=32'b0;
    pcd_ID<=32'b0;
    pcin_ID<=32'b0;
  end
  else if(IFID_en)
  begin
    pc_ID<=pc_IF;
    inst_ID<=inst_IF;
    pcd_ID<=pcd_IF;
    pcin_ID<=pcin_IF;
  end
  else
  begin
    pc_ID<=pc_ID;
    inst_ID<=inst_ID;
    pcd_ID<=pcd_ID;
    pcin_ID<=pcin_ID;
  end
end


always@(*)
begin
  rd_ID=inst_ID[11:7];
  rs1_ID=inst_ID[19:15];
  rs2_ID=inst_ID[24:20];
end

//control
always@(*)
begin
if(rst==1)
  ctrl_ID=32'b0;
else
 case(inst_ID[6:0])
   7'b0110011:
   begin
   
   if(inst_ID[14:12]==3'b000&&inst_ID[31:25]==7'b0)  //add
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b000&&inst_ID[31:25]==7'b0100000)  //sub
   begin
     ctrl_ID[3:0]=4'b0000;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b100&&inst_ID[31:25]==7'b0000000)  //xor
   begin
     ctrl_ID[3:0]=4'b0100;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b110&&inst_ID[31:25]==7'b0000000)  //or
   begin
     ctrl_ID[3:0]=4'b0011;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b111&&inst_ID[31:25]==7'b0000000)  //and
   begin
     ctrl_ID[3:0]=4'b0010;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b001&&inst_ID[31:25]==7'b0000000)  //sll
   begin
     ctrl_ID[3:0]=4'b0101;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b101&&inst_ID[31:25]==7'b0000000)  //srl
   begin
     ctrl_ID[3:0]=4'b0110;  //aluop
     ctrl_ID[4]=1;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   end
   7'b0010011:      //addi
   begin
   
   if(inst_ID[14:12]==3'b000)   //addi
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=2'b0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b100)   //xori
   begin
     ctrl_ID[3:0]=4'b0100;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=2'b0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b110)   //ori
   begin
     ctrl_ID[3:0]=4'b0011;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=2'b0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b111)   //andi
   begin
     ctrl_ID[3:0]=4'b0010;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=2'b0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b001)   //slli
   begin
     ctrl_ID[3:0]=4'b0101;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=2'b0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   end
   7'b0100011:        //sw
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=1;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=0;   //rf_wr
     ctrl_ID[19]=2'b0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   7'b0000011:            //lw
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=1;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=1;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b01;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   7'b1100011:
   begin
   
   if(inst_ID[14:12]==3'b000)  //beq
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=0;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=1;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=0;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b001)   //bne
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=0;   //a_sel
     ctrl_ID[7:6]=2'b01;  //blt/bne
     ctrl_ID[8]=1;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=0;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b100)   //blt
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=0;   //a_sel
     ctrl_ID[7:6]=2'b10;  //blt/bne
     ctrl_ID[8]=1;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=0;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   else if(inst_ID[14:12]==3'b101)   //bge
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=0;   //a_sel
     ctrl_ID[7:6]=2'b00;  //blt/bne
     ctrl_ID[8]=1;   //br
     ctrl_ID[9]=0;   //jal
     ctrl_ID[11:10]=2'b01;  //10:bge
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b0;  //wb_sel
     ctrl_ID[18]=0;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
   
   end
   7'b1101111:                  //jal
   begin
     ctrl_ID[3:0]=4'b0001;  //aluop
     ctrl_ID[4]=0;   //b_sel
     ctrl_ID[5]=0;   //a_sel
     ctrl_ID[7:6]=2'b0;
     ctrl_ID[8]=0;   //br
     ctrl_ID[9]=1;   //jal
     ctrl_ID[11:10]=2'b0;
     ctrl_ID[12]=0;  //m_wr
     ctrl_ID[13]=0;  //m_rd
     ctrl_ID[15:14]=2'b0;
     ctrl_ID[17:16]=2'b10;  //wb_sel
     ctrl_ID[18]=1;   //rf_wr
     ctrl_ID[19]=0;
     ctrl_ID[21:20]=bforward; //b_fwd
     ctrl_ID[23:22]=2'b0;
     ctrl_ID[25:24]=aforward; //a_fwd
     ctrl_ID[27:26]=2'b0;
     ctrl_ID[28]=IDEX_flush;   //eflush
     ctrl_ID[29]=IFID_flush;   //dflush
     ctrl_ID[30]=~IDEX_en;   //dstall
     ctrl_ID[31]=~IFID_en;   //fstall
   end
endcase
end

//Imm Gen
always@(*)
begin
if(rst)
  imm_ID=32'b0;
else 
case(inst_ID[6:0])
   7'b0010011:          //addi
   begin
   if(inst_ID[14:12]==3'b001)
   begin
   imm_ID[4:0]=inst_ID[24:20];
   imm_ID[31:5]=27'b0;
   end
   else
   begin
     imm_ID[11:0]=inst_ID[31:20];
     if(inst_ID[31]==0)
       imm_ID[31:12]=20'b0;
     else
       imm_ID[31:12]=20'hfffff;
   end
   end
   7'b0100011:          //sw
   begin
     imm_ID[4:0]=inst_ID[11:7];
     imm_ID[11:5]=inst_ID[31:25];
     if(inst_ID[31]==0)
       imm_ID[31:12]=20'b0;
     else
       imm_ID[31:12]=20'hfffff;
   end
   7'b0000011:            //lw
   begin
     imm_ID[11:0]=inst_ID[31:20];
     if(inst_ID[31]==0)
       imm_ID[31:12]=20'b0;
     else
       imm_ID[31:12]=20'hfffff;
   end
   7'b1100011:              //beq
   begin
     imm_ID[0]=0;
     imm_ID[4:1]=inst_ID[11:8];
     imm_ID[10:5]=inst_ID[30:25];
     imm_ID[11]=inst_ID[7];
     imm_ID[12]=inst_ID[31];
     if(inst_ID[31]==0)
       imm_ID[31:13]=19'b0;
     else
       imm_ID[31:13]=19'h7ffff;
   end
   7'b1101111:             //jal
   begin
     imm_ID[0]=0;
     imm_ID[10:1]=inst_ID[30:21];
     imm_ID[11]=inst_ID[20];
     imm_ID[19:12]=inst_ID[19:12];
     imm_ID[20]=inst_ID[31];
     if(inst_ID[31]==0)
       imm_ID[31:21]=11'b0;
     else
       imm_ID[31:21]=11'h7ff;
   end
   default:
     imm_ID=32'b0;
endcase
end

RF RF(.clk(clk),.we(ctrlw[18]),.ra1(ir[19:15]),.ra2(ir[24:20]),.ra3(m_rf_addr[4:0]),.wa(rdw),.rd1(ra),.rd2(rb),.rd3(rf_data),.wd(wd));

always@(*)
begin
  a_ID=ra;
  b_ID=rb;
end

//IDEX
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    pc_EX<=32'b0;
    a_EX<=32'b0;
    b_EX<=32'b0;
    imm_EX<=32'b0;
    rd_EX<=5'b0;
    ctrl_EX<=32'b0;
    pcd_EX<=32'b0;
    rs1_EX<=5'b0;
    rs2_EX<=5'b0;
  end
  else if(IDEX_flush==1||HazardSel==1)
  begin
    pc_EX<=32'b0;
    a_EX<=32'b0;
    b_EX<=32'b0;
    imm_EX<=32'b0;
    rd_EX<=5'b0;
    ctrl_EX<=32'b0;
    pcd_EX<=32'b0;
    rs1_EX<=5'b0;
    rs2_EX<=5'b0;
  end
  else if(IDEX_en)
  begin
    pc_EX<=pc_ID;
    a_EX<=a_ID;
    b_EX<=b_ID;
    imm_EX<=imm_ID;
    rd_EX<=rd_ID;
    ctrl_EX<=ctrl_ID;
    pcd_EX<=pcd_ID;
    rs1_EX<=rs1_ID;
    rs2_EX<=rs2_ID;
  end
  else
  begin
    pc_EX<=pc_EX;
    a_EX<=a_EX;
    b_EX<=b_EX;
    imm_EX<=imm_EX;
    rd_EX<=rd_EX;
    ctrl_EX<=ctrl_EX;
    pcd_EX<=pcd_EX;
    rs1_EX<=rs1_EX;
    rs2_EX<=rs2_EX;
  end
end



always@(*)
begin
   if(aforward==2'b00)
     adata=y_MEM;
   else if(aforward==2'b01)
     adata=a_EX;
   else if(aforward==2'b10)
     adata=wdata;
end 

always@(*)
begin
   if(bforward==2'b00)
     bdata=y_MEM;
   else if(bforward==2'b01)
     bdata=b_EX;
   else if(bforward==2'b10)
     bdata=wdata;
end 

always@(*)
begin
   if(ctrl_EX[5])
     op1=adata;
   else
     op1=pc_EX;
end 

always@(*)
begin
   if(ctrl_EX[4])
     op2=bdata;
   else
     op2=imm_EX;
end 

ALU ALU(.a(wop1),.b(wop2),.y(ALUout),.z(z),.f(ctrl_EX[3:0]));

always@(*)
begin
  y_EX=ALUout;
  bm_EX=bdata;
end
/*
always@(*)
begin
  if(ctrl_EX[8]&&(adata==bdata))
    zero=2'b0;
  else if(ctrl_EX[6]&&(adata!=bdata))
    zero=2'b1;
  else if(ctrl_EX[7]&&(adata<bdata))
    zero=2'b10;
  else if(ctrl_EX[10]&&(adata>=bdata))
    zero=2'b11;
end
*/

always@(*)
begin
  if(adata==bdata)
    zero=2'b0;
  /*  
  else if(adata!=bdata)
    zero=2'b1;
  */
  else if(adata<bdata)
    zero=2'b10;
  else if(adata>bdata)
    zero=2'b11;
end

//EXMEM
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    y_MEM<=32'b0;
    bm_MEM<=32'b0;
    rd_MEM<=5'b0;
    ctrl_MEM<=32'b0;
    pcd_MEM<=32'b0;
  end
  else
  begin
    y_MEM<=y_EX;
    bm_MEM<=bm_EX;
    rd_MEM<=rd_EX;
    ctrl_MEM<=ctrl_EX;
    pcd_MEM<=pcd_EX;
  end
end


dist_mem_gen_1 dist_mem_gen_1(.a(y[7:0]),.d(bm),.we(ctrlm[12]&(~y_MEM[10])),.clk(clk),.dpra(m_rf_addr),.spo(data),.dpo(m_data));

always@(*)
begin
   if(y_MEM[10])
     rdata=io_din;
   else
     rdata=data;
end

always@(*)
begin
   mdr_MEM=rdata;
end

always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    y_WB<=32'b0;
    mdr_WB<=32'b0;
    rd_WB<=5'b0;
    ctrl_WB<=32'b0;
    pcd_WB<=32'b0;
  end
  else
  begin
    y_WB<=y_MEM;
    mdr_WB<=mdr_MEM;
    rd_WB<=rd_MEM;
    ctrl_WB<=ctrl_MEM;
    pcd_WB<=pcd_MEM;
  end
end

always@(*)
begin
    if(ctrlw[17:16]==2'b0)
      wdata=y_WB;
    else if(ctrlw[17:16]==2'b01)
      wdata=mdr_WB;
    else if(ctrlw[17:16]==2'b10)
      wdata=pcd_WB;
end

//Hazard Detection Unit
always@(*)
    begin
        if( (ctrl[13]==1) && ( (rd_EX==ir[24:20]) || (rd_EX==ir[19:15]) ) )
        begin
            pc_en=0;
            IFID_en=0;
            IDEX_en=0;
            HazardSel=1;
        end
        else
        begin
            pc_en=1;
            IFID_en=1;
            IDEX_en=1;
            HazardSel=0;
        end
    end
    
// forwarding Unit
    always@(*)
    if(rst)
    begin
    aforward=2'b00;
    bforward=2'b00;
    end
    else
    begin
            if((ctrlm[18]==1)&&(rd_MEM==rs1_EX)) aforward=2'b00;
            else if((ctrlw[18]==1)&&(rd_WB==rs1_EX)) aforward=2'b10;
            else aforward=2'b01;
            
            if((ctrlm[18]==1)&&(rd_MEM==rs2_EX)) bforward=2'b00;
            else if((ctrlw[18]==1)&&(rd_WB==rs2_EX)) bforward=2'b10;
            else bforward=2'b01;
    end

always@(*)
    begin
        if((zero==2'b0&&ctrl_EX[8])||ctrl_EX[9]||((zero==2'b10||zero==2'b11)&&ctrl_EX[6])||(zero==2'b10&&ctrl_EX[7])||((zero==2'b11||zero==2'b0)&&ctrl_EX[10]))
        begin
            IFID_flush=1;
            IDEX_flush=1;
            //EXMEM_flush=1;
        end
        else
        begin
            IFID_flush=0;
            IDEX_flush=0;
            //EXMEM_flush=0;
        end
    end


endmodule
