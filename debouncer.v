`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
 
// Description: Display driver code stored in lcd_diplay.v file  and debouncer.v 
// come from the book "Wprowadzenie do języka Verilog" wrote by Zbigniew Hajduk.

//////////////////////////////////////////////////////////////////////////////////


module debouncer(input clk,
                input [3:0] PB,
                output reg [3:0] BUTTONS);
                
reg [3:0] pb_sync;
reg [16:0] cnt;

always @(posedge clk)
    pb_sync<=PB;
    
wire cnt_max=&cnt;

always @(posedge clk)
    if(pb_sync==BUTTONS) cnt<=0;
    else
    begin
    cnt<=cnt+1;
    if(cnt_max) BUTTONS<=pb_sync;
    end

endmodule

