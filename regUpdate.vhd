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
    component dff 
    generic ( W : integer := 8                              
        );                                          
     port ( clk     : in  std_logic;                     
            reset   : in  std_logic;                     
            d       : in  std_logic_vector(W-1 downto 0);
            q       : out std_logic_vector(W-1 downto 0) 
     );                                             
    end component;
-- reg_update----------------------------------------------------------------------------

begin
    
    DQ1 : dff
    port map(
            clk      =>    clk,
            reset    =>    reset,
            d        =>    reg_a_n,
            q        =>    reg_a_c
            );
    DQ2 : dff
    port map(
            clk      =>    clk,
            reset    =>    reset,
            d        =>    reg_b_n,
            q        =>    reg_b_c
            );
  
    reg_a_n <= input when (RegCtrl = "00") 
                     else reg_a_c;
    reg_b_n <= input when (RegCtrl = "01")
                     else reg_b_c;  
    A <= reg_a_c;
    B <= reg_b_c;                      
--    reg_update : process(clk,input)
--    begin
--        if reset = '1' then
--            reg_a_c <= input;
--            reg_b_c <= input;
--        elsif rising_edge(clk) then
--            reg_a_c <= reg_a_n;
--            reg_b_c <= reg_b_n;
--        end if;
       
--    end process;    


   -- DEVELOPE YOUR CODE HERE

end behavioral;
