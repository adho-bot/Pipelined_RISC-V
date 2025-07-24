module Register_bank(
    input  logic        [31:0] WD3_i,       // Data to be written
    input  logic               WD3_en_i,    // High for write, low for read
    input  logic               clk,       // System clock
    input  logic               rst,       // Master Reset
    input  logic        [4:0]  A1_addr_i,   // Read rs1
    input  logic        [4:0]  A2_addr_i,   // Read rs2
    input  logic        [4:0]  A3_addr_i,   //` Writeback rd
    output logic       [31:0]  RD1_o,
    output logic       [31:0]  RD2_o
);

    logic [31:0] register [0:31];

    // Asynchronous Read. 0 for x0 register
    assign RD1_o = (A1_addr_i == 5'b00000) ? 32'd0 : register[A1_addr_i];
    assign RD2_o = (A2_addr_i == 5'b00000) ? 32'd0 : register[A2_addr_i];

    // Synchronous Write & Reset
    always_ff @(posedge clk) begin
        if (rst) begin
            register[0]  <= 32'd0;
            register[1]  <= 32'd0;
            register[2]  <= 32'd0;
            register[3]  <= 32'd0;
            register[4]  <= 32'd0;
            register[5]  <= 32'd0;
            register[6]  <= 32'd0;
            register[7]  <= 32'd0;
            register[8]  <= 32'd0;
            register[9]  <= 32'd0;
            register[10] <= 32'd0;
            register[11] <= 32'd0;
            register[12] <= 32'd0;
            register[13] <= 32'd0;
            register[14] <= 32'd0;
            register[15] <= 32'd0;
            register[16] <= 32'd0;
            register[17] <= 32'd0;
            register[18] <= 32'd0;
            register[19] <= 32'd0;
            register[20] <= 32'd0;
            register[21] <= 32'd0;
            register[22] <= 32'd0;
            register[23] <= 32'd0;
            register[24] <= 32'd0;
            register[25] <= 32'd0;
            register[26] <= 32'd0;
            register[27] <= 32'd0;
            register[28] <= 32'd0;
            register[29] <= 32'd0;
            register[30] <= 32'd0;
            register[31] <= 32'd0;
        end else if (WD3_en_i && (A3_addr_i != 5'd0)) begin
            register[A3_addr_i] <= WD3_i;
        end
    end

endmodule
