library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_system_top is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        start   : in  std_logic; 
        done    : out std_logic  
    );
end entity;

architecture structural of cordic_system_top is
    component microprocessor is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            mem_data_in : in  std_logic_vector(15 downto 0);
            mem_addr    : out std_logic_vector(5 downto 0);
            mem_data_out: out std_logic_vector(15 downto 0);
            Mre         : out std_logic;
            Mwe         : out std_logic;
            done        : out std_logic
        );
    end component;

    component memory is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            Mre      : in  std_logic;
            Mwe      : in  std_logic;
            address  : in  std_logic_vector(5 downto 0);
            data_in  : in  std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0)
        );
    end component;

    signal s_mem_addr     : std_logic_vector(5 downto 0);
    signal s_data_p_to_m  : std_logic_vector(15 downto 0); 
    signal s_data_m_to_p  : std_logic_vector(15 downto 0); 
    signal s_mre, s_mwe   : std_logic;

begin


    U_PROCESSOR: microprocessor
        port map (
            clk          => clk,
            rst          => rst,
            start        => start,
            
            -- K?t n?i bus d? li?u và ??a ch?
            mem_data_in  => s_data_m_to_p, 
            mem_addr     => s_mem_addr,    
            mem_data_out => s_data_p_to_m, 
            
            -- K?t n?i tín hi?u ?i?u khi?n RAM
            Mre          => s_mre,
            Mwe          => s_mwe,
            
            done         => done
        );


    U_MEMORY: memory
        port map (
            clk      => clk,
            rst      => rst,
            
            Mre      => s_mre,
            Mwe      => s_mwe,
            address  => s_mem_addr,
            data_in  => s_data_p_to_m,
            data_out => s_data_m_to_p
        );

end structural;

