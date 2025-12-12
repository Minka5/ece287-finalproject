
module strategy_grudger(
    input  wire clk,
    input  wire reset,
    input  wire round_start,
    input  wire opponent_last_move,   // 1 = defect, 0 = cooperate
    output reg  decision              // 1 = defect, 0 = cooperate
);

    reg grudge; // once set, stays set until reset

    always @(posedge clk) begin
        if (reset) begin
            grudge   <= 1'b0;
            decision <= 1'b0; // start by cooperating
        end
        else if (round_start) begin
            // If opponent defected last round, hold a grudge forever
            if (opponent_last_move)
                grudge <= 1'b1;

            // Decision for this round
            decision <= grudge ? 1'b1 : 1'b0;
        end
    end

endmodule
