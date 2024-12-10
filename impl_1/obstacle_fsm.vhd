library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity obstacle_fsm is
   port(
       LFSR_clk : in std_logic;
       ob_Row : in unsigned(9 downto 0);
       ob_Col : in unsigned(9 downto 0);
       OB_60HZ_clk : in std_logic;
       OB1_draw : out std_logic;
       OB2_draw : out std_logic;
       OB3_draw : out std_logic;
       OB4_draw : out std_logic;
       OB5_draw : out std_logic;
       OB6_draw : out std_logic;
       OB7_draw : out std_logic;
       OB8_draw : out std_logic;
       OB9_draw : out std_logic;
       OB10_draw : out std_logic;
       ptero1_draw : out std_logic;
       ptero2_draw : out std_logic;
       ptero3_draw : out std_logic;
       ob_display_on : in std_logic;
       game_start_state, game_playing_state, game_over_state : in std_logic;
       blank_on : out std_logic;
       game_velocity : in integer range 0 to 12;
       ob_out : out std_logic_vector(5 downto 0)
   );
end obstacle_fsm;


architecture synth of obstacle_fsm is


  
   --obstacle roms:
   component CactusROM1 is
       port(
           Xin : in unsigned(4 downto 0);
           Yin : in unsigned(4 downto 0);
           data : out std_logic_vector(5 downto 0)
       );
   end component;
  
       component CactusROM2 is
       port(
           Xin : in unsigned(4 downto 0);
           Yin : in unsigned(4 downto 0);
           data : out std_logic_vector(5 downto 0)
       );
   end component;
  
       component CactusROM3 is
       port(
           Xin : in unsigned(4 downto 0);
           Yin : in unsigned(4 downto 0);
           data : out std_logic_vector(5 downto 0)
       );
   end component;
  
       component CactusROM4 is
       port(
           Xin : in unsigned(4 downto 0);
           Yin : in unsigned(4 downto 0);
           data : out std_logic_vector(5 downto 0)
       );
   end component;
  
   component pterodown_ROM is
       port(
           Xin : in unsigned(4 downto 0);
           Yin : in unsigned(4 downto 0);
           data : out std_logic_vector(5 downto 0)
       );
   end component;
  
   component pteroup_ROM is
       port(
           Xin : in unsigned(4 downto 0);
           Yin : in unsigned(4 downto 0);
           data : out std_logic_vector(5 downto 0)
       );
   end component;
  


   signal random_ob : unsigned(2 downto 0);
  
   --ob1 signals
   signal ob1_offset : unsigned(9 downto 0) := (others => '0');
   constant ob1_width : unsigned(9 downto 0) := to_unsigned(28, 10);
   constant ob1_height : unsigned(9 downto 0) := to_unsigned(46, 10);
   --signal ob1_rgb : integer range 0 to 3;


      
   --ob1 signals
   signal ob2_offset : unsigned(9 downto 0) := (others => '0');
   constant ob2_width : unsigned(9 downto 0) := to_unsigned(48, 10);
   constant ob2_height : unsigned(9 downto 0) := to_unsigned(46, 10);
   --signal ob2_rgb : integer range 0 to 3;
  


      
   --ob1 signals
   signal ob3_offset : unsigned(9 downto 0) := (others => '0');
   constant ob3_width : unsigned(9 downto 0) := to_unsigned(62, 10);
   constant ob3_height : unsigned(9 downto 0) := to_unsigned(46, 10);
   signal ob3_rgb : integer range 0 to 3;
   signal ob5_offset : unsigned(9 downto 0) := (others => '0');
   signal ob6_offset : unsigned(9 downto 0) := (others => '0');
   signal ob7_offset : unsigned(9 downto 0) := (others => '0');
   signal ob8_offset : unsigned(9 downto 0) := (others => '0');
   signal ob9_offset : unsigned(9 downto 0) := (others => '0');
   signal ob10_offset : unsigned(9 downto 0) := (others => '0');


      
   --ob1 signals
   signal ob4_offset : unsigned(9 downto 0) := (others => '0');
   constant ob4_width : unsigned(9 downto 0) := to_unsigned(18, 10);
   constant ob4_height : unsigned(9 downto 0) := to_unsigned(42, 10);
   --signal ob4_rgb : integer range 0 to 3;
  
   signal ROMXin : unsigned(4 downto 0);
   signal ROMYin : unsigned(4 downto 0);
  
   --OB draw signal:
   signal OB1 : std_logic;
   signal cactus1_draw : std_logic;
   signal y_pos, x_pos : unsigned(9 downto 0);
  
   --obstacle Rom's:
   signal Cactus1_out : std_logic_vector(5 downto 0);
   signal Cactus2_out : std_logic_vector(5 downto 0);
   signal Cactus3_out : std_logic_vector(5 downto 0);
   signal Cactus4_out : std_logic_vector(5 downto 0);
   signal pterodown_out : std_logic_vector(5 downto 0);
   signal pteroup_out : std_logic_vector(5 downto 0);
   --signal random_spawn_counter_int : integer range 0 to 25; 
   signal ptero1_offset : unsigned(9 downto 0) := (others => '0');
   signal ptero2_offset : unsigned(9 downto 0) := (others => '0');
   signal ptero3_offset : unsigned(9 downto 0) := (others => '0');
   signal ptero_rom_switch_counter : integer range 0 to 16;
  
 
  
   constant sep_dist : integer := 300;
