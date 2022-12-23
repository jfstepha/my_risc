module alu (
    input [3:0] alu_ctl,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] o,
    output zero
);

always @ (*)
begin
    case( alu_ctl )
    4'b0000 : o = a + b; // add
    4'b0001 : o = a - b; // sub
    4'b0010 : o = ~a; 
    4'b0011 : o = a << b; // shift left
    4'b0100 : o = a >> b; // shirt right
    4'b0101 : o = a & b; // and
    4'b0110 : o = a | b; // or
    4'b0111 : begin // LT
        if (a<b) o = 32'd1;
        else o = 32'd0;
    end
    4'b1001 : begin  // LTU TODO: what is this?
        if (a<b) o = 32'd1;
        else o = 32'd0;
    end
    4'b1010 : o = a ^ b; // xor
    default: o = a + b;
    endcase
end
assign zero = (o == 32'd0) ? 1'b1 : 1'b0;

endmodule