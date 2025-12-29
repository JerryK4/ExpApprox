library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port (
        start  : in  std_logic;
        rst    : in  std_logic;
        clk    : in  std_logic;
        rs     : in  std_logic;
        cal    : in  std_logic;

        x_sel  : out std_logic_vector(1 downto 0);
        y_sel  : out std_logic_vector(1 downto 0);
        z_sel  : out std_logic_vector(1 downto 0);
        i_sel  : out std_logic;

        x_en   : out std_logic;
        y_en   : out std_logic;
        z_en   : out std_logic;
        i_en   : out std_logic;

        Mre    : out std_logic; 
        Mwe    : out std_logic; 
        addr_sel: out std_logic; 
        IIRinc : out std_logic;
        OIRinc : out std_logic;

        done   : out std_logic
    );
end controller;

architecture fsm of controller is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
    signal state : state_type;
begin
    -- STATE REGISTER
    process(clk, rst)
    begin
        if rst = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            case state is
                when S0 =>
                    state <= S1;


                when S1 =>
                    if start = '1' then
                        state <= S2;
                    else
                        state <= S1;
                    end if;
		
		when S2 =>
		    state <= S3;
		
                when S3 =>
                    state <= S4;

                when S4 =>
                    if rs = '1' then
                        state <= S5;
                    else
                        state <= S8;
                    end if;

                when S5 =>
                    if cal = '1' then
                        state <= S6;
                    else
                        state <= S7;
                    end if;

                when S6 =>
                    state <= S4;

                when S7 =>
                    state <= S4;

                when S8 =>
                    state <= S9;

		when S9 =>
			if start = '0' then
                        	state <= S0;
                    	else
                        	state <= S9;
                    	end if;

                when others =>
                    state <= S0;
            end case;
        end if;
    end process;

    -- SELECT SIGNALS
    x_sel <= "00" when state = S3 else
             "01" when state = S6 else
             "10" when state = S7 else        -- Z<0  update
             "00";

    y_sel <= "00" when state = S3 else
             "01" when state = S6 else
             "10" when state = S7 else        -- Z<0  update
             "00";

    z_sel <= "00" when state = S3 else
             "01" when state = S6 else
             "10" when state = S7 else        -- Z<0  update
             "00";

    i_sel <= '0' when state = S3 else '1' when state = S6 or state = S7;

    -- ENABLE SIGNALS
    x_en <= '1' when state = S3 or state = S6 or state = S7 else '0';
    y_en <= '1' when state = S3 or state = S6 or state = S7 else '0';
    z_en <= '1' when state = S3 or state = S6 or state = S7 else '0';
    i_en <= '1' when state = S3 or state = S6 or state = S7 else '0';

    -- MEMORY SIGNALS
    Mre <= '1' when state = S2  else '0';
    
    addr_sel <= '1' when state = S8 else '0';
    
    IIRinc <= '1' when state = S3 else '0';
    
    Mwe <= '1' when state = S8 else '0';
    
    OIRinc <= '1' when state = S8 else '0';
				 
    -- DONE SIGNAL
    done   <= '1' when state = S8 else '0';
end fsm;

