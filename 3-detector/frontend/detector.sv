`timescale 1ns/1ps
module detector(input logic clk, rst,
               input logic enable, din,
               input logic signed [11:0] q,
               output logic spike);

logic signed [11:0] soglia; //variabile intermedia


ser_par ser_par (.clk(clk), .rst(rst), .enable(enable), .din(din), .soglia(soglia));
fsm fsm (.clk(clk), .rst(clk), .q(q), .soglia(soglia), .spike(spike));

endmodule