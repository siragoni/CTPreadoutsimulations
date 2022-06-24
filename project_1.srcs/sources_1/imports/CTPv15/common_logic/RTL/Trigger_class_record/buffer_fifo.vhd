----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 03:58:36 PM
-- Design Name: 
-- Module Name: buffer_fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity buffer_fifo is
  Port (
    clk_i       : in  std_logic;
    clk_en_i    : in  std_logic;
    data_i		: in  std_logic_vector(82  downto 0);
    data_o		: out std_logic_vector(82  downto 0);
    valid       : in  std_logic;
    read        : in  std_logic;
    reset       : in  std_logic
   );
end buffer_fifo;

architecture Behavioral of buffer_fifo is
    signal temp_data_s       : std_logic_vector(82 downto 0):= (others => '0');
    signal s_store_count     : std_logic_vector(8  downto 0):= (others => '0');
    signal helper_check      : std_logic := '0';

begin

    
--    process(clk_i, valid, reset)
--          variable store_count     : natural := 0;
--    begin
--        if (reset = '1') then
--          s_store_count <= (others => '0');
--          temp_data_s   <= (others => '0');
--        elsif (rising_edge(clk_i)) then
--            store_count := to_integer(unsigned(s_store_count(8 downto 0)));
--            store_count := store_count + 1;
--            if(valid = '1') then
--                temp_data_s <= data_i;
--                store_count := 0;
--                helper_check <= '0';
--            end if;
--            s_store_count <= std_logic_vector(to_unsigned(store_count,s_store_count'length));    
--        end if;
--    end process;

    
      
      
--    process(clk_i, read)
--        variable store_count_2     : natural := 0;
--    begin
--        store_count_2 := to_integer(unsigned(s_store_count(8 downto 0)));
--        if(rising_edge(clk_i)) then
--            if reset = '1' then
--                data_o <= (others => '0');
--                helper_check <= '0';
--            elsif helper_check = '1' and data_i(80) = '1' then
--                data_o <= (others => '0');    
--            elsif (helper_check = '1' and data_i(80) = '0') or read = '1' then
--                data_o <= temp_data_s;
--                helper_check <= '0';
--            elsif(store_count_2 > 6) then
--                data_o <= (others => '0');
--            end if;    
--        end if;
--    end process;




    process(clk_i, valid, reset)
          variable store_count     : natural := 0;
    begin
        if (reset = '1') then
          s_store_count <= (others => '0');
          temp_data_s   <= (others => '0');
          data_o <= (others => '0');
          helper_check <= '0';
        elsif (rising_edge(clk_i)) then
            store_count := to_integer(unsigned(s_store_count(8 downto 0)));
            store_count := store_count + 1;
            if(valid = '1') then
                temp_data_s <= data_i;
                store_count := 0;
                helper_check <= '0';
            elsif helper_check = '1' and data_i(80) = '1' then
                data_o <= (others => '0');    
            elsif (helper_check = '1' and data_i(80) = '0') or read = '1' then
                data_o <= temp_data_s;
                helper_check <= '0';
            elsif(store_count > 6) then
                data_o <= (others => '0');
            end if;
            s_store_count <= std_logic_vector(to_unsigned(store_count,s_store_count'length));    
        end if;
    end process;

    
      
      
            
    
end Behavioral;
