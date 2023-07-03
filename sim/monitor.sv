//Samples the interface signals, captures into transaction packet and sends the packet to scoreboard.

`define MON_IF ahb_IF.MONITOR.Monitor_cb
class monitor;
  
  //virtual interface handle
  virtual ahb_if ahb_IF;

  //create mailbox handle
  mailbox #(transaction) monScrmbx;

  //constructor
  function new(mailbox #(transaction) monScrmbx, virtual ahb_if ahb_IF);

    this.monScrmbx = monScrmbx;
    this.ahb_IF = ahb_IF;

  endfunction

  //main method
  task main;
    forever begin
      transaction Trans;
      Trans = new();
      @(posedge ahb_IF.MONITOR.HCLK);
      Trans.HADDR   = `MON_IF.HADDR;
      Trans.HWRITE  = `MON_IF.HWRITE;
      Trans.HSEL    = `MON_IF.HSEL;
      Trans.HSIZE   = `MON_IF.HSIZE;
      Trans.HBURST  = `MON_IF.HBURST;
      Trans.HPROT   = `MON_IF.HPROT;
      Trans.HTRANS  = `MON_IF.HTRANS;
      //@(posedge ahb_IF.MONITOR.HCLK);
      if(`MON_IF.HWRITE) begin
        @(posedge ahb_IF.MONITOR.HCLK);
        Trans.HWDATA = `MON_IF.HWDATA;
      end
      else begin
        @(posedge ahb_IF.MONITOR.HCLK);
        Trans.HRDATA = `MON_IF.HRDATA;
      end
      //$display("[MONITOR]: HWDATA : %0h \t HRDATA : %0h", Trans.HWDATA, Trans.HRDATA);
      Trans.HREADY    = `MON_IF.HREADY;
      Trans.HRESP     = `MON_IF.HRESP;
      Trans.HREADYOUT = `MON_IF.HREADYOUT;
      //$display("[MONITOR]: HRDATA : %0h \t HRDATA : %0h", `MON_IF.HRDATA, Trans.HRDATA);
      //$display("[MONITOR]: HADDR : %0h \t HWDATA : %0h", Trans.HADDR, Trans.HWDATA);
      monScrmbx.put(Trans);
    end
  endtask

endclass
