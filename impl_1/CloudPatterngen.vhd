library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CloudPatterngen is
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
end CloudPatterngen;

architecture synth of CloudPatterngen is
	component CloudROM is
		port(
			Xin : in unsigned(4 downto 0);
			Yin : in unsigned(4 downto 0);
			data : out std_logic_vector(5 downto 0)
		);
		
	end component;
	
--	 Cloud ROM signals
	signal CloudROM_out : std_logic_vector(5 downto 0);
	signal velocity : integer range 0 to 15 := 15;
	
	signal CloudScaleRow : unsigned(4 downto 0);
	signal CloudScaleCol : unsigned(4 downto 0);
	signal x_pos : unsigned(9 downto 0);
	signal y_pos : unsigned(9 downto 0);
	
	--signal Cloud_scroll_offset : unsigned(9 downto 0) := (others => '0');
	--signal adjusted_x_pos : unsigned(9 downto 0);
	--constant ClOUD_WIDTH : unsigned(9 downto 0) :=  to_unsigned(640, 10);
	--constant DISPLAY_WIDTH : unsigned(9 downto 0) := to_unsigned(800, 10);
	
	signal random_cloud_counter : unsigned(9 downto 0) := (others => '0');
	signal cloud_offset1 : unsigned(9 downto 0) := to_unsigned(546, 10);
	signal cloud_offset2 : unsigned(9 downto 0) := to_unsigned(276, 10);
	signal cloud_offset3 : unsigned(9 downto 0) := to_unsigned(101, 10);
	
	signal cloud1_ypos : unsigned(9 downto 0) := to_unsigned(196, 10);
	signal cloud2_ypos : unsigned(9 downto 0) := to_unsigned(81, 10);
	signal cloud3_ypos : unsigned(9 downto 0) := to_unsigned(141, 10);
	

	
begin

	Cloud_inst : CloudROM
		port map( 
			Xin => CloudScaleCol,
			Yin => CloudScaleRow,
			data => CloudROM_out
		);
		

	Cloud_range1 <= '1' when Cloud_Row_in > cloud1_ypos and Cloud_Row_in < (cloud1_ypos + 45) and Cloud_col_in > cloud_offset1 and Cloud_col_in < (cloud_offset1 + 55)  else '0'; 
	Cloud_range2 <= '1' when Cloud_Row_in > cloud2_ypos and Cloud_Row_in < (cloud2_ypos + 45) and Cloud_col_in > cloud_offset2 and Cloud_col_in < (cloud_offset2 + 55)   else '0'; 
	Cloud_range3 <= '1' when Cloud_Row_in > cloud3_ypos and Cloud_Row_in < (cloud3_ypos + 45) and Cloud_col_in > cloud_offset3 and Cloud_col_in < (cloud_offset3 + 55)   else '0'; 
	
	process(Cloud_60Hz_CLK) is begin
		if rising_edge(Cloud_60Hz_CLK) then
			if random_cloud_counter = to_unsigned(210, 8) then 
				random_cloud_counter <= (others => '0');
			else 
				random_cloud_counter <= random_cloud_counter + 1;
			end if;
			if game_start_state = '1' then
				cloud_offset1 <= to_unsigned(545, 10);
				cloud_offset2 <= to_unsigned(275, 10);
				cloud_offset3 <= to_unsigned(100, 10);
				
				cloud1_ypos <= to_unsigned(196, 10);
				cloud2_ypos <= to_unsigned(81, 10);
				cloud3_ypos <= to_unsigned(141, 10);
			elsif game_playing_state = '1' then 
				if cloud_offset1 = 0 then 
					cloud_offset1 <= to_unsigned(640, 10);
					cloud1_ypos <= random_cloud_counter;
				else 
					cloud_offset1 <= cloud_offset1 - 1;
				end if;
				if cloud_offset2 = 0 then 
					cloud_offset2 <= to_unsigned(640, 10);
					cloud2_ypos <= random_cloud_counter;
				else 
					cloud_offset2 <= cloud_offset2 - 1;
				end if;
				if cloud_offset3 = 0 then 
					cloud_offset3 <= to_unsigned(640, 10);
					cloud3_ypos <= random_cloud_counter;
				else 
					cloud_offset3 <= cloud_offset3 - 1;
				end if;
			end if;
		end if;
	end process;
	process(Cloud_display_on, game_start_state, game_playing_state, Cloud_Row_in, Cloud_Col_in) is begin
		if Cloud_display_on = '1' then
			if game_start_state = '1' then
				if Cloud_range1 then
					y_pos <= Cloud_Row_in - (cloud1_ypos);
					x_pos <= Cloud_Col_in - (cloud_offset1 + 1);
					CloudScaleRow <= y_pos(5 downto 1);
					CloudScaleCol <= x_pos(5 downto 1);
					Cloud_rgb <= CloudROM_out;
				elsif Cloud_range2 then
					y_pos <= Cloud_Row_in - (cloud2_ypos);
					x_pos <= Cloud_Col_in - (cloud_offset2 + 1);
					CloudScaleRow <= y_pos(5 downto 1);
					CloudScaleCol <= x_pos(5 downto 1);
					Cloud_rgb <= CloudROM_out;
				elsif Cloud_range3 then
					y_pos <= Cloud_Row_in - (cloud3_ypos);
					x_pos <= Cloud_Col_in - (cloud_offset3 + 1);
					CloudScaleRow <= y_pos(5 downto 1);
					CloudScaleCol <= x_pos(5 downto 1);
					Cloud_rgb <= CloudROM_out;
				end if;
			elsif game_playing_state = '1' then
				if Cloud_range1 then
					y_pos <= Cloud_Row_in - (cloud1_ypos);
					x_pos <= Cloud_Col_in - (cloud_offset1 + 1);
					CloudScaleRow <= y_pos(5 downto 1);
					CloudScaleCol <= x_pos(5 downto 1);
					Cloud_rgb <= CloudROM_out;
				elsif Cloud_range2 then
					y_pos <= Cloud_Row_in - (cloud2_ypos);
					x_pos <= Cloud_Col_in - (cloud_offset2 + 1);
					CloudScaleRow <= y_pos(5 downto 1);
					CloudScaleCol <= x_pos(5 downto 1);
					Cloud_rgb <= CloudROM_out;
				elsif Cloud_range3 then
					y_pos <= Cloud_Row_in - (cloud3_ypos);
					x_pos <= Cloud_Col_in - (cloud_offset3 + 1);
					CloudScaleRow <= y_pos(5 downto 1);
					CloudScaleCol <= x_pos(5 downto 1);
					Cloud_rgb <= CloudROM_out;
				end if;
			end if;
		end if;
	end process;
end synth;
