

------------------------------------------------------------------------------------
-------------------------PACKAGE----------------------------------------------------
------------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

--package nlm_package is
    
--   constant N : integer := 74;
--   constant M : integer := 5;
--   constant L : integer := 3;
--   constant h_val :std_logic_vector(7 downto 0):= "00000100";  -- h_val = 4;
--   shared variable L2 : integer := L*L;
--   shared variable M2 : integer := M*M;
--   shared variable N2 : integer := N*N;
--   shared variable reg_size : integer := M + L - 1;
----   shared variable CENT_M := (1+M) srl 1;
----   shared variable CENT_L := (1+L);

--    -- Weight Base  TYPES --
--    type weight_window is array( 1 to L, 1 to L) of std_logic_vector ( 7 downto 0 );
--    type subsq_window is array( 1 to L, 1 to L) of std_logic_vector( 15 downto 0 );
--    type sum_window is array( 1 to L2) of std_logic_vector( 19 downto 0 );
    
    
--    -- One Pixel Types --
--    type search_window is array( 1 to M, 1 to M) of weight_window;
--    type weight_values is array( 1 to M, 1 to M) of std_logic_vector( 15 downto 0 );
    
--    type sum_weight_val is array( 1 to M2 ) of std_logic_vector( 20 downto 0 );
    
--    type multiply is array( 1 to M, 1 to M ) of std_logic_vector( 23 downto 0 );
--    type sum_multiply is array( 1 to M2 ) of std_logic_vector( 28 downto 0 );
   
--    -- Image Type --
--    type image_size is array( 1 to N2) of std_logic_vector( 7 downto 0 );
--    type register_array is array( 1 to reg_size, 1 to N) of std_logic_vector( 7 downto 0);
    
--    type fp_var is array( 0 to 48 ) of std_logic_vector( 14 downto 0 );
--end package nlm_package;


----------------------------------------------------------------------------------
---------------------SINGLE PIXEL FUNCTION----------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------



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

entity one_pixel is
    Port ( clk_25    : in STD_LOGIC;
           en_calc   : in STD_LOGIC;
           one_search: in search_window;
           en_out    : out std_logic;
           pixel_out : out STD_LOGIC_VECTOR(7 downto 0));
end one_pixel;

architecture Behavioral of one_pixel is

component weight_base is
    Port ( clk_25,en    : in std_logic;
           wind1        : in weight_window;
           wind2        : in weight_window;
           out_weight   : out STD_LOGIC_VECTOR (15 downto 0));
end component weight_base;

signal central_window   : weight_window;                   -- For storing the Central Pixel Window 
signal each_weight      : weight_values;                   -- Weight Associated with each Pixel
signal mult_out         : multiply;                        -- Weight Multiplied with pixel values
signal sum_mult_out     : sum_multiply;                    -- Sum of PIXEL * WEIGHT 
signal sum_weights      : sum_weight_val;                  -- To find the Total Sum of all Weights
signal normal_weight    : std_logic_vector(20 downto 0);   -- Normalisation Factor
signal vi_wi            : std_logic_vector(28 downto 0);   -- FINAL Sum of PIXEL * WEIGHT
signal out_pixel        : STD_LOGIC_VECTOR(28 downto 0);


begin

--  N(i)  --
central_window <= one_search(13);

--  W(i,j)  --
sgen1: for ii in 1 to M generate
sgen2: for jj in 1 to M generate
smap: weight_base port map( clk_25 => clk_25 , en=>en_calc, wind1=>central_window, wind2 => one_search((ii-1)*M + jj),out_weight => each_weight((ii-1)*M + jj));
end generate;
end generate;

--  V(i) * W(i,j) --
mult1: for aa in 1 to M generate
mult2: for bb in 1 to M generate
mult_out((aa-1)*M + bb) <= each_weight((aa-1)*M + bb)*one_search((aa-1)*M + bb)(5);
end generate;
end generate;

