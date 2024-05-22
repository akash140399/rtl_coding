`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 21.05.2024
// Design Name:
// Module Name: multiplier_environment
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

class multiplier_environment;
    multiplier_generator                                                    gen0;
    multiplier_driver                                                       drv0;
    multiplier_monitor                                                      mon0;
    multiplier_scoreboard                                                   sbd0;

    mailbox                                                                 gen2drv;
    mailbox                                                                 drv2mon;
    mailbox                                                                 mon2sbd;

    virtual multiplier_interface                                            vi_intf0;

    function new
    (
        input  virtual multiplier_interface                                 vi_intf0
    );
        this.vi_intf0 = vi_intf0;

        gen2drv = new();
        drv2mon = new();
        mon2sbd = new();

        gen0 = new(.gen2drv(gen2drv));
        drv0 = new(.vi_intf0(vi_intf0), .gen2drv(gen2drv), .drv2mon(drv2mon));
        mon0 = new(.vi_intf0(vi_intf0), .drv2mon(drv2mon), .mon2sbd(mon2sbd));
        sbd0 = new(.mon2sbd(mon2sbd));
    endfunction

    task pre_test();
        drv0.reset();
    endtask

    task test();
        fork
            gen0.main();
            drv0.main();
            mon0.main();
            sbd0.main();
        join_any
    endtask

    task post_test();
        wait(gen0.gen_done.triggered);
        wait(gen0.num_transactions == sbd0.num_transactions);
    endtask

    task run();
        pre_test();
        test();
        post_test();
        $finish();
    endtask
endclass