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
    output MemWrite
);

reg [6:0] opcode;
string itype;

always @ ( * ) begin
    opcode = instr[6:0];
    case (instr[6:0])

       7'h13 :  // I type
          begin
            itype = "I";
            rd = instr[11:7];
            funct3 = instr[14:12];
            funct7 = 7'b0000000;
            rs1 = instr[19:15];
            rs2 = 0;
            imm[11:0] = instr[31:20];
            imm[31:12] = 0;
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            $display ("[%0t]  control:I type",$time);
          end
       7'h1b :  // I type
          begin
            itype = "I";
            rd = instr[11:7];
            funct3 = instr[14:12];
            funct7 = 7'b0000000;
            rs1 = instr[19:15];
            rs2 = 0;
            imm[11:0] = instr[31:20];
            imm[31:12] = 0;
            ImmSel = 0; // IType12
            Op1Sel = 1; // Reg
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            WBSel = 2'b01; // ALU
            MemWrite = 0;
            $display ("[%0t]  control:I type",$time);
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
            $display ("[%0t]  control:U type",$time);
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
            $display ("[%0t]  control:U type",$time);
          end
        default:
          begin
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
            $display ("[%0t]  control:Default",$time);
          end
    endcase
    // $display("[%0t]  control clocked", $time);
end
always @ (*)
    $display("[%0t]  control: instr=0x%x opcode=0x%x itype=%s funct3=0x%x rd=0x%x rs1=0x%x rs2=0x%x imm=0x%x ImmSel=%d, Op2Sel=%d", 
      $time, instr, opcode, itype, funct3, rd, rs1, rs2, imm, ImmSel, Op2Sel); 

endmodule
