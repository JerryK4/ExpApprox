--subtractor.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
    port(
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        SUB : out std_logic_vector(15 downto 0)
    );
end subtractor;

architecture dataflow of subtractor is
begin
    SUB <= std_logic_vector(signed(A) - signed(B));
end dataflow;

