module game_controller(
    input clk,
    input reset,
	 input restart,
    input decision_a,
    input decision_b,
    output reg [7:0] score_a,
    output reg [7:0] score_b,
    output reg [6:0] round_count,
    output reg round_start,
    output reg game_active
);

    // State definitions
    localparam IDLE = 3'd0;
    localparam COMPUTE = 3'd1;
    localparam SCORE_UPDATE = 3'd2;
    localparam DELAY = 3'd3;
    localparam NEXT_ROUND = 3'd4;
	 localparam GAME_OVER = 3'd5; 
    
	 localparam [6:0] MAX_ROUNDS = 7'd50;   // target = 50 rounds total
    reg [2:0] state;
    reg [26:0] delay_counter;
    
    // Payoff calculator wires
    wire [2:0] points_a, points_b;
    
    // Instantiate payoff calculator
    payoff_calculator payoff(
        .decision_a(decision_a),
        .decision_b(decision_b),
        .points_a(points_a),
        .points_b(points_b)
    );
    
    // Main FSM
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            score_a <= 8'd0;
            score_b <= 8'd0;
            round_count <= 7'd0;
            round_start <= 1'b0;
            delay_counter <= 27'd0;
            game_active <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    game_active <= 1'b1;
                    round_start <= 1'b1;
                    state <= COMPUTE;
                end
                
                COMPUTE: begin
                    round_start <= 1'b0;
                    state <= SCORE_UPDATE;
                end
                
               
					SCORE_UPDATE: begin
					score_a <= score_a + points_a;
					score_b <= score_b + points_b;

						// If we just scored the LAST round, pause
					if (round_count == (MAX_ROUNDS - 7'd1))
						state <= GAME_OVER;
					else
						state <= DELAY;
					end
               
                
                DELAY: begin
                    // Wait 1 second (50 million cycles at 50MHz)
                    if (delay_counter == 27'd50_000_000) begin
                        delay_counter <= 27'd0;
                        state <= NEXT_ROUND;
                    end
                    else begin
                        delay_counter <= delay_counter + 1;
                    end
                end
                
                
					 NEXT_ROUND: begin
					 round_count <= round_count + 1'b1;
					 round_start <= 1'b1;
					 state <= COMPUTE;
				 end
					 
                GAME_OVER: begin
                    game_active <= 1'b0;   // LEDR[2] will drop if you want an indicator
                    round_start <= 1'b0;
                    delay_counter <= 27'd0;

                    // Hold final scores until user restarts
                    if (restart) begin
                        score_a     <= 8'd0;
                        score_b     <= 8'd0;
                        round_count <= 7'd0;
                        state       <= IDLE;
                    end
                end					 
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule


