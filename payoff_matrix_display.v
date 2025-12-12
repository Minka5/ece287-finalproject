module payoff_matrix_display(
    input [9:0] x,
    input [9:0] y,
    input decision_a,        // Current decision by player A
    input decision_b,        // Current decision by player B
    output reg pixel_on,
    output reg [23:0] pixel_color
);

    // Color definitions
    localparam [23:0] COLOR_BG = 24'h2B2B2B;
    localparam [23:0] COLOR_BORDER = 24'h808080;
    localparam [23:0] COLOR_TEXT = 24'hC0C0C0;
    localparam [23:0] COLOR_HIGHLIGHT = 24'hFFFF00;  // Yellow for current outcome
    localparam [23:0] COLOR_CELL_BG = 24'h3a3a3a;
    
    // Matrix position and sizing
    // Top-left corner of matrix
    localparam [9:0] MATRIX_X = 10'd350;
    localparam [9:0] MATRIX_Y = 10'd50;
    
    // Cell dimensions
    localparam [9:0] CELL_WIDTH = 10'd80;
    localparam [9:0] CELL_HEIGHT = 10'd40;
    localparam [9:0] BORDER_WIDTH = 10'd2;
    
    // Define matrix grid regions
    // Row 0: Headers (Player B, Cooperate, Defect)
    // Row 1: Player A Cooperate row
    // Row 2: Player A Defect row
    // Col 0: Player A labels
    // Col 1: (3,3) cell - both cooperate
    // Col 2: (0,5) cell - A coop, B defect
    // Row 2, Col 1: (5,0) cell - A defect, B coop
    // Row 2, Col 2: (1,1) cell - both defect
    
    // Calculate which cell we're in
    wire in_matrix_region = (x >= MATRIX_X && x < (MATRIX_X + CELL_WIDTH * 3 + BORDER_WIDTH * 4) &&
                             y >= MATRIX_Y && y < (MATRIX_Y + CELL_HEIGHT * 3 + BORDER_WIDTH * 4));
    
    wire [9:0] rel_x = x - MATRIX_X;
    wire [9:0] rel_y = y - MATRIX_Y;
    
    // Determine which cell (including borders)
    wire [1:0] cell_col = (rel_x < (CELL_WIDTH + BORDER_WIDTH)) ? 2'd0 :
                          (rel_x < (CELL_WIDTH * 2 + BORDER_WIDTH * 2)) ? 2'd1 :
                          2'd2;
    
    wire [1:0] cell_row = (rel_y < (CELL_HEIGHT + BORDER_WIDTH)) ? 2'd0 :
                          (rel_y < (CELL_HEIGHT * 2 + BORDER_WIDTH * 2)) ? 2'd1 :
                          2'd2;
    
    // Check if we're on a border
    wire on_vertical_border = ((rel_x >= (CELL_WIDTH)) && (rel_x < (CELL_WIDTH + BORDER_WIDTH))) ||
                              ((rel_x >= (CELL_WIDTH * 2 + BORDER_WIDTH)) && (rel_x < (CELL_WIDTH * 2 + BORDER_WIDTH * 2)));
    
    wire on_horizontal_border = ((rel_y >= (CELL_HEIGHT)) && (rel_y < (CELL_HEIGHT + BORDER_WIDTH))) ||
                                ((rel_y >= (CELL_HEIGHT * 2 + BORDER_WIDTH)) && (rel_y < (CELL_HEIGHT * 2 + BORDER_WIDTH * 2)));
    
    wire on_border = on_vertical_border || on_horizontal_border;
    
    // Determine which outcome cell should be highlighted
    wire highlight_cell_11 = (!decision_a && !decision_b);  // Both cooperate (3,3)
    wire highlight_cell_12 = (!decision_a && decision_b);   // A coop, B defect (0,5)
    wire highlight_cell_21 = (decision_a && !decision_b);   // A defect, B coop (5,0)
    wire highlight_cell_22 = (decision_a && decision_b);    // Both defect (1,1)
    
    // Check if current pixel is in a highlighted cell
    wire in_highlighted_cell = ((cell_row == 2'd1 && cell_col == 2'd1 && highlight_cell_11) ||
                                (cell_row == 2'd1 && cell_col == 2'd2 && highlight_cell_12) ||
                                (cell_row == 2'd2 && cell_col == 2'd1 && highlight_cell_21) ||
                                (cell_row == 2'd2 && cell_col == 2'd2 && highlight_cell_22));
    
    // Text rendering for payoff values
    // We'll use simple positioning for numbers
    
    // Cell (1,1): "3,3" - Both cooperate
    wire in_cell_11 = (cell_row == 2'd1 && cell_col == 2'd1 && !on_border);
    wire text_cell_11_3_left, text_cell_11_comma, text_cell_11_3_right;
    
    // Position for "3,3" in cell (1,1)
    wire [9:0] cell_11_x = MATRIX_X + CELL_WIDTH + BORDER_WIDTH;
    wire [9:0] cell_11_y = MATRIX_Y + CELL_HEIGHT + BORDER_WIDTH;
    
    string_display str_cell_11(
        .x(x), .y(y),
        .start_x(cell_11_x + 10'd25),
        .start_y(cell_11_y + 10'd15),
        .char0(8'd51), .char1(8'd44), .char2(8'd51),  // "3,3"
        .char3(8'd32), .char4(8'd32), .char5(8'd32),
        .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
        .str_length(4'd3),
        .pixel_on(text_cell_11_3_left)
    );
    
    // Cell (1,2): "0,5" - A coop, B defect
    wire text_cell_12;
    wire [9:0] cell_12_x = MATRIX_X + CELL_WIDTH * 2 + BORDER_WIDTH * 2;
    wire [9:0] cell_12_y = MATRIX_Y + CELL_HEIGHT + BORDER_WIDTH;
    
    string_display str_cell_12(
        .x(x), .y(y),
        .start_x(cell_12_x + 10'd25),
        .start_y(cell_12_y + 10'd15),
        .char0(8'd48), .char1(8'd44), .char2(8'd53),  // "0,5"
        .char3(8'd32), .char4(8'd32), .char5(8'd32),
        .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
        .str_length(4'd3),
        .pixel_on(text_cell_12)
    );
    
    // Cell (2,1): "5,0" - A defect, B coop
    wire text_cell_21;
    wire [9:0] cell_21_x = MATRIX_X + CELL_WIDTH + BORDER_WIDTH;
    wire [9:0] cell_21_y = MATRIX_Y + CELL_HEIGHT * 2 + BORDER_WIDTH * 2;
    
    string_display str_cell_21(
        .x(x), .y(y),
        .start_x(cell_21_x + 10'd25),
        .start_y(cell_21_y + 10'd15),
        .char0(8'd53), .char1(8'd44), .char2(8'd48),  // "5,0"
        .char3(8'd32), .char4(8'd32), .char5(8'd32),
        .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
        .str_length(4'd3),
        .pixel_on(text_cell_21)
    );
    
    // Cell (2,2): "1,1" - Both defect
    wire text_cell_22;
    wire [9:0] cell_22_x = MATRIX_X + CELL_WIDTH * 2 + BORDER_WIDTH * 2;
    wire [9:0] cell_22_y = MATRIX_Y + CELL_HEIGHT * 2 + BORDER_WIDTH * 2;
    
    string_display str_cell_22(
        .x(x), .y(y),
        .start_x(cell_22_x + 10'd25),
        .start_y(cell_22_y + 10'd15),
        .char0(8'd49), .char1(8'd44), .char2(8'd49),  // "1,1"
        .char3(8'd32), .char4(8'd32), .char5(8'd32),
        .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
        .str_length(4'd3),
        .pixel_on(text_cell_22)
    );
    
    // Header labels
    // "Player B" at top
    wire text_header_b;
    string_display str_header_b(
        .x(x), .y(y),
        .start_x(MATRIX_X + CELL_WIDTH + 10'd30),
        .start_y(MATRIX_Y - 10'd20),
        .char0(8'd80), .char1(8'd108), .char2(8'd97), .char3(8'd121),  // "Play"
        .char4(8'd101), .char5(8'd114), .char6(8'd32), .char7(8'd66),  // "er B"
        .char8(8'd32), .char9(8'd32),
        .str_length(4'd8),
        .pixel_on(text_header_b)
    );
    
    // "Coop" above column 1
    wire text_coop_top;
    string_display str_coop_top(
        .x(x), .y(y),
        .start_x(MATRIX_X + CELL_WIDTH + 10'd20),
        .start_y(MATRIX_Y + 10'd10),
        .char0(8'd67), .char1(8'd111), .char2(8'd111), .char3(8'd112),  // "Coop"
        .char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32),
        .char8(8'd32), .char9(8'd32),
        .str_length(4'd4),
        .pixel_on(text_coop_top)
    );
    
    // "Defect" above column 2
    wire text_defect_top;
    string_display str_defect_top(
        .x(x), .y(y),
        .start_x(MATRIX_X + CELL_WIDTH * 2 + BORDER_WIDTH + 10'd15),
        .start_y(MATRIX_Y + 10'd10),
        .char0(8'd68), .char1(8'd101), .char2(8'd102), .char3(8'd101),  // "Defe"
        .char4(8'd99), .char5(8'd116), .char6(8'd32), .char7(8'd32),    // "ct"
        .char8(8'd32), .char9(8'd32),
        .str_length(4'd6),
        .pixel_on(text_defect_top)
    );
    
    // "Player A" on left side (rotated text would be complex, use "A:" for simplicity)
    wire text_header_a_coop, text_header_a_defect;
    
    // "Coop" next to row 1
    string_display str_a_coop(
        .x(x), .y(y),
        .start_x(MATRIX_X + 10'd5),
        .start_y(MATRIX_Y + CELL_HEIGHT + 10'd15),
        .char0(8'd67), .char1(8'd111), .char2(8'd111), .char3(8'd112),  // "Coop"
        .char4(8'd32), .char5(8'd32), .char6(8'd32), .char7(8'd32),
        .char8(8'd32), .char9(8'd32),
        .str_length(4'd4),
        .pixel_on(text_header_a_coop)
    );
    
    // "Defect" next to row 2
    string_display str_a_defect(
        .x(x), .y(y),
        .start_x(MATRIX_X + 10'd5),
        .start_y(MATRIX_Y + CELL_HEIGHT * 2 + BORDER_WIDTH + 10'd15),
        .char0(8'd68), .char1(8'd101), .char2(8'd102), .char3(8'd101),  // "Defe"
        .char4(8'd99), .char5(8'd116), .char6(8'd32), .char7(8'd32),    // "ct"
        .char8(8'd32), .char9(8'd32),
        .str_length(4'd6),
        .pixel_on(text_header_a_defect)
    );
    
    // Arrow indicator for current cell
    wire text_arrow;
    wire [9:0] arrow_y = (cell_row == 2'd1) ? (cell_11_y + 10'd15) : (cell_21_y + 10'd15);
    
    string_display str_arrow(
        .x(x), .y(y),
        .start_x(MATRIX_X + CELL_WIDTH * 3 + BORDER_WIDTH * 3 + 10'd10),
        .start_y(arrow_y),
        .char0(8'd60), .char1(8'd45), .char2(8'd32),  // "<-"
        .char3(8'd32), .char4(8'd32), .char5(8'd32),
        .char6(8'd32), .char7(8'd32), .char8(8'd32), .char9(8'd32),
        .str_length(4'd2),
        .pixel_on(text_arrow)
    );
    
    // Output logic
    always @(*) begin
        pixel_on = 1'b0;
        pixel_color = COLOR_BG;
        
        if (in_matrix_region) begin
            if (on_border) begin
                // Draw border
                pixel_on = 1'b1;
                pixel_color = COLOR_BORDER;
            end
            else if (in_highlighted_cell) begin
                // Highlight current outcome cell
                pixel_on = 1'b1;
                pixel_color = COLOR_HIGHLIGHT;
            end
            else if (cell_row > 0 && cell_col > 0) begin
                // Inside a data cell
                pixel_on = 1'b1;
                pixel_color = COLOR_CELL_BG;
            end
        end
        
        // Text overlays (highest priority)
        if (text_cell_11_3_left || text_cell_12 || text_cell_21 || text_cell_22 ||
            text_header_b || text_coop_top || text_defect_top ||
            text_header_a_coop || text_header_a_defect) begin
            pixel_on = 1'b1;
            pixel_color = COLOR_TEXT;
        end
        
        // Arrow indicator
        if (text_arrow && in_highlighted_cell) begin
            pixel_on = 1'b1;
            pixel_color = COLOR_HIGHLIGHT;
        end
    end

Endmodule
