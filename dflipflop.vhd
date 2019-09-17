


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dflipflop is
    Port ( clk  : in STD_LOGIC;
           en   : in STD_LOGIC;
           D    : in STD_LOGIC_VECTOR (7 downto 0);
           Q    : out STD_LOGIC_VECTOR (7 downto 0));
end dflipflop;

architecture Behavioral of dflipflop is

begin

dff:process(clk)
begin
if (clk'event and clk = '1') then
    if(en = '1') then
        Q <= D;
    end if;
end if;
end process;
end Behavioral;
