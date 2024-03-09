`timescale 1ns / 1ps
module fifo1 #(parameter width=8, depth=16)(
    input clk, rst, wr_en, rd_en,
    input [width-1:0]datain,
    output reg [width-1:0]dataout,
    output full,empty
    );
    
    reg [width-1:0] mem[0:depth-1];
    reg [3:0] wr_ptr, rd_ptr;
    
    always @(posedge clk)
    begin
        if(rst)begin
            wr_ptr <= 4'h0;
            rd_ptr <= 4'h0;
            dataout <= 8'h0;
        end    
        else begin
            wr_ptr <= wr_ptr+1;
            rd_ptr <= rd_ptr+1; end
            
        if(wr_ptr==4'b1111)
            $display("MEM Full");
        if(rd_ptr==wr_ptr==4'h0)
            $display("MEM Empty");    
                
    end
    
    always @(posedge clk)
    begin
        if(wr_en & !full)begin
            mem[wr_ptr-1]<= datain;
            wr_ptr <= wr_ptr+1;
        end            
    end
    
    always @(posedge clk)
    begin
        if(rd_en & !empty)begin
            dataout <= mem[rd_ptr-1];
            rd_ptr <= rd_ptr+1;
        end   
    end
    
    assign full= ((wr_ptr+1) & rd_ptr);
    assign empty= (rd_ptr+1==wr_ptr);
endmodule
