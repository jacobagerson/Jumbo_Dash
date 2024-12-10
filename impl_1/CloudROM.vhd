library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity CloudROM is
port(
Xin : in unsigned(4 downto 0);
	Yin : in unsigned(4 downto 0);
data : out std_logic_vector(5 downto 0)
);
end entity;


architecture synth of CloudROM is


Signal addy : unsigned(9 downto 0);


begin


addy <= Yin & Xin;


process(addy) begin
	case addy is
when "0000010000" => data <= "000000";
when "0000010001" => data <= "000000";
when "0000101110" => data <= "000000";
when "0000101111" => data <= "000000";
when "0000110000" => data <= "000000";
when "0000110001" => data <= "000000";
when "0000110010" => data <= "000000";
when "0001001101" => data <= "000000";
when "0001001110" => data <= "000000";
when "0001010010" => data <= "000000";
when "0001100111" => data <= "000000";
when "0001101000" => data <= "000000";
when "0001101101" => data <= "000000";
when "0001110011" => data <= "000000";
when "0001110100" => data <= "000000";
when "0001110101" => data <= "000000";
when "0010000111" => data <= "000000";
when "0010001000" => data <= "000000";
when "0010001001" => data <= "000000";
when "0010001010" => data <= "000000";
when "0010001011" => data <= "000000";
when "0010001100" => data <= "000000";
when "0010001101" => data <= "000000";
when "0010010101" => data <= "000000";
when "0010010110" => data <= "000000";
when "0010010111" => data <= "000000";
when "0010100110" => data <= "000000";
when "0010100111" => data <= "000000";
when "0010101100" => data <= "000000";
when "0010110111" => data <= "000000";
when "0010111000" => data <= "000000";
when "0011000100" => data <= "000000";
when "0011000101" => data <= "000000";
when "0011000110" => data <= "000000";
when "0011010111" => data <= "000000";
when "0011011000" => data <= "000000";
when "0011011001" => data <= "000000";
when "0011100010" => data <= "000000";
when "0011100011" => data <= "000000";
when "0011100100" => data <= "000000";
when "0011111000" => data <= "000000";
when "0100000000" => data <= "000000";
when "0100000001" => data <= "000000";
when "0100011000" => data <= "000000";
when "0100011001" => data <= "000000";
when "0100100010" => data <= "000000";
when "0100101111" => data <= "000000";
when "0100110000" => data <= "000000";
when "0100110001" => data <= "000000";
when "0100110010" => data <= "000000";
when "0100110011" => data <= "000000";
when "0100110100" => data <= "000000";
when "0100110101" => data <= "000000";
when "0100110110" => data <= "000000";
when "0100111001" => data <= "000000";
when "0101000100" => data <= "000000";
when "0101000101" => data <= "000000";
when "0101000110" => data <= "000000";
when "0101000111" => data <= "000000";
when "0101001000" => data <= "000000";
when "0101001001" => data <= "000000";
when "0101001010" => data <= "000000";
when "0101001011" => data <= "000000";
when "0101001100" => data <= "000000";
when "0101001101" => data <= "000000";
when "0101001110" => data <= "000000";
when "0101001111" => data <= "000000";
when "0101010110" => data <= "000000";
when "0101010111" => data <= "000000";
when "0101011000" => data <= "000000";
when "0101011001" => data <= "000000";
when "0101011010" => data <= "000000";




		when others => data <= "111111";
end case;
end process;
end;










