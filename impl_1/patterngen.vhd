library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity patterngen is
	port(
		CLK : in std_logic;
		Row : in std_logic_vector(9 downto 0); -- y
		Col : in std_logic_vector(9 downto 0); -- x
		display_on : in std_logic;
		jump_lgc : in std_logic;
		start_lgc : in std_logic;
		duck_lgc : in std_logic;
		rgb_patterngen : out std_logic_vector(5 downto 0)
	);
end patterngen;

architecture synth of patterngen is

	component speedCalc is
	port(
		score : in unsigned(16 downto 0);
		increment : out integer range 0 to 10
		--game_over_state  : in std_logic
	);
	end component;

	component obstacle_fsm is
		port(
			LFSR_clk : in std_logic;
			OB_60HZ_clk : in std_logic;
			ob_Row : in unsigned(9 downto 0);
			ob_Col : in unsigned(9 downto 0);
			ob_display_on : in std_logic;
			OB1_draw : out std_logic;
			OB2_draw : out std_logic;
			OB3_draw : out std_logic;
			OB4_draw : out std_logic;
			OB5_draw : out std_logic;
			OB6_draw : out std_logic;
			OB7_draw : out std_logic;
			OB8_draw : out std_logic;
			OB9_draw : out std_logic;
			OB10_draw : out std_logic;
			game_start_state, game_playing_state, game_over_state : in std_logic;
			game_velocity : in integer range 0 to 12;
			ob_out : out std_logic_vector(5 downto 0);
			ptero1_draw : out std_logic;
			ptero2_draw : out std_logic;
			ptero3_draw : out std_logic
		);
	end component obstacle_fsm;

	component jumbo_fsm is
		port(
			jumbo_60Hz_CLK : in std_logic;
			Jumbo_Row_in : in unsigned(9 downto 0); -- y
			Jumbo_Col_in : in unsigned(9 downto 0); -- x
			jumbo_display_on : in std_logic;
			jump_lgc : in std_logic;
			start_lgc : in std_logic;
			duck_lgc : in std_logic;
			game_start_state, game_playing_state : in std_logic;
			jumbo_state_rgb : out std_logic_vector(5 downto 0);
			JUMBO_Draw : out std_logic
		);
	end component jumbo_fsm;

	component score is 
		port(
			clk_60hz : in std_logic;
			score_row_in : in unsigned(9 downto 0);
			score_col_in : in unsigned(9 downto 0);
			score : in unsigned(16 downto 0);
			display_on : in std_logic;
			game_start_state : in std_logic;
			game_playing_state : in std_logic;
			game_over_state : in std_logic;
			game_velocity : out integer;
			score_rgb_out : out std_logic_vector(5 downto 0);
			Digit0 : out std_logic;
			Digit1: out std_logic;
			Digit2 : out std_logic;
			Digit3 : out std_logic;
			Digit4 : out std_logic;
			HI_Digit0 : out std_logic;
			HI_Digit1 : out std_logic;
			HI_Digit2 : out std_logic;
			HI_Digit3 : out std_logic;
			HI_Digit4 : out std_logic;
			H_draw : out std_logic;
			I_draw : out std_logic
		);
	end component;
	
	component groundPatternGen is
		port(
			ground_60Hz_CLK : in std_logic;
			ground_Row_in : in unsigned(9 downto 0); -- y
			ground_Col_in : in unsigned(9 downto 0); -- x
			ground_display_on : in std_logic;
			game_start_state, game_playing_state : in std_logic;
			ground_rgb : out std_logic_vector(5 downto 0);
			game_velocity : in integer range 0 to 12;
			ground_range : out std_logic
		);
	end component;
	
	component CloudPatterngen is
	port(
		Cloud_60Hz_CLK : in std_logic;
		Cloud_Row_in : in unsigned(9 downto 0); -- y
		Cloud_Col_in : in unsigned(9 downto 0); -- x
		Cloud_display_on : in std_logic;
		game_start_state, game_playing_state : in std_logic;
		Cloud_rgb : out std_logic_vector(5 downto 0);
		Cloud_range1 : out std_logic;
		Cloud_range2 : out std_logic;
		Cloud_range3 : out std_logic

	);
