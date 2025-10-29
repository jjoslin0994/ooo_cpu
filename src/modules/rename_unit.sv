import cpu_design_params::*;

module rename_unit()

// Register Alias Table
rat_t rat [NUM_A_REGS];

always_ff @( posedge clk or negedge rst_n ) begin : blockName
  if(!rst_n)  begin
    for (int i = 0; i < NUM_A_REGS; i++) begin
    rat[i].p_mapping <= i;
    rat[i].valid <= 1'b1; // always valid
    end
  end
end

// Free List
// a lifi with push/pop 
// has 64 P_REGS
// loads from max index (NUM_PREGS - NUM_A_REGS - 1)
// pop give p_reg at head 

prn_t free_list [MAX_FREE_REGS];
logic [4:0] head_ptr;

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    // load the free values in order from init 
    for (int i = 0; i < MAX_FREE_REGS; i++) free_list[i] <= (i + NUM_A_REGS);
    head_ptr <= '0;
  end
end




// History Buffer -- omitted from v1

endmodule : rename_unit