library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity groundPatternGen is
	port(
		ground_60Hz_CLK : in std_logic;
		ground_Row_in : in unsigned(9 downto 0); -- y
		ground_Col_in : in unsigned(9 downto 0); -- x
		ground_display_on : in std_logic;
		game_start_state, game_playing_state : in std_logic;
		ground_rgb : out std_logic_vector(5 downto 0);
		game_velocity :  in integer range 0 to 12;
		ground_range : out std_logic
	);
end groundPatternGen;

architecture synth of groundPatternGen is
	
	
	component biggroundROM is
		port(
			Xin : in unsigned(8 downto 0);
			Yin : in unsigned(8 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
		
	end component;--	 ground ROM signals
	signal biggroundROM_out : std_logic_vector(5 downto 0);
	
	signal groundScaleRow : unsigned(8 downto 0);
	signal groundScaleCol : unsigned(8 downto 0);
	signal x_pos : unsigned(9 downto 0);
	signal y_pos : unsigned(9 downto 0);
	
	signal ground_scroll_offset : integer range 0 to 1280;
	signal adjusted_x_pos : unsigned(9 downto 0);
	constant GROUND_WIDTH : unsigned(9 downto 0) :=  to_unsigned(640, 10);
	

begin

	bigground_inst : biggroundROM
		port map( 
			Xin => groundScaleCol,
			Yin => groundScaleRow,
			data => biggroundROM_out
		);
		

	ground_range <= '1' when (ground_Row_in > 280 and ground_Row_in < 350) and ground_Col_in < 641 else '0'; 
	
	process(ground_60Hz_CLk)
	begin 
		if rising_edge(ground_60Hz_CLK) then 
			if game_playing_state = '1' then
				--if ground_scroll_offset = GROUND_WIDTH - 1 then 
					--ground_scroll_offset <= (others => '0');
				--else 
					ground_scroll_offset <= (ground_scroll_offset + game_velocity);
				--end if;
			end if;
		end if;
	end process;
	
	process(ground_Col_in, ground_scroll_offset)
	begin
		adjusted_x_pos <= (ground_Col_in + ground_scroll_offset) mod 640;
	end process;
			
process(ground_display_on, game_start_state, game_playing_state, ground_Row_in, ground_Col_in)
begin
	if ground_display_on = '1' then
		if game_start_state = '1' then
				if ground_range then
					y_pos <= ground_Row_in - 281;
					x_pos <= ground_Col_in;
					groundScaleRow <= y_pos(9 downto 1);
					groundScaleCol <= x_pos(9 downto 1);
					ground_rgb <= biggroundROM_out;
				end if;
		elsif game_playing_state = '1' then
			if ground_range then
					y_pos <= ground_Row_in - 281;
					groundScaleRow <= y_pos(9 downto 1);
					groundScaleCol <= adjusted_x_pos(9 downto 1);
					ground_rgb <= biggroundROM_out;
			end if;
		end if;
	end if;
end process;
end synth;
		