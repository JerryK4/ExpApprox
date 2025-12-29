library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity inc1 is
	port (
	input: in std_logic_vector (4 downto 0);
	output: out std_logic_vector (4 downto 0)
	);
end inc1;
architecture dataflow of inc1 is
begin
	output <= input + 1;
end dataflow;
	


