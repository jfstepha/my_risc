module alu (
    input [2:0] alu_ctl,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] o,
    output zero
);

always @ (*)
begin
    case( alu_ctl )
    3'b000 : o = a + b; // add
    3'b001 : o = a - b; // sub
    3'b010 : o = ~a; 
    3'b011 : o = a << b; // shift left
    3'b100 : o = a >> b; // shirt right
    3'b101 : o = a & b; // and
    3'b110 : o = a | b; // or
    3'b111 : begin
        if (a<b) o = 32'd1;
        else o = 32'd0;
    end
    default: o = a + b;
    endcase
end
assign zero = (o == 32'd0) ? 1'b1 : 1'b0;

endmodule