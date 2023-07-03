//Generates randomized transaction packets and put them in the mailbox to send the packets to driver 

class generator;
  
  //declare transaction class
  transaction Trans;
    
  //create mailbox handle
  mailbox #(transaction) genDrvmbx;
  
  //declare an event
  event genEvent;

  //variable, to speicify number of items to generate.
  int genCount;
  
  //constructor
  function new(mailbox #(transaction) genDrvmbx, event genEvent);

    this.genDrvmbx = genDrvmbx;
    this.genEvent  = genEvent;
    Trans = new();

  endfunction
  
  //main methods
  task main();
    repeat(genCount) begin
      if( !Trans.randomize() ) $fatal("Gen:: Trans randomization failed");
      //Trans.print_trans();
      genDrvmbx.put(Trans.do_copy());
    end
    ->genEvent; 
  endtask
  
endclass
