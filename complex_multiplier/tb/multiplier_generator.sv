`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 20.05.2024
// Design Name:
// Module Name: multiplier_generator
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

class multiplier_generator;
    multiplier_transaction                                                  trans0;
    int unsigned                                                            num_transactions;
    mailbox                                                                 gen2drv;
    event                                                                   gen_done;

    function new
    (
        input  mailbox                                                      gen2drv
    );
        this.gen2drv = gen2drv;
    endfunction

    task main();
        repeat(num_transactions)
        begin
            trans0 = new();
            trans0.display("Generator");
            gen2drv.put(trans0);
        end

        -> gen_done;
    endtask
endclass