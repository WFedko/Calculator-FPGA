`timescale 1ns / 1ps

module testbench_alu;
//input
reg clk;
reg[3:0] digit;
reg[1:0] operation;
reg clear_ALU;

//output 
wire full_AUX;
wire[39:0] AUX;
wire sgn_AUX;
wire full_ACC;

// Generation 12 MHz clock
initial 
    begin
        clk = 0;
        forever 
            begin
                #41.6666 clk = ~clk;
            end 
    end

alu uut2(
    .clk(clk),
    .digit(digit),
    .operation(operation),
    .clear_ALU(clear_ALU),
    .full_AUX(full_AUX),
    .AUX(AUX),
    .sgn_AUX(sgn_AUX),
    .full_ACC(full_ACC)
);

initial begin
#41.6666
// clear    
    clear_ALU = 1;
    #83.33334
    clear_ALU = 0;
    #83.33334

//// Addition of two positive numbers        
// 4    
    digit = 4'b0100;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 6    
    digit = 4'b0110;
    #83.33334
    digit = 4'b1101;
    #83.33334
// +
    operation=2'b01;
    #83.33334
    operation=2'b00;
    #83.33334
// 7    
    digit = 4'b0111;
    #83.33334
    digit = 4'b1101;
    #83.33334  
// 0    
    digit = 4'b0000;
    #83.33334
    digit = 4'b1101;
    #83.33334     
// =
    operation=2'b11;
    #83.33334
    operation=2'b00;
    #83.33334

#1000

// clear    
    clear_ALU = 1;
    #83.33334
    clear_ALU = 0;
    #83.33334

//// Addition of two negative numbers        
// -
    operation=2'b10;
    #83.33334
    operation=2'b00;
    #83.33334
// 8    
    digit = 4'b1000;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 8    
    digit = 4'b1000;
    #83.33334
    digit = 4'b1101;
    #83.33334
// -
    operation=2'b10;
    #83.33334
    operation=2'b00;
    #83.33334
// 2    
    digit = 4'b0010;
    #83.33334
    digit = 4'b1101;
    #83.33334  
// 1    
    digit = 4'b0001;
    #83.33334
    digit = 4'b1101;
    #83.33334  
// 2    
    digit = 4'b0010;
    #83.33334
    digit = 4'b1101;
    #83.33334    
// =
    operation=2'b11;
    #83.33334
    operation=2'b00;
    #83.33334

    #1000

// clear    
    clear_ALU = 1;
    #83.33334
    clear_ALU = 0;
    #83.33334

//// Subtraction of positive and negative numbers        
// 1    
    digit = 4'b0001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 6    
    digit = 4'b0110;
    #83.33334
    digit = 4'b1101;
    #83.33334
// -
    operation=2'b10;
    #83.33334
    operation=2'b00;
    #83.33334
// 1    
    digit = 4'b0001;
    #83.33334
    digit = 4'b1101;
    #83.33334  
// 8    
    digit = 4'b1000;
    #83.33334
    digit = 4'b1101;
    #83.33334  
// 5    
    digit = 4'b0101;
    #83.33334
    digit = 4'b1101;
    #83.33334    
// =
    operation=2'b11;
    #83.33334
    operation=2'b00;
    #83.33334    

#1000

// clear    
    clear_ALU = 1;
    #83.33334
    clear_ALU = 0;
    #83.33334
       
//// Subtraction of negative and positive numbers 
// -
    operation = 2'b10;
    #83.33334
    operation = 2'b00;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// +
    operation = 2'b01;
    #83.33334
    operation = 2'b00;
    #83.33334
// 5    
    digit = 4'b0101;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 6    
    digit = 4'b0110;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 4    
    digit = 4'b0100;
    #83.33334
    digit = 4'b1101;
    #83.33334
// =
    operation = 2'b11;
    #83.33334
    operation = 2'b00;
    #83.33334

#1000

// clear    
    clear_ALU = 1;
    #83.33334
    clear_ALU = 0;
    #83.33334

//// Overflow of AUX and ACC       
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 9    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334
// 4    
    digit = 4'b0100;
    #83.33334
    digit = 4'b1101;
    #83.33334
// +
    operation=2'b01;
    #83.33334
    operation=2'b00;
    #83.33334
// 1    
    digit = 4'b1001;
    #83.33334
    digit = 4'b1101;
    #83.33334 
// =
    operation=2'b11;
    #83.33334
    operation=2'b00;
    #83.33334      

    $finish;
    end
endmodule
