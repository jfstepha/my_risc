module pcReg(reset, CLK, D, Q);
    input reset;
    input CLK;
    parameter N=32;
    input [N-1:0] D;
    output [N-1:0] Q;
    reg [N-1:0] Q;

    always @(posedge CLK, posedge reset ) 
        if (reset)
            Q<=0;
        else if (CLK == 1)
            Q<=D;
endmodule
