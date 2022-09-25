`timescale 1ns / 1ps

module fsm( 
    input clk,
    input [3:0] key,
    input full_ACC,
    input busy_DISP,
    input full_AUX,
    output reg [3:0] digit,
    output reg [1:0] operation,
    output reg update_DISP,
    output reg clear_ALU
    );

reg ENZ;  //enable zero when it is not the fisrt digit of number   
reg [2:0] state;
reg [3:0] key_locked;

parameter [3:0] S_CLEAR=4'd0, S_DIGIT=4'd1,S_OPERATION=4'd2,
                S_WAIT_FOR_KEY=4'd3, S_WAIT_FOR_DISP=4'd4, 
		S_WAIT_FOR_ALU=4'd5, S_ERROR=4'd6;
    
always @(posedge clk)
    if (key == 4'd15) begin state<=3'd0; end
    else if (key >= 4'd0 && key<=4'd9) begin 
        if (state == 3'd6) begin state<=3'd6; end 
        else begin key_locked <= key; state <= 3'd1; end
    end
    else if (key >= 4'd10 && key<=4'd12) begin
        if (state == 3'd6) begin state<=3'd6; end
        else begin key_locked <= key; state <= 3'd2; end
    end
    else begin
        case(state)
            S_CLEAR: begin          //clear all registers
                    $display("%t S_CLEAR", $time);
                    clear_ALU <= 1;
                    ENZ <= 0;
                    state <= S_WAIT_FOR_ALU;
                end
            S_WAIT_FOR_ALU : begin
                    $display("%t S_WAIT_FOR_ALU", $time);
                    clear_ALU <= 0;
                    digit <= 4'b1101;
                    operation <= 2'b00;
                    update_DISP <= 1;
                    state <= S_WAIT_FOR_DISP;
                end
            S_WAIT_FOR_DISP : begin
                $display("%t S_WAIT_FOR_DISP", $time);
                if (update_DISP) begin update_DISP <= 0; state <= S_WAIT_FOR_DISP; end
                else if (busy_DISP) begin state <= S_WAIT_FOR_DISP; end
                else begin
                    if (full_ACC) begin state <= S_ERROR; end
                    else begin state <= S_WAIT_FOR_KEY; end
                end
            end
            S_WAIT_FOR_KEY : begin
                    $display("%t S_WAIT_FOR_KEY", $time);
                    state <= S_WAIT_FOR_KEY;
                end
            S_DIGIT : begin
                $display("%t S_DIGIT", $time);
                if (!full_AUX && !full_ACC) begin
                    case(key_locked)
                        4'b0000: begin 
                            if (ENZ) begin digit <= 4'b0000; state<=S_WAIT_FOR_ALU; end
                            else begin state <= S_WAIT_FOR_KEY; end    //ignore 0 if this is a first digit in number
                        end
                        4'b0001: begin digit<=4'b0001; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b0010: begin digit<=4'b0010; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b0011: begin digit<=4'b0011; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b0100: begin digit<=4'b0100; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b0101: begin digit<=4'b0101; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b0110: begin digit<=4'b0110; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b0111: begin digit<=4'b0111; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b1000: begin digit<=4'b1000; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                        4'b1001: begin digit<=4'b1001; ENZ <= 1; state <= S_WAIT_FOR_ALU; end
                    endcase
                end
                else begin state <= S_WAIT_FOR_KEY; end
            end
            S_OPERATION : begin
                $display("%t S_OPERATION", $time);
                    if (!full_ACC) begin
                        case(key_locked)
                            4'b1010: begin operation<=2'b01; ENZ <= 0; end
                            4'b1011: begin operation<=2'b10; ENZ <= 0; end
                            4'b1100: begin operation<=2'b11; ENZ <= 0; end
                        endcase
                        state <= S_WAIT_FOR_ALU;
                    end
                    else begin state <= S_WAIT_FOR_KEY; end
            end
            S_ERROR : begin
                $display("%t S_ERROR", $time);
                state <= S_ERROR;
            end
        endcase
    end
endmodule