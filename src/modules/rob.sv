import cpu_design_params::*;

module rob #(

)(
  input logic clk, rst_n,
  RobInterface.internal rob_if
);

  localparam PTR_SIZE   = $clog2(ROB_SIZE); // wraps for ^2 logic***
  localparam COUNT_SIZE  = $clog2(ROB_SIZE + 1);

  rob_data_t rob_table[ROB_SIZE - 1 : 0];
  logic [PTR_SIZE - 1 : 0] head_ptr, head_ptr_n,
                            tail_ptr, tail_ptr_n;

  logic commit_head, alloc_ok;
  logic rob_full, rob_empty;
  logic [COUNT_SIZE - 1 : 0] rob_count, rob_count_n;

  always_comb begin : commit_outputs
    rob_if.commit_valid     = commit_head;
    rob_if.commit_rd_arch   = rob_table[head_ptr].rd_arch;
    rob_if.commit_p_new     = rob_table[head_ptr].p_new;
    rob_if.commit_p_old     = rob_table[head_ptr].p_old;
    rob_if.commit_writes_rd = rob_table[head_ptr].writes_rd;
    rob_if.commit_pc        = rob_table[head_ptr].pc;
  end

  always_comb begin
    rob_if.tag = tail_ptr; // RS captures tag on ready&&aloc_ok
  end

  always_comb begin : ptr_math
    head_ptr_n  = commit_head ? head_ptr + 1 : head_ptr;
    tail_ptr_n  = alloc_ok ? tail_ptr + 1 : tail_ptr;
  end

  always_comb begin : control_logic
    commit_head = rob_table[head_ptr].valid && rob_table[head_ptr].done && !rob_table[head_ptr].exception;

    alloc_ok    = (rob_if.alloc_valid && (!rob_full || commit_head));

    rob_count_n = (commit_head && !alloc_ok) ? rob_count - 1 : 
                (!commit_head && alloc_ok) ? rob_count + 1 :
                rob_count;


    rob_full = (rob_count == ROB_SIZE);
    rob_empty = (rob_count == 0);
  end
 



  assign rob_if.alloc_ready = !rob_full || commit_head;


    always_ff @( posedge clk or negedge rst_n ) begin : check_head
    if(!rst_n) begin
      for (int i = 0; i < ROB_SIZE; i++) begin
         rob_table[i] <= '0; // clear all data on table entry;
      end
      head_ptr <= '0;
      tail_ptr <= '0;
    end 
    else begin
      // check head every cycle
      if(commit_head && !(rob_full && alloc_ok)) rob_table[head_ptr].valid <= 1'b0;
      if(alloc_ok) rob_table[tail_ptr] <= '{
          valid:      1'b1,
          done:       1'b0,
          exception:  1'b0,
          writes_rd:  rob_if.alloc_data.writes_rd,

          p_new:      rob_if.alloc_data.p_new,
          p_old:      rob_if.alloc_data.p_old,
          rd_arch:    rob_if.alloc_data.rd_arch,

          hist_ptr:   rob_if.alloc_data.hist_ptr,
          pc:         rob_if.alloc_data.pc,
        };
      
      
      // ---- update pointers ----
      head_ptr <= head_ptr_n;
      tail_ptr <= tail_ptr_n;
      rob_count <= rob_count_n;
    end
  end


endmodule : rob