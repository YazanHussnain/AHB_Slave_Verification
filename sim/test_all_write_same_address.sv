`include "environment.sv"
`include "amba_ahb_defines.sv"
program test(ahb_if ahb_IF);

    class my_trans extends transaction;

        bit [1:0] count;

        constraint addr_aligned { }
        
        function void pre_randomize();

            HWRITE.rand_mode(0);
            HADDR.rand_mode(0);
            HTRANS.rand_mode(0);
            HSEL.rand_mode(0);
            HREADY.rand_mode(0);
            HSEL = 1;
            HREADY = 1;

            HWRITE = `H_WRITE;
            HTRANS = `H_NONSEQ;
            HADDR = 8'hb4;

        endfunction
    
    endclass
  
  //declaring environment instance
  environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(ahb_IF);

    my_tr = new();
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.Gen.genCount = 10;

    env.Gen.Trans = my_tr;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram