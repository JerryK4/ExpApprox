--comparator0.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator0 is
    port(
        z   : in  std_logic_vector(15 downto 0);
        cal : out std_logic
    );
end comparator0;

architecture dataflow of comparator0 is
begin
    cal <= '1' when (signed(z) >= 0) else '0';
end dataflow;

