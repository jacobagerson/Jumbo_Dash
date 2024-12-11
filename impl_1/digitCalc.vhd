library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

 --Declare the entity
--entity digitCalc is
    --Port ( 
		--score     : in unsigned(16 downto 0); -- Input binary
		--digitsOut : out integer_vector(4 downto 0)
    --);
--end digitCalc;

 --Architecture implementation
--architecture synth of digitCalc is
     --Temporary signal for storing digits
    --signal digits : integer_vector(0 to 4); 
    --signal score_decimal : integer; -- Decimal value of the score

--begin

     --Process to extract digits from the counter_value
    --process(score)
    --begin
		--score_decimal <= to_integer(score);
         --Initialize the digits vector to all zeros
        --digits <= (others => 0);  

         --Extract digits by dividing and using modulus
        --digits(0) <= score_decimal mod 10;         -- Ones place
        --digits(1) <= (score_decimal / 10) mod 10;  -- Tens place
        --digits(2) <= (score_decimal / 100) mod 10; -- Hundreds place
        --digits(3) <= (score_decimal / 1000) mod 10;-- Thousands place
        --digits(4) <= (score_decimal / 10000) mod 10;-- Ten-thousands place

        -- Assign the digits to the output vector
        --digitsOut <= digits;
    --end process;

--end synth;

entity digitCalc is
    port ( 
		score_60hz_clock  : in  std_logic;                    
           	game_over_state, game_start_state  : in  std_logic;                    
           	velocity : in  integer range 0 to 10;         
           	digitsOut : out integer_vector(0 to 4)		
           );
end digitCalc;

architecture synth of digitCalc is
	signal digit0, digit1, digit2, digit3, digit4 : integer range 0 to 10 := 0;
	signal timer : integer range 0 to 6;	
begin
	process(score_60hz_clock, game_over_state, game_start_state)
    	begin
		if rising_edge(score_60hz_clock) then 
			if game_start_state = '1' then 
				digit0 <= 0;
				digit1 <= 0;
				digit2 <= 0;
				digit3 <= 0;
				digit4 <= 0;
			elsif game_over_state = '1' then
				digit0 <= digit0;
				digit1 <= digit1;
				digit2 <= digit2;
				digit3 <= digit3;
				digit4 <= digit4;
			else 
				if timer = 6 then
					timer <= 0;
					digit0 <= digit0 + 1;
				else
					timer <= timer + 1;
				end if;
				
				if digit0 = 10 then
					digit0 <= 0;
					digit1 <= digit1 + 1;
				end if;
				if digit1 = 10 then
					digit1 <= 0;
					digit2 <= digit2 + 1;
				end if;
				if digit2 = 10 then
					digit2 <= 0;
					digit3 <= digit3 + 1;
				end if;
				if digit3 = 10 then
					digit3 <= 0;
					digit4 <= digit4 + 1;
				end if;
				if digit4 = 10 then
					digit4 <= 0;
				end if;
	        	end if;
		end if;
	end process;
	digitsOut <= (digit0, digit1, digit2, digit3, digit4);
end synth;
