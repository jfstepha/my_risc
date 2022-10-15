module regfile
(
    input clk,
    input we,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] waddr, 
    input [31:0] wdat,
    output [31:0] rdat1,
    output [31:0] rdat2   
);

reg[31:0] reg_array[31:0];

integer i;

initial begin
  for( i=0; i<32; i++ )
    reg_array[i] = 0;
end

assign rdat1 = reg_array[rs1];
assign rdat2 = reg_array[rs2];

always @ (negedge clk) begin
    if (we) begin
        if (waddr > 0) begin
           reg_array[waddr] <= wdat;
           //$display("[%0t]  regfile: wrote 0x%x to reg 0x%x", $time, wdat, waddr);
        end
    end
    //$display("[%0t]  regfile: read r1[0x%x]=0x%x r2[0x%x]=0x%x", $time, rs1, rdat1, rs2, rdat2 );
end

endmodule
