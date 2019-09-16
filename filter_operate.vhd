---------------------------------------------------------------------------------- 
-- Create Date: 11.06.2019 13:50:32
-- Module Name: read_input_image - Behavioral
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package arr is
 
            constant addr_width : integer :=4;  --addresss_size
            constant data_width : integer :=8;  --data_size
            constant image_size : integer :=15; --image_size
            constant image_file_name : string :="data.mif"; --file_name
            type output_arr is array(0 to image_size) of std_logic_vector(data_width-1 downto 0); --output
end package arr;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.arr.all;
use std.textio.all;

entity read_image_vhdl is
       port(
            clock:in std_logic;                                                                   
            data:in std_logic_vector((data_width-1) downto 0);                                                              
            read_addr:in std_logic_vector((addr_width-1) downto 0);                                                                
            write_addr:in std_logic_vector((addr_width-1) downto 0);                                                              
            we:in std_logic;                                                               
            re:in std_logic;  
            outp: out output_arr
            );
     
end read_image_vhdl;

architecture Behavioral of read_image_vhdl is
        
          
        begin
        process
            file my_file : text is in "data.mif";
            variable my_line : line;
            variable temp : bit_vector((data_width-1) downto 0);
            variable i : std_logic_vector((addr_width-1) downto 0);
            begin
                for i in outp'range loop
                readline(my_file,my_line);
                read(my_line,temp);
                outp(i) <= to_stdlogicvector(temp);
            end loop;
            wait;
        end process;
       
        signal read_address_reg :std_logic_vector((addr_width) downto 0) := (others =>'0');
        begin
        process(clock)
        begin
            if(rising_edge(clock)) then
                if(we='1') then
                       ram_block(to_integer(unsigned(write_addr))) <= data;
                end if;
                if(re='1') then 
                        outp<=ram_block(to_integer(unsigned(read_addr)));
                end if;
            end if;                    
        end process;               
end Behavioral;

