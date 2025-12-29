library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_lut_mem is
    port (
        Addr     : in  std_logic_vector(4 downto 0);
        Data_out : out std_logic_vector(15 downto 0)
    );
end entity;

architecture RTL of cordic_lut_mem is

    type rom_type is array(0 to 31) of std_logic_vector(15 downto 0);
    constant ROM : rom_type := (
        -- LUT[i] = atanh(2^-i) in Q3.13 format
        0  => x"1194",   -- atanh(1) = 1.194 (Q3.13)
        1  => x"082C",   -- atanh(1/2)
        2  => x"0405",   -- atanh(1/4)
        3  => x"0201",   -- atanh(1/8)
        4  => x"0100",
        5  => x"0080",
        6  => x"0040",
        7  => x"0020",
        8  => x"0010",
        9  => x"0008",
        10 => x"0004",
        11 => x"0002",
        12 => x"0001",
        13 => x"0001",
        14 => x"0000",
        15 => x"0000",
        others => x"0000"
    );

begin
    Data_out <= ROM(to_integer(unsigned(Addr)));

end RTL;


