--reg5bit
library ieee;
use ieee.std_logic_1164.all;

entity reg5bit is
	port(
		clk: in std_logic;
		D: in std_logic_vector(4 downto 0);
		en: in std_logic;
		rst: in std_logic;
		Q: out std_logic_vector(4 downto 0)
	);
end reg5bit;

architecture behav of reg5bit is
begin
	process(clk, rst) 
	begin
		if rst = '1' then 
			Q <= (others => '0');
		elsif rising_edge(clk) then 
			if en = '1' then
				Q <= D;
			end if;
		end if;
	end process;
end behav;