end component;

	
	component GameOverROM is
		port(
			Xin : in unsigned(8 downto 0);
			Yin : in unsigned(8 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;


	component StartScreenROM2 is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component StartScreenROM1 is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	


	
	-- 60 Hz game clock signal
	signal sixtyHZ_clk : std_logic := '0';
	
	signal US_row : unsigned(9 downto 0);
	signal US_column : unsigned(9 downto 0);
	
	
	signal ROMXin : unsigned(4 downto 0);
	signal ROMYin : unsigned(4 downto 0);
	
	signal JUMBO_Draw_patterngen : std_logic;
	signal JUMBO_RGB : std_logic_vector(5 downto 0);
	
	signal ground_Draw_patterngen : std_logic;
	signal ground_RGB : std_logic_vector(5 downto 0);
	
	--signal digitVal : integer;
	signal Digit_xpos : unsigned(9 downto 0);
	signal Digit_ypos : unsigned(9 downto 0);
	signal binaryScore : unsigned(16 downto 0) := (others => '0'); -- Input binary

	signal game_velocity : integer range 0 to 12;
	
	-- Game state signals
	type STATE_GAME is (START_GAME, PLAYING, GAME_OVER);
	signal current_state_GAME, next_state_game : STATE_GAME;
	signal JUMBO_STATE_GRAPHIC : std_logic_vector(5 downto 0);
	signal start_state, playing_state, game_over_state : std_logic; -- this will be our overarching game statw logic
	
	-- Start Screen ROM signals
	signal StartROM1_out : std_logic_vector(5 downto 0);
	signal StartROM2_out : std_logic_vector(5 downto 0);
	signal StartScreen_press : std_logic;
	signal StartScreen_start : std_logic;
	--	 Score ROM signals
	signal Digit0 : std_logic;
	signal Digit1 : std_logic;
	signal Digit2 : std_logic;
	signal Digit3 : std_logic;
	signal Digit4 : std_logic;
	signal SCORE_RGB_OUT : std_logic_vector(5 downto 0);
	signal HI_Digit0: std_logic;
	signal HI_Digit1: std_logic;
	signal HI_Digit2 : std_logic;
	signal HI_Digit3 : std_logic;
	signal HI_Digit4 : std_logic;
	signal H_draw : std_logic;
	signal I_draw : std_logic;
	signal score_slowing_counter : integer range 0 to 6;
	signal score_slowing_clk : std_logic;
	
	signal Clouddraw1 : std_logic;
	signal Clouddraw2 : std_logic;
	signal Clouddraw3 : std_logic;
	signal Cloud_rgb : std_logic_vector(5 downto 0);
	
	--ground ROM range signals
	signal ground_range : std_logic;

	--obstacle draw signals:
	signal SINGLE_CACT_ON :  std_logic;
	signal DOUBLE_CACT_ON : std_logic;
	signal TRIPLE_CACT_ON : std_logic;
	signal SINGLE_TALLCACT_ON :  std_logic;
	signal PTERO_LOW_ON : std_logic;
	signal PTERO_MID_ON : std_logic;
	signal PTERO_HIGH_ON : std_logic;
	signal BLANK_ON : std_logic;
	
	--obstacle draw ranges
	signal OB1_draw : std_logic;
	signal OB2_draw : std_logic;
	signal OB3_draw : std_logic;
	signal OB4_draw : std_logic;	
	signal ptero1_draw : std_logic;
	signal OB5_draw : std_logic;
	signal OB6_draw : std_logic;
	signal OB7_draw : std_logic;
	signal OB8_draw : std_logic;	
	signal ptero2_draw : std_logic;
	signal OB9_draw : std_logic;
	signal OB10_draw : std_logic;	
	signal ptero3_draw : std_logic;
	
	--obstacle rom out
	
	--game over ROM sigs:
	signal game_over_xin : unsigned(8 downto 0);
	signal game_over_yin : unsigned(8 downto 0);
	signal game_over_draw : std_logic;
	signal game_over_rgb : std_logic_vector(5 downto 0);
	
	signal ob_out : std_logic_vector(5 downto 0);
	
	signal col_detection : std_logic;
	
	

begin
	--unsigned x and y coord
	US_row <= unsigned(Row); -- y
	US_column <= unsigned(Col); -- x
	
	
		obstacle_fsm_int : obstacle_fsm
		port map(
			LFSR_clk => CLK,
			OB_60HZ_clk => sixtyHZ_clk, 
			ob_Row => US_row,
			ob_Col => US_column,
			ob_display_on => display_on,
			ob_out => ob_out,
			OB1_draw => OB1_draw,
			OB2_draw => OB2_draw,
			OB3_draw => OB3_draw,
			OB4_draw => OB4_draw,
			OB5_draw => OB5_draw,
			OB6_draw => OB6_draw,
			OB7_draw => OB7_draw,
			OB8_draw => OB8_draw,
			OB9_draw => OB9_draw,
			OB10_draw => OB10_draw,
			game_start_state => start_state, 
			game_playing_state => playing_state,
			game_over_state => game_over_state,
			game_velocity => game_velocity,
			ptero1_draw => ptero1_draw,
			ptero2_draw => ptero2_draw,
			ptero3_draw => ptero3_draw
		);

	
		jumbo_fsm_inst : jumbo_fsm
		port map(
			jumbo_60Hz_CLK => sixtyHZ_clk,
			Jumbo_Row_in => US_row, -- y
			Jumbo_Col_in => US_column, -- x
			jumbo_display_on => display_on, 
			jump_lgc => jump_lgc,
			start_lgc => start_lgc,
			duck_lgc => duck_lgc,
			jumbo_state_rgb => JUMBO_RGB,
			game_start_state => start_state,
			game_playing_state => playing_state,
			JUMBO_Draw => JUMBO_Draw_patterngen
		);
		
		groundPatternGen_inst : groundPatternGen
			port map(
				ground_60Hz_CLK => sixtyHZ_clk,
				ground_Row_in => US_row, -- y
				ground_Col_in => US_column, -- x
				ground_display_on => display_on, 
				game_start_state => start_state, 
				game_playing_state => playing_state,
				ground_rgb => ground_RGB,
				game_velocity => game_velocity,
				ground_range => ground_range
			);
			
		CloudPatterngen_inst : CloudPatterngen
		port map(
			Cloud_60Hz_CLK => sixtyHZ_clk,
			Cloud_Row_in => US_row, -- y
			Cloud_Col_in => US_column, -- x
			Cloud_display_on => display_on, 
			game_start_state => start_state, 
			game_playing_state => playing_state,
			Cloud_rgb => Cloud_RGB,
			Cloud_range1 => Clouddraw1,
			Cloud_range2 => Clouddraw2,
			Cloud_range3 => Clouddraw3
			
			
		);
			
		score_inst : score
		port map(
			clk_60hz => sixtyHZ_clk,
			score_row_in => US_row,
			score_col_in => US_column,
			score => binaryScore,
			display_on => display_on,
			game_velocity => game_velocity,
			score_rgb_out => SCORE_RGB_OUT,
			game_start_state => start_state,
			game_over_state => game_over_state,
			Digit0 => Digit0,
			Digit1 => Digit1,
			Digit2 => Digit2,
			Digit3 => Digit3,
			Digit4 => Digit4,
			HI_Digit0 => HI_Digit0,
			HI_Digit1 => HI_Digit1,
			HI_Digit2 => HI_Digit2,
			HI_Digit3 => HI_Digit3,
			HI_Digit4 => HI_Digit4,
			H_draw => H_draw,
			I_draw => I_draw
		);
		
				
		StartScreenROM1_inst : StartScreenROM1
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => StartROM1_out
			);
			
		StartScreenROM2_inst : StartScreenROM2
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => StartROM2_out
			);
			
		GameOverROM_inst : GameOverRom
			port map(
			Xin => game_over_xin,
			Yin => game_over_yin,
			data => game_over_rgb
		);
			
			
		speedCALC_inst : speedCalc
			port map(
				score => binaryScore,
				increment => game_velocity

				);
		
