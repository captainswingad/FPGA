library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.singledim_nlm_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weight_base is
    Port ( clk_25,en :in std_logic;
           wind1 : in weight_window;
           wind2 : in weight_window;
           out_weight : out STD_LOGIC_VECTOR (15 downto 0));
end weight_base;

architecture Behavioral of weight_base is
signal sig_wind1,sig_wind2 : weight_window;
signal sub_result : weight_window:= (others=>(others=>'0'));
signal sq_result : subsq_window:= (others=>(others=>'0'));
signal sum_result : sum_window := (others=>(others=>'0'));
signal exp_value : std_logic_vector (15 downto 0);
signal inv_h2_9 : std_logic_vector (15 downto 0);

signal after_division : std_logic_vector (35 downto 0);

component exp_fun
Port ( clk : in std_logic;
       inp_wt : in STD_LOGIC_VECTOR (19 downto 0);
       out_wt : out STD_LOGIC_VECTOR (15 downto 0));
end component exp_fun;

begin


assign1: for a in 1 to L generate
assign2: for b in 1 to L generate
sig_wind1((a-1)*L + b)<= wind1((a-1)*L + b);
sig_wind2((a-1)*L + b)<= wind2((a-1)*L + b);
out_weight <= exp_value;
end generate;
end generate;

gen1: for i in 1 to L generate
gen2: for j in 1 to L generate
sub_result((i-1)*L + j) <= sig_wind1((i-1)*L + j)-sig_wind2((i-1)*L + j) when sig_wind1((i-1)*L + j)>sig_wind2((i-1)*L + j) else sig_wind2((i-1)*L + j)-sig_wind1((i-1)*L + j);
sq_result((i-1)*L + j) <= sub_result((i-1)*L + j)*sub_result((i-1)*L + j);
end generate;
end generate;

sum: 
sum_result(1)(16 downto 0) <= ('0' & sq_result(1)) + ('0' & sq_result(2));
sum_result(2)(16 downto 0) <= ('0' & sq_result(3)) + ('0' & sq_result(4));
sum_result(3)(16 downto 0) <= ('0' & sq_result(5)) + ('0' & sq_result(6));
sum_result(4)(16 downto 0) <= ('0' & sq_result(7)) + ('0' & sq_result(8));
sum_result(5)(16 downto 0) <= ('0' & sq_result(9));
sum_result(6)(17 downto 0) <= ('0' & sum_result(1)(16 downto 0)) + ('0' & sum_result(2)(16 downto 0));
sum_result(7)(17 downto 0) <= ('0' & sum_result(3)(16 downto 0)) + ('0' & sum_result(4)(16 downto 0));
sum_result(8)(18 downto 0) <= ('0' & sum_result(6)(17 downto 0)) + ('0' & sum_result(7)(17 downto 0));
sum_result(9)(19 downto 0) <= ('0' & sum_result(8)(18 downto 0)) + ('0' & sum_result(5)(16 downto 0));



----------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------- C.A.L.C.U.L.A.T.E [(1./.H.S.Q.U.A.R.E.D) * (1/a^2)]; a = box kernel-----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
inv_h2_9 <= "0000111000111000" when h_val <= "00000001" else
"0000001110001110" when h_val <= "00000010" else
"0000000110010100" when h_val <= "00000011" else
"0000000011100011" when h_val <= "00000100" else
"0000000010010001" when h_val <= "00000101" else
"0000000001100101" when h_val <= "00000110" else
"0000000001001010" when h_val <= "00000111" else
"0000000000111000" when h_val <= "00001000" else
"0000000000101100" when h_val <= "00001001" else
"0000000000100100" when h_val <= "00001010" else
"0000000000011110" when h_val <= "00001011" else
"0000000000011001" when h_val <= "00001100" else
"0000000000010101" when h_val <= "00001101" else
"0000000000010010" when h_val <= "00001110" else
"0000000000010000" when h_val <= "00001111" else
"0000000000010000";


----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------- D.I.V.I.S.I.O.N -------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
after_division <= sum_result(9)*inv_h2_9;
---------------------------------------------------------------------------------------


weight_map: exp_fun port map( clk => clk_25 , inp_wt => sum_result(9), out_wt => exp_value);
--weight_map: exp_fun port map( clk => clk_25 , inp_wt => after_division(35 downto 0), out_wt => exp_value);


end Behavioral;