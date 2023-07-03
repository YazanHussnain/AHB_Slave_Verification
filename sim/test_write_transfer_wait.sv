`include "environment.sv"
`include "amba_ahb_defines.sv"//pass
program test(ahb_if ahb_IF);

    class my_trans extends transaction;

        bit [1:0] count;

        constraint addr_aligned { }
        
        function void pre_randomize();

            HWRITE.rand_mode(0);
            HADDR.rand_mode(0);
            HREADY.rand_mode(0);
            HTRANS.rand_mode(0);
            //=HSIZE.rand_mode(0);
            HTRANS = `H_NONSEQ;
            //HSIZE = `H_SIZE_32;

            case(cnt)
                2'h0: begin
                    HREADY  = 1;
                    HWRITE = `H_WRITE;
                    HADDR = 32'hb4;
                end
                2'h1: begin
                    HADDR = 32'hbc;
                    HREADY = 0;
                end
                2'h2: begin
                    HADDR = 32'hb4;
                    HWRITE = `H_READ;
                    HREADY = 1;
                end
                2'h3: begin
                    HREADY = 1;
                end
            endcase
            cnt++;

        endfunction
    
    endclass
  
  //declaring environment instance
    environment env;
    my_trans my_tr;
    
    initial begin
      //creating environment
      env = new(ahb_IF);
  
      my_tr = new();

      $readmemh("memoryData.mem", env.Scb.mem_array, 0, 255);
      
      //setting the repeat count of generator as 4, means to generate 4 packets
      env.Gen.genCount = 4s;
  
      env.Gen.Trans = my_tr;
      
      //calling run of env, it interns calls generator and driver main tasks.
      env.run();
    end
  endprogram