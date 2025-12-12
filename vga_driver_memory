module vga_driver_memory	(
  	//////////// ADC //////////
	//output		          		ADC_CONVST,
	//output		          		ADC_DIN,
	//input 		          		ADC_DOUT,
	//output		          		ADC_SCLK,

	//////////// Audio //////////
	//input 		          		AUD_ADCDAT,
	//inout 		          		AUD_ADCLRCK,
	//inout 		          		AUD_BCLK,
	//output		          		AUD_DACDAT,
	//inout 		          		AUD_DACLRCK,
	//output		          		AUD_XCK,

	//////////// CLOCK //////////
	//input 		          		CLOCK2_50,
	//input 		          		CLOCK3_50,
	//input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	//output		    [12:0]		DRAM_ADDR,
	//output		     [1:0]		DRAM_BA,
	//output		          		DRAM_CAS_N,
	//output		          		DRAM_CKE,
	//output		          		DRAM_CLK,
	//output		          		DRAM_CS_N,
	//inout 		    [15:0]		DRAM_DQ,
	//output		          		DRAM_LDQM,
	//output		          		DRAM_RAS_N,
	//output		          		DRAM_UDQM,
	//output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	//output		          		FPGA_I2C_SCLK,
	//inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	//output		     [6:0]		HEX4,
	//output		     [6:0]		HEX5,

	//////////// IR //////////
	//input 		          		IRDA_RXD,
	//output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	//inout 		          		PS2_CLK,
	//inout 		          		PS2_CLK2,
	//inout 		          		PS2_DAT,
	//inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	//input 		          		TD_CLK27,
	//input 		     [7:0]		TD_DATA,
	//input 		          		TD_HS,
	//output		          		TD_RESET_N,
	//input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output reg	     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output reg	     [7:0]		VGA_G,
	output		          		VGA_HS,
	output reg	     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_1

);



	wire clk;
	wire rst;
	wire reset; 
	 
	wire decision_a, decision_b;
	wire [7:0] score_a, score_b;
	wire [6:0] round_count;
	wire round_start;
	wire game_active;

	// History buffers (DAY 3)
	wire [9:0] history_a, history_b;
	

	assign clk = CLOCK_50;
	assign rst = SW[0];
	assign reset = ~SW[0];

	// ========================================
	// SCORE DISPLAY ON HEX SEGMENTS (DAY 2)
	// ========================================
	
	// Convert Player A score to BCD
	wire [3:0] score_a_hundreds, score_a_tens, score_a_ones;
	bin_to_bcd bcd_a(
		.binary(score_a),
		.hundreds(score_a_hundreds),
		.tens(score_a_tens),
		.ones(score_a_ones)
	);
	
	// Convert Player B score to BCD
	wire [3:0] score_b_hundreds, score_b_tens, score_b_ones;
	bin_to_bcd bcd_b(
		.binary(score_b),
		.hundreds(score_b_hundreds),
		.tens(score_b_tens),
		.ones(score_b_ones)
	);
	
	// Display Player A score on HEX1-HEX0 (rightmost)
	seven_seg_decoder seg_a_tens(
		.digit(score_a_tens),
		.seg(HEX1)
	);
	
	seven_seg_decoder seg_a_ones(
		.digit(score_a_ones),
		.seg(HEX0)
	);
	
	// Display Player B score on HEX3-HEX2 (leftmost)
	seven_seg_decoder seg_b_tens(
		.digit(score_b_tens),
		.seg(HEX3)
	);
	
	seven_seg_decoder seg_b_ones(
		.digit(score_b_ones),
		.seg(HEX2)
	);

	// ========================================
	// VGA DRIVER SETUP
	// ========================================

 	wire active_pixels;
	wire [9:0] x;
	wire [9:0] y;

	vga_driver the_vga(
		.clk(clk),
		.rst(rst),
		.vga_clk(VGA_CLK),
		.hsync(VGA_HS),
		.vsync(VGA_VS),
		.active_pixels(active_pixels),
		.xPixel(x),
		.yPixel(y),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N)
	);

	// ========================================
	// GAME LOGIC (DAY 1-4)
	// ========================================
	
	// Game signals

reg round_start_d; 
	
