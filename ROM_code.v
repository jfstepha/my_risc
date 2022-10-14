module ROM_code(out, addr, CS);
output[31:0] out;
input[31:0] addr;
input CS;
reg [31:0] out;
reg [31:0] ROM[32'h1000000:0];
always @(posedge CS)
begin
ROM[32'h0] <=32'h00000093; // li      ra,0
ROM[32'h4] <=32'h00000113; // li      sp,0
ROM[32'h8] <=32'h00000193; // li      gp,0
ROM[32'hc] <=32'h00200193; // li      gp,2
ROM[32'h10]<=32'h00ff07b7; // lui     a5,0xff0
ROM[32'h14]<=32'h0ff78793; // addi    a5,a5,255
ROM[32'h18]<=32'h00002097; // auipc   ra,0x2
ROM[32'h1c]<=32'he8008093; // addi    ra,ra,-384
ROM[32'h20]<=32'h0000a703; // lw      a4,0(ra)
ROM[32'h24]<=32'h00ff03b7; // lui     t2,0xff0
ROM[32'h28]<=32'h0ff38393; // addi    t2,t2,255
ROM[32'h2c]<=32'h2a771663; // bne     a4,t2,80000440 <fail>




out<=ROM[addr];
end
endmodule

// a good start test might be rv32ui-p-lw
