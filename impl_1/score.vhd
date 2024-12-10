library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity score is 
	port(
		clk_60hz : in std_logic;
		score_row_in : in unsigned(9 downto 0);
		score_col_in : in unsigned(9 downto 0);
		score : in unsigned(16 downto 0);
		display_on : in std_logic;
		game_start_state : in std_logic;
		game_playing_state : in std_logic;
		game_over_state : in std_logic;
		game_velocity : out integer range 0 to 10;
		score_rgb_out : out std_logic_vector(5 downto 0);
		Digit0 : out std_logic;
		Digit1: out std_logic;
		Digit2 : out std_logic;
		Digit3 : out std_logic;
		Digit4 : out std_logic;
		HI_Digit0 : out std_logic;
		HI_Digit1: out std_logic;
		HI_Digit2 : out std_logic;
		HI_Digit3 : out std_logic;
		HI_digit4 : out std_logic;
		H_draw : out std_logic;
		I_draw : out std_logic
	);
end score;
	
architecture synth of score is --	digit case function
	function get_digitVal(
	digit : integer;
	ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut : std_logic_vector(5 downto 0)
	) return std_logic_vector is
		begin
			case digit is
				when 0 => return ZeroOut;
				when 1 => return OneOut;
				when 2 => return TwoOut;
				when 3 => return ThreeOut;
				when 4 => return FourOut;
				when 5 => return FiveOut;
				when 6 => return SixOut;
				when 7 => return SevenOut;
				when 8 => return EightOut;
				when 9 => return NineOut;
				when others => return ZeroOut;
			end case;
	end function;
	
		component speedCalc is
		port(
			score : in unsigned(16 downto 0);
			increment : out integer range 0 to 10
		);
	end component;
	
	component Digit0ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit1ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit2ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit3ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit4ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit5ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit6ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit7ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit8ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component Digit9ROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component digitCalc is
    Port ( 
			score_60hz_clock  : in  std_logic;                    
           	game_over_state, game_start_state  : in  std_logic;                    
           	velocity     : in  integer range 0 to 10;         
           	digitsOut : out integer_vector(0 to 4)
           );
	end component;
	
	component IROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component HROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	--		 Digit RBG display signals
	signal ZeroOut : std_logic_vector(5 downto 0); 
	signal OneOut : std_logic_vector(5 downto 0); 
	signal TwoOut : std_logic_vector(5 downto 0); 
	signal ThreeOut : std_logic_vector(5 downto 0);
	signal FourOut : std_logic_vector(5 downto 0); 
	signal FiveOut : std_logic_vector(5 downto 0); 
	signal SixOut : std_logic_vector(5 downto 0);
	signal SevenOut : std_logic_vector(5 downto 0);
	signal EightOut : std_logic_vector(5 downto 0); 
	signal NineOut : std_logic_vector(5 downto 0); 
	
	signal digit_row_range : std_logic;
	
	signal digitVal : integer;
	signal Digit_xpos : unsigned(9 downto 0);
	signal Digit_ypos : unsigned(9 downto 0);
	signal ScoreDigits : integer_vector(4 downto 0);
	signal binaryScore : unsigned(16 downto 0) := (others => '0'); -- Input binary
	signal HighScore : unsigned(16 downto 0) := (others => '0'); -- Input binary

	
	signal ROMXin : unsigned(4 downto 0);
	signal ROMYin : unsigned(4 downto 0);
	
	signal HI_digits : integer_vector(4 downto 0);
	signal HROM_out : std_logic_vector(5 downto 0); 
	signal IROM_out : std_logic_vector(5 downto 0); 


	
