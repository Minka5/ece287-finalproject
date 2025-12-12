module color_generator(
    input active_pixels,
    input [9:0] x,
    input [9:0] y,
    input decision_a,
    input decision_b,
    input [7:0] score_a,
    input [7:0] score_b,
    input [6:0] round_count,
    input [9:0] history_a,
    input [9:0] history_b,
	 input [1:0] sel_a,
	 input [1:0] sel_b,
    output reg [23:0] color_out
);

    // Color definitions
    localparam [23:0] COLOR_BG = 24'h2B2B2B;        // Dark gray background
    localparam [23:0] COLOR_COOPERATE = 24'h0088FF; // Blue
    localparam [23:0] COLOR_DEFECT = 24'hFF0000;    // Red
    localparam [23:0] COLOR_TEXT = 24'hC0C0C0;      // Light gray text
    localparam [23:0] COLOR_BOX_BORDER = 24'h808080; // Gray border
    
    // Main decision boxes (90x90 pixels)
    wire box_a = (x >= 10'd55 && x < 10'd145 && y >= 10'd75 && y < 10'd165);
    wire box_b = (x >= 10'd195 && x < 10'd285 && y >= 10'd75 && y < 10'd165);
    
    // Box borders (1 pixel border)
    wire box_a_border = ((x >= 10'd54 && x < 10'd146 && (y == 10'd74 || y == 10'd165)) ||
                         (y >= 10'd74 && y < 10'd166 && (x == 10'd54 || x == 10'd145)));
    wire box_b_border = ((x >= 10'd194 && x < 10'd286 && (y == 10'd74 || y == 10'd165)) ||
                         (y >= 10'd74 && y < 10'd166 && (x == 10'd194 || x == 10'd285)));
    
    // Text: "Player A" at (58, 178)
    wire text_player_a;
    string_display str_player_a(
        .x(x), .y(y),
        .start_x(10'd58), .start_y(10'd178),
        .char0(8'd80), .char1(8'd108), .char2(8'd97), .char3(8'd121), .char4(8'd101),
        .char5(8'd114), .char6(8'd32), .char7(8'd65), .char8(8'd32), .char9(8'd32),
        .str_length(4'd8),
        .pixel_on(text_player_a)
    );
    
    // Text: "Player B" at (198, 178)
    wire text_player_b;
    string_display str_player_b(
        .x(x), .y(y),
        .start_x(10'd198), .start_y(10'd178),
        .char0(8'd80), .char1(8'd108), .char2(8'd97), .char3(8'd121), .char4(8'd101),
        .char5(8'd114), .char6(8'd32), .char7(8'd66), .char8(8'd32), .char9(8'd32),
        .str_length(4'd8),
        .pixel_on(text_player_b)
    );
    
    // Text: "History (Last 10 rounds):" at (35, 245)
    wire text_history_label;
    string_display str_history(
        .x(x), .y(y),
        .start_x(10'd35), .start_y(10'd245),
        .char0(8'd72), .char1(8'd105), .char2(8'd115), .char3(8'd116), .char4(8'd111),
        .char5(8'd114), .char6(8'd121), .char7(8'd32), .char8(8'd40), .char9(8'd76),
        .str_length(4'd10),
        .pixel_on(text_history_label)
    );
    
    // History boxes for Player A (10 boxes, 20x20 each)
    // Starting at x=40, y=275
    wire [3:0] hist_a_index;
    wire hist_a_valid;
    assign hist_a_valid = (x >= 10'd40 && x < 10'd280 && y >= 10'd275 && y < 10'd295);
    assign hist_a_index = (x - 10'd40) / 10'd24; // 20px box + 4px spacing
    
    wire hist_a_box = hist_a_valid && (((x - 10'd40) % 10'd24) < 10'd20) && (hist_a_index < 10);
    
    // History boxes for Player B (10 boxes, 20x20 each)
    // Starting at x=40, y=330
    wire [3:0] hist_b_index;
    wire hist_b_valid;
    assign hist_b_valid = (x >= 10'd40 && x < 10'd280 && y >= 10'd330 && y < 10'd350);
    assign hist_b_index = (x - 10'd40) / 10'd24;
    
    wire hist_b_box = hist_b_valid && (((x - 10'd40) % 10'd24) < 10'd20) && (hist_b_index < 10);
	 
	 
    
    // Text: "(Player A)" at (275, 282)
    wire text_hist_a_label;
    string_display str_hist_a(
        .x(x), .y(y),
        .start_x(10'd275), .start_y(10'd282),
        .char0(8'd40), .char1(8'd80), .char2(8'd108), .char3(8'd97), .char4(8'd121),
        .char5(8'd101), .char6(8'd114), .char7(8'd32), .char8(8'd65), .char9(8'd41),
        .str_length(4'd10),
        .pixel_on(text_hist_a_label)
    );
    
    // Text: "(Player B)" at (275, 337)
    wire text_hist_b_label;
    string_display str_hist_b(
        .x(x), .y(y),
        .start_x(10'd275), .start_y(10'd337),
        .char0(8'd40), .char1(8'd80), .char2(8'd108), .char3(8'd97), .char4(8'd121),
        .char5(8'd101), .char6(8'd114), .char7(8'd32), .char8(8'd66), .char9(8'd41),
        .str_length(4'd10),
        .pixel_on(text_hist_b_label)
    );
    
    // Text: "Blue=Cooperate, Red=Defect" at (35, 400)
    wire text_legend;
    string_display str_legend(
        .x(x), .y(y),
        .start_x(10'd35), .start_y(10'd400),
        .char0(8'd66), .char1(8'd108), .char2(8'd117), .char3(8'd101), .char4(8'd61),
        .char5(8'd67), .char6(8'd111), .char7(8'd111), .char8(8'd112), .char9(8'd44),
        .str_length(4'd10),
        .pixel_on(text_legend)
    );
	 
	 
	 
	     // ========================================
    // ROUND PROGRESS BAR (under history)
    // ========================================
    localparam [9:0] BAR_X = 10'd40;
    localparam [9:0] BAR_Y = 10'd365;
    localparam [9:0] BAR_W = 10'd240;
    localparam [9:0] BAR_H = 10'd14;

    localparam [6:0] MAX_ROUNDS = 7'd50;

    localparam [23:0] COLOR_PROGRESS_FILL = 24'h00CC66;
    localparam [23:0] COLOR_PROGRESS_BG   = 24'h3A3A3A;

    wire bar_region = (x >= BAR_X && x < (BAR_X + BAR_W) &&
                       y >= BAR_Y && y < (BAR_Y + BAR_H));

    wire bar_border = bar_region &&
                      (x == BAR_X || x == (BAR_X + BAR_W - 1) ||
                       y == BAR_Y || y == (BAR_Y + BAR_H - 1));

    wire bar_inner  = bar_region && !bar_border;

    localparam [9:0] BAR_INNER_W = (BAR_W - 10'd2);

    wire [6:0] round_prog_raw = round_count + 7'd1;
    wire [6:0] round_prog = (round_prog_raw >= MAX_ROUNDS) ? MAX_ROUNDS : round_prog_raw;

    wire [9:0] inner_x = x - (BAR_X + 10'd1);

    wire [17:0] lhs = inner_x    * MAX_ROUNDS;
    wire [17:0] rhs = round_prog * BAR_INNER_W;

    wire bar_fill = bar_inner && (lhs < rhs);
	 
	 
	 // ------------------------------
// Round counter text: "R:##"
// ------------------------------
	 wire [7:0] round_bin = {1'b0, round_prog};  // 0..50 fits in 8 bits

	 wire [3:0] round_hundreds, round_tens, round_ones;
	 
	 bin_to_bcd bcd_round(
		 .binary(round_bin),
		 .hundreds(round_hundreds),
		 .tens(round_tens),
		 .ones(round_ones)
	 );

// ASCII digits (suppress leading zero on tens)
	 wire [7:0] round_tens_ascii = (round_tens == 4'd0) ? 8'd32 : (8'd48 + round_tens); // ' ' or '0'..'9'
	 wire [7:0] round_ones_ascii = 8'd48 + round_ones;  
	 
	 wire text_round_counter;

	 string_display str_round_counter(
		 .x(x), .y(y),
		 .start_x(BAR_X + BAR_W + 10'd20),   // e.g., 40+240+20 = 300
		 .start_y(BAR_Y + 10'd3),            // vertically centered-ish
		 .char0(8'd82),                      // 'R'
		 .char1(8'd58),                      // ':'
		 .char2(round_tens_ascii),
		 .char3(round_ones_ascii),
		 .char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		 .str_length(4'd4),
		 .pixel_on(text_round_counter)
	 );
	 
	 wire text_a_tft, text_a_lfsr, text_a_coop, text_a_grud;

	 string_display a_tft(
		.x(x), .y(y), .start_x(10'd75), .start_y(10'd50),
		.char0(8'd84), .char1(8'd70), .char2(8'd84), // "TFT"
		.char3(8'd32), .char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd3),
		.pixel_on(text_a_tft)
	 );

	 string_display a_lfsr(
		.x(x), .y(y), .start_x(10'd75), .start_y(10'd50),
		.char0(8'd76), .char1(8'd70), .char2(8'd83), .char3(8'd82), // "LFSR"
		.char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd4),
		.pixel_on(text_a_lfsr)
	 );

	 string_display a_coop(
		.x(x), .y(y), .start_x(10'd75), .start_y(10'd50),
		.char0(8'd67), .char1(8'd79), .char2(8'd79), .char3(8'd80), // "COOP"
		.char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd4),
		.pixel_on(text_a_coop)
	 );

	 string_display a_grud(
		.x(x), .y(y), .start_x(10'd75), .start_y(10'd50),
		.char0(8'd71), .char1(8'd82), .char2(8'd85), .char3(8'd68), // "GRUD"
		.char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd4),
		.pixel_on(text_a_grud)
	 );

	  assign text_strat_a =
		(sel_a == 2'b00) ? text_a_tft  :
		(sel_a == 2'b01) ? text_a_lfsr :
		(sel_a == 2'b10) ? text_a_coop :
                       text_a_grud;

	 wire text_b_tft, text_b_lfsr, text_b_coop, text_b_grud;

	 string_display b_tft(
		.x(x), .y(y), .start_x(10'd215), .start_y(10'd50),
		.char0(8'd84), .char1(8'd70), .char2(8'd84),
		.char3(8'd32), .char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd3),
		.pixel_on(text_b_tft)
	 );

	 string_display b_lfsr(
		.x(x), .y(y), .start_x(10'd215), .start_y(10'd50),
		.char0(8'd76), .char1(8'd70), .char2(8'd83), .char3(8'd82),
		.char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd4),
		.pixel_on(text_b_lfsr)
	 );

	 string_display b_coop(
		.x(x), .y(y), .start_x(10'd215), .start_y(10'd50),
		.char0(8'd67), .char1(8'd79), .char2(8'd79), .char3(8'd80),
		.char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd4),
		.pixel_on(text_b_coop)
	 );

	string_display b_grud(
		.x(x), .y(y), .start_x(10'd215), .start_y(10'd50),
		.char0(8'd71), .char1(8'd82), .char2(8'd85), .char3(8'd68),
		.char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
		.str_length(4'd4),
		.pixel_on(text_b_grud)
	 );

	 assign text_strat_b =
		(sel_b == 2'b00) ? text_b_tft  :
		(sel_b == 2'b01) ? text_b_lfsr :
		(sel_b == 2'b10) ? text_b_coop :
								text_b_grud;

	
    
    // Generate colors
    always @(*) begin
        if (!active_pixels) begin
            color_out = 24'h000000;
        end
        // Text has highest priority
        else if  (text_round_counter ||
         text_strat_a || text_strat_b ||
         text_player_a || text_player_b || text_history_label || 
         text_hist_a_label || text_hist_b_label || text_legend) begin
            color_out = COLOR_TEXT;
        end
        // Box borders
        else if (box_a_border || box_b_border) begin
            color_out = COLOR_BOX_BORDER;
        end
        // Main decision boxes
        else if (box_a) begin
            color_out = decision_a ? COLOR_DEFECT : COLOR_COOPERATE;
        end
        else if (box_b) begin
            color_out = decision_b ? COLOR_DEFECT : COLOR_COOPERATE;
        end
        // History boxes
        else if (hist_a_box && hist_a_index < 10) begin
            color_out = history_a[hist_a_index] ? COLOR_DEFECT : COLOR_COOPERATE;
        end
        else if (hist_b_box && hist_b_index < 10) begin
            color_out = history_b[hist_b_index] ? COLOR_DEFECT : COLOR_COOPERATE;
        end
		      // Progress bar (add these wires above this always block)
        else if (bar_border) begin
        color_out = COLOR_BOX_BORDER;
        end
        else if (bar_inner) begin
        color_out = bar_fill ? COLOR_PROGRESS_FILL : COLOR_PROGRESS_BG;
        end
        // Background
        else begin
            color_out = COLOR_BG;
        end
    end

endmodule

