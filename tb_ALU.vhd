library ieee;
use ieee.std_logic_1164.all;

entity tb_ALU is
end tb_ALU;

architecture structural of tb_ALU is

--   component ALU
--   port ( A          : in  std_logic_vector(7 downto 0);
--          B          : in  std_logic_vector(7 downto 0);
--          FN         : in  std_logic_vector(3 downto 0);
--          result     : out std_logic_vector(7 downto 0);
--          overflow   : out std_logic;
--          sign       : out std_logic
--        );
--   end component;
   
--   component ALU_ctrl
--   port (
--         clk     : in  std_logic;                                                     
--         reset   : in  std_logic;                                                     
--         enter   : in  std_logic;                                                     
--         sign    : in  std_logic;                                                     
--         FN      : out std_logic_vector (3 downto 0);   -- ALU functions              
--         RegCtrl : out std_logic_vector (1 downto 0)   -- Register update control bit
--         );
--   end component;
   component ALU_top 
   port ( clk        : in  std_logic;
          reset      : in  std_logic;
          b_Enter    : in  std_logic;
          b_Sign     : in  std_logic;
          input      : in  std_logic_vector(7 downto 0);
          seven_seg  : out std_logic_vector(6 downto 0);
          anode      : out std_logic_vector(3 downto 0)
        );
   end component;
--   signal A          : std_logic_vector(7 downto 0);
--   signal B          : std_logic_vector(7 downto 0);
   signal input      : std_logic_vector(7 downto 0);
--   signal FN         : std_logic_vector(3 downto 0);
--   signal result     : std_logic_vector(7 downto 0);
--   signal overflow   : std_logic;
   signal sign       : std_logic;
   signal enter      : std_logic;
   signal reset      : std_logic;
   signal clk        : std_logic := '0';
   signal seven_seg  : std_logic_vector(6 downto 0);
   signal anode      : std_logic_vector(3 downto 0);
--   signal RegCtrl    : std_logic_vector(1 downto 0);
   constant period   : time := 100ns;
   constant period1    : time := 10ns;
   
begin  -- structural
   clk <= not (clk) after 1*period1;
   DUT: ALU_top
   port map (
             clk        => clk,  
            reset       => reset,
            b_Enter     => enter,
            b_Sign      => sign,
            input       => input,
            seven_seg   => seven_seg,
            anode       => anode
            );
            
--    DUT2:ALU_ctrl
--    port map(
--            clk         => clk, 
--            reset       => reset,
--            enter       => enter,
--            sign        => sign,
--            FN          => FN,
--            RegCtrl     => RegCtrl
--            );
   
   -- *************************
   -- User test data pattern
   -- *************************
   
   input <= "00000101",                    -- A = 5
        "00001001" after 1 * period,   -- A = 9
        "00010001" after 2 * period,   -- A = 17
        "10010001" after 3 * period,   -- A = 145
        "10010100" after 4 * period,   -- A = 148
        "11010101" after 5 * period,   -- A = 213
        "00100011" after 6 * period,   -- A = 35
        "11110010" after 7 * period,   -- A = 242
        "00110001" after 8 * period,   -- A = 49
        "01010101" after 9 * period;   -- A = 85
  
--   B <= "00000011",                    -- B = 3
--        "00000011" after 1 * period,   -- B = 3
--        "10010001" after 2 * period,   -- B = 145
--        "01111100" after 3 * period,   -- B = 124
--        "11111001" after 4 * period,   -- B = 249
--        "01101001" after 5 * period,   -- B = 105
--        "01100011" after 6 * period,   -- B = 35
--        "01101000" after 7 * period,   -- B = 104
--        "00101101" after 8 * period,   -- B = 45
--        "00100100" after 9 * period;   -- B = 36
     
--   FN <= "0000",                              -- Pass A
--         "0001" after 1 * period,             -- Pass B
--         "0000" after 2 * period,             -- Pass A
--         "0001" after 3 * period,             -- Pass B
--         "1011" after 4 * period,             -- Pass unsigned A + B
--         "1011" after 5 * period,             -- Pass unsigned A - B  
--         "1011" after 6 * period,             -- Pass unsigned A - B
--         "1011" after 7 * period,             -- Pass unsigned A + B
--         "1011" after 8 * period,             -- Pass unsigned A - B
--         "1011" after 9 * period,             -- Pass unsigned max(A, B)
--         "1011" after 10 * period,            -- Pass signed A + B
--         "1011" after 11 * period,            -- Pass signed A - B
--         "1011" after 12 * period,            -- Pass signed max(A, B)
--         "1011" after 13 * period;            -- Invalid input command
  reset <= '1' ,
           '0' after    3*period1;
           
         
  enter <= '0',
           '1'    after 1 * period,
           '0'    after 2 * period,
           '1'    after 3 * period,
           '0'    after 4 * period,
           '1'    after 5 * period,
           '0'    after 6 * period,
           '1'    after 7 * period,
           '0'    after 8 * period,
           '1'    after 9 * period,
           '0'    after 10 * period,
           '1'    after 11 * period,
           '0'    after 12 * period,
           '1'    after 13 * period,
           '0'    after 14 * period,
           '1'    after 15 * period,
           '0'    after 16 * period,
           '1'    after 17 * period;
           
   sign <=  '0',        
            '0'    after 1 * period,
            '0'    after 2 * period,
            '0'    after 3 * period,
            '0'    after 4 * period,
            '0'    after 5 * period,
            '1'    after 6 * period,
            '0'    after 7 * period,
            '0'    after 8 * period,
            '1'    after 9 * period,
            '0'    after 10 * period,
            '0'    after 11 * period,
            '1'    after 12 * period,
            '0'    after 13 * period,
            '1'    after 14 * period;     
           
  
end structural;
