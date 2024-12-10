library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity speedCalc is
port(
    score : in unsigned(16 downto 0);
	increment : out integer range 0 to 12
);
end;

architecture synth of speedCalc is

signal scoreDecimal : integer range 0 to 99999 := 0;

begin

scoreDecimal <= to_integer(score);

process(score) begin
	
	if scoreDecimal < 250 then
		increment <= 6;
	elsif scoreDecimal >= 250 and scoreDecimal < 500 then
		increment <= 7;
	elsif scoreDecimal >= 500 and scoreDecimal < 1000 then
		increment <= 8;
	elsif scoreDecimal >= 1000 and scoreDecimal < 1500 then
		increment <= 9;
	elsif scoreDecimal >= 1500 then
		increment <= 10;
	end if;
end process;


end;


