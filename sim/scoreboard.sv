//Gets the packet from monitor, generates the expected result and compares with the actual result received from the Monitor
`include "amba_ahb_defines.sv"
class scoreboard;

  //create mailbox handle
  mailbox #(transaction) monScrmbx;

  //used to count the number of transactions
  int no_transactions = 0;

  //array to use as local memory
  bit [`DATAW - 1:0] mem_array [0:255];

  //Endian
  int endian = 0;

  //constructor
  function new(mailbox #(transaction) monScrmbx);
    //getting the mailbox handles from  environment
    this.monScrmbx = monScrmbx;
  endfunction

  task startIDLETransfer(transaction Trans);
    if(Trans.HRESP == `H_OKAY) begin
      $display("[Scoreboard] - HRESP OKAY to IDLE Transfer");
    end
    else begin
      $display("[Scoreboard] - HRESP ERROR to IDLE Transfer");
    end
  endtask

  task startBUSYTransfer(transaction Trans);
    if(Trans.HRESP == `H_OKAY) begin
      $display("[Scoreboard] - HRESP OKAY to BUSY Transfer");
    end
    else begin
      $display("[Scoreboard] - HRESP ERROR to BUSY Transfer");
    end
  endtask

  task writeWord(transaction Trans);
    mem_array[Trans.HADDR[9:2]] = Trans.HWDATA;
    $display("WRITE - WORD - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]]);
  endtask

  task writeHalfWord(transaction Trans);
    if(Trans.HADDR[1] == 0) begin
      if(!endian)
        mem_array[Trans.HADDR[9:2]][15:0] = Trans.HWDATA[15:0];
      else
        mem_array[Trans.HADDR[9:2]][15:0] = Trans.HWDATA[31:16];
      $display("WRITE - HW0 - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]][15:0]);
    end
    if(Trans.HADDR[1] == 1) begin
      if(!endian)
        mem_array[Trans.HADDR[9:2]][31:16] = Trans.HWDATA[31:16];
      else
        mem_array[Trans.HADDR[9:2]][31:16] = Trans.HWDATA[15:0];
      $display("WRITE - HW1 - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]][31:16]);
    end
  endtask

  task writeByte(transaction Trans);
    if(Trans.HADDR[1:0] == 0) begin
      if(!endian)
        mem_array[Trans.HADDR[9:2]][7:0] = Trans.HWDATA[7:0];
      else
        mem_array[Trans.HADDR[9:2]][7:0] = Trans.HWDATA[31:24];
      $display("WRITE - BYTE0 - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]][7:0]);
    end
    if(Trans.HADDR[1:0] == 1) begin
      if(!endian)
        mem_array[Trans.HADDR[9:2]][15:8] = Trans.HWDATA[15:8];
      else
        mem_array[Trans.HADDR[9:2]][15:8] = Trans.HWDATA[23:16];
      $display("WRITE - BYTE1 - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]][15:8]);
    end
    if(Trans.HADDR[1:0] == 2) begin
      if(!endian)
        mem_array[Trans.HADDR[9:2]][23:16] = Trans.HWDATA[23:16];
      else
        mem_array[Trans.HADDR[9:2]][23:16] = Trans.HWDATA[15:8];
      $display("WRITE - BYTE2 - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]][23:16]);
    end
    if(Trans.HADDR[1:0] == 3) begin
      if(!endian)
        mem_array[Trans.HADDR[9:2]][31:24] = Trans.HWDATA[31:24];
      else
        mem_array[Trans.HADDR[9:2]][31:24] = Trans.HWDATA[7:0];
      $display("WRITE - BYTE3 - HADDR - %0h, HWDATA - %0h", Trans.HADDR, mem_array[Trans.HADDR[9:2]][31:24]);
    end
  endtask

  task writeTransfer(transaction Trans);
    //$display(" >>>> Initiate NONSEQ Write Transfer <<<<");
    if(Trans.HREADY) begin
      if(Trans.HSIZE == `H_SIZE_32) begin
        writeWord(Trans);
      end
      else if(Trans.HSIZE == `H_SIZE_16) begin
        writeHalfWord(Trans);
      end
      else if(Trans.HSIZE == `H_SIZE_8) begin
        writeByte(Trans);
      end
    end
  endtask

  task readWord(transaction Trans);
    if(mem_array[Trans.HADDR[9:2]] == Trans.HRDATA) begin
      $display("READ - WORD - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA);
    end
  endtask

  task readHalfWord(transaction Trans);
    if(Trans.HADDR[1] == 0) begin
      if(mem_array[Trans.HADDR[9:2]][15:0] == Trans.HRDATA[15:0]) begin
        $display("READ - HW0 - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA[15:0]);
      end
    end
    if(Trans.HADDR[1] == 1) begin
      if(mem_array[Trans.HADDR[9:2]][31:16] == Trans.HRDATA[31:16]) begin
        $display("READ - HW1 - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA[31:16]);
      end
    end
  endtask

  task readByte(transaction Trans);
    if(Trans.HADDR[1:0] == 0) begin
      if(mem_array[Trans.HADDR[9:2]][7:0] == Trans.HRDATA[7:0]) begin
        $display("READ - BYTE0 - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA[7:0]);
      end
    end
    if(Trans.HADDR[1:0] == 1) begin
      if(mem_array[Trans.HADDR[9:2]][15:8] == Trans.HRDATA[15:8]) begin
        $display("READ - BYTE1 - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA[15:8]);
      end
    end
    if(Trans.HADDR[1:0] == 2) begin
      if(mem_array[Trans.HADDR[9:2]][23:16] == Trans.HRDATA[23:16]) begin
        $display("READ - BYTE2 - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA[23:16]);
      end
    end
    if(Trans.HADDR[1:0] == 3) begin
      if(mem_array[Trans.HADDR[9:2]][31:24] == Trans.HRDATA[31:24]) begin
        $display("READ - BYTE3 - HADDR - %0h, HRDATA - %0h", Trans.HADDR, Trans.HRDATA[31:24]);
      end
    end
  endtask

  task readTransfer(transaction Trans);
    //$display(" >>>> Initiate NONSEQ Read Transfer <<<<");
    if(Trans.HREADY) begin
      if(Trans.HSIZE == `H_SIZE_8) begin
        readByte(Trans);
      end
      else if(Trans.HSIZE == `H_SIZE_16) begin
        readHalfWord(Trans);
      end
      else if(Trans.HSIZE == `H_SIZE_32) begin
        readWord(Trans);
      end
      //$display("READ - all - HADDR - %0h, HRDATA - %0h",mem_array[Trans.HADDR], Trans.HRDATA);
    end
  endtask

  //main method
  task main;
    transaction Trans;
    forever begin
      //$display("--------- [SCOREBOARD-TRANSFER: %0d] ---------",no_transactions);
      monScrmbx.get(Trans);
      
      if(Trans.HSEL & Trans.HREADY) begin
        //$display(" >>>> Slave Connected <<<<");
        if(Trans.HPROT == 1) begin
          //$display(" >>>> Data Access Protection Enabled <<<<");
          if(Trans.HTRANS == `H_IDLE) begin
            $display(" >>>> IDLE Transfer Initiate <<<<");
            startIDLETransfer(Trans);
          end
          else if(Trans.HTRANS == `H_BUSY) begin
            $display(" >>>> BUSY Transfer Initiate <<<<");
            startBUSYTransfer(Trans);
          end
          else begin
            //$display(" >>>> NONSEQ Transfer Initiate <<<<");
            if(Trans.HWRITE == `H_WRITE) begin
              writeTransfer(Trans);
            end
            else begin
              readTransfer(Trans);
            end
          end
        end
        else begin
          $display("Data Access Protection Disbaled");
        end
      end
      else begin

        if(!Trans.HREADY) begin
          $display("Transfer Pending");
        end
        else begin
          $display("Slave is not Connected!");
        end

      end

      no_transactions++;
    end
  endtask
  
endclass
