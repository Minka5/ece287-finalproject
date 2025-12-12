module strategy_tit_for_tat(
    input clk,
    input reset,
    input round_start,
    input opponent_last_move,  // What opponent did last round
    output reg decision
);

    // Tit-for-tat: Start with cooperate, then copy opponent
    always @(posedge clk) begin
        if (reset) begin
            decision <= 1'b0;  // Start by cooperating
        end
        else if (round_start) begin
            // Copy what opponent did last time
            decision <= opponent_last_move;
        end
    end

endmodule
