`timescale 1ns/1ps
module tb_fsm();

logic clk=1'b0, rst, spike;
logic signed [11:0] q, soglia;
localparam T=10ns;
localparam d1=T/5;

fsm DUT (.*);

always 
    #(T/2) clk = ~clk;

initial begin
    rst=1'b1; q='0; soglia=12'b000100000000;
    q=12'b000000000000;
    #(T/2);
    #d1;
    rst=1'b0;
    #T;
    #T q=12'b000000011000;
    #T q=12'b010000011000;
    #(2*T) q=12'b000000011000;
    #T q=12'b010000011000;
    #(2*T) q=12'b000001011000;
    #(2*T)  q=12'b011000011000;
    #(4*T) q='0;
    #(4*T);
    $finish;
end


initial begin
    int nerror;
    nerror=0;
    #(T/2);
    #d1;
    // uscita bassa per i 6 cicli di clock (dopo il reset)
    for (int k=1; k<=6; k++) begin
        #T;
        assert (spike==1'b0) else begin
            nerror++;
            $display("");
            $display("Errore al tempo %0.3f ns",$realtime);
            $display("Uscita attesa: 0  uscita prodotta dal circuito: 1");
            $display("");
        end
    end
 
    // uscita alta per 2 cicli di clock
    for (int k=1; k<=2; k++) begin
        #T;
        assert (spike==1'b1) else begin
            nerror++;
            $display("");
            $display("Errore al tempo %0.3f ns",$realtime);
            $display("Uscita attesa: 1  uscita prodotta dal circuito: 0");
            $display("");
        end
    end

    // uscita bassa per 5 cicli di clock
    for (int k=1; k<=5; k++) begin
        #T;
        assert (spike==1'b0) else begin
            nerror++;
            $display("");
            $display("Errore al tempo %0.3f ns",$realtime);
            $display("Uscita attesa: 0  uscita prodotta dal circuito: 1");
            $display("");
        end
    end

    // uscita alta per 1 ciclo
    for (int k=1; k<=1; k++) begin
        #T;
        assert (spike==1'b1) else begin
            nerror++;
            $display("");
            $display("Errore al tempo %0.3f ns",$realtime);
            $display("Uscita attesa: 1  uscita prodotta dal circuito: 0");
            $display("");
        end
    end

    // uscita bassa per 2 cicli di clock
    for (int k=1; k<=2; k++) begin
        #T;
        assert (spike==1'b0) else begin
            nerror++;
            $display("");
            $display("Errore al tempo %0.3f ns",$realtime);
            $display("Uscita attesa: 0  uscita prodotta dal circuito: 1");
            $display("");
        end
    end

    $display(" *******************************");
    $display(" **** Simulazione Terminata ****");
    $display(" **** Errori individuati: %0d",nerror);
    $display(" *******************************");
end


endmodule