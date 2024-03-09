`timescale 1ns / 1ps
module tb_fifo_using_dualport#(parameter depth=16, width=8)();
    reg clk, rst,wr_en, rd_en;
    reg [7:0] fifo_in;
    wire fifo_out;
    wire full, empty,almost_full, almost_empty;
    
    fifo_using_dualport fifo(.clk(clk), .rst(rst), .wr_en(wr_en),
                        .rd_en(rd_en), .fifo_in(fifo_in), .fifo_out(fifo_out),
                        .full(full), .empty(empty), .almost_full(almost_full), .almost_empty(almost_empty));
                        
    always #5 clk=~clk;
    
    initial 
    begin
    clk=0;
    rst=1;
    wr_en=0; rd_en=0;
    fifo_in=0; 
    #15
    rst=0;
    wr_en=1;
    fifo_in=7'h6;
    #20  rd_en=1;
    fifo_in=7'h34;
    #20
    fifo_in=7'h24; #20
    fifo_in=7'h31; #20
    fifo_in=7'h22; #20
    fifo_in=7'h35;#20
    fifo_in=7'h12;#20
    fifo_in=7'h27;#20
    #150;
    $finish;
    
    end                    
    
    
endmodule
