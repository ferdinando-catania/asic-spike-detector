`timescale 1ns / 1ps

module fir (
  input  logic clk, rst,
  input  logic signed [11:0] p,
  output logic signed [11:0] q
);

  localparam logic signed [9:0] b0 = 10'sb0000010101; //Q0.10
  localparam logic signed [9:0] b1 = 10'sb0001000011; //Q0.10
  localparam logic signed [9:0] b2 = 10'sb0010101010; //Q0.10
  localparam logic signed [9:0] b3 = 10'sb0011111101; //Q0.10
  localparam logic signed [9:0] b4 = 10'sb0011111101; //Q0.10
  localparam logic signed [9:0] b5 = 10'sb0010101010; //Q0.10
  localparam logic signed [9:0] b6 = 10'sb0001000011; //Q0.10
  localparam logic signed [9:0] b7 = 10'sb0000010101; //Q0.10

  localparam logic signed [21:0] round_const = signed'({12'b0,1'b1, 9'b0});

  logic signed [11:0] p0, p1, p2, p3, p4, p5, p6, p7; //Q2.10
  logic signed [21:0] t0, t1, t2, t3, t4, t5, t6, t7; //Q2.20, uscite dei moltiplicatori

  logic signed [21:0] q0; //Q2.20, uscita del sommatore
  logic signed [11:0] q1; //Q2.10, uscita del rounding

  logic signed [21:0] tmp1;

  always_ff @ (posedge clk)
    if (rst) begin
      p0 <= 12'b0;
      p1 <= 12'b0;
      p2 <= 12'b0;
      p3 <= 12'b0;
      p4 <= 12'b0;
      p5 <= 12'b0;
      p6 <= 12'b0;
      p7 <= 12'b0;
      q  <= 12'b0;
    end
    else begin
      p0 <= p;
      p1 <= p0;
      p2 <= p1;
      p3 <= p2;
      p4 <= p3;
      p5 <= p4;
      p6 <= p5;
      p7 <= p6;
      q  <= q1;
    end

  always_comb begin
    t0 = p0*b0; //Q1.20
    t1 = p1*b1; //Q1.20
    t2 = p2*b2; //Q1.20
    t3 = p3*b3; //Q1.20
    t4 = p4*b4; //Q1.20
    t5 = p5*b5; //Q1.20
    t6 = p6*b6; //Q1.20
    t7 = p7*b7; //Q1.20
    q0 = t0+t1+t2+t3+t4+t5+t6+t7; //Q2.20
  end

  assign tmp1 = q0 + round_const; //Q2.20 -> Q2.10
  assign q1   = signed '(tmp1[21:10]); //Q2.10

endmodule