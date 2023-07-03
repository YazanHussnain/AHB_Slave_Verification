//Interface groups the design signals, specifies the direction (Modport) and Synchronize the signals(Clocking Block)

interface ahb_if(input logic HCLK, input logic HRESETn);

    // Add design signals here
  logic          HSEL;
  logic [`ADDRW-1:0] HADDR;
  logic [`DATAW-1:0] HWDATA;
  logic          HWRITE;
  logic [2:0]    HSIZE;
  logic [2:0]    HBURST;
  logic [3:0]    HPROT;
  logic [1:0]    HTRANS;
  logic          HREADY;
  logic          HREADYOUT;
  logic [`DATAW-1:0] HRDATA;
  logic          HRESP;
    
    //Master Clocking block - used for Drivers
  clocking Driver_cb @(posedge HCLK);
    default input #1 output #1;
    output HSEL;
    output HADDR;
    output HWDATA;
    output HWRITE;
    output HSIZE;
    output HBURST;
    output HPROT;
    output HTRANS;
    output HREADY;
    input  HREADYOUT;
    input  HRDATA;
    input  HRESP; 
  endclocking
    
    //Monitor Clocking block - For sampling by monitor components
  clocking Monitor_cb @(posedge HCLK);
    default input #1 output #1;
    input HSEL;
    input HADDR;
    input HWDATA;
    input HWRITE;
    input HSIZE;
    input HBURST;
    input HPROT;
    input HTRANS;
    input HREADY;
    input HREADYOUT;
    input HRDATA;
    input HRESP; 
  endclocking
    //Add modports here
  //driver modport
  modport DRIVER(clocking Driver_cb,input HCLK, HRESETn);
  
  //monitor modport  
  modport MONITOR(clocking Monitor_cb,input HCLK, HRESETn);
  
endinterface
