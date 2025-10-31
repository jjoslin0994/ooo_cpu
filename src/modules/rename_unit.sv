import cpu_design_params::*;

module rename_unit()

// Register Alias Table
rat_t rat [NUM_A_REGS];

always_ff @( posedge clk or negedge rst_n ) begin : blockName
  if(!rst_n)  begin
    for (int i = 0; i < NUM_A_REGS; i++) begin
    rat[i].p_mapping <= i;
    rat[i].valid <= 1'b1; // always valid may be removed in future
    end
  end
end

// Free List
// a lifi with push/pop 
// has 48 P_REGS
// loads from max index free_list[0] = p47, free_list[1] = p46 . . ., free_list[15] = p32
// pop give p_reg at head 

prn_t free_list [MAX_FREE_REGS];
logic [4:0] head_ptr;

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    // load the free values in order from init 
    for (int i = MAX_FREE_REGS - 1; i >= 0 ; i--) free_list[i] <= (NUM_A_REGS + i);
    head_ptr <= MAX_FREE_REGS - 1;
  end
  else begin  
    if()
  end
end




// History Buffer -- omitted from v1

endmodule : rename_unit