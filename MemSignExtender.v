module MemSignExtender( 
    input [31:0] RawMem,
    input [2:0]  funct3,
    input MemRdSignExtend,
    output [31:0] ExtendedMem
    );

always @ (*) begin
    if (MemRdSignExtend) begin
        case(funct3) 
            3'b000 :  ExtendedMem = { RawMem[7]  ? 24'hffffff : 24'b0  , RawMem[7:0]  };  // byte
            3'b001 :  ExtendedMem = { RawMem[15] ? 16'hffff   : 16'b0  , RawMem[15:0] };  // half byte
            3'b010 :  ExtendedMem = RawMem[31:0];   // word
            default : ExtendedMem = RawMem[31:0];
        endcase
    end
    else
        ExtendedMem = RawMem[31:0];
end

endmodule

