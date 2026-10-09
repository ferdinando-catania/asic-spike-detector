`timescale 1ns / 1ps
module tb_iir_section1 ();
logic clk=1'b0, rst;
logic signed  [10:0] x, y, y_attesa;
localparam string filename="iir_section1.txt";

localparam T=10ns;
localparam d1=T/10;
localparam int NN = 100;

iir_section1 DUT (.*);

always
    #(T/2) clk = ~ clk;

initial begin
    rst=1'b1;
    x='0;
    #(T/2);
    #d1;
    rst=1'b0;
    x=11'sb01111111111;
    #T;
    x='0;
    #(NN*T)
    $finish;
end

// Controllo dei risultati
// la prima uscita significativa si ha dopo il secondo clock
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
    // attendo il reset ed il primo ciclo di clock
    #(T/2);
    #d1;
    for (int i=1; i<= NN; i++) begin
        #T;
        // leggo il valore atteso dal file
        ns = $fgets(linea,fid);
        if (ns==0) begin
            $error("******* Errore durante la lettura del file '%s' linea:%0d",filename,i);
            $error("******* Simulazione abortita.");
            $finish;
        end
        ns = $sscanf(linea,"%b",y_attesa);
        assert (y==y_attesa) else begin
            nerror++;
            $display("");
            $display("Errore al tempo %0.3f ns, linea:%0d del file dati",$realtime,i);
            $display("Uscita attesa: %b  uscita prodotta dal circuito: %b, ",y_attesa, y);
            $display("In decimale: uscita attesa: %f  uscita prodotta dal circuito: %f, ",
                   real'(y_attesa)* 2.0**-10, real'(y)* 2.0**-10);
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