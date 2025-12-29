library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OIR is
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        OIRinc : in  std_logic;
        Q      : out std_logic_vector(5 downto 0)
    );
end OIR;

architecture behavioral of OIR is
    constant OFFSET : unsigned(5 downto 0) := "100000"; -- Giá tr? 32
    signal OIR_temp : unsigned(5 downto 0);
begin
    -- Thêm rst vào danh sách nh?y ?? reset không ??ng b?
    process(clk, rst)
    begin
        if rst = '1' then
            OIR_temp <= OFFSET; -- Reset ngay l?p t?c không ??i xung nh?p
        elsif rising_edge(clk) then
            if OIRinc = '1' then
                if OIR_temp = 63 then
                    OIR_temp <= "100000";
                else
                    OIR_temp <= OIR_temp + 1;
                end if;
            end if;
        end if;
    end process;
    Q <= std_logic_vector(OIR_temp);
end behavioral;
