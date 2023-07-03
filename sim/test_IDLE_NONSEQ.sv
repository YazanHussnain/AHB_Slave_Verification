`include "environment.sv" // fail
`include "amba_ahb_defines.sv"
program test(ahb_if ahb_IF);

    class my_trans extends transaction;

        bit [1:0] count;

        constraint addr_aligned { }
        
        function void pre_randomize();

            HTRANS.rand_mode(0);
            HWRITE.rand_mode(0);
            HREADY.rand_mode(0);
            HBURST.rand_mode(0);
            HADDR.rand_mode(0);
            HSEL.rand_mode(0);
            HSEL = 1;

            case(count)
              2'h0: begin
                HTRANS = `H_NONSEQ;
                HADDR = 32'hA8;
                HBURST = `H_SINGLE;
                HREADY = 1;
                HWRITE = `H_WRITE;
              end
              2'h1: begin
                HTRANS = `H_IDLE;
                HADDR = 32'hA4;
                HBURST = `H_SINGLE;
                HREADY = 0;
                HWRITE = `H_WRITE;
              end
              2'h2: begin
                HTRANS = `H_NONSEQ;
                HADDR = 32'hAC;
                HBURST = `H_INCR4;
                HREADY = 0;
                HWRITE = `H_WRITE;
              end
              2'h3: begin
                HTRANS = `H_NONSEQ;
                HADDR = 32'h9C;
                HBURST = `H_INCR4;
                HREADY = 1;
                HWRITE = `H_WRITE;
              end
            endcase
            count++;

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