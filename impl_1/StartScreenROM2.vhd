library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity StartScreenROM2 is
port(
	Xin : in unsigned(4 downto 0);
	Yin : in unsigned(4 downto 0);
data : out std_logic_vector(5 downto 0)
);
end entity;


architecture synth of StartScreenROM2 is


Signal addy : unsigned(9 downto 0);


Begin


addy <= Yin & Xin;


process(addy) begin
	case addy is
		when "0000000000" => data <= "000000";
when "0000000001" => data <= "000000";
when "0000000010" => data <= "000000";
when "0000000011" => data <= "000000";
when "0000000101" => data <= "000000";
when "0000000110" => data <= "000000";
when "0000000111" => data <= "000000";
when "0000001000" => data <= "000000";
when "0000001010" => data <= "000000";
when "0000001011" => data <= "000000";
when "0000001100" => data <= "000000";
when "0000001101" => data <= "000000";
when "0000001111" => data <= "000000";
when "0000010000" => data <= "000000";
when "0000010001" => data <= "000000";
when "0000010010" => data <= "000000";
when "0000010100" => data <= "000000";
when "0000010101" => data <= "000000";
when "0000010110" => data <= "000000";
when "0000010111" => data <= "000000";
when "0000100000" => data <= "000000";
when "0000100011" => data <= "000000";
when "0000100101" => data <= "000000";
when "0000101000" => data <= "000000";
when "0000101010" => data <= "000000";
when "0000101111" => data <= "000000";
when "0000110100" => data <= "000000";
when "0001000000" => data <= "000000";
when "0001000011" => data <= "000000";
when "0001000101" => data <= "000000";
when "0001001000" => data <= "000000";
when "0001001010" => data <= "000000";
when "0001001111" => data <= "000000";
when "0001010100" => data <= "000000";
when "0001100000" => data <= "000000";
when "0001100001" => data <= "000000";
when "0001100010" => data <= "000000";
when "0001100011" => data <= "000000";
when "0001100101" => data <= "000000";
when "0001100110" => data <= "000000";
when "0001100111" => data <= "000000";
when "0001101000" => data <= "000000";
when "0001101010" => data <= "000000";
when "0001101011" => data <= "000000";
when "0001101100" => data <= "000000";
when "0001101101" => data <= "000000";
when "0001101111" => data <= "000000";
when "0001110000" => data <= "000000";
when "0001110001" => data <= "000000";
when "0001110010" => data <= "000000";
when "0001110100" => data <= "000000";
when "0001110101" => data <= "000000";
when "0001110110" => data <= "000000";
when "0001110111" => data <= "000000";
when "0010000000" => data <= "000000";
when "0010000101" => data <= "000000";
when "0010000111" => data <= "000000";
when "0010001010" => data <= "000000";
when "0010010010" => data <= "000000";
when "0010010111" => data <= "000000";
when "0010100000" => data <= "000000";
when "0010100101" => data <= "000000";
when "0010101000" => data <= "000000";
when "0010101010" => data <= "000000";
when "0010110010" => data <= "000000";
when "0010110111" => data <= "000000";
when "0011000000" => data <= "000000";
when "0011000101" => data <= "000000";
when "0011001000" => data <= "000000";
when "0011001010" => data <= "000000";
when "0011001011" => data <= "000000";
when "0011001100" => data <= "000000";
when "0011001101" => data <= "000000";
when "0011001111" => data <= "000000";
when "0011010000" => data <= "000000";
when "0011010001" => data <= "000000";
when "0011010010" => data <= "000000";
when "0011010100" => data <= "000000";
when "0011010101" => data <= "000000";
when "0011010110" => data <= "000000";
when "0011010111" => data <= "000000";


		when others => data <= "111111";
end case;
end process;
end;










