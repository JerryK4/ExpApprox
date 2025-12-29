library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity microprocessor is
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
end microprocessor;

architecture structural of microprocessor is
    component control_unit is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            start    : in  std_logic;
            rs       : in  std_logic;
            cal      : in  std_logic;

            x_sel    : out std_logic_vector(1 downto 0);
            y_sel    : out std_logic_vector(1 downto 0);
            z_sel    : out std_logic_vector(1 downto 0);
            i_sel    : out std_logic;
            x_en     : out std_logic;
            y_en     : out std_logic;
            z_en     : out std_logic;
            i_en     : out std_logic;

            Mre      : out std_logic;
            Mwe      : out std_logic;
            address  : out std_logic_vector(5 downto 0);
            done     : out std_logic
        );
    end component;

    component datapath is
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            x_sel   : in std_logic_vector(1 downto 0);
            y_sel   : in std_logic_vector(1 downto 0);
            z_sel   : in std_logic_vector(1 downto 0);
            i_sel   : in std_logic;
            x_en    : in std_logic;
            y_en    : in std_logic;
            z_en    : in std_logic;
            i_en    : in std_logic;
            i_in    : in std_logic_vector(4 downto 0); 
            x_in    : in std_logic_vector(15 downto 0); 
            y_in    : in std_logic_vector(15 downto 0); 
            z_in    : in std_logic_vector(15 downto 0); 
            cal     : out std_logic;
            rs      : out std_logic;
            exp_out : out std_logic_vector(15 downto 0)
        );
    end component;

    signal s_x_sel, s_y_sel, s_z_sel : std_logic_vector(1 downto 0);
    signal s_i_sel                   : std_logic;
    signal s_x_en, s_y_en, s_z_en    : std_logic;
    signal s_i_en	             : std_logic;
    signal s_rs, s_cal               : std_logic;

    -- CORDIC Constants (Q3.13)
    constant X_INIT_VAL : std_logic_vector(15 downto 0) := x"2690"; 
    constant Y_INIT_VAL : std_logic_vector(15 downto 0) := x"0000";
    constant I_START    : std_logic_vector(4 downto 0)  := "00001"; 

begin
    U_CU: control_unit
        port map (
            clk      => clk,
            rst      => rst,
            start    => start,
            rs       => s_rs,
            cal      => s_cal,

            x_sel    => s_x_sel,
            y_sel    => s_y_sel,
            z_sel    => s_z_sel,
            i_sel    => s_i_sel,
            x_en     => s_x_en,
            y_en     => s_y_en,
            z_en     => s_z_en,
            i_en     => s_i_en,

            Mre      => Mre,
            Mwe      => Mwe,
            address  => mem_addr,
            done     => done
        );

    U_DP: datapath
        port map (
            clk     => clk,
            rst     => rst,
            
            x_sel   => s_x_sel,
            y_sel   => s_y_sel,
            z_sel   => s_z_sel,
            i_sel   => s_i_sel,
            
            x_en    => s_x_en,
            y_en    => s_y_en,
            z_en    => s_z_en,
            i_en    => s_i_en,

            i_in    => I_START,
            x_in    => X_INIT_VAL,
            y_in    => Y_INIT_VAL,
            z_in    => mem_data_in, 

            cal     => s_cal,
            rs      => s_rs,
            exp_out => mem_data_out 
        );

end structural;


