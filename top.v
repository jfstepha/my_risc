// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2003 by Wilson Snyder.
// ======================================================================

// This is intended to be a complex example of several features, please also
// see the simpler examples/hello_world_c.

module top
  (
   // Declare some signals so we can see how I/O works
   input         clk,
   input         fastclk,
   input         reset_l,

   // for debug
   output [31:0] pc,
   output [31:0] instr,
   output [31:0] pc_new,
   output [4:0] rd,
   output [4:0] rs1,
   output [4:0] rs2,
   output [31:0]  imm,
   output [31:0] op2
   );

   // Connect up the outputs, using some trivial logic
   reg [31:0]   pc;
   reg [31:0]   pc_new;
   wire [31:0]   instr;
   reg [1:0]    PCSel;
   reg [31:0]   pc_plus4;
   reg [31:0]   pc_branch;
   wire [4:0]   rd;
   wire [2:0]  funct3;
   wire [6:0]  funct7;
   wire [4:0]   rs1;
   wire [4:0]   rs2;
   wire [31:0]  imm;
   wire [31:0]  op1;
   wire [31:0]  op2;
   wire [31:0]  wbdat;
   wire [31:0]  rfdat1;
   wire [31:0]  rfdat2;
   wire [2:0]   ALU_Ctl;
   wire [1:0]   WBSel;
   wire alu_zero;
   wire ImmSel;
   wire Op2Sel;
   wire Op1Sel;
   wire RegWriteEn;
   wire [6:0] opcode;
   wire [31:0] alu_out;
   wire MemWrite;
   wire MemRdSignExtend;
   wire [31:0] mem_rdata;
   wire [31:0] mem_rdata_extended;


   always 
     pc_plus4 = pc + 4;
   
   // The ROM currently contains the code
   ROM_code rom( 
            .out   (instr),
            .addr  (pc),
            .CS    (clk));

   // The program counter register
   always @ (posedge clk)
   begin
     pc <= pc_new;
   end

  // Program Counter MUX
   mux4 pcMux(
         .sel   (PCSel),
         .out   (pc_new),
         .a     (pc_plus4),
         .b     (pc_branch),
         .c     (0),
         .d     (0));
  // Control unit
  control control(
    .clk (clk),
    .instr (instr),
    .rd (rd),
    .funct3 (funct3),
    .funct7 (funct7),
    .rs1 (rs1),
    .rs2 (rs2),
    .imm (imm),
    .ImmSel (ImmSel),
    .Op2Sel (Op2Sel),
    .Op1Sel (Op1Sel),
    .RegWriteEn (RegWriteEn),
    .WBSel (WBSel),
    .opcode (opcode),
    .MemWrite(MemWrite),
    .MemRdSignExtend(MemRdSignExtend),
    .PCSel(PCSel)
  );
  mux2 op1mux(
    .out(op1),
    .sel(Op1Sel),
    .a(pc),
    .b(rfdat1)
  );

  mux2 op2mux( 
    .out (op2),
    .sel (Op2Sel),
    .a (imm),
    .b (rfdat2)
  );

  regfile regfile(
    .clk (clk),
    .we (RegWriteEn),
    .rs1 (rs1),
    .rs2 (rs2),
    .waddr (rd),
    .wdat (wbdat),
    .rdat1 (rfdat1),
    .rdat2 (rfdat2)
  );

  aluctl aluctl(
    .ALU_Ctl(ALU_Ctl),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7)
  );

  alu alu(
    .alu_ctl(ALU_Ctl),
    .a(op1),
    .b(op2),
    .o(alu_out),
    .zero(alu_zero)
  );

  MemSignExtender MemSignExtender(
    .RawMem(mem_rdata),
    .funct3(funct3),
    .MemRdSignExtend(MemRdSignExtend),
    .ExtendedMem(mem_rdata_extended)
  );

  // Write back mux
  mux4 wbmux (
    .sel(WBSel),
    .out(wbdat),
    .a(mem_rdata_extended),       // from Data Mem
    .b(alu_out), // from ALU
    .c(pc_new), // from PC
    .d(0)        // nc 


  );

  data_mem data_mem(
    .clk(clk),
    .we(MemWrite),
    .addr(alu_out),
    .wdata(rfdat2),
    .rdata(mem_rdata)
  );

  branch_logic branch_logic(
    .d1(rfdat1),
    .d2(rfdat2),
    .imm(imm),
    .pc(pc),
    .pc_new(pc_branch),
    .funct3(funct3)
  );


   // Print startup message
   initial begin
      pc = 32'h0;
      $display("[%0t] Model running...\n", $time);
   end

endmodule