-- Start Screen Ranges
StartScreen_press <= '1' when US_column > 260 and US_column < 314 and US_row > 232 and US_row < 248 and start_state = '1' else '0';
StartScreen_start <= '1' when US_column > 321 and US_column < 375 and US_row > 232 and US_row < 248 and start_state = '1' else '0';
game_over_draw <= '1' when US_column > 264 and US_column < 374 and US_row > 216 and US_row < 265 and game_over_state = '1' else '0';
--temp groundROM ranges


-- Make 60Hz master game clock logic signal
sixtyHZ_clk <= '1' when US_row = 482 else '0';

process(sixtyHZ_clk) is begin
	if rising_edge(sixtyHZ_clk) then 
		score_slowing_counter <= score_slowing_counter + 1;
			current_state_GAME <= next_state_GAME;
		if score_slowing_counter = 6 then 
			score_slowing_clk <= '1';
			score_slowing_counter <= 0;
		else 
			score_slowing_clk <= '0';
		end if;
	end if;
end process;

process(score_slowing_clk) is begin
	if rising_edge(score_slowing_clk) then 
		if current_state_GAME = PLAYING then 
			binaryScore <= binaryScore + 1;
		elsif current_state_GAME = START_GAME then 
			binaryScore <= (others => '0');
		else 
			binaryScore <= binaryScore;
		end if;
	end if;
