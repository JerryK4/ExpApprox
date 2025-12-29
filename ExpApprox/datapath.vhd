library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
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
end datapath;

architecture structural of datapath is
component cordic_lut_mem is
    port (
        Addr     : in  std_logic_vector(4 downto 0);
        Data_out : out std_logic_vector(15 downto 0)
    );
end component;

component reg16bit is
    port(
        clk : in std_logic;
        D   : in std_logic_vector(15 downto 0);
        en  : in std_logic;
        rst : in std_logic;
        Q   : out std_logic_vector(15 downto 0)
    );
end component;

component reg5bit is
    port(
        clk : in std_logic;
        D   : in std_logic_vector(4 downto 0);
        en  : in std_logic;
        rst : in std_logic;
        Q   : out std_logic_vector(4 downto 0)
    );
end component;

component mux3to1 is
    port(
        sel : in std_logic_vector(1 downto 0);       
        I0  : in std_logic_vector(15 downto 0);
        I1  : in std_logic_vector(15 downto 0);
        I2  : in std_logic_vector(15 downto 0);
        O   : out std_logic_vector(15 downto 0)
    );
end component;

component mux2to1 is
    port(
        sel : in std_logic;
        I0  : in std_logic_vector(4 downto 0);
        I1  : in std_logic_vector(4 downto 0);
        O   : out std_logic_vector(4 downto 0)
    );
end component;

component shift_right_signed is
    port(
        din  : in  signed(15 downto 0);
        sh   : in  std_logic_vector(4 downto 0);  
        dout : out signed(15 downto 0)
    );
end component;

component comparatoriN is
    port(
        i  : in  std_logic_vector(4 downto 0);
        N  : in  std_logic_vector(4 downto 0);
        rs : out std_logic
    );
end component;

component comparator0 is
    port(
        z   : in  std_logic_vector(15 downto 0);
        cal : out std_logic
    );
end component;

component inc1 is
    port (
        input  : in std_logic_vector(4 downto 0);
        output : out std_logic_vector(4 downto 0)
    );
end component;

component i_address is
    port(
        i_in   : in  std_logic_vector(4 downto 0);
        addr_out : out std_logic_vector(4 downto 0)
    );
end component;

component adder is
    port(
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        SUM : out std_logic_vector(15 downto 0)
    );
end component;

component subtractor is
    port(
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        SUB : out std_logic_vector(15 downto 0)
    );
end component;


signal x_out_mux, y_out_mux, z_out_mux : std_logic_vector(15 downto 0);
signal i_out_mux : std_logic_vector(4 downto 0);
signal x_out, y_out, z_out : std_logic_vector(15 downto 0);
signal i_out : std_logic_vector(4 downto 0);
signal x_shift_s, y_shift_s : signed(15 downto 0);
signal x1, y1, z1 : std_logic_vector(15 downto 0);
signal x2, y2, z2 : std_logic_vector(15 downto 0);
signal i_inc : std_logic_vector(4 downto 0);
signal lut_addr_signal : std_logic_vector(4 downto 0);
signal s_lut_data : std_logic_vector(15 downto 0); -- Tín hi?u ch?a atanh(2^-i)

begin
U_LUT: cordic_lut_mem
    port map(
        Addr     => lut_addr_signal,
        Data_out => s_lut_data
    );

MUX_X: mux3to1 port map(sel => x_sel, I0 => x_in, I1 => x1, I2 => x2, O => x_out_mux);
MUX_Y: mux3to1 port map(sel => y_sel, I0 => y_in, I1 => y1, I2 => y2, O => y_out_mux);
MUX_Z: mux3to1 port map(sel => z_sel, I0 => z_in, I1 => z1, I2 => z2, O => z_out_mux);
MUX_I: mux2to1 port map(sel => i_sel, I0 => i_in, I1 => i_inc, O => i_out_mux);

REG_X: reg16bit port map(clk => clk, D => x_out_mux, en => x_en, rst => rst, Q => x_out);
REG_Y: reg16bit port map(clk => clk, D => y_out_mux, en => y_en, rst => rst, Q => y_out);
REG_Z: reg16bit port map(clk => clk, D => z_out_mux, en => z_en, rst => rst, Q => z_out);
REG_I: reg5bit   port map(clk => clk, D => i_out_mux, en => i_en, rst => rst, Q => i_out);

INC_I: inc1 port map(input => i_out, output => i_inc);

CALC_I_ADDR: i_address 
    port map(i_in => i_out, addr_out => lut_addr_signal);

SHIFT_X: shift_right_signed port map(din => signed(x_out), sh => i_out, dout => x_shift_s);
SHIFT_Y: shift_right_signed port map(din => signed(y_out), sh => i_out, dout => y_shift_s);

COMPARE_Z: comparator0 port map(z => z_out, cal => cal);
COMPARE_I: comparatoriN port map(i => i_out, N => "01111", rs => rs);

-- X1 = X + (Y >> i), Y1 = Y + (X >> i)
ADD_OUT_X1: adder port map(A => x_out, B => std_logic_vector(y_shift_s), SUM => x1);
ADD_OUT_Y1: adder port map(A => y_out, B => std_logic_vector(x_shift_s), SUM => y1);

-- X2 = X - (Y >> i), Y2 = Y - (X >> i)
SUB_OUT_X2: subtractor port map(A => x_out, B => std_logic_vector(y_shift_s), SUB => x2);
SUB_OUT_Y2: subtractor port map(A => y_out, B => std_logic_vector(x_shift_s), SUB => y2);

-- Z1 = Z - LUT(i), Z2 = Z + LUT(i-1)
SUB_OUT_Z1: subtractor port map(A => z_out, B => s_lut_data, SUB => z1);
ADD_OUT_Z2: adder      port map(A => z_out, B => s_lut_data, SUM => z2);

-- Final result calculation
ADD_DONE: adder
    port map(A => x_out, B => y_out, SUM => exp_out);

end structural;
