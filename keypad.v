`timescale 1ns / 1ps

module keypad(
    input CLK2MHZ,
    input [3:0] row,
    output reg [3:0] col,
    output reg [3:0] key
);

parameter S_RELEASED = 1'd0, S_PRESSED = 1'd1;
reg state;

reg[17:0] counter = 0;
reg[1:0] reset_col = 0;
parameter change_col = 10;

always @(posedge CLK2MHZ)
    if (counter == 99_999) 
        begin
            counter <= 0;
            reset_col <= reset_col + 1;
        end
    else
        counter <= counter + 1;

always @(posedge CLK2MHZ)
    begin
        case(state)
            S_RELEASED: 
                begin
                    case(reset_col)
                    2'b00 :	
                        begin
                        col = 4'b0111;
                        if (counter == change_col)
                            case(row)
                                4'b0111 : begin key <= 4'b0001; state <= S_PRESSED; end	// 1
                                4'b1011 : begin key <= 4'b0100; state <= S_PRESSED; end	// 4
                                4'b1101 : begin key <= 4'b0111; state <= S_PRESSED; end	// 7
                                4'b1110 : begin key <= 4'b1111; state <= S_PRESSED; end	// CLEAR
                                default : begin key <= 4'b1101; state <= S_RELEASED; end
                            endcase
                        end
                    2'b01 :	
                        begin
                        col = 4'b1011;
                        if (counter == change_col)
                            case(row)
                                4'b0111 : begin key <= 4'b0010; state <= S_PRESSED; end	// 2	
                                4'b1011 : begin key <= 4'b0101; state <= S_PRESSED; end	// 5	
                                4'b1101 : begin key <= 4'b1000; state <= S_PRESSED; end	// 8	
                                4'b1110 : begin key <= 4'b0000; state <= S_PRESSED; end	// 0
                                default : begin key <= 4'b1101; state <= S_RELEASED; end
                            endcase
                        end
                    2'b10 :	
                        begin       
                        col = 4'b1101;
                        if (counter == change_col)
                            case(row)
                                4'b0111 : begin key <= 4'b0011; state <= S_PRESSED; end	// 3 		
                                4'b1011 : begin key <= 4'b0110; state <= S_PRESSED; end	// 6 		
                                4'b1101 : begin key <= 4'b1001; state <= S_PRESSED; end	// 9 		
                                4'b1110 : begin key <= 4'b1101; state <= S_RELEASED; end //ignored
                                default : begin key <= 4'b1101; state <= S_RELEASED; end	    
                            endcase
                        end
                    2'b11 :	
                        begin
                        col = 4'b1110;
                        if (counter == change_col)
                            case(row)
                                4'b0111 : begin key <= 4'b1010; state <= S_PRESSED; end	// +
                                4'b1011 : begin key <= 4'b1011; state <= S_PRESSED; end	// -
                                4'b1101 : begin key <= 4'b1100; state <= S_PRESSED; end	// =
                                4'b1110 : begin key <= 4'b1101; state <= S_RELEASED; end //ignored
                                default : begin key <= 4'b1101; state <= S_RELEASED; end
                            endcase
                        end
                    endcase
                    end
            S_PRESSED : 
                begin 
                    state <= (row == 4'b1111)?S_RELEASED:S_PRESSED; 
                end
        endcase
    end
endmodule