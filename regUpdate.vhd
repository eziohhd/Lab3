library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regUpdate is
   port ( clk        : in  std_logic;
          reset      : in  std_logic;
          RegCtrl    : in  std_logic_vector (1 downto 0);   -- Register update control from ALU controller
          input      : in  std_logic_vector (7 downto 0);   -- Switch inputs
          A          : out std_logic_vector (7 downto 0);   -- Input A
          B          : out std_logic_vector (7 downto 0)   -- Input B
        );
end regUpdate;

architecture behavioral of regUpdate is
    signal reg_a_c,reg_a_n,reg_b_c,reg_b_n : std_logic_vector (7 downto 0);
-- reg_update----------------------------------------------------------------------------

begin
    reg_update : process(clk,input)
    begin
        if reset = '1' then
            A  <= input;
            B <= input;
        elsif rising_edge(clk) then
            A <= reg_a_n;
            B <= reg_b_n;
        end if;
    end process;    
    reg_a_n <= input when (RegCtrl = "00") 
                     else A;
    reg_b_n <= input when (RegCtrl = "01")
                     else B;                     
    

   -- DEVELOPE YOUR CODE HERE

end behavioral;
