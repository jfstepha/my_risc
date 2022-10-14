module control (
    input clk, 
    input [31:0] instr,
    output [4:0] rd,
    output [2:0] funct3,
    output [4:0] rs1,
    output [4:0] rs2,
    output [31:0] imm,
    output ImmSel,
    output Op2Sel,
    output RegWriteEn
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
            rs1 = instr[19:15];
            rs2 = 0;
            imm[11:0] = instr[31:20];
            imm[31:12] = 0;
            ImmSel = 0; // IType12
            Op2Sel = 0; // Imm
            RegWriteEn = 1;
            $display ("[%0t]  control:I type",$time);

          end
        default:
          begin
            itype ="Unknown";
            rd = 5'b11111;
            funct3 = 3'b111;
            rs1 =  5'b11111;
            rs2 =  5'b11111;
            imm = 32'hFFFFFFFF;
            ImmSel = 1;
            Op2Sel = 1; // Reg
            RegWriteEn = 0;
            $display ("[%0t]  control:Default",$time);
          end
    endcase
    // $display("[%0t]  control clocked", $time);
end
always @ (*)
    $display("[%0t]  control: instr=0x%x opcode=0x%x itype=%s funct3=0x%x rd=0x%x rs1=0x%x rs2=0x%x imm=0x%x ImmSel=%d, Op2Sel=%d", 
      $time, instr, opcode, itype, funct3, rd, rs1, rs2, imm, ImmSel, Op2Sel); 

endmodule
