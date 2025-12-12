module bin_to_bcd(
    input [7:0] binary,        // 8-bit binary input (0-255)
    output reg [3:0] hundreds, // Hundreds digit (0-2)
    output reg [3:0] tens,     // Tens digit (0-9)
    output reg [3:0] ones      // Ones digit (0-9)
);

    integer i;
    
    always @(*) begin
        // Initialize
        hundreds = 4'd0;
        tens = 4'd0;
        ones = 4'd0;
        
        // Double dabble algorithm
        for (i = 7; i >= 0; i = i - 1) begin
            // Add 3 to columns >= 5
            if (hundreds >= 5)
                hundreds = hundreds + 3;
            if (tens >= 5)
                tens = tens + 3;
            if (ones >= 5)
                ones = ones + 3;
                
            // Shift left
            hundreds = hundreds << 1;
            hundreds[0] = tens[3];
            tens = tens << 1;
            tens[0] = ones[3];
            ones = ones << 1;
            ones[0] = binary[i];
        end
    end

endmodule



