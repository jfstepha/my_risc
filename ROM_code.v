module ROM_code(out, addr, CS);
output[31:0] out;
input[31:0] addr;
input CS;
reg [31:0] out;
reg [31:0] ROM[32'h1000000:0];
always @(posedge CS)
begin
ROM[32'h16c] <=32'h00000093; // li      ra,0
ROM[32'h170] <=32'h00000113; // li      sp,0
ROM[32'h174] <=32'h00000193; // li      gp,0
ROM[32'h178] <=32'h00200193; // li      gp,2
ROM[32'h17c] <=32'h00ff07b7; // lui     a5,0xff0
ROM[32'h180] <=32'h0ff7879b; // addiw   a5,a5,255
ROM[32'h184] <=32'h00002097; // auipc   ra,0x2
ROM[32'h188] <=32'he7c08093; // addi    ra,ra,-388
ROM[32'h18c] <=32'h0000a703; // lw      a4,0(ra)
ROM[32'h190] <=32'h00ff03b7; // lui     t2,0xff0
ROM[32'h194] <=32'h0ff3839b; // addiw   t2,t2,255
ROM[32'h198] <=32'h2a771663; // bne     a4,t2,80000444



out<=ROM[addr];
end
endmodule

// a good start test might be rv32ui-p-lw
// following rv64ui-p-lw, because that's what I ran

