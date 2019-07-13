
---------------------------------------------------------------------------------- 
-- Create Date: 11.06.2019 13:50:32
-- Module Name: filter_operate - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;                                                                                                                                                                                          
                                                                                                                       
entity sort is                                                                                                         
            port(
            term0:in std_logic_vector(7 downto 0);                                                                   
            term1:in std_logic_vector(7 downto 0);                                                              
            term2:in std_logic_vector(7 downto 0);                                                                
            term3:in std_logic_vector(7 downto 0);                                                              
            term4:in std_logic_vector(7 downto 0);                                                               
            term5:in std_logic_vector(7 downto 0);                                                            
            term6:in std_logic_vector(7 downto 0);
            term7:in std_logic_vector(7 downto 0);
            term8:in std_logic_vector(7 downto 0);
            outp:out std_logic_vector(7 downto 0)
            );
end sort;

architecture algo_sort of sort is
      type arr is array(0 to 8) of std_logic_vector(7 downto 0);
      signal arr2  : arr := (others => "00000000");
      --source : stack_overflow 
      --( others => '0') is an expression, an aggregate of elements into a composite type.
      --The expression (others=>'O') means that all elements are assigned to '0'.
      --If array is of  8 bit then it will assign 00000000 to array. 
      --If array is two dimensional then the same thing will be (others =>(others =>'0')).
      
      
      begin
        arr2(0) <= term0;
        arr2(1) <= term1;
        arr2(2) <= term2;
        arr2(3) <= term3;
        arr2(4) <= term4;
        arr2(5) <= term5;
        arr2(6) <= term6;
        arr2(7) <= term7;
        arr2(8) <= term8;
        
        process(arr2)
            variable temp : std_logic_vector(7 downto 0) ;
            variable arr1  : arr := (others => "00000000");
            --assignment can only be done inside begin not here
            begin                            
                arr1:=arr2;
                loop1 : for i in 0 to 8 loop
                    loop2: for j in 0 to 7 loop
                                if(std_logic_vector(arr1(j+1))>std_logic_vector(arr1(j))) then
                                         temp :=std_logic_vector(arr1(j));
                                         arr1(j):=arr1(j+1);
                                         arr1(j+1):=temp;
                                end if;
                    end loop loop2;
                end loop loop1;
            outp<=arr1(4);
        end process;
end algo_sort;                              
            
        
        
        
        
        
        
        
        
            
            