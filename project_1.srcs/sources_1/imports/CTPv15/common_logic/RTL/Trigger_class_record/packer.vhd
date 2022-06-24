----------------------------------------------------------------------------------
-- PACKER for State Machine.
-- It takes the input of 68+12 bits 
-- and produces the adequate output.
-- 
-- The way the logic works is that a
-- variable is defined which contains 
-- the meaningful number of bits.
--
-- This is modified in the top file
-- so that in Run 3 only the small number
-- have to be changed...
--
-- The crux of the problem is that both 
-- the CTP readout and the IR readout
-- should handle only a N < 80 bits,
-- while the GBT link can cope with 80 bits 
-- only.
--
-- This means that the rates would not be 
-- optimal. 
--
-- Unfortunately, this becomes more serious
-- for IR as it deals with 60 bits, than 
-- with TC which has 76 bits. 
--
--
-- It also generates a validation signal so 
-- that GBT is sending data only when it is high.
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity packer is
  generic (
    bits_to_get : integer := 76
    );

  port (
   clk_i		: in  std_logic;
   clk_en_i		: in  std_logic;
   rst_i		: in  std_logic;
--   data_i 		: in  std_logic_vector((bits_to_get - 13) downto 0); -- BC_ID + 1 due to the numbering
   data_i 		: in  std_logic_vector(67  downto 0); -- BC_ID + 1 due to the numbering
   bc_count_i	: in  std_logic_vector(11  downto 0);
   trg_i        : in  std_logic_vector(119 downto 0);
--   data_o		: out std_logic_vector(79  downto 0)
   valid_flag	: out std_logic;
   data_o		: out std_logic_vector(82  downto 0)
);
end packer;

architecture Behavioral of packer is
  signal data_i_reg        : std_logic_vector(67  downto 0);
  signal temp_data_s       : std_logic_vector(299 downto 0):= (others => '0');
  signal zeroes            : std_logic_vector(299 downto 0):= (others => '0');
  signal s_store_count     : std_logic_vector(8   downto 0):= (others => '0');
  signal store_valid       : std_logic := '0';
  signal helper_orbit      : std_logic := '0';
  
  
  alias  s_HB              : std_logic is trg_i(1);
  alias  s_EOx_0           : std_logic is trg_i(8);
  alias  s_EOx_1           : std_logic is trg_i(10);

begin

data_i_reg <= data_i when rising_edge(clk_i);

process(clk_i)
      variable store_count     : natural := 0;
      variable new_store_count : natural := 0;
      variable flag            : natural := 0;
      variable write_flag      : std_logic := '0';
    begin
--      if rising_edge(clk_i) and clk_en_i = '1' then
      if rising_edge(clk_i) then
      if clk_en_i = '1' then
        store_count := to_integer(unsigned(s_store_count(8 downto 0)));
        write_flag  := or_reduce(data_i_reg);
        if( rst_i = '1' ) then
           s_store_count   <= (others => '0');
           temp_data_s     <= (others => '0');
           data_o          <= (others => '0');
           valid_flag      <= '0';
           new_store_count := 0;
           store_count     := 0;
           helper_orbit    <= '0';
           
           
-- PACKER RELEASE
        elsif( s_HB = '1' or s_EOx_0 = '1' or s_EOx_1 = '1' ) then       
               if helper_orbit = '0' then     
               data_o(82)                               <= s_EOx_1;  
               else 
               data_o(82)                               <= '0';
               end if;    
               data_o(81)                               <= s_EOx_0;  
               data_o(80)                               <= s_HB;  
               data_o(79            downto 0)           <= temp_data_s(79 downto 0);
               valid_flag      <= '1';
               s_store_count   <= (others => '0');
               temp_data_s     <= (others => '0');
               new_store_count := 0;
               store_count     := 0;
               helper_orbit    <= '1';
        
        elsif( write_flag = '0' and store_valid = '1' ) then
               valid_flag <= '0';   
               store_valid <= '0';   
               helper_orbit    <= '0';

-- ZERO SUPPRESSION
        elsif( write_flag = '1' ) then   
          helper_orbit    <= '0';
          case store_count is
	           when 0 =>
