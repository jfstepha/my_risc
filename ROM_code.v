module ROM_code(out, addr, CS);
output[31:0] out;
input[31:0] addr;
input CS;
reg [31:0] ROM[32'h1000000:0];

initial begin 
    $readmemh("./tests/rv64ui-p-lw.prog", ROM);
end    

assign out=ROM[addr >> 2];

endmodule

// a good start test might be rv32ui-p-lw
// following rv64ui-p-lw, because that's what I ran

