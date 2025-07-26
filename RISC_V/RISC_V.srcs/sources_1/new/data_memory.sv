module data_memory(
    input logic clk,
    input logic [31:0] address_i,  
    input logic [31:0] data_i,     
    input logic data_wr,           
    input logic data_rd,         
    
    output logic [31:0] data_o  
);


logic [7:0] data_memory [0:1023];  



always_ff @(negedge clk) begin
    if (data_rd) begin

        data_o <= {data_memory[address_i[11:0]+3], 
                   data_memory[address_i[11:0]+2], 
                   data_memory[address_i[11:0]+1], 
                   data_memory[address_i[11:0]]};
    end
end


always_ff @(negedge clk) begin
    if (data_wr) begin
        data_memory[address_i[11:0]]   <= data_i[7:0];   
        data_memory[address_i[11:0]+1] <= data_i[15:8];
        data_memory[address_i[11:0]+2] <= data_i[23:16];
        data_memory[address_i[11:0]+3] <= data_i[31:24]; 
    end
end

endmodule