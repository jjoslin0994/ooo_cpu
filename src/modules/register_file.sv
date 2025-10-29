// ARF

module RegisterFile #(
  parameter int DATA_WIDTH  = 32,
  parameter int NUM_REGS    = 32,
  parameter bit HAS_X0      = 1
)(
  input logic clk, rst_n,
  RegisterFileInterface.internal rf_if
);

  logic [DATA_WIDTH - 1 : 0] regs [NUM_REGS - 1 : 0];
  logic write_X0;
  
  assign write_X0 = (HAS_X0 && rf_if.w_addr == '0);

  always_ff @( posedge clk or negedge rst_n ) begin : reset_write
    if(!rst_n) begin
      for(int i = 0; i < NUM_REGS; i++) regs[i] <= '0;
    end
    else if(rf_if.w_en && !write_X0) regs[rf_if.w_addr] <= rf_if.d_in;
 
  end

  always_comb begin : read_data
    // Port 1
    if(HAS_X0 && (rf_if.r_addr_1 == '0)) rf_if.d_out_1              = '0;
    else if(rf_if.w_en && (rf_if.w_addr == rf_if.r_addr_1) && !write_X0) 
                                                      rf_if.d_out_1 = rf_if.d_in;
    else rf_if.d_out_1                                              = regs[rf_if.r_addr_1];

    // Port 2
    if(HAS_X0 && (rf_if.r_addr_2 == '0)) rf_if.d_out_2    = '0;
    else if(rf_if.w_en && (rf_if.w_addr == rf_if.r_addr_2) && !write_X0) 
                                            rf_if.d_out_2 = rf_if.d_in;
    else rf_if.d_out_2                                    = regs[rf_if.r_addr_2];
  end

endmodule