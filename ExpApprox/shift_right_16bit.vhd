-- shift_right_signed.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_right_signed is
    port(
        din  : in  signed(15 downto 0);
        sh   : in  std_logic_vector(4 downto 0);  
        dout : out signed(15 downto 0)
    );
end entity;

architecture rtl of shift_right_signed is
begin
    process(din, sh)
    begin
        dout <= shift_right(din, to_integer(unsigned(sh)));
    end process;
end rtl;


