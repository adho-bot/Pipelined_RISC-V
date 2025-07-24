/*------------------------------------------------------------------------------------------*/
/*                                ALU Operation States                                      */
/*------------------------------------------------------------------------------------------*/
//Normal ALU
`define ADD		    10'b0000000_000 // Addition
`define SUB     	10'b0100000_000 // Subtraction
`define SLL    	  	10'b0000000_001 // Shift left logical
`define XORR     	10'b0000000_100 // Xor
`define SRL     	10'b0000000_101 // Shift right logical
`define SRA     	10'b0100000_101 // Shift right arithmetic
`define ORR     	10'b0000000_110 // Or
`define ANDD    	10'b0000000_111 // And
    
    
//Branch
`define BEQ     	10'b1111111_000  //sketchy way of doing this. Qno funct7 for B instructions. I just made it 7 1s
`define BNE     	10'b1111111_001
`define BLT     	10'b1111111_100
`define BGE     	10'b1111111_101









