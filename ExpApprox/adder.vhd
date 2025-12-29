--adder.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port(
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        SUM : out std_logic_vector(15 downto 0)
    );
end adder;

architecture dataflow of adder is
begin
    SUM <= std_logic_vector(signed(A) + signed(B));
end dataflow;

