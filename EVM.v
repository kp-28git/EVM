module evm (
    input wire [3:0] voter_switch,     // Voting switch for 4 different parties
    input wire Push_Button,            // Button to cast vote
    input wire voting_en,              // Enable voting
    input wire reset,                  // Reset signal
    
    output reg [6:0] dout,             // Total vote count (max 128)
    output reg [4:0] v1,               // Votes for selected party
    output reg [6:0] seg3,             // Indicates party number being voted for
    output reg [6:0] seg2,             // Displays individual vote count for a party
    
    input wire sw1,                    // Switch for party 1
    input wire sw2,                    // Switch for party 2
    input wire sw3,                    // Switch for party 3
    input wire sw4,                    // Switch for party 4
    input wire swout                   // Switch to display vote count for each party
);

// Registers for each party's vote count
reg [4:0] cnt_reg1 = 0;  // Party 1
reg [4:0] cnt_reg2 = 0;  // Party 2
reg [4:0] cnt_reg3 = 0;  // Party 3
reg [4:0] cnt_reg4 = 0;  // Party 4

// Counting votes for each party
always @(posedge Push_Button or posedge reset) begin
    if (reset) cnt_reg1 <= 0;
    else if (voter_switch == 4'b0001 && voting_en) cnt_reg1 <= cnt_reg1 + 1;
end

always @(posedge Push_Button or posedge reset) begin
    if (reset) cnt_reg2 <= 0;
    else if (voter_switch == 4'b0010 && voting_en) cnt_reg2 <= cnt_reg2 + 1;
end

always @(posedge Push_Button or posedge reset) begin
    if (reset) cnt_reg3 <= 0;
    else if (voter_switch == 4'b0100 && voting_en) cnt_reg3 <= cnt_reg3 + 1;
end

always @(posedge Push_Button or posedge reset) begin
    if (reset) cnt_reg4 <= 0;
    else if (voter_switch == 4'b1000 && voting_en) cnt_reg4 <= cnt_reg4 + 1;
end

// Total votes calculation
always @(*) begin
    if (swout && voting_en)
        dout = cnt_reg1 + cnt_reg2 + cnt_reg3 + cnt_reg4;
    else
        dout = 6'b000000;
end

// Display individual party votes and party number on 7-segment
always @(*) begin
    casez ({sw1, sw2, sw3, sw4, swout})
        5'b10000: begin
            v1 = cnt_reg1;
            seg3 = 7'b1001111; // Display "1" for party 1
        end
        5'b01000: begin
            v1 = cnt_reg2;
            seg3 = 7'b0010010; // Display "2" for party 2
        end
        5'b00100: begin
            v1 = cnt_reg3;
            seg3 = 7'b0000110; // Display "3" for party 3
        end
        5'b00010: begin
            v1 = cnt_reg4;
            seg3 = 7'b1001100; // Display "4" for party 4
        end
    endcase

    casez ({sw1, sw2, sw3, sw4, swout})
        5'b10001: seg2 = seven(cnt_reg1); // Show votes for party 1
        5'b01001: seg2 = seven(cnt_reg2); // Show votes for party 2
        5'b00101: seg2 = seven(cnt_reg3); // Show votes for party 3
        5'b00011: seg2 = seven(cnt_reg4); // Show votes for party 4
    endcase
end

// 7-Segment Display Decoder
function [6:0] seven;
    input [3:0] data_in;
    begin
        case (data_in)
            4'b0000: seven = 7'b0000001; // Display "0"
            4'b0001: seven = 7'b1001111; // Display "1"
            4'b0010: seven = 7'b0010010; // Display "2"
            4'b0011: seven = 7'b0000110; // Display "3"
            4'b0100: seven = 7'b1001100; // Display "4"
            4'b0101: seven = 7'b0100100; // Display "5"
            4'b0110: seven = 7'b0100000; // Display "6"
            4'b0111: seven = 7'b0001111; // Display "7"
            4'b1000: seven = 7'b0000000; // Display "8"
            4'b1001: seven = 7'b0000100; // Display "9"
            default: seven = 7'b1111111; // Blank display
        endcase
    end
endfunction

endmodule
