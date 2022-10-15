module branch_logic (
    input [31:0] d1,
    input [31:0] d2,
    input [31:0] imm,
    input [31:0] pc,
    input [2:0] funct3,
    output [31:0] pc_new
);

reg condition;

always @ (*) begin
    case(funct3)
      3'b000 : /* beq */ condition = d1 == d2;
      3'b001 : /* bne */ condition = d1 != d2;
      3'b010 : /* blt */ condition = d1 < d2; 
      3'b100 : /* blt */ condition = d1 < d2;
      3'b101 : /* bge */ condition = d1 >= d2;
      default: condition = 0;
    endcase
end


assign pc_new = condition ? pc + imm : pc + 4;

endmodule