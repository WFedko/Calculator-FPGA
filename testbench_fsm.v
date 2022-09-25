`timescale 1ns / 1ps

module testbench_fsm;
//inputs
reg clk;
reg[3:0] key;
reg full_ACC;
reg busy_DISP;
reg full_AUX;
//outputs
wire[3:0] digit;
wire[1:0] operation;
wire clear_ALU;

// Generation 12 MHz clock
initial 
    begin
        clk = 0;
        forever 
            begin
                #41.6666 clk = ~clk;
            end 
    end

fsm main_fsm(
    //inputs
    .clk(clk), .key(key), .full_ACC(full_ACC),
    .busy_DISP(busy_DISP), .full_AUX(full_AUX),
    //outputs 
    .digit(digit), .operation(operation),
    .update_DISP(update_DISP), .clear_ALU(clear_ALU));

initial begin
// clear
    #41.6666
    key = 4'd15; full_ACC=0; busy_DISP=0; full_AUX=0;
    #83.33332
    key = 4'd13;
    #166.66664
    busy_DISP = 1;
    #83.33332
    busy_DISP = 0;
    #166.66664
// digit
    key = 4'd7;
    #83.33332
    key = 4'd13;
    #166.66664
    busy_DISP = 1;
    #166.66664
    busy_DISP = 0;
    #166.66664
// operation
    key = 4'd11;
    #83.33332
    key = 4'd13;
    #166.66664
    busy_DISP = 1;
    #83.33332
    busy_DISP = 0;
    #83.33332

#1000

////////// how full_AUX works   
// clear
    #41.6666   
    key=4'd15; full_ACC=0; busy_DISP=0; full_AUX=0;
    #83.33332
    key=4'd13;
    #166.66664
    busy_DISP=1;
    #83.33332
    busy_DISP=0;
    #166.66664
// digit
    key=4'd8;
    #83.33332
    key=4'd13;
    #83.33332
    full_AUX=1;
    #83.33332
    busy_DISP=1;
    #83.33332
    busy_DISP=0;
    #166.66664
// digit
    key=4'd5;
    #83.33332
    key=4'd13;
    #416.6666
// operation
    key=4'd10;
    #83.33332
    key=4'd13;
    #83.33332
    full_AUX=0;
    #83.33332
    busy_DISP=1;
    #83.33332
    busy_DISP=0;
    #249.99996

////////// how full_ACC works   
// clear
    #41.6666   
    key=4'd15; full_ACC=0; busy_DISP=0; full_AUX=0;
    #83.33332
    key=4'd13;
    #166.66664
    busy_DISP=1;
    #83.33332
    busy_DISP=0;
    #166.66664
// digit
    key=4'd3;
    #83.33332
    key=4'd13;
    #83.33332
    full_ACC=1;
    #83.33332
    busy_DISP=1;
    #83.33332
    busy_DISP=0;
    #166.66664
// digit
    key=4'd6;
    #83.33332
    key=4'd13;
    #416.6666
// operation
    key=4'd10;
    #83.33332
    key=4'd13;
    #499.99992
// clear
    key=4'd15;
    #83.33332
    key=4'd13;
    #83.33332
    full_ACC=0;
    #83.33332
    busy_DISP=1; 
    #83.33332
    busy_DISP=0;
    #166.66664
    
    $finish;
    end
endmodule
