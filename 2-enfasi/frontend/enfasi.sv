`timescale 1ns / 1ps
module enfasi (
  input  logic clk, rst,
  input  logic signed [10:0] z,
  output logic signed [11:0] q
);

logic signed [11:0] collegamento;

aso aso (.clk(clk), .rst(rst), .z(z), .p(collegamento));
fir fir (.clk(clk), .rst(rst), .p(collegamento), .q(q));

endmodule