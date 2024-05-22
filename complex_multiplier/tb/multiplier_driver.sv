`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 21.05.2024
// Design Name:
// Module Name: multiplier_driver
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

class multiplier_driver;
    virtual multiplier_interface                                            vi_intf0;
    int unsigned                                                            num_transactions;
    mailbox                                                                 gen2drv;
    mailbox                                                                 drv2mon;

    function new
    (
        input  virtual multiplier_interface                                 vi_intf0,
        input  mailbox                                                      gen2drv,
        input  mailbox                                                      drv2mon
    );
        this.vi_intf0 = vi_intf0;
        this.gen2drv = gen2drv;
        this.drv2mon = drv2mon;
    endfunction

    task reset();
        wait(!vi_intf0.rst_n);
        $display("%s", {100{"="}});
        $display("Resetting the DUT");
        $display("%s", {100{"="}});

        vi_intf0.input_a_tvalid <= 1'b0;
        vi_intf0.input_a_tdata <=  'h0;
        vi_intf0.input_b_tvalid <= 1'b0;
        vi_intf0.input_b_tdata <=  'h0;
        vi_intf0.output_prod_tready <= 1'b1;

        wait(vi_intf0.rst_n);
        $display("%s", {100{"="}});
        $display("Finished resetting the DUT");
        $display("%s", {100{"="}});
    endtask

    task main();
        multiplier_transaction                                              trans0;

        forever
        begin
            gen2drv.get(trans0);
            drv2mon.put(trans0);
            while((vi_intf0.input_a_tready && vi_intf0.input_b_tready) !== 1'b1)
                @(posedge vi_intf0.clk);

            vi_intf0.input_a_tvalid <= 1'b1;
            vi_intf0.input_a_tdata <= trans0.input_a;
            vi_intf0.input_b_tvalid <= 1'b1;
            vi_intf0.input_b_tdata <= trans0.input_b;

            @(posedge vi_intf0.clk);
            vi_intf0.input_a_tvalid <= 1'b0;
            vi_intf0.input_b_tvalid <= 1'b0;

            trans0.display("Driver");
            num_transactions++;
        end
    endtask
endclass