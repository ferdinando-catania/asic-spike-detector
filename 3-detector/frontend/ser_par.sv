`timescale 1ns/1ps
module ser_par(
    input  logic clk, rst,         // Clock e Reset
    input  logic enable, din,      // Enable e ingresso seriale
    output logic signed [11:0] soglia // Uscita parallela signed Q2.10
);

logic signed [11:0] tmp;

// Shift register per caricare MSB first
always_ff @(posedge clk) begin
    if (rst) 
        tmp <= 12'sb0; 
        //soglia <= 12'b0;
    else if (enable) 
        tmp [11:1] <= tmp [10:0]; //Shift a sinistra
        tmp [0] <= din; 
        //soglia <= signed'({soglia[10:0],din}); //SHift a sinistra con casting per inserire din dal lato di LSB
end
assign soglia = tmp;
endmodule
