`timescale 1ns / 1ps

module iir_section1 (
  input  logic clk, rst,
  input  logic signed [10:0] x,
  output logic signed [10:0] y
);

  localparam logic signed [11:0] b0  = 12'sb000000011100;
  localparam logic signed [11:0] b1  = 12'sb000000100001;
  localparam logic signed [11:0] b2  = 12'sb000000011100;
  localparam logic signed [11:0] ma1 = 12'sb011000101001;
  localparam logic signed [11:0] ma2 = 12'sb110101101110;

  localparam logic signed [20:0] round_const = 21'sb000000000001000000000;

  logic signed [10:0] xn1, xn2; //Q1.10
  logic signed [22:0] t0, t1, t2, t3, t4, t_out; //Q3.20
  logic signed [10:0] y0, yn1, yn2; //Q1.10

  logic signed [20:0] tmp1;
  logic signed [20:0] tmp2;
 
  always_ff @ (posedge clk)
    if (rst) begin
      // Reset di x
      xn1 <= 11'b0;
      xn2 <= 11'b0;
      // Reset di y
      yn1 <= 11'b0;
      yn2 <= 11'b0;
      y <= 11'b0; // inizializzo l'uscita y per evitare che ci siano valori indefiniti all'inizio
    end

    else begin
      // Registri x
      xn1 <= x;
      xn2 <= xn1;
      // Registri y
      yn1 <= y0;
      yn2 <= yn1;
      y <= y0;
    end

  always_comb begin
    t0 = x * b0;
    t1 = xn1 * b1;
    t2 = xn2 * b2;

    t3 = yn1 * ma1;
    t4 = yn2 * ma2;
    t_out = t0+t1+t2+t3+t4;
  end

  assign tmp1 = signed '(t_out [20:0]);
  assign tmp2 = tmp1 + round_const;
  assign y0 = signed '(tmp2 [20:10]);


endmodule