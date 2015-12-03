library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hiker is 
   port (meaning_of_life : out std_logic_vector (7 downto 0));
end hiker;

architecture dataflow of hiker is
begin
   meaning_of_life <= "00110110";  -- 54
end dataflow;


