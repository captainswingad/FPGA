----------------------------------------------------------------------------------
-- Create Date: 11.06.2019 15:55:36
-- Module Name: test_bench - Behavioral
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
library work;
use work.arr.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity test_bench is
--  Port ( );
end test_bench;

architecture Behavioral of test_bench is
        
component read_image_vhdl is
            port(
--            clock:in std_logic;                                                                   
--            data:in std_logic_vector(7 downto 0);                                                              
--            read_addr:in std_logic_vector(3 downto 0);                                                                
--            write_addr:in std_logic_vector(3 downto 0);                                                              
--            we:in std_logic;                                                               
--            re:in std_logic;                                                            
              outp: out output_arr
    );
end component;

--input cases---

--signal clock :std_logic := '0';
--signal data : std_logic_vector(7 downto 0) := (others=>'0');
--signal read_addr : std_logic_vector(3 downto 0) := (others=>'0');
--signal write_addr : std_logic_vector(3 downto 0) := (others=>'0');
--signal we : std_logic := '0';
--signal re :std_logic := '0';

--output cases----

signal outp : output_arr;

--defining clock signals--

--constant time_period : time :=10 ns;

--loop definition----
--signal i :integer;

--begining...----

begin
   uut:read_image_vhdl port map(
        --clock=>clock,
        --data=>data,
        --read_addr=>read_addr,
        --write_addr=>write_addr,
        --we=>we,
        --re=>re,
        outp=>outp
    );
--defining clock....----
--process
    --begin
        --clock <= '0';
        --wait for time_period/2;
        --clock<='1';
        --wait for time_period/2;
    --end process;
--process 
    --begin
        --data<=x"00";  --x means no.s are in hexadecimal format 
        --write_addr<=x"0";
        --read_addr<=x"0";
        --we<='0';
        --re<='0';
        --wait for 100 ns;
        --re<='1';
        --for i in 0 to 15 loop
            --read_addr <= std_logic_vector(to_unsigned(i,4));
            --wait for 20 ns;
        --end loop;
        --wait; --makes the process wait indefinetly(it will never re-execute from its beginning
 --end process;
        
         

end Behavioral;
