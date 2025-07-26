module writeback(
    input logic clk,
    input logic rst,
    
    // Inputs from memory stage (renamed from M to WB)
    input logic [31:0]      PC_cur_WB_i,
    input logic [31:0]      ALU_WB_i,
    input logic [1:0]       data_sel_WB_i,
    input logic             WD3_en_WB_i,
    input logic [4:0]       A3_addr_WB_i,
    input logic [31:0]      data_read_WB_i,

    // Outputs
    output logic [31:0]     data_WB_o,
    output logic            WD3_en_WB_o,
    output logic [4:0]      A3_addr_WB_o
);

// Data selection mux
always_comb begin
    case(data_sel_WB_i)
        2'b00: data_WB_o = ALU_WB_i;
        2'b01: data_WB_o = data_read_WB_i;
        2'b10: data_WB_o = PC_cur_WB_i;
        default: data_WB_o = ALU_WB_i;
    endcase
end

// Pass through register control signals
assign WD3_en_WB_o = WD3_en_WB_i;
assign A3_addr_WB_o = A3_addr_WB_i;

endmodule