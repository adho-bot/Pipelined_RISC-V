module Branch_target_buffer#(
    parameter DATA_WIDTH = 32,
    parameter BLOCK_SIZE = 16  // (in bytes) 4 blocks storing 32 bits in each one
)(
    input logic i_clk,
    input logic i_rstn,
    input logic [31:0] i_pc_index,           // PC address (byte-aligned)
    input logic i_we,                         // Write enable (update BTB)
    input logic [31:0] i_target_addr,        // Branch target address to store
    output logic o_hit,                       // BTB hit signal
    output logic [31:0] o_predicted_target   // Predicted branch target
);

    // Convert byte-aligned PC to word-aligned
    logic [29:0] word_pc_index;
    assign word_pc_index = i_pc_index[31:2];
    
    // Cache addressing fields
    logic [2:0] line;
    logic [26:0] tag;
    
    // BTB storage arrays (8 entries for direct-mapped cache)
    logic [29:0] cache_data [7:0];  // Stores branch target addresses (29 bits cus word addr)
    logic [26:0] tag_data [7:0];    // Stores tags for each cache line
    logic valid [7:0];               // Valid bit for each cache line
    
    // Parse PC into tag, line (index)
    // i_pc_index = {tag(29 bits), line(3 bits)}
    assign line   = word_pc_index[2:0];
    assign tag    = word_pc_index[31:3];
    
    // Hit logic: check if tag matches and line is valid
    assign o_hit = valid[line] && (tag_data[line] == tag);
    
    // Output predicted target from BTB
    assign o_predicted_target = cache_data[line];
    
    // Sequential logic for BTB updates
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            for (int i = 0; i < 8; i++) begin
                valid[i] <= 1'b0;
                tag_data[i] <= '0;
                cache_data[i] <= '0;
            end
        end else begin
            // Write to BTB on branch resolution
            if (i_we) begin
                valid[line] <= 1'b1;
                tag_data[line] <= tag;
                cache_data[line] <= i_target_addr;
            end
        end
    end

endmodule