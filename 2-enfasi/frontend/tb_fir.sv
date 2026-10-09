`timescale 1ns / 1ps

module tb_fir ();
logic clk=1'b0, rst;
logic signed [11:0] p, q, q_attesa;
localparam string filename="fir.txt";

localparam T=10ns;
localparam d1=T/4.0;


fir DUT (.*);

always
  #(T/2)clk = ~clk;

initial begin
    rst =1'b1; p='0;
    #(T/2);
    #d1;
    rst =1'b0; p=12'b010000000000;
    #T;
    p='0;    
    #(20*T);
    $finish;
end

// Controllo dei risultati
// la prima uscita significativa si ha dopo 3 clock
initial begin
  int ns, fid, nerror;
  string linea;
  nerror=0;
  fid = $fopen (filename,"r");
  assert (fid != 0) else begin
      $error("****** Non posso aprire in lettura il file '%s'",filename);
      $error("****** Simulazione abortita.");
      $finish;
  end
  // attendo 3 cicli di clock
  #(T/2);
  #d1;
  #(T);
  for (int i=1; i<= 9; i++) begin
      #T;
      // leggo il valore atteso dal file
      ns = $fgets(linea,fid);
      if (ns==0) begin
          $error("******* Errore durante la lettura del file '%s' linea:%0d",filename,i);
          $error("******* Simulazione abortita.");
          $finish;
      end
      ns = $sscanf(linea,"%b",q_attesa);
      assert (q==q_attesa) else begin
          nerror++;
          $display("");
          $display("Errore al tempo %0.3f ns, linea:%0d del file dati",$realtime,i);
          $display("Uscita attesa: %b  uscita prodotta dal circuito: %b, ",q_attesa, q);
          $display("In decimale: uscita attesa: %f  uscita prodotta dal circuito: %f, ",
                 real'(q_attesa)* 2.0**-10, real'(q)* 2.0**-10);
          $display("");
      end
  end
  $fclose(fid);
  $display(" *******************************");
  $display(" **** Simulazione Terminata ****");
  $display(" **** Errori individuati: %0d",nerror);
  $display(" *******************************");
end


endmodule