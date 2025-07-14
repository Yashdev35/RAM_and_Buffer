----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2025 06:55:28 PM
-- Design Name: 
-- Module Name: register_file - arch
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

--*******************************************
-- Register file 32 bit register with 4bytes 
--*******************************************
entity reg_file_4by8 is
port(
clk, rst : in std_logic;
wr_en : in std_logic;
wr_addr, rd_addr : in std_logic_vector(1 downto 0);
wr_data : in std_logic_vector(7 downto 0);
rd_data : out std_logic_vector(7 downto 0)
);
end reg_file_4by8;
architecture arch of reg_file_4by8 is
type std_logic_2D is array (0 to 3) of std_logic_vector(7 downto 0);
signal regs : std_logic_2D;
signal wr_gate : std_logic_vector(3 downto 0);
begin

--decoding logic wr_data
sync_reg : process(clk, rst)
begin 
    if(rst = '1') then 
          regs(0) <= (others => '0');
          regs(1) <= (others => '0');
          regs(2) <= (others => '0');
          regs(3) <= (others => '0');
    elsif(rising_edge(clk)) then   
          if (wr_gate(0) = '1') then 
                  regs(0) <= wr_data;
          end if;
          if (wr_gate(1) = '1') then 
                  regs(1) <= wr_data;
          end if;
          if (wr_gate(2) = '1') then 
                  regs(2) <= wr_data;
          end if;
          if (wr_gate(3) = '1') then 
                  regs(3) <= wr_data;
          end if;
    end if;
end process sync_reg;

-- decoding wr_addr
decode_wr_addr : process(wr_addr, wr_en) 
begin
        if(wr_en = '0') then 
                wr_gate <= (others => '0');
        else 
             case wr_addr is 
                     when "00" => 
                            wr_gate <= (0 =>'1', others => '0');
                     when "01" => 
                            wr_gate <= (1 =>'1', others => '0');
                     when "10" => 
                            wr_gate <= (2 =>'1', others => '0');
                     when others => 
                            wr_gate <= (3 =>'1', others => '0');
             end case;
        end if;
end process decode_wr_addr;
          
-- read data decoding  
with rd_addr select rd_data <= 
       regs(0) when "00",
       regs(1) when "01",
       regs(2) when "10",
       regs(3) when others;

end arch;
