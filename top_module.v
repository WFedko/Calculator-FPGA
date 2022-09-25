timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
Company : AGH University of Science and Technology in Cracow
Author : Wioleta Fedko
//
Create Date : 19.09.2022 18 : 08 : 00
Module Name : top_module
Project Name : Calculator_BCD
Target Devices : Arty S7 - 50
Tool Versions :
Description: Display driver code stored in lcd_diplay.v file and debouncer.v come from the book "Wprowadzenie do języka Verilog" wrote by Zbigniew Hajduk.
//
Dependencies :
	//
	Revision :
	Revision 0.01 - FILE Created
	Additional Comments :
//
//////////////////////////////////////////////////////////////////////////////////

module top_module(
	input clk, // clock 12MHz from Arty s7
	input[3:0] rows, // Pmod JC: pins from 10 to 7
	output[3:0] cols, // Pmod JC pins from 4 to 1
	inout[7:0] LCD_DB,
	output LCD_E, LCD_RS, LCD_RW,
	input[3:0] BTN
);

wire [3:0] w_dec;

reg [2:0] ss_1;
reg [5:0] c;
reg CLK1MHZ, WR_EN;
reg [3:0] ct;
wire [7:0] LCD_BUS;
wire [8:0] DATA_IN;
reg [7:0] ASCII;

reg busy_DISP;
wire [39:0] AUX;
wire sgn_AUX;

reg number;
reg zero;

reg [1:0] ct_2;
reg CLK2MHZ;

wire [3:0] digit;
wire [1:0] operation;
wire clear_ALU;
wire full_ACC;
wire full_AUX;
wire update_DISP;

keypad kpd(.CLK2MHZ(CLK2MHZ), .row(rows),
		   .col(cols), .key(w_dec));

fsm main_fsm(.clk(clk), .key(w_dec), .full_ACC(full_ACC),
			 .busy_DISP(busy_DISP), .full_AUX(full_AUX),
			 .digit(digit), .operation(operation),
			 .update_DISP(update_DISP), .clear_ALU(clear_ALU));

alu main_alu(.clk(clk), .digit(digit),
			 .operation(operation), .clear_ALU(clear_ALU),
			 .full_AUX(full_AUX), .AUX(AUX),
			 .sgn_AUX(sgn_AUX), .full_ACC(full_ACC));

debouncer d1(.clk(clk), .PB(BTN),
			 .BUTTONS({ sw1, sw2, sw3, sw4 }));

lcd_display d2(.CLK1MHZ(CLK1MHZ), .clk(clk), .WR_EN(WR_EN),
			   .RST(~sw1), .BF(BUSY_FLAG), .DATA_IN(DATA_IN),
			   .LCD_E(LCD_E), .LCD_RS(LCD_RS), .LCD_RW(LCD_RW),
			   .LCD_DB(LCD_BUS));

assign LCD_DB = LCD_RW ? 8'HZZ : LCD_BUS;
assign BUSY_FLAG = LCD_DB[7];

assign DATA_IN = (c == 0) ? 9'h001 : {1'b1, ASCII};

always @(posedge clk)
if (sw1) ss_1 <= 0;
else
	case (ss_1)
		0: begin
			c <= 0;
			WR_EN <= 0;
			number <= 0;
			zero <= 0;
			busy_DISP <= 0;
			ASCII <= 8'd48;
			ss_1 <= 1;
		end
		1 : begin
			c <= 0;
			WR_EN <= 0;
			number <= 0;
			zero <= 0;
			busy_DISP <= 0;
			if (update_DISP | | sw2) begin
				busy_DISP <= 1;
				ss_1 <= 2;
			end end
		2 : begin
			WR_EN <= 1;
			ss_1 <= 3;
		end
		3 : begin
			WR_EN <= 0;
			ss_1 <= 4;
		end
		4 : begin
		if (AUX[7:0] == 8'b11101110) begin
			c <= c + 1;
			ss_1 <= 5;
			end
		else
			begin
			c <= c + 1;
			if (c < 6'd5) begin
				ASCII <= 8'd32;
				ss_1 <= 2;
				end
			else if (c == 6'd16) ss_1 <= 7;
			else if (zero == 1) begin
				ASCII <= 8'd48;
				ss_1 <= 2;
			end
			else begin
			if (({ AUX[(14 - c) * 4 + 3], AUX[(14 - c) * 4 + 2], AUX[(14 - c) * 4 + 1], AUX[(14 - c) * 4] } == 4'b0000) & & number == 0)
				begin
				if (c == 14) begin
					ASCII <= 8'd32;
					zero <= 1;
					ss_1 <= 2;
				end 
			else begin
				ASCII <= 8'd32;
				ss_1 <= 2;
			end end
			else begin
				if (number == 0) begin
					ASCII = (sgn_AUX == 0) ? 8'd32 : 8'd45;
					number <= 1;
					ss_1 <= 2;
				end
				else begin
					case({ AUX[(15 - c) * 4 + 3], AUX[(15 - c) * 4 + 2], AUX[(15 - c) * 4 + 1], AUX[(15 - c) * 4] })
						4'b0000 : ASCII <= 8'd48;
						4'b0001 : ASCII <= 8'd49;
						4'b0010 : ASCII <= 8'd50;
						4'b0011 : ASCII <= 8'd51;
						4'b0100 : ASCII <= 8'd52;
						4'b0101 : ASCII <= 8'd53;
						4'b0110 : ASCII <= 8'd54;
						4'b0111 : ASCII <= 8'd55;
						4'b1000 : ASCII <= 8'd56;
						4'b1001 : ASCII <= 8'd57;
						 default: ASCII <= 8'hxx;
					endcase
					ss_1 <= 2;
				end
				end
			end
			end
		end
		5 : begin
			case(c)
			6'd1 : begin
					ASCII <= 8'd69;  // E
					ss_1 <= 2;
				end
			6'd2 : begin
					ASCII <= 8'd82;  // R
					ss_1 <= 2;
				end
			6'd3 : begin
					ASCII <= 8'd82;  // R
					ss_1 <= 2;
				end
			6'd4 : begin
					ASCII <= 8'd79;  // O
					ss_1 <= 2;
				end
			6'd5 : begin
					ASCII <= 8'd82;  // R
					ss_1 <= 2;
				end
			default: begin
					ss_1 <= 7;
				end
			endcase
		end
		7 : begin
			if (~update_DISP & &~sw2) begin
				busy_DISP <= 0;
				ss_1 <= 1;
			end end
	endcase

always @(posedge clk) //generation of 1 MHz clock signal for display driver
	if (ct < 5) ct <= ct + 1;
	else begin
		ct <= 0;
		CLK1MHZ <= ~CLK1MHZ;
	end

always @(posedge clk) //generation of 2 MHz clock signal for keypad
	if (ct_2 < 2) ct_2 <= ct_2 + 1;
	else begin
		ct_2 <= 0;
		CLK2MHZ <= ~CLK2MHZ;
	end

endmodule