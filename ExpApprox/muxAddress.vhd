library ieee;
use ieee.std_logic_1164.all;

entity muxAddress is
    port(
        sel : in  std_logic;
        I0  : in  std_logic_vector(5 downto 0);
        I1  : in  std_logic_vector(5 downto 0);
        O   : out std_logic_vector(5 downto 0)
    );
end muxAddress;

architecture behavioral of muxAddress is
begin
    O <= I0 when sel = '0' else I1;
end behavioral;
