library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity jumbo_fsm is
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
end jumbo_fsm;

architecture synth of jumbo_fsm is

	component JumboROM1 is 
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
         		data : out std_logic_vector(5 downto 0)
     	);
	end component;
	
	component JumboRUN_ROM1 is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component JumboRUN_ROM2 is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component JumboCROUCH_ROM1 is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	component JumboJumpROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
	end component;
	
	signal jumbo_ROW_MOVING : integer range 0 to 120 := 1;
	constant JUMBO_ROW_START_TOP : integer := 275; -- row 275 is top of jumbo while running
	constant JUMBO_ROW_START_BOTTOM : integer := 322; -- row 322 is bottom of jumbo while running
	signal jumbo_direction : std_logic := '1'; -- 0 for up, 1 for down
	signal velocity : integer range 0 to 15 := 15;
	constant gravity : integer := -1;
	
	--ROM SIGNALS
	signal jumbo_Row_draw : unsigned(9 downto 0);
	signal jumbo_Col_draw : unsigned(9 downto 0);
	signal jumbo_ROM_out : std_logic_vector(5 downto 0);
	signal crouchROM_out : std_logic_vector(5 downto 0);
	signal ROMRUN1_out : std_logic_vector(5 downto 0);
	signal ROMRUN2_out : std_logic_vector(5 downto 0);
	signal JumpROM_OUT : std_logic_vector(5 downto 0);
	signal ROM_out : std_logic_vector(5 downto 0);
	
	signal ROMXin : unsigned(4 downto 0);
	signal ROMYin : unsigned(4 downto 0);

	signal running_counter : integer range 0 to 16 := 0;
	
	type STATE_JUMBO is (JUMBO_STATIC, JUMBO_JUMPING, JUMBO_DUCKING, JUMBO_RUNNING); 
	signal current_state_JUMBO, next_state_JUMBO : STATE_JUMBO;

