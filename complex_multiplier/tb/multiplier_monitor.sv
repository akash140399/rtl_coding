`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 21.05.2024
// Design Name:
// Module Name: multiplier_monitor
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

class multiplier_monitor;
    virtual multiplier_interface                                            vi_intf0;
    mailbox                                                                 drv2mon;
    mailbox                                                                 mon2sbd;

    function new
    (
        input  virtual multiplier_interface                                 vi_intf0,
        input  mailbox                                                      drv2mon,
        input  mailbox                                                      mon2sbd
    );
        this.vi_intf0 = vi_intf0;
        this.drv2mon = drv2mon;
        this.mon2sbd = mon2sbd;
    endfunction

    task main();
        multiplier_transaction                                             trans0;

        vi_intf0.output_prod_tready = 1'b1;
        forever
        begin
            drv2mon.get(trans0);
            while(vi_intf0.output_prod_tvalid !== 1'b1)
                @(posedge vi_intf0.clk);

            @(posedge vi_intf0.clk);
            trans0.output_prod = vi_intf0.output_prod_tdata;
            trans0.display("Monitor");
            mon2sbd.put(trans0);
        end
    endtask
endclass