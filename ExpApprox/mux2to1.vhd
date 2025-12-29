--mux2to1
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	port(
		sel: in std_logic;
		I0: in std_logic_vector(4 downto 0);
		I1: in std_logic_vector(4 downto 0);
		O: out std_logic_vector(4 downto 0)
	);
end mux2to1;

architecture dataflow of mux2to1 is
begin
	O <= I1 when sel = '1' else I0;
end dataflow;

