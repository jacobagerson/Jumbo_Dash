library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
	port(
		pixel_clk : in std_logic; --25 MHz pixel clock input
		hsync : out std_logic; --Horizontal sync signal
		vsync: out std_logic; -- vertical sync signal
		display_enable : out std_logic; -- display valid signal
		row : out std_logic_vector(9 downto 0); -- current row (vertical position)
		column : out std_logic_vector(9 downto 0) -- current column (horizontal position)
	);
end vga;

architecture synth of vga is

	-- Horizontal and Vertical counter signals
	signal column_count : integer range 0 to 799 := 0;
	signal row_count : integer range 0 to 524 := 0;
	
begin

	-- Process for column and row counters
	process(pixel_clk) 
	begin
		if rising_edge(pixel_clk) then 
			
			--Column counter
			if column_count = 799 then
				column_count <= 0;
			
			-- row counter
			if row_count = 524 then
				row_count <= 0;
			else
				row_count <= row_count + 1;
			end if;
		else
			column_count <= column_count + 1;
		end if;
	end if;
	end process;
	
	-- combinational logic for HSYNC
	hsync <= '0' when (column_count >= 656 and column_count < 752) else '1';
	 -- combinational logic for VSYNC 
	vsync <= '0' when (row_count >= 490 and row_count < 492) else '1';
	 
	display_enable <= '1' when (column_count < 640 and row_count < 480) else '0';
	
	-- Assign the current row and column for display 
	column <= std_logic_vector(to_unsigned(column_count, 10));
	row <= std_logic_vector(to_unsigned(row_count, 10));
	
end;
	 