`timescale 1ns / 1ps

module aso (
  input  logic clk, rst,
  input  logic signed [10:0] z,
  output logic signed [11:0] p
);

  localparam logic signed [21:0] round_const = signed'({12'b0,1'b1, 9'b0});
  
  logic signed [10:0] z0, z1, z2, z3, z4, t1; //Q1.10
  logic signed [21:0] t2; //Q2.20
  logic signed [11:0] p1; //Q2.10

  logic signed [21:0] tmp1;

  always_ff @ (posedge clk)
    if (rst) begin
      z0 <= 11'b0;
      z1 <= 11'b0;
      z2 <= 11'b0;
      z3 <= 11'b0;
      z4 <= 11'b0;
      p  <= 12'b0; // inizializzo l'uscita p per evitare che ci siano valori indefiniti all'inizio
    end
    else begin
      z0 <= z;
      z1 <= z0;
      z2 <= z1;
      z3 <= z2;
      z4 <= z3;
      p  <= p1;
    end

  always_comb begin
    t1 = z0-z4;
    t2 = t1*z0;
  end

  assign tmp1 = t2 + round_const;
  assign p1 = signed'(tmp1[21:10]);


endmodule