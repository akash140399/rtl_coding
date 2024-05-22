`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 21.05.2024
// Design Name:
// Module Name: multiplier_socreboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

class multiplier_scoreboard;
    int unsigned                                                            num_transactions;
    mailbox                                                                 mon2sbd;

    function new
    (
        input  mailbox                                                      mon2sbd
    );
        this.mon2sbd = mon2sbd;
    endfunction

    task main();
        multiplier_transaction                                              trans0;

        forever
        begin
            mon2sbd.get(trans0);

            if(trans0.output_prod == trans0.ref_output_prod)
                $display("Result is as expected");

            else
            begin
                $display("Wrong result: expected = %08x, actual = %08x", trans0.output_prod, trans0.ref_output_prod);
                $fatal(1);
            end

            trans0.display("Scoreboard");
            num_transactions++;
        end
    endtask
endclass