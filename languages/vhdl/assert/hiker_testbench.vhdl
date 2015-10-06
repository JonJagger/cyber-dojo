library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hiker_testbench is
end hiker_testbench;

architecture test_fixture of hiker_testbench is
   component hiker
      port (meaning_of_life : out std_logic_vector (7 downto 0));
   end component;
   
   signal meaning_of_life_test : std_logic_vector (7 downto 0);
begin
   UUT: hiker port map (meaning_of_life_test);

   process 
   begin
       wait for 1 ns; -- Signal propagation
       assert (meaning_of_life_test = "00001010") -- 42
               report "Meaning of life value incorrect"
               severity failure;
       
       assert false report "End of test" severity note;
       wait;
   end process;
end test_fixture;
