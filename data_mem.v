module data_mem(
    input clk,
    input we,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata
);

reg[31:0] memory[32'h8000:0];

initial begin
    memory[32'h2000] = 32'h00ff;
    memory[32'h2002] = 32'h00ff;
    memory[32'h2004] = 32'hff00;
    memory[32'h2006] = 32'hff00;
    memory[32'h2008] = 32'h0ff0;
    memory[32'h200a] = 32'h0ff0;
    memory[32'h200c] = 32'hf00ff00f;
end

always @ (posedge clk) begin
    if(we) 
      memory[addr] <= wdata;
end
assign rdata = memory[addr];
endmodule




