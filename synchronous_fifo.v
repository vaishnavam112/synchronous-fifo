`timescale 1ns/1ps

module synchronous_fifo #(parameter DEPTH=16, DATA_WIDTH=8) (
  input clk, rst_n,
  input w_en, r_en,
  input [DATA_WIDTH-1:0] data_in,
  output [DATA_WIDTH-1:0] data_out,
  output full, empty, almost_full, almost_empty
);
  
  localparam PTR_WIDTH = $clog2(DEPTH);
  
  reg [PTR_WIDTH:0] w_ptr, r_ptr; // additional bit to detect full/empty condition
  
  reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1]; //fifo memory
  
  reg [DATA_WIDTH-1:0] temp_data_out;
  
  // Counter for write pointer
  always@(posedge clk) begin
    if(!rst_n)
      w_ptr <= 0;
    else if(w_en & !full)
      w_ptr <= w_ptr + 1;
  end
  
    // Counter for read pointer
  always@(posedge clk) begin
    if(!rst_n)
      r_ptr <= 0;
    else if(r_en & !empty)
      r_ptr <= r_ptr + 1;
  end

  // Write operation
  always@(posedge clk) begin
    if(w_en & !full)
      fifo[w_ptr[PTR_WIDTH-1:0]] <= data_in;
  end
  
  // Read operation
  always@(posedge clk) begin
    if(r_en & !empty)
      temp_data_out <= fifo[r_ptr[PTR_WIDTH-1:0]];
  end
  
  assign data_out = (r_en)? temp_data_out : 'hz;
  
  //Full condition: MSB of write and read pointers are different and remainimg bits are same.
  assign full = (w_ptr[PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0]) & (w_ptr[PTR_WIDTH] ^ r_ptr[PTR_WIDTH]); // To check MSB of write and read pointers are different
  
  //Empty condition: All bits of write and read pointers are same.
  //assign empty = (w_ptr[PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0]) & ~(w_ptr[PTR_WIDTH] ^ r_ptr[PTR_WIDTH]); 
  //or
  assign empty = (w_ptr == r_ptr);

  assign almost_empty = ((w_ptr-r_ptr)<=4);
  assign almost_full  = ((w_ptr-r_ptr)>=(DEPTH-4));

endmodule