begin
	
	JumboROM1_inst : JumboROM1 
		port map(
		Xin => ROMXin,
		Yin => ROMYin,
		data => ROM_out
	);
	
	JumboCROUCH_ROM1_inst : JumboCROUCH_ROM1
		port map(
			Xin => ROMXin,
			Yin => ROMYin,
			data => crouchROM_out
	);
	
	JumboRUN_ROM1inst : JumboRUN_ROM1 
		port map(
		Xin => ROMXin,
		Yin => ROMYin,
		data => ROMRUN1_out
	);
	
	JumboRUN_ROM2_inst : JumboRUN_ROM2 
		port map(
		Xin => ROMXin,
		Yin => ROMYin,
		data => ROMRUN2_out
	);
	
	JumboJumpROM_inst : JumboJumpROM
		port map(
		Xin => ROMXin,
		Yin => ROMYin,
		data => JumpROM_OUT
	);

	JUMBO_Draw <= '1' when Jumbo_Col_in < 83 and Jumbo_Col_in > 20 and
				Jumbo_Row_in > JUMBO_ROW_START_TOP - jumbo_ROW_MOVING and
				Jumbo_Row_in < JUMBO_ROW_START_BOTTOM - jumbo_ROW_MOVING else '0';
			
	process(jumbo_60Hz_CLK) is 
	begin
		if rising_edge(jumbo_60Hz_CLK) then  
			running_counter <= running_counter + 1;
			if jumbo_display_on = '0' then 
				current_state_JUMBO <= next_state_JUMBO; 
			end if;
			if running_counter = 16 then 
				running_counter <= 0;
			end if;
			if current_state_JUMBO = JUMBO_JUMPING then 
				if jumbo_direction = '1' then -- Moving down
					velocity <= velocity - gravity;
					if jumbo_ROW_MOVING <= 0 then -- ROW_MOVING <= 0 when ROM is back at starting position after moving down
						jumbo_direction <= '0'; -- switch to upward movement
						velocity <= 15;
					else 
						jumbo_ROW_MOVING <= jumbo_ROW_MOVING - velocity; -- Move down
					end if;
				else -- Moving up 
					velocity <= velocity + gravity;
					if jumbo_ROW_MOVING >= 120 then -- How many pixels we want the ROM to go up by from starting position
						jumbo_direction <= '1'; -- Switch to downward movement
						velocity <= 0;
					else
						jumbo_ROW_MOVING <= jumbo_ROW_MOVING + velocity; -- Move up
					end if;
				end if;
			end if;
		end if;
	end process;
	        
	 
	
	process(current_state_JUMBO, jumbo_display_on, Jumbo_Row_in, Jumbo_Col_in, jump_lgc, duck_lgc, start_lgc, game_start_state, game_playing_state, running_counter) is begin 
	    case current_state_JUMBO is 
	        when JUMBO_STATIC =>
	            if jumbo_display_on = '1' and game_start_state = '1' then 
			if JUMBO_Draw then
				jumbo_Row_draw <= Jumbo_Row_in - 20;
	                        jumbo_Col_draw <= Jumbo_Col_in - 280;
	                        ROMXin <= jumbo_Col_draw(5 downto 1);
	                        ROMYin <= jumbo_Row_draw(5 downto 1);
	                        jumbo_state_rgb <= ROM_out;
			else
	                    jumbo_state_rgb <= "111111"; --White
			end if;
	            elsif game_playing_state = '1' then 
			    next_state_JUMBO <= JUMBO_RUNNING;
		    else
			    next_state_JUMBO <= JUMBO_STATIC;
	            end if;
	        when JUMBO_JUMPING =>
	            if jumbo_display_on = '1' then
			if DUCK_LGC = '1' then 
				next_state_JUMBO <= JUMBO_RUNNING;
			end if;
	                if JUMBO_Draw then
	                        jumbo_Row_draw <= Jumbo_Row_in - 20 + jumbo_ROW_MOVING;
	                        jumbo_Col_draw <= Jumbo_Col_in - 280;
	                        ROMXin <= jumbo_Col_draw(5 downto 1);
	                        ROMYin <= jumbo_Row_draw(5 downto 1);
	                        jumbo_state_rgb <= JumpROM_OUT; 
	                else
	                    jumbo_state_rgb <= "111111"; --White
	                end if;
	            elsif jumbo_ROW_MOVING <= 0 then
	                next_state_JUMBO <= JUMBO_RUNNING; -- Transition back to running when down
	            else
	                next_state_JUMBO <= JUMBO_JUMPING; -- Stay in JUMPING state
	            end if;
			when JUMBO_DUCKING =>
	            -- ducking animation
	            if jumbo_display_on = '1' then
	                if JUMBO_Draw then
	                        jumbo_Row_draw <= Jumbo_Row_in - 20;
	                        jumbo_Col_draw <= Jumbo_Col_in - 280;
	                        ROMXin <= jumbo_Col_draw(5 downto 1);
	                        ROMYin <= jumbo_Row_draw(5 downto 1);
	                        jumbo_state_rgb <= crouchROM_out; -- JUMBO ROM
			else
	                    jumbo_state_rgb <= "111111"; --White
	                end if;
	            elsif duck_lgc = '0' then
	                next_state_JUMBO <= JUMBO_RUNNING; -- Transition back to running when down
		    elsif jump_lgc = '1' then 
			next_state_JUMBO <= JUMBO_DUCKING;
	             else
	                next_state_JUMBO <= JUMBO_DUCKING; -- Stay in ducking state
		      end if;
				
		when JUMBO_RUNNING =>
			if jumbo_display_on = '1' then
				if JUMBO_DRAW then 
					jumbo_Row_draw <= Jumbo_Row_in - 20;
	                    		jumbo_Col_draw <= Jumbo_Col_in - 280;
	                    		ROMXin <= jumbo_Col_draw(5 downto 1);
	                    		ROMYin <= jumbo_Row_draw(5 downto 1);
					if running_counter > 8 then 
						jumbo_state_rgb <= ROMRUN1_out; 
					else 
						jumbo_state_rgb <= ROMRUN2_out;
					end if;
				else 
					jumbo_state_rgb <= "111111";
				end if;
			elsif jump_lgc = '1' and duck_lgc = '1' then 
				next_state_JUMBO <= JUMBO_RUNNING;
			elsif duck_lgc = '1' then 
				next_state_JUMBO <= JUMBO_DUCKING;
			elsif jump_lgc = '1' then
				next_state_JUMBO <= JUMBO_JUMPING;
			else 
			next_state_JUMBO <= JUMBO_RUNNING;
		end if;
	    end case;
	end process;
end synth;
