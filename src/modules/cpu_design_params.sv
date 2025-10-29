package cpu_design_params;

  parameter int NUM_A_REGS  = 32;
  parameter int ROB_SIZE    = 16;
  parameter int PC_SIZE     = 64;
  parameter int DATA_WIDTH  = 32;

  localparam int MAX_FREE_REGS = NUM_P_REGS - NUM_A_REGS; // 48 - 32 = 16
  
  // ---- Derived Widths ----
  localparam int NUM_P_REGS   = ROB_SIZE + NUM_A_REGS;
  localparam int PRN_WIDTH    = $clog2(NUM_P_REGS);
  localparam int ARN_WIDTH    = $clog2(NUM_A_REGS);
  localparam int ROB_IDX_WDTH = $clog2(ROB_SIZE); 
  localparam int F_LIST_WDTH  = $clog2(MAX_FREE_REGS);

  // ---- Rename History ----
  parameter int HIST_DPTH = ROB_SIZE;
  localparam int HISTW    = $clog2(HIST_DPTH + 1);

  // ---- Canonical typedefs ----
  typedef logic [PRN_WIDTH-1:0]         prn_t;        // physical reg index
  typedef logic [ARN_WIDTH-1:0]         arn_t;        // architectural reg index
  typedef logic [HISTW-1:0]             hist_ptr_t;   // rename history pointer
  typedef logic [PC_SIZE-1:0]           pc_t;         // program counter at time of rename
  typedef logic [ROB_IDX_WDTH - 1 : 0]  rob_idx_t;    // rob index
  typedef logic [3:0]                   op_t;         // opcode
  typedef logic [DATA_WIDTH - 1 : 0]    operand_t;


  typedef struct packed {
    logic       valid;
    logic       done;
    logic       exception;
    logic       writes_rd;

    prn_t       p_new;
    prn_t       p_old;
    arn_t       rd_arch;

    hist_ptr_t  hist_ptr;
    pc_t        pc;
  } rob_data_t;

  
  typedef struct packed {
    op_t      op;
    rob_idx_t rob_idx;
    prn_t     p_dest;

    logic src1_valid;
    logic src2_valid;
    operand_t src1_value;
    operand_t src2_value;
  } rs_endtry_t;

  typedef struct packed {
    logic valid;
    prn_t p_mapping;    
  } rat_t;


  // ---- rename_unit tasks ---- 
  task automatic free_list_pop(
    intout logic [PRN_WIDTH - 1 : 0] free_list [MAX_FREE_REGS]
  );

  endtask

endpackage