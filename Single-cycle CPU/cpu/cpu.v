module cpu(clock,reset_n,inst,mem,pc,wmem,alu,data);
input clock;
input reset_n;
input [31:0] inst;
input [31:0] mem;
output [31:0]pc,alu,data;
output wmem;
wire [31:0] p4,bpc,npc,adr,ra,alua,alub,res,alu_mem;

wire [3:0] aluc;
wire [4:0]reg_dest,wn;
wire [1:0]pcsource;
wire zero,wmem,wreg,regrt,m2reg,shift,aluimm,jal,sext;
wire [31:0] offset = {imm[13:0],inst[15:0],2'b00};

cpu_control_single control(inst[31:26],inst[5:0],zero, wmem,wreg , regrt , m2reg , aluc , shift , aluimm, pcsource,jal,sext);
//用于产生各种内部控制信号

wire e = sext & inst[15];
wire [15:0] imm = {16{e}};
wire [31:0] immediate = {imm,inst[15:0]};
dffe32 ip(npc,clock,reset_n,1'b1,pc);

assign p4 = pc + 32'h4;
//assign p4 = pc + 32'h1;

assign adr = p4 + offset;

wire [31:0]  jpc= {p4[31:28],inst[25:0],2'b00};

mux2x32 alu_b(data,immediate,aluimm,alub);
mux2x32 alu_a(ra,sa,shift,alua);
mux2x32 result(alu,mem,m2reg,alu_mem);
mux2x32 link(alu_mem,p4,jal,res);
mux2x5 reg_wn(inst[15:11],inst[20:16],regrt,reg_dest);

assign wn = reg_dest | {5{jal}};


mux4x32 nextpc(p4,adr,ra,jpc,pcsource,npc);

regfile rf(inst[25:21],inst[20:16],res,wn,wreg,clock,reset_n,ra,data);
alu al_unit(alua,alub,aluc,alu,zero);


endmodule
