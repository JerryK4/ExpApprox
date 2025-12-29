library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i_address is
    port(
        i_in   : in  std_logic_vector(4 downto 0);   
        addr_out : out std_logic_vector(4 downto 0) 
    );
end i_address;

architecture rtl of i_address is
begin
    addr_out <= std_logic_vector(unsigned(i_in) - 1);
end rtl;

