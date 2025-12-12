module char_rom(
    input [7:0] char_code,    // ASCII character code
    input [2:0] row,          // Row within character (0-6)
    input [2:0] col,          // Column within character (0-4)
    output pixel_on
);

    reg [4:0] char_row;
    
    // 5x7 font definitions for needed characters
    always @(*) begin
        case (char_code)
            // Letters
            8'd65, 8'd97: begin // 'A', 'a'
                case (row)
                    3'd0: char_row = 5'b01110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b11111;
                    3'd4: char_row = 5'b10001;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b10001;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd66, 8'd98: begin // 'B', 'b'
                case (row)
                    3'd0: char_row = 5'b11110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b11110;
                    3'd4: char_row = 5'b10001;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b11110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd67, 8'd99: begin // 'C', 'c'
                case (row)
                    3'd0: char_row = 5'b01110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10000;
                    3'd3: char_row = 5'b10000;
                    3'd4: char_row = 5'b10000;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b01110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd68, 8'd100: begin // 'D', 'd'
                case (row)
                    3'd0: char_row = 5'b11110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b10001;
                    3'd4: char_row = 5'b10001;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b11110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd69, 8'd101: begin // 'E', 'e'
                case (row)
                    3'd0: char_row = 5'b11111;
                    3'd1: char_row = 5'b10000;
                    3'd2: char_row = 5'b10000;
                    3'd3: char_row = 5'b11110;
                    3'd4: char_row = 5'b10000;
                    3'd5: char_row = 5'b10000;
                    3'd6: char_row = 5'b11111;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd70, 8'd102: begin // 'F', 'f'
                case (row)
                    3'd0: char_row = 5'b11111;
                    3'd1: char_row = 5'b10000;
                    3'd2: char_row = 5'b10000;
                    3'd3: char_row = 5'b11110;
                    3'd4: char_row = 5'b10000;
                    3'd5: char_row = 5'b10000;
                    3'd6: char_row = 5'b10000;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd72, 8'd104: begin // 'H', 'h'
                case (row)
                    3'd0: char_row = 5'b10001;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b11111;
                    3'd4: char_row = 5'b10001;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b10001;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd73, 8'd105: begin // 'I', 'i'
                case (row)
                    3'd0: char_row = 5'b01110;
                    3'd1: char_row = 5'b00100;
                    3'd2: char_row = 5'b00100;
                    3'd3: char_row = 5'b00100;
                    3'd4: char_row = 5'b00100;
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b01110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd76, 8'd108: begin // 'L', 'l'
                case (row)
                    3'd0: char_row = 5'b10000;
                    3'd1: char_row = 5'b10000;
                    3'd2: char_row = 5'b10000;
                    3'd3: char_row = 5'b10000;
                    3'd4: char_row = 5'b10000;
                    3'd5: char_row = 5'b10000;
                    3'd6: char_row = 5'b11111;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd79, 8'd111: begin // 'O', 'o'
                case (row)
                    3'd0: char_row = 5'b01110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b10001;
                    3'd4: char_row = 5'b10001;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b01110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd80, 8'd112: begin // 'P', 'p'
                case (row)
                    3'd0: char_row = 5'b11110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b11110;
                    3'd4: char_row = 5'b10000;
                    3'd5: char_row = 5'b10000;
                    3'd6: char_row = 5'b10000;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd82, 8'd114: begin // 'R', 'r'
                case (row)
                    3'd0: char_row = 5'b11110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b11110;
                    3'd4: char_row = 5'b10100;
                    3'd5: char_row = 5'b10010;
                    3'd6: char_row = 5'b10001;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd83, 8'd115: begin // 'S', 's'
                case (row)
                    3'd0: char_row = 5'b01111;
                    3'd1: char_row = 5'b10000;
                    3'd2: char_row = 5'b10000;
                    3'd3: char_row = 5'b01110;
                    3'd4: char_row = 5'b00001;
                    3'd5: char_row = 5'b00001;
                    3'd6: char_row = 5'b11110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd84, 8'd116: begin // 'T', 't'
                case (row)
                    3'd0: char_row = 5'b11111;
                    3'd1: char_row = 5'b00100;
                    3'd2: char_row = 5'b00100;
                    3'd3: char_row = 5'b00100;
                    3'd4: char_row = 5'b00100;
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b00100;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd89, 8'd121: begin // 'Y', 'y'
                case (row)
                    3'd0: char_row = 5'b10001;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10001;
                    3'd3: char_row = 5'b01010;
                    3'd4: char_row = 5'b00100;
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b00100;
                    default: char_row = 5'b00000;
                endcase
            end
				
				8'd71, 8'd103: begin // 'G', 'g'
					 case (row)
							3'd0: char_row = 5'b01110;
							3'd1: char_row = 5'b10001;
							3'd2: char_row = 5'b10000;
							3'd3: char_row = 5'b10111;
							3'd4: char_row = 5'b10001;
							3'd5: char_row = 5'b10001;
							3'd6: char_row = 5'b01110;
							default: char_row = 5'b00000;
						endcase
					end
					
				 8'd85, 8'd117: begin // 'U', 'u'
						 case (row)
								 3'd0: char_row = 5'b10001;
								 3'd1: char_row = 5'b10001;
								 3'd2: char_row = 5'b10001;
       						 3'd3: char_row = 5'b10001;
       						 3'd4: char_row = 5'b10001;
       						 3'd5: char_row = 5'b10001;
        						 3'd6: char_row = 5'b01110;
        						 default: char_row = 5'b00000;
    						 endcase
						 end
            // Numbers
            8'd48: begin // '0'
                case (row)
                    3'd0: char_row = 5'b01110;
                    3'd1: char_row = 5'b10001;
                    3'd2: char_row = 5'b10011;
                    3'd3: char_row = 5'b10101;
                    3'd4: char_row = 5'b11001;
                    3'd5: char_row = 5'b10001;
                    3'd6: char_row = 5'b01110;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd49: begin // '1'
                case (row)
                    3'd0: char_row = 5'b00100;
                    3'd1: char_row = 5'b01100;
                    3'd2: char_row = 5'b00100;
                    3'd3: char_row = 5'b00100;
                    3'd4: char_row = 5'b00100;
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b01110;
                    default: char_row = 5'b00000;
                endcase
            end
				8'd50: begin // '2'
				case (row)
					3'd0: char_row = 5'b01110;
					3'd1: char_row = 5'b10001;
					3'd2: char_row = 5'b00001;
					3'd3: char_row = 5'b00010;
					3'd4: char_row = 5'b00100;
					3'd5: char_row = 5'b01000;
					3'd6: char_row = 5'b11111;
					default: char_row = 5'b00000;
				endcase
			end

				8'd51: begin // '3'
				case (row)
					3'd0: char_row = 5'b01110;
					3'd1: char_row = 5'b10001;
					3'd2: char_row = 5'b00001;
					3'd3: char_row = 5'b00110;
					3'd4: char_row = 5'b00001;
					3'd5: char_row = 5'b10001;
					3'd6: char_row = 5'b01110;
					default: char_row = 5'b00000;
				endcase
			end

			8'd52: begin // '4'
				case (row)
					3'd0: char_row = 5'b00010;
					3'd1: char_row = 5'b00110;
					3'd2: char_row = 5'b01010;
					3'd3: char_row = 5'b10010;
					3'd4: char_row = 5'b11111;
					3'd5: char_row = 5'b00010;
					3'd6: char_row = 5'b00010;
					default: char_row = 5'b00000;
				endcase
				end

			8'd53: begin // '5'
				case (row)
					3'd0: char_row = 5'b11111;
					3'd1: char_row = 5'b10000;
					3'd2: char_row = 5'b11110;
					3'd3: char_row = 5'b00001;
					3'd4: char_row = 5'b00001;
					3'd5: char_row = 5'b10001;
					3'd6: char_row = 5'b01110;
					default: char_row = 5'b00000;
				endcase
			end

			8'd54: begin // '6'
				case (row)
					3'd0: char_row = 5'b00110;
					3'd1: char_row = 5'b01000;
					3'd2: char_row = 5'b10000;
					3'd3: char_row = 5'b11110;
					3'd4: char_row = 5'b10001;
					3'd5: char_row = 5'b10001;
					3'd6: char_row = 5'b01110;
					default: char_row = 5'b00000;
					endcase
				end

			8'd55: begin // '7'
				case (row)
					3'd0: char_row = 5'b11111;
					3'd1: char_row = 5'b00001;
					3'd2: char_row = 5'b00010;
					3'd3: char_row = 5'b00100;
					3'd4: char_row = 5'b01000;
					3'd5: char_row = 5'b01000;
					3'd6: char_row = 5'b01000;
					default: char_row = 5'b00000;
				endcase
			end

			8'd56: begin // '8'
				case (row)
					3'd0: char_row = 5'b01110;
					3'd1: char_row = 5'b10001;
					3'd2: char_row = 5'b10001;
					3'd3: char_row = 5'b01110;
					3'd4: char_row = 5'b10001;
					3'd5: char_row = 5'b10001;
					3'd6: char_row = 5'b01110;
					default: char_row = 5'b00000;
				endcase
			end

			8'd57: begin // '9'
				case (row)
					3'd0: char_row = 5'b01110;
					3'd1: char_row = 5'b10001;
					3'd2: char_row = 5'b10001;
					3'd3: char_row = 5'b01111;
					3'd4: char_row = 5'b00001;
					3'd5: char_row = 5'b00010;
					3'd6: char_row = 5'b01100;
					default: char_row = 5'b00000;
				endcase
			end

            
            // Special characters
            8'd32: begin // Space
                char_row = 5'b00000;
            end
            
            8'd45: begin // '-'
                case (row)
                    3'd3: char_row = 5'b11111;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd58: begin // ':'
                case (row)
                    3'd2: char_row = 5'b00100;
                    3'd4: char_row = 5'b00100;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd40: begin // '('
                case (row)
                    3'd0: char_row = 5'b00010;
                    3'd1: char_row = 5'b00100;
                    3'd2: char_row = 5'b01000;
                    3'd3: char_row = 5'b01000;
                    3'd4: char_row = 5'b01000;
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b00010;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd41: begin // ')'
                case (row)
                    3'd0: char_row = 5'b01000;
                    3'd1: char_row = 5'b00100;
                    3'd2: char_row = 5'b00010;
                    3'd3: char_row = 5'b00010;
                    3'd4: char_row = 5'b00010;
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b01000;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd44: begin // ','
                case (row)
                    3'd5: char_row = 5'b00100;
                    3'd6: char_row = 5'b01000;
                    default: char_row = 5'b00000;
                endcase
            end
            
            8'd61: begin // '='
                case (row)
                    3'd2: char_row = 5'b11111;
                    3'd4: char_row = 5'b11111;
                    default: char_row = 5'b00000;
                endcase
            end
            
            default: char_row = 5'b00000;
        endcase
    end
	 
    assign pixel_on = (col < 3'd5) ? char_row[4 - col] : 1'b0;
    

endmodule

