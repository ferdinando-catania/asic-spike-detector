`timescale 1ns/1ps
module tb_ser_par();

logic clk=1'b0, rst,enable, din;
logic signed [11:0] soglia;
localparam T=10ns;
localparam d1=T/5;
localparam  signed [11:0] test_value=12'sb011001011101;

ser_par DUT (.*);

always
  #(T/2) clk= ~clk;

initial begin
 rst=1'b1; enable=1'b0; din=1'b0;
 #(T/2);
 #d1;
 rst=1'b0;
 #(2*T);
 enable = 1'b1;
 for (int k=11; k>=0; k--) begin
  // dato MSB first
  din = test_value[k];
  #T;
 end
 enable =1'b0;
 #T
 if (soglia==test_value) begin
  $display("");
  $display("***********************************************");
  $display("**** Simulazione terminata. Nessun errore *****");
  $display("***********************************************");
  $display("");
 end else begin
  $display("");
  $display("***********************************************");
  $display("**** ERRORE ***********************************");
  $display("****  Valore atteso per la soglia: %b", test_value);
  $display("**** Valore prodotto dal circuito: %b", soglia);
  $display("***********************************************");
  $display("");
 end
 $finish;
end  

endmodule