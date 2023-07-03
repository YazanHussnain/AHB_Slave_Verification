//A container class that contains Mailbox, Generator, Driver, Monitor and Scoreboard
//Connects all the components of the verification environment
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //handles of all components
  generator  Gen;
  driver     Driv;
  monitor    Mon;
  scoreboard Scb;
  
  //mailbox handles
  mailbox #(transaction) genDrvmbx;
  mailbox #(transaction) monScrmbx;

  //declare an event
  event genEvent;
  
  //virtual interface handle
  virtual ahb_if ahb_IF;
  
  //constructor
  function new(virtual ahb_if ahb_IF);
    //get the interface from test
    this.ahb_IF = ahb_IF;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    genDrvmbx = new();
    monScrmbx = new();
    
    //creating generator and driver
    Gen  = new(genDrvmbx, genEvent);
    Driv = new(genDrvmbx, ahb_IF);
    Mon  = new(monScrmbx, ahb_IF);
    Scb  = new(monScrmbx);
  endfunction
  
  //pre_test methods
  task pre_test();
    Driv.reset();
  endtask
  
  //test methods
  task test();
    fork 
      Gen.main();
      Driv.main();
      Mon.main();
      Scb.main();      
    join_any
  endtask
  
  //post_test methods
  task post_test();
    wait(genEvent.triggered);
    //$display("Generator Finished");
    //$display("Gen Count - %0d", Gen.genCount);
    wait(Gen.genCount == Driv.no_transactions);
    //$display("SCOREBOARD-ENV - %0d", Scb.no_transactions);
    wait((Gen.genCount + 1) == Scb.no_transactions);
  endtask  
    
  //run methods
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass


