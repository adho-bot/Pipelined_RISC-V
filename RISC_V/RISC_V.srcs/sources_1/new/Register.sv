module Register(
    input  logic [31:0] reg_i,
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        enable_i,
    output logic [31:0] reg_o
);

    always_ff @(posedge clk_i) begin
        if (rst_i)
            reg_o<= 32'b0;     
        else if (enable_i)
            reg_o <= reg_i;        
        else
            reg_o <= reg_o;    
    end
endmodule

