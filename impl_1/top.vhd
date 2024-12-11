library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	port(
		DATA : in std_logic;
		LATCH : out std_logic;
		NES_CLK : out std_logic;
		clk_12M : in std_logic;
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		RGB : out std_logic_vector(5 downto 0)
	);
end top;

architecture synth of top is

	signal pll_clk : std_logic;
	signal ROW : std_logic_vector(9 downto 0);
	signal COLUMN : std_logic_vector(9 downto 0);
	signal DISPLAY_ENABLE : std_logic;
	signal JUMP_LGC : std_logic;
	signal START_LGC : std_logic;
	signal DUCK_LGC : std_logic;
	
	--jumbo graphic signal 
	signal JUMBO_GRAPHIC : std_logic_vector(5 downto 0);
	
	component nes is 
		port(
			data : in std_logic;
			latch : out std_logic;
			controller_clk : out std_logic;
			jump_but : out std_logic;
			start_but : out std_logic;
			duck_but : out std_logic
		);
	end component nes;
	
	component mypll is
		port(
			ref_clk_i: in std_logic;
			rst_n_i: in std_logic;
			outcore_o: out std_logic;
			outglobal_o: out std_logic
		);
	end component mypll;
	
	component vga is
		port(
			pixel_clk : in std_logic; --25 MHz pixel clock input
			hsync : out std_logic; --Horizontal sync signal
			vsync: out std_logic; -- vertical sync signal
			display_enable : out std_logic; -- display valid signal
			row : out std_logic_vector(9 downto 0); -- current row (vertical position)
			column : out std_logic_vector(9 downto 0) -- current column (horizontal position)
		);
	end component vga;
	
	component patterngen is
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
	end component patterngen;
		
begin

	--pll instatiation
	mypll_inst : mypll 
		port map(
			ref_clk_i => clk_12M,
			rst_n_i => '1',
			outglobal_o => pll_clk
		);
	
	-- vga instatiation
	vga_inst : vga 
		port map(
			pixel_clk => pll_clk,
			hsync => HSYNC,
			vsync => VSYNC,
			display_enable => DISPLAY_ENABLE,
			row => ROW,
			column => COLUMN
		);
		
	-- pattern gen instatiation
	patterngen_inst : patterngen
		port map(
			CLK => pll_clk,
			Row => ROW,
			Col => COLUMN,
			rgb_patterngen => RGB,
			jump_lgc => JUMP_LGC,
			start_lgc => START_LGC,
			duck_lgc => DUCK_LGC,
			display_on => DISPLAY_ENABLE
		);
		
		--nes controller instantiation
	nes_inst : nes
		port map(
			data => DATA,
			latch => LATCH,
			controller_clk => NES_CLK,
			--dataout => DATAOUT,
			jump_but => JUMP_LGC,
			start_but => START_LGC,
			duck_but => DUCK_LGC
		);
		

	
end synth;