--	               temp_data_s(299 downto 76) <= (others => '0');	           
	               temp_data_s(75  downto  0) <= data_i_reg(63 downto 0) & bc_count_i;
--	               temp_data_s(299  downto  0) <= zeroes(299 downto 76) & data_i_reg(63 downto 0) & bc_count_i;
	               temp_data_s(299 downto 76) <= (others => '0');
	               store_count := 76;
	               data_o <= (others => '0');
	               valid_flag <= '0';
	               store_valid <= '0';
	           when 4 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(63 downto 0) & bc_count_i(11 downto 0) & temp_data_s(3  downto 0);
	               temp_data_s(299     downto  0)           <= (others => '0');                   
     	           store_count := 0;
 	               valid_flag <= '1';    	           
 	               store_valid <= '1';    	           
	           when 8 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(59 downto 0) & bc_count_i(11 downto 0) & temp_data_s(7  downto 0);
                   temp_data_s(3       downto  0)           <= data_i_reg(63 downto 60);
	               temp_data_s(299     downto  4)           <= (others => '0');                   
     	           store_count := 4;
 	               valid_flag <= '1';
  	               store_valid <= '1';    	           	                   	           
	           when 12 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(55 downto 0) & bc_count_i(11 downto 0) & temp_data_s(11 downto 0);
                   temp_data_s(7       downto  0)           <= data_i_reg(63 downto 56);
	               temp_data_s(299     downto  8)           <= (others => '0');                   
     	           store_count := 8;
	               valid_flag <= '1';     
 	               store_valid <= '1';    	           	               	           
	           when 16 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(51 downto 0) & bc_count_i(11 downto 0) & temp_data_s(15 downto 0);
                   temp_data_s(11      downto  0)           <= data_i_reg(63 downto 52);
	               temp_data_s(299     downto 12)           <= (others => '0');                   
     	           store_count := 12;
 	               valid_flag <= '1';  
 	               store_valid <= '1';    	            	                 	           
	           when 20 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(47 downto 0) & bc_count_i(11 downto 0) & temp_data_s(19 downto 0);
                   temp_data_s(15      downto  0)           <= data_i_reg(63 downto 48);
	               temp_data_s(299     downto 16)           <= (others => '0');                   
     	           store_count := 16;
	               valid_flag <= '1';  
 	               store_valid <= '1';    	           	               	                  	           
	           when 24 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(43 downto 0) & bc_count_i(11 downto 0) & temp_data_s(23 downto 0);
                   temp_data_s(19      downto  0)           <= data_i_reg(63 downto 44);
	               temp_data_s(299     downto 20)           <= (others => '0');                   
     	           store_count := 20;
 	               valid_flag <= '1'; 
 	               store_valid <= '1';    	            	                  	           
	           when 28 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(39 downto 0) & bc_count_i(11 downto 0) & temp_data_s(27 downto 0);
                   temp_data_s(23      downto  0)           <= data_i_reg(63 downto 40);
	               temp_data_s(299     downto 24)           <= (others => '0');                   
     	           store_count := 24;
 	               valid_flag <= '1';  
  	               store_valid <= '1';    	           	                 	           
	           when 32 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(35 downto 0) & bc_count_i(11 downto 0) & temp_data_s(31 downto 0);
                   temp_data_s(27      downto  0)           <= data_i_reg(63 downto 36);
	               temp_data_s(299     downto 28)           <= (others => '0');                   
     	           store_count := 28;
	               valid_flag <= '1';  
 	               store_valid <= '1';    	           	                  	           
	           when 36 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(31 downto 0) & bc_count_i(11 downto 0) & temp_data_s(35 downto 0);
                   temp_data_s(31      downto  0)           <= data_i_reg(63 downto 32);
	               temp_data_s(299     downto 32)           <= (others => '0');                   
     	           store_count := 32;     	           
 	               valid_flag <= '1';  
 	               store_valid <= '1';    	            	                 	           
	           when 40 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(27 downto 0) & bc_count_i(11 downto 0) & temp_data_s(39 downto 0);
                   temp_data_s(35      downto  0)           <= data_i_reg(63 downto 28);
	               temp_data_s(299     downto 36)           <= (others => '0');                   
     	           store_count := 36;
 	               valid_flag <= '1';
  	               store_valid <= '1';    	           	                	                   	           
	           when 44 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(23 downto 0) & bc_count_i(11 downto 0) & temp_data_s(43 downto 0);
                   temp_data_s(39      downto  0)           <= data_i_reg(63 downto 24);
	               temp_data_s(299     downto 40)           <= (others => '0');                   
     	           store_count := 40;
 	               valid_flag <= '1';   
  	               store_valid <= '1';    	           	                	           
	           when 48 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(19 downto 0) & bc_count_i(11 downto 0) & temp_data_s(47 downto 0);
                   temp_data_s(43      downto  0)           <= data_i_reg(63 downto 20);
	               temp_data_s(299     downto 44)           <= (others => '0');                   
     	           store_count := 44;
 	               valid_flag <= '1';  
  	               store_valid <= '1';    	           	                 	           
	           when 52 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(15 downto 0) & bc_count_i(11 downto 0) & temp_data_s(51 downto 0);
                   temp_data_s(47      downto  0)           <= data_i_reg(63 downto 16);
	               temp_data_s(299     downto 48)           <= (others => '0');                   
     	           store_count := 48;
	               valid_flag <= '1';  
 	               store_valid <= '1';    	           	                  	           
	           when 56 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(11 downto 0) & bc_count_i(11 downto 0) & temp_data_s(55 downto 0);
                   temp_data_s(51      downto  0)           <= data_i_reg(63 downto 12);
	               temp_data_s(299     downto 52)           <= (others => '0');                   
     	           store_count := 52;
	               valid_flag <= '1';    
 	               store_valid <= '1';    	           	                	           
	           when 60 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(7 downto 0) & bc_count_i(11 downto 0) & temp_data_s(59 downto 0);
                   temp_data_s(55      downto  0)           <= data_i_reg(63 downto 8);
	               temp_data_s(299     downto 56)           <= (others => '0');                   
     	           store_count := 56;
	               valid_flag <= '1';
 	               store_valid <= '1';    	           	               
	           when 64 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= data_i_reg(3 downto 0) & bc_count_i(11 downto 0) & temp_data_s(63 downto 0);
                   temp_data_s(59      downto  0)           <= data_i_reg(63 downto 4);
	               temp_data_s(299     downto 60)           <= (others => '0');                   
     	           store_count := 60;
	               valid_flag <= '1';
 	               store_valid <= '1';    	           	               
	           when 68 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= bc_count_i(11 downto 0) & temp_data_s(67 downto 0);
                   temp_data_s(63      downto  0)           <= data_i_reg(63 downto 0);
	               temp_data_s(299     downto 64)           <= (others => '0');                   
     	           store_count := 64;
	               valid_flag <= '1';
 	               store_valid <= '1';    	           	               
	           when 72 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79            downto 0)           <= bc_count_i(7 downto 0) & temp_data_s(71 downto 0);
                   temp_data_s(67      downto  0)           <= data_i_reg(63 downto 0) & bc_count_i(11 downto 8);
	               temp_data_s(299     downto 68)           <= (others => '0');                   
     	           store_count := 68;
	               valid_flag <= '1';
 	               store_valid <= '1';    	           	               
	           when 76 =>
	               data_o(82)                               <= s_EOx_1;  
                   data_o(81)                               <= s_EOx_0;  
                   data_o(80)                               <= s_HB;  
                   data_o(79           downto  0)           <= bc_count_i(3 downto 0) & temp_data_s(75 downto 0);
                   temp_data_s(71      downto  0)           <= data_i_reg(63 downto 0) & bc_count_i(11 downto 4);
	               temp_data_s(299     downto 72)           <= (others => '0');
     	           store_count := 72;
	               valid_flag <= '1';
 	               store_valid <= '1';    	           	               
	            when others =>   
                   data_o      <= (others => '0');
                   temp_data_s <= (others => '0');
                   valid_flag  <= '0';
                   store_count := 0;
                   store_valid <= '0'; 

            end case;
            s_store_count <= std_logic_vector(to_unsigned(store_count,s_store_count'length));
         
         else
               data_o     <= (others => '0');
               valid_flag <= '0';
               helper_orbit    <= '0';
            
         end if;
       end if;
    end if;        
    end process;

   
    
    
    
    
    
    
    
    
end;
