library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_system_top_tb is
end entity;

architecture sim of cordic_system_top_tb is

    -- 1. Khai báo Component Top Level
    component cordic_system_top is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            start   : in  std_logic;
            done    : out std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal start : std_logic := '0';
    signal done  : std_logic;

    constant CLK_PERIOD : time := 10 ns; 

begin
    DUT: cordic_system_top
        port map (
            clk   => clk,
            rst   => rst,
            start => start,
            done  => done
        );
    clk_process : process
    begin
        while now < 10000 ns loop 
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stimulus_process : process
    begin
        report "Starting Simulation...";
        start <= '0';
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 20 ns;

        for i in 0 to 18 loop
            report "Processing sample index: " & integer'image(i);

            wait until rising_edge(clk);
            start <= '1';

            wait until done = '1';
            start <= '0';
            wait for 2 * CLK_PERIOD;
            
            report "Sample " & integer'image(i) & " completed.";
        end loop;

        report "SUCCESS: All samples have been processed and stored in RAM.";
        
        wait for 100 ns;
        assert false report "End of Simulation" severity failure;
        wait;
    end process;
end sim;
