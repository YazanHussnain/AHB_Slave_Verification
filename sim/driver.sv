//Gets the packet from generator and drive the transaction packet items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT)
`include "amba_ahb_defines.sv"
`define DRIV_IF ahb_IF.DRIVER.Driver_cb
class driver;

  //used to count the number of transactions
  int no_transactions = 0;

  //virtual interface handle
  virtual ahb_if ahb_IF;

  //create mailbox handle
  mailbox #(transaction) genDrvmbx;

  //constructor
  function new(mailbox #(transaction) genDrvmbx, virtual ahb_if ahb_IF);

    this.genDrvmbx = genDrvmbx;
    this.ahb_IF    = ahb_IF;

  endfunction

  //reset methods, Reset the Interface signals to default/initial values
  task reset;
    wait(!ahb_IF.HRESETn);
    $display("--------- [DRIVER] Reset Started ---------");
    `DRIV_IF.HTRANS <= `H_IDLE;
    `DRIV_IF.HSEL   <= 0;
    `DRIV_IF.HADDR  <= 0;
    `DRIV_IF.HWDATA <= 0;
    `DRIV_IF.HWRITE <= 0;
    `DRIV_IF.HSIZE  <= 0;
    `DRIV_IF.HBURST <= 0;
    `DRIV_IF.HPROT  <= 0;
    `DRIV_IF.HREADY <= 1;
    wait(ahb_IF.HRESETn);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask

  //drive methods
  task drive;
    //$display("Yazan");
    forever begin
      transaction Trans = new();
      genDrvmbx.get(Trans);
      //$display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
      //$display("Yazan_1");
      //$display("HREADY - %0b", Trans.HREADY);
      //wait(Trans.HREADY);
      //$display("HREADY - %0b", Trans.HREADY);
      @(posedge ahb_IF.DRIVER.HCLK);
      `DRIV_IF.HADDR  <= Trans.HADDR;
      `DRIV_IF.HSEL   <= Trans.HSEL;
      `DRIV_IF.HPROT  <= Trans.HPROT;
      `DRIV_IF.HSIZE  <= Trans.HSIZE;
      `DRIV_IF.HBURST <= Trans.HBURST;
      `DRIV_IF.HTRANS <= Trans.HTRANS;
      `DRIV_IF.HWRITE <= Trans.HWRITE;
      `DRIV_IF.HREADY <= Trans.HREADY;
      //$display("Yazan");
      if(Trans.HWRITE) begin
        `DRIV_IF.HWDATA <= Trans.HWDATA;
        //@(posedge ahb_IF.DRIVER.HCLK);
        //$display("[DRIVER-%0d] : \tHADDR = %0h \tHWDATA = %0h",no_transactions,Trans.HADDR,Trans.HWDATA);
      end
      // if(!Trans.HWRITE) begin
      //   Trans.HRDATA    <= `DRIV_IF.HRDATA;
      //   @(posedge ahb_IF.DRIVER.HCLK);
      //$display("[DRIVER-%0d] : \tHADDR = %0h \tHWDATA = %0h",no_transactions,Trans.HADDR,Trans.HWDATA);
      // end
      //$display("-----------------------------------------");
      //@(`DRIV_IF.HREADYOUT);
      //$display("SCOREBOARD - %0d", no_transactions);
      no_transactions++;
    end
  endtask

  //main methods
  task main;
    forever begin
      //$display("Yazan_2");
      wait(ahb_IF.HRESETn);
      //$display("Yazan_3");
      drive();
    end
  endtask

endclass