begin


      
       CactusROM1_inst : CactusROM1
           port map(
           Xin => ROMXin,
           Yin => ROMYin,
           data => Cactus1_out
       );
  
       CactusROM2_inst : CactusROM2
           port map(
           Xin => ROMXin,
           Yin => ROMyin,
           data => Cactus2_out
       );


       CactusROM3_inst : CactusROM3
           port map(
           Xin => ROMXin,
           Yin => ROMYin,
           data => Cactus3_out
       );
  
       CactusROM4_inst : CactusROM4
           port map(
           Xin => ROMXin,
           Yin => ROMYin,
           data => Cactus4_out
       );
  
       pterodown_ROM_inst : pterodown_ROM
           port map(
           Xin => ROMXin,
           Yin => ROMYin,
           data => pterodown_out
       );
      
       pteroup_ROM_inst : pteroup_ROM
           port map(
           Xin => ROMXin,
           Yin => ROMYin,
           data => pteroup_out
       ); 


   OB1_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob1_height and ob_Col > ob1_offset and ob_col < (ob1_offset + ob1_width)) else '0';
   OB2_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob2_height and ob_Col > ob2_offset and ob_col < (ob2_offset + ob2_width)) else '0';
   OB3_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob3_height and ob_Col > ob3_offset and ob_col < (ob3_offset + ob3_width)) else '0';
   OB4_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob4_height and ob_Col > ob4_offset and ob_col < (ob4_offset + ob4_width)) else '0';
   OB5_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob4_height and ob_Col > ob5_offset and ob_col < (ob5_offset + ob4_width)) else '0';
   OB6_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob3_height and ob_Col > ob6_offset and ob_col < (ob6_offset + ob3_width)) else '0';
   OB7_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob1_height and ob_Col > ob7_offset and ob_col < (ob7_offset + ob1_width)) else '0';
   OB8_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob1_height and ob_Col > ob8_offset and ob_col < (ob8_offset + ob1_width)) else '0';
   OB9_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob2_height and ob_Col > ob9_offset and ob_col < (ob9_offset + ob2_width)) else '0';
   OB10_draw <= '1' when (ob_Row < 313 and ob_Row > 312 - ob4_height and ob_Col > ob10_offset and ob_col < (ob10_offset + ob4_width)) else '0';
  
   ptero1_draw <= '1' when (ob_Row < 275 and ob_Row > 248 and ob_Col > ptero1_offset and ob_Col < (ptero1_offset + 43)) else '0';
   ptero2_draw <= '1' when (ob_Row < 265 and ob_Row > 238 and ob_Col > ptero2_offset and ob_Col < (ptero2_offset + 43)) else '0';
   ptero3_draw <= '1' when (ob_Row < 285 and ob_Row > 258 and ob_Col > ptero3_offset and ob_Col < (ptero3_offset + 43)) else '0';
  
  
   --h
   process(OB_60HZ_clk) is begin
       if rising_edge(OB_60HZ_clk) then
           if ptero_rom_switch_counter = 16 then
               ptero_rom_switch_counter <= 0;
           else
               ptero_rom_switch_counter <= ptero_rom_switch_counter + 1;
           end if;
           if game_start_state = '1' then
               ob4_offset <= to_unsigned(640, 10);
               ob3_offset <= to_unsigned(640, 10);
               ob2_offset <= to_unsigned(640, 10);
               ptero1_offset <= to_unsigned(640, 10);
               ptero2_offset <= to_unsigned(640, 10);
               ptero3_offset <= to_unsigned(640, 10);
               ob1_offset <= to_unsigned(330, 10);
               ob5_offset <= to_unsigned(640, 10);
               ob6_offset <= to_unsigned(640, 10);
               ob7_offset <= to_unsigned(640, 10);
               ob8_offset <= to_unsigned(640, 10);
               ob9_offset <= to_unsigned(640, 10);
               ob10_offset <= to_unsigned(640, 10);
           elsif game_playing_state = '1' then
               if ob1_offset = 0 then
                   ob1_offset <= to_unsigned(640, 10);
               elsif abs(to_integer(ob1_offset) - to_integer(ob2_offset)) < sep_dist then
                   ob1_offset <= to_unsigned(640, 10);
               else
                   ob1_offset <= ob1_offset - game_velocity;
               end if;
              
               if ob2_offset = 0 then
                   ob2_offset <= to_unsigned(640,10);
               elsif ob2_offset - ob3_offset < sep_dist then  
                   ob2_offset <= to_unsigned(640, 10);
               else
                   ob2_offset <= ob2_offset - game_velocity;
               end if;
              
               if ob3_offset = 0 then
                   ob3_offset <= to_unsigned(640,10);
               elsif ob3_offset - ptero1_offset < sep_dist then
                   ob3_offset <= to_unsigned(640, 10);


               else
                   ob3_offset <= ob3_offset - game_velocity;


               end if;


               if ptero1_offset = 0 then
                   ptero1_offset <= to_unsigned(640, 10);
               elsif ptero1_offset - ob4_offset < sep_dist then
                   ptero1_offset <= to_unsigned(640, 10); 


               else
                   ptero1_offset <= ptero1_offset - game_velocity;
               end if;


               if ob4_offset = 0 then
                   ob4_offset <= to_unsigned(640,10);
               elsif ob4_offset - ptero2_offset < sep_dist then
                       ob4_offset <= to_unsigned(640, 10);
               else
                   ob4_offset <= ob4_offset - game_velocity;
               end if;


               if ptero2_offset = 0 then
                   ptero2_offset <= to_unsigned(640, 10);
               elsif ptero2_offset - ob5_offset < sep_dist then
                   ptero2_offset <= to_unsigned(640, 10); 


               else
                   ptero2_offset <= ptero2_offset - game_velocity;
               end if;


               if ob5_offset = 0 then
                   ob5_offset <= to_unsigned(640,10);
               elsif ob5_offset - ob6_offset < sep_dist then
                       ob5_offset <= to_unsigned(640, 10);
               else
                   ob5_offset <= ob5_offset - game_velocity;
               end if;
               if ob6_offset = 0 then
                   ob6_offset <= to_unsigned(640,10);
               elsif ob6_offset - ob7_offset < sep_dist then
                       ob6_offset <= to_unsigned(640, 10);
               else
                   ob6_offset <= ob6_offset - game_velocity;
               end if;


               if ob7_offset = 0 then
                   ob7_offset <= to_unsigned(640,10);
               elsif ob7_offset - ptero3_offset < sep_dist then
                       ob7_offset <= to_unsigned(640, 10);
               else
                   ob7_offset <= ob7_offset - game_velocity;
               end if;


               if ptero3_offset = 0 then
                   ptero3_offset <= to_unsigned(640, 10);
               elsif ptero3_offset - ob8_offset < sep_dist then
                   ptero3_offset <= to_unsigned(640, 10); 


               else
                   ptero3_offset <= ptero3_offset - game_velocity;
               end if;


               if ob8_offset = 0 then
                   ob8_offset <= to_unsigned(640,10);
               elsif ob8_offset - ob9_offset < sep_dist then
                       ob8_offset <= to_unsigned(640, 10);
               else
                   ob8_offset <= ob8_offset - game_velocity;
               end if;
               if ob9_offset = 0 then
                   ob9_offset <= to_unsigned(640,10);
               elsif ob9_offset - ob10_offset < sep_dist then
                       ob9_offset <= to_unsigned(640, 10);
               else
                   ob9_offset <= ob9_offset - game_velocity;
               end if;


               if ob10_offset = 0 then
                   ob10_offset <= to_unsigned(640,10);
               elsif ob10_offset - ob1_offset < sep_dist then
                       ob10_offset <= to_unsigned(640, 10);
               else
                   ob10_offset <= ob10_offset - game_velocity;
               end if;
			elsif game_over_state = '1' then 
				ob4_offset <= to_unsigned(640, 10);
               ob3_offset <= to_unsigned(640, 10);
               ob2_offset <= to_unsigned(640, 10);
               ptero1_offset <= to_unsigned(640, 10);
               ptero2_offset <= to_unsigned(640, 10);
               ptero3_offset <= to_unsigned(640, 10);
               ob1_offset <= to_unsigned(330, 10);
               ob5_offset <= to_unsigned(640, 10);
               ob6_offset <= to_unsigned(640, 10);
               ob7_offset <= to_unsigned(640, 10);
               ob8_offset <= to_unsigned(640, 10);
               ob9_offset <= to_unsigned(640, 10);
               ob10_offset <= to_unsigned(640, 10);
           end if;
		end if;
   end process;
          
   process(ob_display_on, game_start_state, game_playing_state, ob_Row, ob_Col, OB1_draw, ptero1_draw, ptero2_draw, ptero3_draw, OB2_draw, OB3_draw, OB4_draw, OB5_draw, OB6_draw, OB7_draw, OB9_draw, OB9_draw, OB10_draw)  is
   begin
       if ob_display_on  = '1' then
           if game_start_state = '1' then
                 ob_out <= "111111";
           elsif game_playing_state = '1' then
               if OB1_draw then
                   y_pos <= ob_Row - (313 - ob1_height);
                   x_pos <= ob_Col - (ob1_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus1_out;
               elsif ptero1_draw then
                   y_pos <= ob_Row - 248;
                   x_pos <= ob_Col - (ptero1_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   if ptero_rom_switch_counter > 8 then
                       ob_out <= pterodown_out;
                   else
                       ob_out <= pteroup_out;
                   end if;
               elsif ptero2_draw then
                   y_pos <= ob_Row - 238;
                   x_pos <= ob_Col - (ptero2_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   if ptero_rom_switch_counter > 8 then
                       ob_out <= pterodown_out;
                   else
                       ob_out <= pteroup_out;
                   end if;
               elsif ptero3_draw then
                   y_pos <= ob_Row - 258;
                   x_pos <= ob_Col - (ptero3_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   if ptero_rom_switch_counter > 8 then
                       ob_out <= pterodown_out;
                   else
                       ob_out <= pteroup_out;
                   end if;
               elsif OB2_draw then
                   y_pos <= ob_Row - (313 - ob2_height);
                   x_pos <= ob_Col - (ob2_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus2_out;
              
               elsif OB3_draw then
                   y_pos <= ob_Row - (313 - ob3_height);
                   x_pos <= ob_Col - (ob3_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus3_out;
          
               elsif OB4_draw then
                   y_pos <= ob_Row - (313 - ob4_height);
                   x_pos <= ob_Col - (ob4_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus4_out;
               elsif OB5_draw then
                   y_pos <= ob_Row - (313 - ob4_height);
                   x_pos <= ob_Col - (ob5_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus4_out;
               elsif OB6_draw then
                   y_pos <= ob_Row - (313 - ob3_height);
                   x_pos <= ob_Col - (ob6_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus3_out;
               elsif OB7_draw then
                   y_pos <= ob_Row - (313 - ob1_height);
                   x_pos <= ob_Col - (ob7_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus1_out;
               elsif OB8_draw then
                   y_pos <= ob_Row - (313 - ob1_height);
                   x_pos <= ob_Col - (ob8_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus1_out;
               elsif OB9_draw then
                   y_pos <= ob_Row - (313 - ob2_height);
                   x_pos <= ob_Col - (ob9_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus2_out;
               elsif OB10_draw then
                   y_pos <= ob_Row - (313 - ob4_height);
                   x_pos <= ob_Col - (ob10_offset + 1);
                   ROMXin <= x_pos(5 downto 1);
                   ROMYin <= y_pos(5 downto 1);
                   ob_out <= Cactus4_out;
               end if;
              
           else
              ob_out <= "111111";
           end if;
       end if;
   end process;


       --process(OB1)
           --when ob1_rgb <=
               --ob1_width
               --ob1_height <=
end;



