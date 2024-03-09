`timescale 1ns / 1ps
module tb_dpram_sync_fifo#(parameter DEPTH=16, DATA_WIDTH=8)(
    );
     
  reg clk, rst_n,
 w_en, r_en,
 cs_w, cs_r;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire full, empty, almost_full, almost_empty;
  integer i;
  dpram_sync_fifo FIFO(.clk(clk), .rst_n(rst_n), .w_en(w_en), 
                        .r_en(r_en), .cs_w(cs_w), .cs_r(cs_r),
                        .data_in(data_in), .data_out(data_out), 
                        .full(full), .empty(empty), .almost_full(almost_full),
                        .almost_empty(almost_empty));
   always #5 clk = ~clk;                     
   
   initial
   begin
   clk=0;
   rst_n = 0;
   w_en=0; r_en=0; cs_w=0; cs_r=0; data_in=0;
    #10
    
    rst_n =1;
    w_en=1; cs_w=1; 
    for(i=0; i<=20; i=i+1)begin
        data_in=$urandom_range(7,0);
        #15;
    end    
    
   r_en=1; cs_r=1;
   for(i=0; i<=20; i=i+1)begin
    data_in=$urandom_range(7,0);
    #15;
   
   end 
   
   
   
   end                     

    
endmodule
