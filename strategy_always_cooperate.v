module strategy_always_cooperate(
    input clk,
    input reset,
    output reg decision
);

    // Always cooperate strategy - the "nice guy"
    always @(posedge clk) begin
        if (reset) begin
            decision <= 1'b0;  // Cooperate
        end
        else begin
            decision <= 1'b0;  // Always cooperate
        end
    end

endmodule

