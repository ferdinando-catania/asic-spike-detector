`timescale 1ns/1ps
module top (input logic clk, rst,
            input logic enable, din,
            input logic signed [10:0] x,
            output logic spike);

logic signed [10:0] z; //uscita filtro
logic signed [11:0] q; //uscita enfasi

iir blocco1 (.clk(clk), .rst(rst), .x(x), .z(z));
enfasi blocco2 (.clk(clk), .rst(rst), .z(z), .q(q));
detector blocco3 (.clk(clk), .rst(rst), .q(q), .din(din), .enable(enable), .spike(spike));

endmodule

