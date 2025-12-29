library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IIR is
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        IIRinc : in  std_logic;
        Q      : out std_logic_vector(5 downto 0)
    );
end IIR;

architecture behavioral of IIR is
    signal IIR_temp : unsigned(5 downto 0);
begin
    -- Thêm rst vào danh sách nh?y ?? reset không ??ng b?
    process(clk, rst)
    begin
        if rst = '1' then
            IIR_temp <= (others => '0'); -- Reset ngay l?p t?c không ??i xung nh?p
        elsif rising_edge(clk) then
            if IIRinc = '1' then
                if IIR_temp = 31 then
                    IIR_temp <= (others => '0');
                else
                    IIR_temp <= IIR_temp + 1;
                end if;
            end if;
        end if;
    end process;
    Q <= std_logic_vector(IIR_temp);
end behavioral;