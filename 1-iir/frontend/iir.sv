`timescale 1ns / 1ps
module iir (
  input  logic clk, rst,
  input  logic signed [10:0] x,
  output logic signed [10:0] z
);

  logic signed [10:0] in_reg1;
  logic signed [10:0] coll_reg;

  always_ff@(posedge clk) begin
    if(rst)
      in_reg1 <= 11'b0;
    else
      in_reg1 <= x;
  end

  iir_section1 section_1 (.clk(clk), .rst(rst), .x(in_reg1), .y(coll_reg));
  iir_section2 section_2 (.clk(clk), .rst(rst), .x(coll_reg), .y(z));



endmodule
