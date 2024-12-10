--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;

--entity lfsr is
	--port(
		--fast_clk : in std_logic;
		--lfsr_out : out unsigned(2 downto 0)
	--);
--end lfsr;

--architecture synth of lfsr is
	--signal r : unsigned(2 downto 0);
	--signal feedback : std_logic;
--begin

	--process(fast_clk)
	--begin
		--if rising_edge(fast_clk) then 
			--if r = (others => '0') then 
				--r <= "001";
			--else 
				
				--feedback <= r(2) xor r(1);  
				--r <= feedback & r(2 downto 1);
			--end if;
		--end if;
	--end process;
	--lfsr_out <= r;
--end architecture synth;