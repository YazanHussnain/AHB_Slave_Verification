//Top most file which connets DUT, interface and the test

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
//`include "test1.sv"
//`include "test2.sv"
//`include "test3.sv"
//----------------------------------------------------------------
`include "interface.sv"

//`include "random_test.sv"
//`include "test_write_read_transfer.sv"
//`include "test_BUSY_write_transfer.sv"
//`include "test_BUSY_read_transfer.sv"
//`include "test_IDLE_write_transfer.sv"
//`include "test_IDLE_read_transfer.sv"
//`include "test_WR_diff _address.sv"
//`include "test_all_write_same_address.sv"
//`include "test_all_read_same_address.sv"
//`include "test_all_read_diff_address.sv"
//`include "test_all_write_diff_address.sv"
//`include "test_WR_same_address.sv"
//`include "test_WR_diff_address.sv"
//`include "test_read_transfer_wait.sv"
//`include "test_write_transfer_wait.sv"
//`include "test_IDLE_NONSEQ.sv"
`include "test_BUSY_SEQ.sv"
//`include "test_wrap4.sv"
//`include "test_incr4.sv"
//`include "test_no_slave_select.sv"

module testbench_top;
  
  //declare clock and reset signal
  bit HCLK;
  bit HRESETn;
  
  //clock generation
  initial begin
    HCLK = 1;
    forever #5 HCLK = ~HCLK;
  end

  //reset generation
  initial begin
    HRESETn = 0;
    #5;
    HRESETn = 1;
  end

  //interface instance, inorder to connect DUT and testcase
  ahb_if ahb_IF(HCLK, HRESETn);

  //testcase instance, interface handle is passed to test as an argument
  test t1(ahb_IF);

  //DUT instance, interface signals are connected to the DUT ports
  ahb3lite_sram1rw
  #(
    .MEM_SIZE(4),
    .MEM_DEPTH(256),
    .HADDR_SIZE(32),
    .HDATA_SIZE(32),
    .TECHNOLOGY("GENERIC"),
    .REGISTERED_OUTPUT("NO"),
    .INIT_FILE("memoryData.mem")
  )
  DUT(
    .HRESETn(ahb_IF.HRESETn),
    .HCLK(ahb_IF.HCLK),
    .HSEL(ahb_IF.HSEL),
    .HADDR(ahb_IF.HADDR),
    .HWDATA(ahb_IF.HWDATA),
    .HRDATA(ahb_IF.HRDATA),
    .HWRITE(ahb_IF.HWRITE),
    .HSIZE(ahb_IF.HSIZE),
    .HBURST(ahb_IF.HBURST),
    .HPROT(ahb_IF.HPROT),
    .HTRANS(ahb_IF.HTRANS),
    .HREADYOUT(ahb_IF.HREADYOUT),
    .HREADY(ahb_IF.HREADY),
    .HRESP(ahb_IF.HRESP)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
