library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_misc.all;


entity prsg_tcr is
  port (
    clk_i     : in std_logic;
	clk_en_i  : in std_logic;
    rst_i	  : in std_logic;
    rand_no_o : out std_logic_vector (47 downto 0);  --output vector
    threshold : in std_logic_vector (31 downto 0)   --programmable threshold
);
end prsg_tcr;

architecture Behavioral of prsg_tcr is
    signal rand_temp2 : std_logic_vector(47 downto 0):=(others => '0');


begin 
  process(clk_i)
--    variable rand_temp : std_logic_vector(47 downto 0):=(47 => '1',others => '0');
    variable rand_temp : std_logic_vector(47 downto 0):=(20 => '1',others => '0');
    variable temp : std_logic := '0';
    variable counter : natural := 0;
    variable threshold_value : natural := 0;
    variable output_value : natural := 0;
  begin
    if(rising_edge(clk_i)) then
      if rst_i = '1' then
--	       rand_temp := (47 => '1',others => '0');
	       rand_temp := (20 => '1',others => '0');
	       rand_no_o <= (others => '0');
      else
	       if clk_en_i = '1' and counter >= 0 then
--	       if clk_en_i = '1'  then
--                temp := rand_temp(47) xor rand_temp(46);
                temp := rand_temp(20) xor rand_temp(19);
--                rand_temp(47 downto 1) := rand_temp(46 downto 0);
                rand_temp(20 downto 1) := rand_temp(19 downto 0);
                rand_temp(0) := temp;
                threshold_value := to_integer(unsigned(threshold(20 downto 0)));
                output_value    := to_integer(unsigned(rand_temp2(20 downto 0)));
                if ( output_value > threshold_value ) then  
                    rand_no_o <= rand_temp;
                else 
                    rand_no_o <= (others => '0');
                end if;             
	            counter := 0;
	            rand_temp2 <= rand_temp;
	       end if;
	       counter := counter + 1;
       end if;
    end if;
  end process;

end;
