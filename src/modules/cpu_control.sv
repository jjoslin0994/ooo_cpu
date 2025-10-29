module cpu_control
(
  input logic clk, rst_n

  ControllerInterface controller_if,
  InstructionMemoryInterface instruction_memory_if
);

  logic [32:0] pc_q;

  logic [31:0] instruction_q;

  logic p1_valid, p2_valid, p3_valid
        p1_ready, p2_ready, p3_ready;

  InstructionMemory instuction_mem_inst(
    .InstructionMemoryIf(instruction_memory_if)
  )


  always_ff @( posedge clk or negedge rst_n ) begin : pipe_1_fetch
    if(!rst_n) begin
      instruction_q <= '0;
      p1_valid <= 1'b1;
    end
    else if(!p1_valid && instruction_memory_if.inst !== 'x) begin
      instruction_q <= instruction_memory_if.instruction;
      p1_valid <= 1'b1;
    end else if(p1_valid && p2_ready)
      p1_valid <= 1'b0;
    else
      // do nothing for this cycle (hold valid or wait for valid data)
  end

  assign p1_ready = !p1_valid || p2_ready;

  always_ff @( posedge clk or negedge rst_n ) begin : pipe_2_decode_rename
    if(!)
  end

  always_ff @( posedge clk or negedge rst_n ) begin : control
    if(!rst_n) begin
      pc_q      <= '0;
      p1_valid  <= 1'b0;
      p2_valid  <= 1'b0;
    end
  end



endmodule : cpu_control

