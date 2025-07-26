

module instruction_memory(
    input clk,
    input logic [31:0] address_i,
    output logic [31:0] instruction_o
    );
    
    
logic [7:0] instruction_memory [0:2047];    
    
initial begin      
    $readmemh("/home/gary/bin/code.hex", instruction_memory);    
end

always @ (negedge clk) begin
            instruction_o <= {instruction_memory[address_i[11:0]+3],instruction_memory[address_i[11:0]+2],instruction_memory[address_i[11:0]+1],instruction_memory[address_i[11:0]]};
end


endmodule
