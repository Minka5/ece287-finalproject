module string_display(
    input [9:0] x,
    input [9:0] y,
    input [9:0] start_x,
    input [9:0] start_y,
    input [7:0] char0,
    input [7:0] char1,
    input [7:0] char2,
    input [7:0] char3,
    input [7:0] char4,
    input [7:0] char5,
    input [7:0] char6,
    input [7:0] char7,
    input [7:0] char8,
    input [7:0] char9,
    input [3:0] str_length,
    output reg pixel_on
);

    parameter CHAR_WIDTH = 6;
    
    wire [9:0] relative_x = x - start_x;
    wire [9:0] relative_y = y - start_y;
    
    wire in_region = (x >= start_x && x < (start_x + str_length * CHAR_WIDTH) &&
                      y >= start_y && y < (start_y + 8));
    
    wire [3:0] char_index = relative_x / CHAR_WIDTH;
    wire [9:0] char_x = start_x + (char_index * CHAR_WIDTH);
    
    reg [7:0] current_char;
    always @(*) begin
        case (char_index)
            4'd0: current_char = char0;
            4'd1: current_char = char1;
            4'd2: current_char = char2;
            4'd3: current_char = char3;
            4'd4: current_char = char4;
            4'd5: current_char = char5;
            4'd6: current_char = char6;
            4'd7: current_char = char7;
            4'd8: current_char = char8;
            4'd9: current_char = char9;
            default: current_char = 8'd32; // Space
        endcase
    end
    
    wire [2:0] char_row = relative_y[2:0];
    wire [2:0] char_col = relative_x % CHAR_WIDTH;
    
    wire char_pixel;
    char_rom rom(
        .char_code(current_char),
        .row(char_row),
        .col(char_col),
        .pixel_on(char_pixel)
    );
    
    always @(*) begin
        pixel_on = in_region && char_pixel && (char_index < str_length);
    end

endmodule