always@(posedge clk) begin
	if (reset)
		round_start_d <= 1'b0; 
		
		else
		
		round_start_d <= round_start; 
end

	history_buffer hist_a(
		.clk(clk),
		.reset(reset),
		.write_en(round_start_d),
		.decision(decision_a),
		.history(history_a)
	);

	history_buffer hist_b(
		.clk(clk),
		.reset(reset),
		.write_en(round_start_d),
		.decision(decision_b),
		.history(history_b)
	);
	
	wire restart_game = ~KEY[0];

	// Instantiate game controller
	game_controller game_ctrl(
		.clk(clk),
		.reset(reset),
		.restart(restart_game),
		.decision_a(decision_a),
		.decision_b(decision_b),
		.score_a(score_a),
		.score_b(score_b),
		.round_count(round_count),
		.round_start(round_start),
		.game_active(game_active)
	);
	
	wire decision_a_tft, decision_a_random, decision_a_coop, decision_a_grudge;

	// Instantiate Player A: Tit-for-Tat
	strategy_tit_for_tat strat_a_tft(
    .clk(clk),
    .reset(reset),
    .round_start(round_start),
    .opponent_last_move(decision_b),   // A copies B
    .decision(decision_a_tft)
);
	
	strategy_random strat_a_random(
    .clk(clk),
    .reset(reset),
    .round_start(round_start),
    .decision(decision_a_random)
);

strategy_always_cooperate strat_a_coop(
    .clk(clk),
    .reset(reset),
    .decision(decision_a_coop)
);


strategy_grudger strat_a_grudger(
    .clk(clk),
    .reset(reset),
    .round_start(round_start),
    .opponent_last_move(decision_b),   // A watches B
    .decision(decision_a_grudge)
);


	// ========================================
	// PLAYER B STRATEGY SELECTION
	// ========================================
	
	// Player B strategy wires
wire decision_b_tft, decision_b_random, decision_b_coop, decision_b_grudge;

strategy_tit_for_tat strat_b_tft(
    .clk(clk),
    .reset(reset),
    .round_start(round_start),
    .opponent_last_move(decision_a),   // B copies A
    .decision(decision_b_tft)
);

strategy_random #(.SEED(8'h3C)) strat_b_random (
    .clk(clk),
    .reset(reset),
    .round_start(round_start),
    .decision(decision_b_random)
);

strategy_always_cooperate strat_b_coop(
    .clk(clk),
    .reset(reset),
    .decision(decision_b_coop)
);

strategy_grudger strat_b_grudger(
    .clk(clk),
    .reset(reset),
    .round_start(round_start),
    .opponent_last_move(decision_a),   // B watches A
    .decision(decision_b_grudge)
);


wire [1:0] sel_a, sel_b;
assign sel_a = SW[5:4];
assign sel_b = SW[3:2];

assign decision_a =
    (sel_a == 2'b00) ? decision_a_tft    :
    (sel_a == 2'b01) ? decision_a_random :
    (sel_a == 2'b10) ? decision_a_coop   :
                       decision_a_grudge;   // 11

assign decision_b =
    (sel_b == 2'b00) ? decision_b_tft    :
    (sel_b == 2'b01) ? decision_b_random :
    (sel_b == 2'b10) ? decision_b_coop   :
                       decision_b_grudge;   // 11

	// ========================================
	// COLOR GENERATOR
	// ========================================
	
	wire [23:0] game_color;
	color_generator color_gen(
		.active_pixels(active_pixels),
		.x(x),
		.y(y),
		.decision_a(decision_a),
		.decision_b(decision_b),
		.score_a(score_a),
		.score_b(score_b),
		.round_count(round_count),
		.history_a(history_a),
		.history_b(history_b),
		.sel_a(sel_a),
		.sel_b(sel_b),
		.color_out(game_color)
	);

	// VGA color output
	always @(*) begin 
		{VGA_R, VGA_G, VGA_B} = game_color;
	end

	// ========================================
	// DEBUG LEDs
	// ========================================
	
	assign LEDR[0] = decision_a;
	assign LEDR[1] = decision_b;
	assign LEDR[2] = game_active;
	assign LEDR[9:3] = round_count;

endmodule


