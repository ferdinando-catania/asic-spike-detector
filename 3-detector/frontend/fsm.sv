`timescale 1ns/1ps
module fsm(input logic clk, rst,
          input logic signed [11:0] q, soglia,
          output logic spike);

typedef enum logic [2:0] {S0, S1, S2, S3, S4, Z2, Z3} stato_t;
stato_t stato_corrente, stato_futuro;

//localparam logic signed [11:0] soglia  = 12'sb000000000111; //7*10^-3
logic r;

always_comb
begin
    if (q>soglia)
        r = 1'b1;
    else 
        r = 1'b0;
end 

always_ff @ (posedge clk)
    if (rst)
        stato_corrente <= S0;
    else
        stato_corrente <= stato_futuro;

always_comb //in questo caso begin/end non è necessario visto che c'è solo il case
  case (stato_corrente)
    S0: if (r==1'b1)
            stato_futuro = S1;
        else 
            stato_futuro = S0;
    S1: if (r==1'b1)
            stato_futuro = S2;
        else
            stato_futuro = Z2;
    S2: if (r==1'b1)
            stato_futuro = S3;
        else
            stato_futuro = Z3;
    S3: if (r==1'b1)
            stato_futuro = S4;
        else
            stato_futuro = S4;
    S4: if (r==1'b1)
            stato_futuro = S4;
        else
            stato_futuro = S0;
    Z2: if (r==1'b1)
            stato_futuro = Z3;
        else 
            stato_futuro = S0;
    Z3: if (r==1'b1)
            stato_futuro = S4;
        else
            stato_futuro = S0;
    default: stato_futuro = S0;
  endcase  

assign spike = (stato_corrente==S4);



endmodule
