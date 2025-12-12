module history_buffer(
    input clk,
    input reset,
    input write_en,
    input decision,
    output reg [9:0] history  // Last 10 moves as bits
);

    always @(posedge clk) begin
        if (reset) begin
            history <= 10'b0;
        end
        else if (write_en) begin
            // Shift left and add new decision
            history <= {history[8:0], decision};
        end
    end

endmodule

