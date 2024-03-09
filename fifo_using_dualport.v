`timescale 1ns / 1ps
module fifo_using_dualport#(parameter depth=16, width=8)(
    input clk, rst,wr_en, rd_en,
    input [7:0] fifo_in, 
    output [7:0] fifo_out,
    output full, empty,almost_full, almost_empty
    );
    //reg [width-1:0] mem[0:depth-1];
    reg [4:0] wr_ptr, rd_ptr;
   // wire [3:0]in, out;
    
    dual_port_ram RAM(.clk(clk),.wr_en(wr_en),.cs(wr_en),
                       .data_in(fifo_in), .addr_in_0(wr_ptr),
                       .addr_in_1(rd_ptr),.port_en_0(port_en_0), 
                       .port_en_1(port_en_1),
                       .data_out_0(d_out_0), .data_out_1(fifo_out) );  
                       
    assign port_en_0=1;
    assign port_en_1=1;                                 
                       
    always @(posedge clk)
    begin
        if(rst)begin
            wr_ptr<=4'h0;
            
        end else if(wr_en==1 && port_en_0==1 && !full)begin
            //wr_ptr-1<=in;
            //addr_in_0[wr_ptr]<=fifo_in;
            wr_ptr<= wr_ptr+1; 
            end
    end 
      
    
    always @(posedge clk)
    begin
        if(rst)
         rd_ptr<=4'h0;
         else if(rd_en==1 && port_en_1==1 && !empty)begin
            //out<= mem[rd_ptr-1];
            rd_ptr<=rd_ptr+1;
        end
    end   
    
  assign full = (wr_ptr[4:0] == rd_ptr[4:0]) & (wr_ptr[5] ^ rd_ptr[5]); 
  assign empty = (wr_ptr == rd_ptr);

  assign almost_empty = ((wr_ptr-rd_ptr)<=4);
  assign almost_full  = ((wr_ptr-rd_ptr)>=(depth-4));
    
endmodule