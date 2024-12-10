library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity StartScreenROM1 is
port(
	Xin : in unsigned(4 downto 0);
	Yin : in unsigned(4 downto 0);
data : out std_logic_vector(5 downto 0)
);
end entity;


architecture synth of StartScreenROM1 is


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
when "0000001001" => data <= "000000";
when "0000001011" => data <= "000000";
when "0000001100" => data <= "000000";
when "0000001101" => data <= "000000";
when "0000001110" => data <= "000000";
when "0000010000" => data <= "000000";
when "0000010001" => data <= "000000";
when "0000010010" => data <= "000000";
when "0000010011" => data <= "000000";
when "0000010101" => data <= "000000";
when "0000010110" => data <= "000000";
when "0000010111" => data <= "000000";
when "0000011000" => data <= "000000";
when "0000011001" => data <= "000000";
when "0000100000" => data <= "000000";
when "0000100111" => data <= "000000";
when "0000101011" => data <= "000000";
when "0000101110" => data <= "000000";
when "0000110000" => data <= "000000";
when "0000110011" => data <= "000000";
when "0000110111" => data <= "000000";
when "0001000000" => data <= "000000";
when "0001000111" => data <= "000000";
when "0001001011" => data <= "000000";
when "0001001110" => data <= "000000";
when "0001010000" => data <= "000000";
when "0001010011" => data <= "000000";
when "0001010111" => data <= "000000";
when "0001100000" => data <= "000000";
when "0001100001" => data <= "000000";
when "0001100010" => data <= "000000";
when "0001100011" => data <= "000000";
when "0001100111" => data <= "000000";
when "0001101011" => data <= "000000";
when "0001101100" => data <= "000000";
when "0001101101" => data <= "000000";
when "0001101110" => data <= "000000";
when "0001110000" => data <= "000000";
when "0001110001" => data <= "000000";
when "0001110010" => data <= "000000";
when "0001110011" => data <= "000000";
when "0001110111" => data <= "000000";
when "0010000011" => data <= "000000";
when "0010000111" => data <= "000000";
when "0010001011" => data <= "000000";
when "0010001110" => data <= "000000";
when "0010010000" => data <= "000000";
when "0010010010" => data <= "000000";
when "0010010111" => data <= "000000";
when "0010100011" => data <= "000000";
when "0010100111" => data <= "000000";
when "0010101011" => data <= "000000";
when "0010101110" => data <= "000000";
when "0010110000" => data <= "000000";
when "0010110011" => data <= "000000";
when "0010110111" => data <= "000000";
when "0011000000" => data <= "000000";
when "0011000001" => data <= "000000";
when "0011000010" => data <= "000000";
when "0011000011" => data <= "000000";
when "0011000111" => data <= "000000";
when "0011001011" => data <= "000000";
when "0011001110" => data <= "000000";
when "0011010000" => data <= "000000";
when "0011010011" => data <= "000000";
when "0011010111" => data <= "000000";


		when others => data <= "111111";
end case;
end process;
end;