-- SUM of ( V(i) * W(i,j) ) --
mult_out_sum:
sum_mult_out(1)(24 downto 0) <= ('0' & mult_out(1)) + ('0' & mult_out(2));
sum_mult_out(2)(24 downto 0) <= ('0' & mult_out(6)) + ('0' & mult_out(7));
sum_mult_out(3)(24 downto 0) <= ('0' & mult_out(11)) + ('0' & mult_out(12));
sum_mult_out(4)(24 downto 0) <= ('0' & mult_out(16)) + ('0' & mult_out(17));
sum_mult_out(5)(24 downto 0) <= ('0' & mult_out(21)) + ('0' & mult_out(22));
sum_mult_out(6)(24 downto 0) <= ('0' & mult_out(3)) + ('0' & mult_out(4));
sum_mult_out(7)(24 downto 0) <= ('0' & mult_out(8)) + ('0' & mult_out(9));
sum_mult_out(8)(24 downto 0) <= ('0' & mult_out(13)) + ('0' & mult_out(14));
sum_mult_out(9)(24 downto 0) <= ('0' & mult_out(18)) + ('0' & mult_out(19));
sum_mult_out(10)(24 downto 0) <= ('0' & mult_out(23)) + ('0' & mult_out(24));
sum_mult_out(11)(24 downto 0) <= ('0' & mult_out(5)) + ('0' & mult_out(10));
sum_mult_out(12)(24 downto 0) <= ('0' & mult_out(15)) + ('0' & mult_out(20));


sum_mult_out(13)(25 downto 0) <= ('0' & sum_mult_out(1)(24 downto 0)) + ('0' & sum_mult_out(2)(24 downto 0));
sum_mult_out(14)(25 downto 0) <= ('0' & sum_mult_out(3)(24 downto 0)) + ('0' & sum_mult_out(4)(24 downto 0));
sum_mult_out(15)(25 downto 0) <= ('0' & sum_mult_out(5)(24 downto 0)) + ('0' & sum_mult_out(6)(24 downto 0));
sum_mult_out(16)(25 downto 0) <= ('0' & sum_mult_out(7)(24 downto 0)) + ('0' & sum_mult_out(8)(24 downto 0));
sum_mult_out(17)(25 downto 0) <= ('0' & sum_mult_out(9)(24 downto 0)) + ('0' & sum_mult_out(10)(24 downto 0));
sum_mult_out(18)(25 downto 0) <= ('0' & sum_mult_out(11)(24 downto 0)) + ('0' & sum_mult_out(12)(24 downto 0));

sum_mult_out(19)(26 downto 0) <= ('0' & sum_mult_out(13)(25 downto 0)) + ('0' & sum_mult_out(14)(25 downto 0));
sum_mult_out(20)(26 downto 0) <= ('0' & sum_mult_out(15)(25 downto 0)) + ('0' & sum_mult_out(16)(25 downto 0));
sum_mult_out(21)(26 downto 0) <= ('0' & sum_mult_out(17)(25 downto 0)) + ('0' & sum_mult_out(18)(25 downto 0));
sum_mult_out(22)(24 downto 0) <= ('0' & mult_out(25));

sum_mult_out(23)(27 downto 0) <= ('0' & sum_mult_out(19)(26 downto 0)) + ('0' & sum_mult_out(20)(26 downto 0));
sum_mult_out(24)(27 downto 0) <= ('0' & sum_mult_out(21)(26 downto 0)) + ('0' & sum_mult_out(22)(23 downto 0));

sum_mult_out(25)(28 downto 0) <= ('0' & sum_mult_out(23)(27 downto 0)) + ('0' & sum_mult_out(24)(27 downto 0));

vi_wi <= sum_mult_out(25);

