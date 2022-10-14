module aluctl(
    output reg[2:0] ALU_Ctl,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7
);

wire [16:0] ALUCtl_in;

assign ALUCtl_in = {funct7,funct3,opcode};
always @ (ALUCtl_in) 
casez (ALUCtl_in)
    17'b???????_???_?????10 : ALU_Ctl =  3'b000;  // 16 bit instruction
    17'b???????_000_0010011 : ALU_Ctl =  3'b000;  // Add
    default: ALU_Ctl = 3'b111;
endcase

endmodule