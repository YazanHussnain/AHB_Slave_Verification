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
            HBURST.rand_mode(0);
            HSIZE.rand_mode(0);
            HSEL.rand_mode(0);
            HSEL = 1;

            case(cnt)
                2'h0: begin
                    HTRANS = `H_NONSEQ;
                    HSIZE = `H_SIZE_32;
                    HREADY = 1;
                    HWRITE = `H_WRITE;
                    HADDR = 32'h38;
                end
                2'h1: begin
                    HTRANS = `H_SEQ;
                    HADDR = 32'h3c;
                end
                2'h2: begin
                    HTRANS = `H_SEQ;
                    HADDR = 32'h40;
                end
                2'h3: begin
                    HTRANS = `H_SEQ;
                    HADDR = 32'h44;
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