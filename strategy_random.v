module strategy_random #( 
	parameter [7:0] SEED = 8'b10101010 
)(
    input clk,
    input reset,
    input round_start,
    output reg decision
);

    // Linear Feedback Shift Register (LFSR) for pseudo-random numbers
    reg [7:0] lfsr;
    
    always @(posedge clk) begin
        if (reset) begin
            lfsr     <= (SEED == 8'h00) ? 8'hA5 : SEED; // avoid all-zero lockup
            decision <= 1'b0;
        end
        else begin
            // LFSR generates pseudo-random bits
            // Taps at positions 7, 5, 4, 3 (maximal length)
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
            
            if (round_start) begin
                // Use bit 0: roughly 50% chance cooperate, 50% defect
                decision <= lfsr[0];
            end
        end
    end

endmodule