begin 
			--speedCalc_inst : speedCalc
			--port map(
				--score => score,
				--increment => game_velocity
			--);
	Digit0Draw : Digit0ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => ZeroOut
			);
				Digit1Draw : Digit1ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => OneOut
			);
			Digit2Draw : Digit2ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => TwoOut
			);
					Digit3Draw : Digit3ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => ThreeOut
			);
			
		Digit4Draw : Digit4ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => FourOut
			);
			
		Digit5Draw : Digit5ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => FiveOut
			);
			
		Digit6Draw : Digit6ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => SixOut
			);
			
		Digit7Draw : Digit7ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => SevenOut
			);
			
		Digit8Draw : Digit8ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => EightOut
			);
			
		Digit9Draw : Digit9ROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => NineOut
			);
		
		
		score_inst : digitCalc
			port map( 
				score_60hz_clock => clk_60hz,              
				game_over_state => game_over_state,
				game_start_state => game_start_state,                    
				velocity => game_velocity,        
				digitsOut => ScoreDigits
           );
			
		IROM_inst : IROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => IROM_out
			);
			
		HROM_inst : HROM
			port map(
				Xin => ROMXin,
				Yin => ROMYin,
				data => HROM_out
			);
			
			
	
	 --Digit ranges for current score
	digit_row_range <= '1' when (score_row_in > 10 and score_row_in < 26) else '0';
	Digit0 <= '1' when score_col_in > 625 and score_col_in < 635 and (digit_row_range = '1') else '0';
	Digit1 <= '1' when score_col_in > 615 and score_col_in < 625 and (digit_row_range = '1') else '0';
	Digit2 <= '1' when score_col_in > 605 and score_col_in < 615 and (digit_row_range = '1') else '0';
	Digit3 <= '1' when score_col_in > 595 and score_col_in < 605 and (digit_row_range = '1') else '0';
	Digit4 <= '1' when score_col_in > 585 and score_col_in < 595 and (digit_row_range = '1') else '0';
	
	HI_Digit0 <= '1' when score_col_in > 555 and score_col_in < 565 and (digit_row_range = '1') else '0';
	HI_Digit1 <= '1' when score_col_in > 545 and score_col_in < 555 and (digit_row_range = '1') else '0';
	HI_Digit2 <= '1' when score_col_in > 535 and score_col_in < 545 and (digit_row_range = '1') else '0';
	HI_Digit3 <= '1' when score_col_in > 525 and score_col_in < 535 and (digit_row_range = '1') else '0';
	HI_Digit4 <= '1' when score_col_in > 515 and score_col_in < 525 and (digit_row_range = '1') else '0';

	H_draw <= '1' when score_col_in > 489 and score_col_in < 499 and (digit_row_range = '1') else '0';
	I_draw <= '1' when score_col_in > 499 and score_col_in < 509 and (digit_row_range = '1') else '0';

	
	process(display_on, score_row_in, score_col_in, game_over_state) is
	begin
		if display_on = '1' then
			if game_over_state = '1' then
			
				if HighScore < binaryScore then
					HI_digits <= ScoreDigits; --like score digits is changing since it is literally the game score. 
					HighScore <= binaryScore; --- this logic is slightly off - i think we need an intermediary signal to store the highest yet of binary score, and then set that val to high score.
				else -- 
					HI_digits <= HI_digits;
				end if;
				
				if HI_Digit0 then 
					digitVal <= HI_digits(4);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 556;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
					digitVal,
					ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit1 then 
					digitVal <= HI_digits(3);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 546;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit2 then 
					digitVal <= HI_digits(2);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 536;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit3 then 
					digitVal <= HI_digits(1);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 526;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit4 then 
					digitVal <= HI_digits(0);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 516;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif H_draw then
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 490;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= HROM_out;
				elsif I_draw then
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 500;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= IROM_out;
				elsif Digit0 then 
					digitVal <= ScoreDigits(4);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 626;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
					digitVal,
					ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit1 then 
					digitVal <= ScoreDigits(3);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 616;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit2 then 
					digitVal <= ScoreDigits(2);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 606;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit3 then 
					digitVal <= ScoreDigits(1);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 596;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit4 then 
					digitVal <= ScoreDigits(0);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 586;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				end if;
			
			else
				if Digit0 then 
					digitVal <= ScoreDigits(4);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 626;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
					digitVal,
					ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit1 then 
					digitVal <= ScoreDigits(3);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 616;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit2 then 
					digitVal <= ScoreDigits(2);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 606;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit3 then 
					digitVal <= ScoreDigits(1);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 596;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif Digit4 then 
					digitVal <= ScoreDigits(0);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 586;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit0 then 
					digitVal <= HI_digits(4);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 556;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
					digitVal,
					ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit1 then 
					digitVal <= HI_digits(3);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 546;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit2 then 
					digitVal <= HI_digits(2);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 536;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1); 
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit3 then 
					digitVal <= HI_digits(1);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 526;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif HI_Digit4 then 
					digitVal <= HI_digits(0);
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 516;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= get_digitVal(
						digitVal,
						ZeroOut, OneOut, TwoOut, ThreeOut, FourOut, FiveOut, SixOut, SevenOut, EightOut, NineOut
					);
				elsif H_draw then
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 490;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= HROM_out;
				elsif I_draw then
					Digit_ypos <= score_row_in - 11;
					Digit_xpos <= score_col_in - 500;
					ROMXin <= Digit_xpos(5 downto 1);
					ROMYin <= Digit_ypos(5 downto 1);
					score_rgb_out <= IROM_out;
				end if;
			end if;
		end if;
	end process;
end synth;