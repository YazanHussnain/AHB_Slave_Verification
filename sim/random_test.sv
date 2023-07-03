`include "environment.sv"
program test(ahb_if ahb_IF);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(ahb_IF);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.Gen.genCount = 10;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram