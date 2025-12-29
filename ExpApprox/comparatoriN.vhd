--comparatoriN.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparatoriN is
    port(
        i  : in  std_logic_vector(4 downto 0);
        N  : in  std_logic_vector(4 downto 0);
        rs : out std_logic
    );
end comparatoriN;

architecture dataflow of comparatoriN is
begin
    rs <= '1' when unsigned(i) <= unsigned(N) else '0';
end dataflow;

