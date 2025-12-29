-- mux3to1.vhd
library ieee;
use ieee.std_logic_1164.all;

entity mux3to1 is
    generic(
        WIDTH : integer := 16          
    );
    port(
        sel : in std_logic_vector(1 downto 0);       
        I0  : in std_logic_vector(WIDTH-1 downto 0);
        I1  : in std_logic_vector(WIDTH-1 downto 0);
        I2  : in std_logic_vector(WIDTH-1 downto 0);
        O   : out std_logic_vector(WIDTH-1 downto 0)
    );
end mux3to1;

architecture dataflow of mux3to1 is
begin
    with sel select
        O <= I0 when "00",
             I1 when "01",
             I2 when "10",
             (others => '0') when others;   
end dataflow;