-- Z(i)  --
weight_sum:
sum_weights(1)(16 downto 0) <= ('0' & each_weight(1)) + ('0' & each_weight(2));
sum_weights(2)(16 downto 0) <= ('0' & each_weight(3)) + ('0' & each_weight(4));
sum_weights(3)(16 downto 0) <= ('0' & each_weight(6)) + ('0' & each_weight(7));
sum_weights(4)(16 downto 0) <= ('0' & each_weight(8)) + ('0' & each_weight(9));
sum_weights(5)(16 downto 0) <= ('0' & each_weight(11)) + ('0' & each_weight(12));
sum_weights(6)(16 downto 0) <= ('0' & each_weight(13)) + ('0' & each_weight(14));
sum_weights(7)(16 downto 0) <= ('0' & each_weight(16)) + ('0' & each_weight(17));
sum_weights(8)(16 downto 0) <= ('0' & each_weight(18)) + ('0' & each_weight(19));
sum_weights(9)(16 downto 0) <= ('0' & each_weight(21)) + ('0' & each_weight(22));
sum_weights(10)(16 downto 0) <= ('0' & each_weight(23)) + ('0' & each_weight(24));
sum_weights(11)(16 downto 0) <= ('0' & each_weight(5)) + ('0' & each_weight(10));
sum_weights(12)(16 downto 0) <= ('0' & each_weight(15)) + ('0' & each_weight(20));


sum_weights(13)(17 downto 0) <= ('0' & sum_weights(1)(16 downto 0)) + ('0' & sum_weights(2)(16 downto 0));
sum_weights(14)(17 downto 0) <= ('0' & sum_weights(3)(16 downto 0)) + ('0' & sum_weights(4)(16 downto 0));
sum_weights(15)(17 downto 0) <= ('0' & sum_weights(5)(16 downto 0)) + ('0' & sum_weights(6)(16 downto 0));
sum_weights(16)(17 downto 0) <= ('0' & sum_weights(7)(16 downto 0)) + ('0' & sum_weights(8)(16 downto 0));
sum_weights(17)(17 downto 0) <= ('0' & sum_weights(9)(16 downto 0)) + ('0' & sum_weights(10)(16 downto 0));
sum_weights(18)(17 downto 0) <= ('0' & sum_weights(11)(16 downto 0)) + ('0' & sum_weights(12)(16 downto 0));

sum_weights(19)(18 downto 0) <= ('0' & sum_weights(13)(17 downto 0)) + ('0' & sum_weights(14)(17 downto 0));
sum_weights(20)(18 downto 0) <= ('0' & sum_weights(15)(17 downto 0)) + ('0' & sum_weights(16)(17 downto 0));
sum_weights(21)(18 downto 0) <= ('0' & sum_weights(17)(17 downto 0)) + ('0' & sum_weights(18)(17 downto 0));
sum_weights(22)(16 downto 0) <= ('0' & each_weight(25));

sum_weights(23)(19 downto 0) <= ('0' & sum_weights(19)(18 downto 0)) + ('0' & sum_weights(20)(18 downto 0));
sum_weights(24)(19 downto 0) <= ('0' & sum_weights(21)(18 downto 0)) + ('0' & sum_weights(22)(16 downto 0));

sum_weights(25)(20 downto 0) <= ('0' & sum_weights(23)(19 downto 0)) + ('0' & sum_weights(24)(19 downto 0));

normal_weight <= sum_weights(25);



out_pixel <= 
"00000" & vi_wi(vi_wi'left downto 5) when normal_weight >= "100000000000000000000" else
"0000" & vi_wi(vi_wi'left downto 4) when normal_weight >= "010000000000000000000" else
"000" & vi_wi(vi_wi'left downto 3) when normal_weight >= "001000000000000000000" else
"00" & vi_wi(vi_wi'left downto 2) when normal_weight >= "000100000000000000000" else
"0" & vi_wi(vi_wi'left downto 1) when normal_weight >= "000010000000000000000" else
(vi_wi)       when normal_weight >= "000001000000000000000" else
(vi_wi);




process(clk_25)
begin
if clk_25'event and clk_25 = '1' then 
    if en_calc = '1' then
        en_out <= '1';
        pixel_out <= out_pixel(22 downto 15);
    else 
        en_out <= '0';
    end if;
end if;

end process;

end Behavioral;
