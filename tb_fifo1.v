`timescale 1ns / 1ps
module tb_fifo1 #(parameter width=8, depth=16)();
   
    reg clk, rst, wr_en, rd_en;
    reg [width-1:0]datain;
    wire [width-1:0]dataout;
    wire full,empty;
    
    fifo1 uut(.clk(clk), .rst(rst), .wr_en(wr_en),
               .rd_en(rd_en), .datain(datain), .dataout(dataout),
               .full(full), .empty(empty));
               
     always #5 clk= ~clk;
     integer i;
    
     initial
     begin
         clk=0;
         datain=8'h0;
         rst=1;
         wr_en=0; rd_en=0;
         #10
         
         rst=0; wr_en=1; rd_en=1;
         datain=8'h11; #13
         datain=8'h7; #14
         datain=8'h5; #16
         datain=8'h64; #14
          for(i=0; i<40; i=i+1)
          begin
            datain=$urandom_range(7,0);
            #13;
          end
          
     #150     
         
     $finish;
     
     end          
    
    
endmodule
