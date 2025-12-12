
module payoff_calculator(
    input decision_a,      // 0 = cooperate, 1 = defect
    input decision_b,
    output reg [2:0] points_a,
    output reg [2:0] points_b
);

    // Prisoner's Dilemma payoff matrix
    always @(*) begin
        case ({decision_a, decision_b})
            2'b00: begin  // Both cooperate
                points_a = 3'd3;
                points_b = 3'd3;
            end
            2'b01: begin  // A cooperates, B defects
                points_a = 3'd0;
                points_b = 3'd5;
            end
            2'b10: begin  // A defects, B cooperates
                points_a = 3'd5;
                points_b = 3'd0;
            end
            2'b11: begin  // Both defect
                points_a = 3'd1;
                points_b = 3'd1;
            end
        endcase
    end

endmodule