end process;

process(current_state_GAME, display_on, start_lgc, jump_lgc, duck_lgc) is begin 
    case current_state_GAME is 
        when START_GAME =>
			start_state <= '1';
			playing_state <= '0';
			game_over_state <= '0';
			col_detection <= '0';
            if display_on = '1' then
			    if JUMBO_Draw_patterngen then
					if ground_range then 
						if JUMBO_RGB = "111111" and ground_RGB = "000000" then 
							rgb_patterngen <= ground_RGB;
						else
							rgb_patterngen <= JUMBO_RGB;
						end if;
					else 
						rgb_patterngen <= JUMBO_RGB;
					end if;
				elsif StartScreen_press then 
					Digit_ypos <= US_row - 233;
                    Digit_xpos <= US_column - 261;
                    ROMXin <= Digit_xpos(5 downto 1);
                    ROMYin <= Digit_ypos(5 downto 1);
					rgb_patterngen <= StartROM2_out;
				elsif StartScreen_start then 
					Digit_ypos <= US_row - 233;
                    Digit_xpos <= US_column - 322;
                    ROMXin <= Digit_xpos(5 downto 1);
                    ROMYin <= Digit_ypos(5 downto 1);
					rgb_patterngen <= StartROM1_out;
                elsif Digit0 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit1 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit2 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit3 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit4 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit0 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit1 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit2 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit3 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit4 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif H_Draw then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif I_Draw then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				elsif ground_range then
					rgb_patterngen <= ground_RGB;
				elsif Clouddraw1 then 
					rgb_patterngen <= Cloud_RGB;
				elsif Clouddraw2 then 
					rgb_patterngen <= Cloud_RGB;
				elsif Clouddraw3 then 
					rgb_patterngen <= Cloud_RGB;
				else
			        rgb_patterngen <= "111111";
			    end if;
			  else 
                next_state_GAME <= START_GAME;
                rgb_patterngen <= "000000";
            end if;
		    if START_LGC = '1' then  
                next_state_GAME <= PLAYING;
			end if;
        when PLAYING =>
            start_state <= '0';
			playing_state <= '1';
			game_over_state <= '0';
            if display_on = '1' then
				if JUMBO_Draw_patterngen then
					if ob1_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob2_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob3_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob4_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ptero1_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob5_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob6_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob7_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ptero2_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob8_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob9_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ob10_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ptero3_draw then 
						if ob_out = "000000" and JUMBO_RGB = "111111" then 
							rgb_patterngen <= ob_out;
							col_detection <= '0';
						elsif JUMBO_RGB = "101010" and ob_out = "000000" then
							col_detection <= '1';
							rgb_patterngen <= JUMBO_RGB;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif ground_range then 
						if JUMBO_RGB = "111111" and ground_RGB = "000000" then 
							rgb_patterngen <= ground_RGB;
						else
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif Clouddraw1 then
						if JUMBO_RGB = "111111" and Cloud_rgb = "000000" then 
							rgb_patterngen <= Cloud_rgb;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif Clouddraw2 then
						if JUMBO_RGB = "111111" and Cloud_rgb = "000000" then 
							rgb_patterngen <= Cloud_rgb;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					elsif Clouddraw3 then
						if JUMBO_RGB = "111111" and Cloud_rgb = "000000" then 
							rgb_patterngen <= Cloud_rgb;
						else 
							rgb_patterngen <= JUMBO_RGB;
						end if;
					else
						rgb_patterngen <= JUMBO_RGB;
					end if;
                elsif Digit0 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit1 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit2 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit3 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit4 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit0 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit1 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit2 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit3 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit4 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif H_Draw then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif I_Draw then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				elsif ground_range then	
					if ob1_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob2_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob3_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob4_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ptero1_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob5_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob6_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob7_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob8_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob9_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ptero2_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ob10_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					elsif ptero3_draw then 
						if ob_out = "000000" then 
							rgb_patterngen <= ob_out;
						else
							rgb_patterngen <= ground_rgb;
						end if;
					else 
						rgb_patterngen <= ground_rgb;
					end if;	
				elsif Clouddraw1 then 
					rgb_patterngen <= Cloud_RGB;
				elsif Clouddraw2 then 
					rgb_patterngen <= Cloud_RGB;
				elsif Clouddraw3 then 
					rgb_patterngen <= Cloud_RGB;
				elsif OB1_draw then
					rgb_patterngen <= ob_out;
				elsif OB2_draw then
					rgb_patterngen <= ob_out;
				elsif OB3_draw then
					rgb_patterngen <= ob_out;
				elsif OB4_draw then
					rgb_patterngen <= ob_out;					
				elsif ptero1_draw then
					rgb_patterngen <= ob_out;
				elsif OB5_draw then
					rgb_patterngen <= ob_out;
				elsif OB6_draw then
					rgb_patterngen <= ob_out;
				elsif OB7_draw then
					rgb_patterngen <= ob_out;
				elsif OB8_draw then
					rgb_patterngen <= ob_out;					
				elsif ptero2_draw then
					rgb_patterngen <= ob_out;
				elsif OB9_draw then
					rgb_patterngen <= ob_out;
				elsif OB10_draw then
					rgb_patterngen <= ob_out;					
				elsif ptero3_draw then
					rgb_patterngen <= ob_out;
				else
                   rgb_patterngen <= "111111"; --White
                end if;
            elsif col_detection = '1' then
				next_state_game <= GAME_OVER;
			else
				next_state_game <= PLAYING;
                rgb_patterngen <= "000000"; -- default off
            end if;
		when GAME_OVER =>
			start_state <= '0';
			playing_state <= '0';
			game_over_state <= '1';
			col_detection <= '0';
            if display_on = '1' then
				--if HI_Digit0 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit1 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit2 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit3 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif HI_Digit4 then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif H_Draw then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				--elsif I_Draw then 
					--rgb_patterngen <= SCORE_RGB_OUT;
				if Digit0 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit1 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit2 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit3 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif Digit4 then 
					rgb_patterngen <= SCORE_RGB_OUT;
				elsif game_over_draw then 
					Digit_ypos <= US_row - 217;
					Digit_xpos <= US_column - 267;
					game_over_xin <= Digit_xpos(9 downto 1);
					game_over_yin <= Digit_ypos(9 downto 1);
					rgb_patterngen <= game_over_rgb;
				else
					rgb_patterngen <= "111111";
				end if;
			elsif START_LGC = '1' then
				next_state_game <= START_GAME;
			else
				next_state_game <= GAME_OVER;
				rgb_patterngen <= "000000"; -- default off
			end if;
    end case;
end process;
end synth;