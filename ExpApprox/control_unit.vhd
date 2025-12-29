library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
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
end control_unit;

architecture structural of control_unit is
    component controller is
        port (
            start, rst, clk, rs, cal : in std_logic;
            x_sel, y_sel, z_sel : out std_logic_vector(1 downto 0);
            i_sel, x_en, y_en, z_en, i_en : out std_logic;
            Mre, Mwe, addr_sel, IIRinc, OIRinc : out std_logic;
            done : out std_logic
        );
    end component;

    component IIR is
        port(
            clk, rst, IIRinc : in std_logic;
            Q : out std_logic_vector(5 downto 0)
        );
    end component;

    component OIR is
        port(
            clk, rst, OIRinc : in std_logic;
            Q : out std_logic_vector(5 downto 0)
        );
    end component;

    component muxAddress is
        port(
            sel : in std_logic;
            I0, I1 : in std_logic_vector(5 downto 0);
            O : out std_logic_vector(5 downto 0)
        );
    end component;

    signal s_addr_sel : std_logic;
    signal s_IIRinc   : std_logic;
    signal s_OIRinc   : std_logic;
    signal s_IIR_out  : std_logic_vector(5 downto 0);
    signal s_OIR_out  : std_logic_vector(5 downto 0);

begin
    U_CTRL: controller
        port map (
            clk      => clk,
            rst      => rst,
            start    => start,
            rs       => rs,
            cal      => cal,
            x_sel    => x_sel,
            y_sel    => y_sel,
            z_sel    => z_sel,
            i_sel    => i_sel,
            x_en     => x_en,
            y_en     => y_en,
            z_en     => z_en,
            i_en     => i_en,
            Mre      => Mre,
            Mwe      => Mwe,
            addr_sel => s_addr_sel,
            IIRinc   => s_IIRinc,
            OIRinc   => s_OIRinc,
            done     => done
        );

    U_IIR: IIR
        port map (
            clk    => clk,
            rst    => rst,
            IIRinc => s_IIRinc,
            Q      => s_IIR_out
        );

    U_OIR: OIR
        port map (
            clk    => clk,
            rst    => rst,
            OIRinc => s_OIRinc,
            Q      => s_OIR_out
        );

    U_MUX_ADDR: muxAddress
        port map (
            sel => s_addr_sel,
            I0  => s_IIR_out,
            I1  => s_OIR_out,
            O   => address
        );

end structural;

