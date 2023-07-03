//Fields required to generate the stimulus are declared in the transaction class
`include "amba_ahb_defines.sv"
class transaction;

  //declare transaction items
  //AHB Slave Interfaces (receive data from AHB Masters)
  //AHB Masters connect to these ports
  rand bit          HSEL;
  rand bit [`ADDRW-1:0]  HADDR;
  rand bit [`DATAW-1:0] HWDATA;
  rand bit          HWRITE;
  rand bit [2:0]    HSIZE;
  rand bit [2:0]    HBURST;
  rand bit [3:0]    HPROT;
  rand bit [1:0]    HTRANS;
  rand bit          HREADY;
  bit               HREADYOUT;
  bit      [`DATAW-1:0] HRDATA;
  bit               HRESP;
  bit      [1:0]    cnt;
  
  //Add Constraints

  constraint no_burst { HBURST inside {[`H_SINGLE:`H_INCR4]}; HBURST != `H_INCR; }

  //constraint transfer_types { HTRANS dist { `H_IDLE:/10, `H_BUSY:/10, `H_NONSEQ:/80 }; }

  constraint transfer_size { HSIZE inside {[`H_SIZE_8:`H_SIZE_32]}; }

  constraint addr_aligned { HADDR % (2**HSIZE) == 0; solve HSIZE before HADDR; }

  constraint prot_dataAccess { HPROT == 1; }

  //constraint hsel { HSEL == 1; }

  //constraint hready_const { HREADY == 1; }

  //constraint htrans { HTRANS == 2; }

  //constraint hwrite { HWRITE == 1 ; }
  
  //Add print transaction method(optional)

  function void print_trans();

    $display("-------- START : [Values: Transaction Items] --------");
    $display("HSEL      = %h",      HSEL);
    $display("HADDR     = %h",     HADDR);
    $display("HWDATA    = %h",    HWDATA);
    $display("HWRITE    = %h",    HWRITE);
    $display("HSIZE     = %h",     HSIZE);
    $display("HBURST    = %h",    HBURST);
    $display("HPROT     = %h",     HPROT);
    $display("HTRANS    = %h",    HTRANS);
    $display("HREADY    = %h",    HREADY);
    $display("HREADYOUT = %h", HREADYOUT);
    $display("HRDATA    = %h",    HRDATA);
    $display("HRESP     = %h",     HRESP);
    $display("--------  END  : [Values: Transaction Items] --------");

  endfunction

  //deep copy method

  function transaction do_copy();
    transaction trans = new();
      trans.HSEL      = this.HSEL;
      trans.HADDR     = this.HADDR;
      trans.HWDATA    = this.HWDATA;
      trans.HWRITE    = this.HWRITE;
      trans.HSIZE     = this.HSIZE;
      trans.HBURST    = this.HBURST;
      trans.HPROT     = this.HPROT;
      trans.HTRANS    = this.HTRANS;
      trans.HREADY    = this.HREADY;
      trans.HREADYOUT = this.HREADYOUT;
      trans.HRDATA    = this.HREADY;
      trans.HRESP     = this.HRESP;
    return trans;
  endfunction
   
endclass