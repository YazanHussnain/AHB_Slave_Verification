`include "environment.sv"
`include "amba_ahb_defines.sv"
program test(ahb_if ahb_IF);

    class my_trans extends transaction;

        bit [1:0] count;
        
        function void pre_randomize();

            HWRITE.rand_mode(0);
            HSEL.rand_mode(0);
            HREADY.rand_mode(0);
            HSEL = 1;
            HREADY = 1;
            //HSIZE.rand_mode(0);

            HWRITE = `H_READ;
            //HSIZE = `H_SIZE_32;

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

      $readmemh("memoryData.mem", env.Scb.mem_array, 0, 255);
      
      //calling run of env, it interns calls generator and driver main tasks.
      env.run();
    end
  endprogram