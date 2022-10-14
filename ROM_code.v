module ROM_code(out, addr, CS);
output[31:0] out;
input[31:0] addr;
input CS;
reg [31:0] out;
reg [31:0] ROM[32'h1000000:0];
always @(posedge CS)
begin
ROM[32'h0]<=32'h00000093; 
ROM[32'h4]<=32'h00000113; 
ROM[32'h8]<=32'h00000193; 
ROM[32'hc]<=32'h00000213; 
out<=ROM[addr];
end
endmodule
