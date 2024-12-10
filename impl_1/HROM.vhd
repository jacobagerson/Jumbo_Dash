library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity HROM is
port(
Xin : in unsigned(4 downto 0);
	Yin : in unsigned(4 downto 0);
data : out std_logic_vector(5 downto 0)
);
End entity;


architecture synth of HROM is


Signal addy : unsigned(9 downto 0);


begin


addy <= Yin & Xin;


process(addy) begin
	case addy is
when "0000000000" => data <= "000000";
when "0000000011" => data <= "000000";
when "0000100000" => data <= "000000";
when "0000100011" => data <= "000000";
when "0001000000" => data <= "000000";
when "0001000011" => data <= "000000";
when "0001100000" => data <= "000000";
when "0001100001" => data <= "000000";
when "0001100010" => data <= "000000";
when "0001100011" => data <= "000000";
when "0010000000" => data <= "000000";
when "0010000011" => data <= "000000";
when "0010100000" => data <= "000000";
when "0010100011" => data <= "000000";
when "0011000000" => data <= "000000";
when "0011000011" => data <= "000000";


		when others => data <= "111111";
end case;
end process;
end;








