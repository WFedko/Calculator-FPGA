`timescale 1ns / 1ps

module alu(
    input clk,
    input [3:0] digit,
    input [1:0] operation,
    input clear_ALU,
    output reg full_AUX,
    output reg [39:0] AUX,
    output reg sgn_AUX,
    output reg full_ACC
    );
    
    reg [39:0] ACC;
    reg sgn_ACC;
    reg sgn_op;

    reg [3:0] AUX_counter;
    reg no_more_operation;

    reg [39:0] X;
    reg [39:0] Y;
    reg [39:0] S;

    reg [10:0] CC;
    reg [39:0] Yu9;
    reg [39:0] S_1;
    reg [3:0] R;

    integer i;
    integer j;
    integer k;
    integer u;
    
    reg [3:0] nx;
    reg [3:0] ny;
    reg [3:0] nfin;

always @(posedge clk) begin
    if (clear_ALU == 1)
        begin
            ACC <= 40'b0;
            sgn_ACC <= 1'b0;              //default: +
            AUX <= 40'b0;
            sgn_AUX <= 1'b0;              //default: +
            AUX_counter <= 4'd0;
            sgn_op <= 1'b0;
            full_AUX <= 1'b0;
            full_ACC <= 1'b0;
            CC <= 11'b0;
            Yu9 <= 40'b0;
            no_more_operation <= 0;
        end
    else if (digit >= 4'd0 && digit<=4'd9) 
        begin
            CC <= 11'b0;
            Yu9 <= 40'b0;
            if (AUX_counter == 4'b0) 
                begin
                    sgn_AUX <= 1'b0;
                    AUX <= {36'd0, digit};
                    AUX_counter <= AUX_counter + 1'd1;
                    no_more_operation <= 0;
                end
            else 
                begin
                    AUX <= {AUX[35:0], digit};
                    AUX_counter <= AUX_counter + 1'd1;
                    if (AUX_counter == 4'd9) begin full_AUX<=1; end
                end
        end

always @(posedge clk) begin
    if (clear_ALU == 1)
        begin
            ACC <= 40'b0;
            sgn_ACC <= 1'b0;              //default: +
            AUX <= 40'b0;
            sgn_AUX <= 1'b0;              //default: +
            AUX_counter <= 4'd0;
            sgn_op <= 1'b0;
            full_AUX <= 1'b0;
            full_ACC <= 1'b0;
            CC <= 11'b0;
            Yu9 <= 40'b0;
            no_more_operation <= 0;
        end
    else if (digit >= 4'd0 && digit<=4'd9) 
        begin
            CC <= 11'b0;
            Yu9 <= 40'b0;
            if (AUX_counter == 4'b0) 
                begin
                    sgn_AUX <= 1'b0;
                    AUX <= {36'd0, digit};
                    AUX_counter <= AUX_counter + 1'd1;
                    no_more_operation <= 0;
                end
            else 
                begin
                    AUX <= {AUX[35:0], digit};
                    AUX_counter <= AUX_counter + 1'd1;
                    if (AUX_counter == 4'd9) begin full_AUX<=1; end
                end
        end    
    else if (operation >= 2'b01 && operation<=2'b11 && !no_more_operation) 
        begin
            AUX_counter <= 4'b0;
            full_AUX <= 0;
            no_more_operation <= (operation == 2'b11)?1'b0:1'b1;
            if ((sgn_ACC == 1'b0 && sgn_op==1'b0) || (sgn_ACC == 1'b1 && sgn_op==1'b1)) 
                begin    //begin addBCD
                    if (!sgn_ACC) begin sgn_AUX <= 1'b0; $display ("%t Addition of two positive numbers.", $time); end
                    else begin sgn_AUX <= 1'b1; $display ("%t Addition of two negative numbers.", $time); end
                    X = ACC;
                    Y = AUX;
                    begin
                        if (X >= 4'h0 && X<8'h10)
                            nx = 4'd1;
                        else if (X > 4'h9 && X<12'h100)
                            nx = 4'd2;
                        else if (X > 8'h99 && X<16'h1000)
                            nx = 4'd3;
                        else if (X > 12'h999 && X<20'h10000)
                            nx = 4'd4;
                        else if (X > 16'h9999 && X<24'h100000)
                            nx = 4'd5;
                        else if (X > 20'h99999 && X<28'h1000000)
                            nx = 4'd6;
                        else if (X > 24'h999999 && X<32'h10000000)
                            nx = 4'd7;
                        else if (X > 28'h9999999 && X<36'h100000000)
                            nx = 4'd8;
                        else if (X > 32'h99999999 && X<40'h1000000000)
                            nx = 4'd9;
                        else if (X > 36'h999999999 && X<44'h10000000000)
                            nx = 4'd10;
                        else nx = 4'd15;

                        if (Y >= 4'h0 && Y<8'h10)
                            ny = 4'd1;
                        else if (Y > 4'h9 && Y<12'h100)
                            ny = 4'd2;
                        else if (Y > 8'h99 && Y<16'h1000)
                            ny = 4'd3;
                        else if (Y > 12'h999 && Y<20'h10000)
                            ny = 4'd4;
                        else if (Y > 16'h9999 && Y<24'h100000)
                            ny = 4'd5;
                        else if (Y > 20'h99999 && Y<28'h1000000)
                            ny = 4'd6;
                        else if (Y > 24'h999999 && Y<32'h10000000)
                            ny = 4'd7;
                        else if (Y > 28'h9999999 && Y<36'h100000000)
                            ny = 4'd8;
                        else if (Y > 32'h99999999 && Y<40'h1000000000)
                            ny = 4'd9;
                        else if (Y > 36'h999999999 && Y<44'h10000000000)
                            ny = 4'd10;
                        else ny = 4'd15;

                        if (nx > ny)
                            nfin = nx;
                        else
                            nfin = ny;
                    end

                    for (k = 39; k > 4 * nfin - 1; k = k - 1) 
                        begin
                            S_1[k] = 1'b0;
                        end
                    for (i = 0; i < nfin; i = i + 1) 
                        begin
                            { CC[i + 1], R } = { X[4 * i + 3], X[4 * i + 2], X[4 * i + 1], X[4 * i] } + {Y[4 * i + 3], Y[4 * i + 2], Y[4 * i + 1], Y[4 * i]} + CC[i];
                            if (CC[i + 1] | R > 9) 
                                begin     //if cout==1 or r>9
                                    { S_1[4 * i + 3], S_1[4 * i + 2], S_1[4 * i + 1], S_1[4 * i] } = R + 6;            //adjust adding 6
                                    CC[i + 1] = 1'b1;
                                end
                            else { S_1[4 * i + 3], S_1[4 * i + 2], S_1[4 * i + 1], S_1[4 * i] } = R;
                        end
                    for (u = 0; u < 40; u = u + 1) 
                        begin
                            if (nfin == 10) 
                                begin
                                    S[u] = S_1[u];
                                    if (CC[nfin] == 1) begin full_ACC <= 1'b1; S=40'b11101110; end           // Error code EE(hex)
                                end
                            else if (u == 4 * nfin) begin  S[u] = CC[nfin]; end
                            else begin S[u] = S_1[u]; end
                        end

                    AUX <= S;
                    ACC <= (operation == 2'b11)?40'b0:S;
                    sgn_ACC <= (sgn_op == 1'b0)?1'b0:1'b1;
                    sgn_op <= (operation == 2'b11)?sgn_op:((operation==2'b01) ? 1'b0:1'b1);

                end     //end addBCD

            else if ((sgn_ACC == 1'b0 && sgn_op==1'b1) || (sgn_ACC == 1'b1 && sgn_op==1'b0)) 
                begin    //begin subBCD               
                    if (sgn_ACC) begin X = AUX; Y = ACC; $display("%t Subtraction of negative ACC and positive AUX.", $time); end
                    else begin X = ACC; Y = AUX; $display("%t Subtraction of positive ACC and negative AUX.", $time); end
                    begin
                        if (X >= 4'h0 && X<8'h10)
                            nx = 1;
                        else if (X > 4'h9 && X<12'h100)
                            nx = 2;
                        else if (X > 8'h99 && X<16'h1000)
                            nx = 3;
                        else if (X > 12'h999 && X<20'h10000)
                            nx = 4;
                        else if (X > 16'h9999 && X<24'h100000)
                            nx = 5;
                        else if (X > 20'h99999 && X<28'h1000000)
                            nx = 6;
                        else if (X > 24'h999999 && X<32'h10000000)
                            nx = 7;
                        else if (X > 28'h9999999 && X<36'h100000000)
                            nx = 8;
                        else if (X > 32'h99999999 && X<40'h1000000000)
                            nx = 9;
                        else if (X > 36'h999999999 && X<44'h10000000000)
                            nx = 10;
                        else nx = 15;

                        if (Y >= 4'h0 && Y<8'h10)
                            ny = 1;
                        else if (Y > 4'h9 && Y<12'h100)
                            ny = 2;
                        else if (Y > 8'h99 && Y<16'h1000)
                            ny = 3;
                        else if (Y > 12'h999 && Y<20'h10000)
                            ny = 4;
                        else if (Y > 16'h9999 && Y<24'h100000)
                            ny = 5;
                        else if (Y > 20'h99999 && Y<28'h1000000)
                            ny = 6;
                        else if (Y > 24'h999999 && Y<32'h10000000)
                            ny = 7;
                        else if (Y > 28'h9999999 && Y<36'h100000000)
                            ny = 8;
                        else if (Y > 32'h99999999 && Y<40'h1000000000)
                            ny = 9;
                        else if (Y > 36'h999999999 && Y<44'h10000000000)
                            ny = 10;
                        else ny = 15;

                        if (nx > ny)
                            nfin = nx;
                        else
                            nfin = ny;
                    end

                    for (j = 0; j < nfin; j = j + 1)
                        begin
                            case({ Y[4 * j + 3], Y[4 * j + 2], Y[4 * j + 1], Y[4 * j] })
                                4'b0000: begin Yu9[4*j+3]=1'b1; Yu9[4 * j + 2] = 1'b0; Yu9[4*j+1]=1'b0; Yu9[4 * j] = 1'b1; end
                                4'b0001: begin Yu9[4*j+3]=1'b1; Yu9[4 * j + 2] = 1'b0; Yu9[4*j+1]=1'b0; Yu9[4 * j] = 1'b0; end
                                4'b0010: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b1; Yu9[4*j+1]=1'b1; Yu9[4 * j] = 1'b1; end
                                4'b0011: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b1; Yu9[4*j+1]=1'b1; Yu9[4 * j] = 1'b0; end
                                4'b0100: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b1; Yu9[4*j+1]=1'b0; Yu9[4 * j] = 1'b1; end
                                4'b0101: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b1; Yu9[4*j+1]=1'b0; Yu9[4 * j] = 1'b0; end
                                4'b0110: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b0; Yu9[4*j+1]=1'b1; Yu9[4 * j] = 1'b1; end
                                4'b0111: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b0; Yu9[4*j+1]=1'b1; Yu9[4 * j] = 1'b0; end
                                4'b1000: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b0; Yu9[4*j+1]=1'b0; Yu9[4 * j] = 1'b1; end
                                4'b1001: begin Yu9[4*j+3]=1'b0; Yu9[4 * j + 2] = 1'b0; Yu9[4*j+1]=1'b0; Yu9[4 * j] = 1'b0; end
                                default: begin Yu9[4 * j + 3] = 1'b1; Yu9[4*j+2]=1'b1; Yu9[4 * j + 1] = 1'b1; Yu9[4*j]=1'b1; end
                            endcase
                        end
                    for (k = 39; k > 4 * nfin - 1; k = k - 1) 
                        begin
                            S_1[k] = 1'b0;
                        end
                    for (i = 0; i < nfin; i = i + 1) 
                        begin
                            { CC[i + 1], R } = { X[4 * i + 3], X[4 * i + 2], X[4 * i + 1], X[4 * i] } + {Yu9[4 * i + 3], Yu9[4 * i + 2], Yu9[4 * i + 1], Yu9[4 * i]} + CC[i];
                            if (CC[i + 1] | R > 9) 
                                begin     //if cout==1 or r>9
                                    { S_1[4 * i + 3], S_1[4 * i + 2], S_1[4 * i + 1], S_1[4 * i] } = R + 6;            //adjust adding 6
                                    CC[i + 1] = 1'b1;
                                end
                            else { S_1[4 * i + 3], S_1[4 * i + 2], S_1[4 * i + 1], S_1[4 * i] } = R;
                        end

                    if (CC[nfin]) 
                        begin          //positive result of subtraction
                            if (S_1[3:0] > 4'b1000) S=S_1+4'b0111;
                            else S = S_1 + 4'b0001;            
                        end
                    else 
                        begin
                    for (u = 9; u >= 0; u = u - 1) 
                        begin
                            if (u > nfin - 1) 
                                begin
                                    S[4 * u + 3] = 1'b0;
                                    S[4 * u + 2] = 1'b0;
                                    S[4 * u + 1] = 1'b0;
                                    S[4 * u] = 1'b0;
                                end
                            else 
                                begin
                                    case({ S_1[4 * u + 3], S_1[4 * u + 2], S_1[4 * u + 1], S_1[4 * u] })
                                        4'b0000: begin S[4*u+3]=1'b1; S[4 * u + 2] = 1'b0; S[4*u+1]=1'b0; S[4 * u] = 1'b1; end
                                        4'b0001: begin S[4*u+3]=1'b1; S[4 * u + 2] = 1'b0; S[4*u+1]=1'b0; S[4 * u] = 1'b0; end
                                        4'b0010: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b1; S[4*u+1]=1'b1; S[4 * u] = 1'b1; end
                                        4'b0011: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b1; S[4*u+1]=1'b1; S[4 * u] = 1'b0; end
                                        4'b0100: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b1; S[4*u+1]=1'b0; S[4 * u] = 1'b1; end
                                        4'b0101: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b1; S[4*u+1]=1'b0; S[4 * u] = 1'b0; end
                                        4'b0110: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b0; S[4*u+1]=1'b1; S[4 * u] = 1'b1; end
                                        4'b0111: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b0; S[4*u+1]=1'b1; S[4 * u] = 1'b0; end
                                        4'b1000: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b0; S[4*u+1]=1'b0; S[4 * u] = 1'b1; end
                                        4'b1001: begin S[4*u+3]=1'b0; S[4 * u + 2] = 1'b0; S[4*u+1]=1'b0; S[4 * u] = 1'b0; end
                                        default: begin S[4 * u + 3] = 1'b1; S[4*u+2]=1'b1; S[4 * u + 1] = 1'b1; S[4*u]=1'b1; end
                                    endcase
                                end
                        end
                    end

                    AUX <= S;
                    sgn_AUX <= ~CC[nfin];
                    ACC <= (operation == 2'b11)?40'b0:S;
                    sgn_ACC <= ~CC[nfin];
                    sgn_op <= (operation == 2'b11)?~CC[nfin]:((operation==2'b01) ? 1'b0:1'b1);
                end     //end subBCD
        end
    end         

endmodule
