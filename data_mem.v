`include "Parameter.v"
module data_mem(
    input clk,
    input we,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata
);

reg[7:0] memory[32'h8000:0];

initial begin 
    $readmemh(`filename_data, memory, `data_start_addr);
    $display (" mem 0x%x = 0x%x", `data_start_addr, memory[`data_start_addr]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+1, memory[`data_start_addr+1]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+2, memory[`data_start_addr+2]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+3, memory[`data_start_addr+3]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+4, memory[`data_start_addr+4]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+5, memory[`data_start_addr+5]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+6, memory[`data_start_addr+6]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+7, memory[`data_start_addr+7]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+8, memory[`data_start_addr+8]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+9, memory[`data_start_addr+9]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+10, memory[`data_start_addr+10]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+11, memory[`data_start_addr+11]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+12, memory[`data_start_addr+12]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+13, memory[`data_start_addr+13]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+14, memory[`data_start_addr+14]);
    $display (" mem 0x%x = 0x%x", `data_start_addr+15, memory[`data_start_addr+15]);
end    

always @ (posedge clk) begin
    if(we) begin
      $display("[%t] mem: writing 0x%x to 0x%x", $time, wdata, addr);
      memory[addr] <= wdata[7:0];
      memory[addr+1] <= wdata[15:8];
      memory[addr+2] <= wdata[23:16];
      memory[addr+3] <= wdata[31:24];
    end
end

//assign rdata = memory[addr];
assign rdata = {memory[addr+3],memory[addr+2],memory[addr+1],memory[addr]};
endmodule




