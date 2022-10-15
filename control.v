module control (
    input clk, 
    input [31:0] instr,
    output [4:0] rd,
    output [2:0] funct3,
    output [6:0] funct7,
    output [4:0] rs1,
    output [4:0] rs2,
    output [31:0] imm,
    output ImmSel,
    output Op1Sel,
    output Op2Sel,
    output RegWriteEn,
    output [1:0] WBSel,
    output [6:0] opcode,
    output MemWrite,
    output MemRdSignExtend,
    output [1:0]PCSel
);

reg [6:0] opcode;
string itype;

always @ ( * ) begin
    opcode = instr[6:0];
    case (instr[6:0])

       7'h3 :  // I type - load
          begin
            itype = "I";
            rd = instr[11:7];
            funct3 = instr[14:12];
            funct7 = 7'b0000000;
            rs1 = instr[19:15];
            rs2 = 0;
            imm[11:0] = instr[31:20];
            imm[31:12] = instr[31] ? 20'hfffff : 20'h0;   // sign extended
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b00; // Mem
            MemWrite = 0;
            MemRdSignExtend = 1;
            PCSel = 2'h0; // next
            //$display ("[%0t]  control:I type",$time);
          end
       7'h13 :  // I type - math byte?
          begin
            itype = "I";
            rd = instr[11:7];
            funct3 = instr[14:12];
            funct7 = 7'b0000000;
            rs1 = instr[19:15];
            rs2 = 0;
            imm[11:0] = instr[31:20];
            imm[31:12] = instr[31] ? 20'hfffff : 20'h0;   // sign extended
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h0; // next
            //$display ("[%0t]  control:I type",$time);
          end
       7'h1b :  // I type - math word?
          begin
            itype = "I";
            rd = instr[11:7];
            funct3 = instr[14:12];
            funct7 = 7'b0000000;
            rs1 = instr[19:15];
            rs2 = 0;
            imm[11:0] = instr[31:20];
            imm[31:12] = instr[31] ? 20'hfffff : 20'h0;   // sign extended
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h0; // next
            //$display ("[%0t]  control:I type",$time);
          end
        7'h17 :  // U type - auipc
          begin
            itype = "U";
            rd = instr[11:7];
            funct3 = 3'b000;
            funct7 = 7'b0000000;
            rs1 = 0;
            rs2 = 0;
            imm[31:12] = instr[31:12];
            imm[11:0] = 0;
            ImmSel = 0; // IType12
            Op1Sel = 0; // PC
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h0; // next
            //$display ("[%0t]  control:U type",$time);
          end
        7'h37 :  // U type - lui
          begin
            itype = "U";
            rd = instr[11:7];
            funct3 = 3'b000;
            funct7 = 7'b0000000;
            rs1 = 0;
            rs2 = 0;
            imm[31:12] = instr[31:12];
            imm[11:0] = 0;
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h0; // next
            //$display ("[%0t]  control:U type",$time);
          end
        7'h63 :  // SB type - branch
          begin
            itype = "SB";
            rd = 0;
            funct3 = instr[14:12];
            funct7 = 7'b0000000;
            rs1 = instr[19:15];
            rs2 = instr[24:20];
            imm[31:11] = imm[12] ? 21'h1fffff : 21'h0;
            imm[12:0] = {instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 1; // Reg
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h1; // branch
            //$display ("[%0t]  control:SB type",$time);
          end        
        7'h6f :  // UJ type - JAL 
          begin
            itype = "SB";
            rd = instr[11:7];
            funct3 = 3'b0;
            funct7 = 7'b0000000;
            rs1 = 0;
            rs2 = 0;
            imm[20] = instr[31];
            imm[10:1] = instr[30:21];
            imm[11] = instr[20];
            imm[19:12] = instr[19:12];
            imm[31:21] = imm[20] ? 11'h7ff : 11'h0;
            imm[0] = 0;
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 1; // Reg
            RegWriteEn = 1;
            WBSel = 2'b10; // PC_new
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h1; // branch
            // $display ("[%0t]  control:SB type",$time);
          end        
        default:
          begin // noop
            itype ="Unknown";
            rd = 5'b11111;
            funct3 = 3'b111;
            funct7 = 7'b1111111;
            rs1 =  5'b11111;
            rs2 =  5'b11111;
            imm = 32'hFFFFFFFF;
            ImmSel = 1;
            Op1Sel = 1; // Reg
            Op2Sel = 1; // Reg
            RegWriteEn = 0;
            MemWrite = 0;
            MemRdSignExtend = 0;
            PCSel = 2'h0; // next
            $display ("[%0t]  control:Default",$time);
          end
    endcase
    // $display("[%0t]  control clocked", $time);
end
always @ (*)
  if(itype == "asdfd") begin   /// this is so the compiler doesn't complain about unused variables
     $display("asdfasdf");
  end
    //$display("[%0t]  control: instr=0x%x opcode=0x%x itype=%s funct3=0x%x rd=0x%x rs1=0x%x rs2=0x%x imm=0x%x ImmSel=%d, Op2Sel=%d", 
    //  $time, instr, opcode, itype, funct3, rd, rs1, rs2, imm, ImmSel, Op2Sel); 
endmodule
