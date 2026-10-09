`timescale 1ns / 1ps

module tb_enfasi();
logic clk=1'b0, rst;
logic signed [10:0] z;
logic signed [11:0] q, q_attesa;
localparam string filename="enfasi.txt";

localparam T=10ns;
localparam d1=T/5;

enfasi DUT (.*);

always
   #(T/2) clk = ~ clk;

initial begin
    rst=1'b1; z='0;
    #(T/2);
    #d1;
    rst=1'b0;
    z=11'b00000000000;
    #T z=11'b00010000000;
    #T z=11'b00100000000;
    #T z=11'b00110000000;
    #T z=11'b01000000000;
    #T z=11'b01010000000;
    #T z=11'b01100000000;
    #T z=11'b01110000000;
    #T z='0;
    #(15*T);
    $finish;
end

// Controllo dei risultati
// la prima uscita significativa si ha dopo 7 clock
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
    // attendo 7 cicli di clock
    #(T/2);
    #d1;
    #(5*T);
    for (int i=1; i<= 14; i++) begin
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