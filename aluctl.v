module aluctl(
    output reg[3:0] ALU_Ctl,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7
);

wire [16:0] ALUCtl_in;

assign ALUCtl_in = {funct7,funct3,opcode};
always @ (ALUCtl_in) 
casez (ALUCtl_in)
    17'b???????_???_?????10 : ALU_Ctl =  4'b0000;  // 16 bit instruction
    17'b???????_???_0000011 : ALU_Ctl =  4'b0000;  // Load: Add
    17'b???????_000_0010011 : ALU_Ctl =  4'b0000;  // ADDI: Add
    17'b???????_000_0010111 : ALU_Ctl =  4'b0000;  // AUIPC: Add
    17'b???????_000_0011011 : ALU_Ctl =  4'b0000;  // ADDIW: Add
    17'b???????_000_0110111 : ALU_Ctl =  4'b0000;  // LUI: Add
    17'b???????_001_0010011 : ALU_Ctl =  4'b0011;  // Shift Left
    17'b0000000_000_0110011 : ALU_Ctl =  4'b0000;  // Add
    17'b0100000_000_0110011 : ALU_Ctl =  4'b0001;  // Sub
    17'b0000000_001_0110011 : ALU_Ctl =  4'b0011;  // Shift Left
    17'b0000000_010_0110011 : ALU_Ctl =  4'b0111;  // Set Less Than
    17'b0000000_011_0110011 : ALU_Ctl =  4'b0000;  // Set Less Than unsigned 
    17'b0000000_100_0110011 : ALU_Ctl =  4'b1010;  // xor
    17'b0000000_101_0110011 : ALU_Ctl =  4'b0110;  // or
    17'b0000000_111_0110011 : ALU_Ctl =  4'b0101;  // and
    
    

    default: ALU_Ctl = 4'b1111;
endcase

endmodule