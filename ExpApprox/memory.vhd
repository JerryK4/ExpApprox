library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        Mre      : in  std_logic; -- ??c
        Mwe      : in  std_logic; -- Ghi
        address  : in  std_logic_vector(5 downto 0);
        data_in  : in  std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity;

architecture behav of memory is
    type mem_type is array (0 to 63) of std_logic_vector(15 downto 0);
    signal tmp_mem : mem_type;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Vùng ??a ch? 0-18: D? li?u ??u vào (Z_init)
                tmp_mem(0)  <= x"8000"; -- -4.00
                tmp_mem(1)  <= x"9000"; -- -3.50
                tmp_mem(2)  <= x"A000"; -- -3.00
                tmp_mem(3)  <= x"B000"; -- -2.50
                tmp_mem(4)  <= x"C000"; -- -2.00
                tmp_mem(5)  <= x"D000"; -- -1.50
                tmp_mem(6)  <= x"E000"; -- -1.00
                tmp_mem(7)  <= x"E800"; -- -0.75
                tmp_mem(8)  <= x"F000"; -- -0.50
                tmp_mem(9)  <= x"F800"; -- -0.25
                tmp_mem(10) <= x"0000"; --  0.00
                tmp_mem(11) <= x"0800"; -- +0.25
                tmp_mem(12) <= x"1000"; -- +0.50
                tmp_mem(13) <= x"1800"; -- +0.75
                tmp_mem(14) <= x"2000"; -- +1.00
                tmp_mem(15) <= x"2400"; -- +1.125
                tmp_mem(16) <= x"2800"; -- +1.250
                tmp_mem(17) <= x"2B33"; -- +1.350
                tmp_mem(18) <= x"2C28"; -- +1.380
                -- Các ô còn l?i m?c ??nh là 0
                for i in 19 to 63 loop
                    tmp_mem(i) <= (others => '0');
                end loop;
            else
                -- Ghi vào b? nh?
                if Mwe = '1' then
                    tmp_mem(to_integer(unsigned(address))) <= data_in;
                end if;
                
                -- ??c t? b? nh?
                if Mre = '1' then
                    data_out <= tmp_mem(to_integer(unsigned(address)));
                else
                    data_out <= (others => 'Z'); 
                end if;
            end if;
        end if;
    end process;
end behav;
