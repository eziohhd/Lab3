library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_ctrl is
   port ( clk     : in  std_logic;
          reset   : in  std_logic;
          enter   : in  std_logic;
          sign    : in  std_logic;
          FN      : out std_logic_vector (3 downto 0);   -- ALU functions
          RegCtrl : out std_logic_vector (1 downto 0)   -- Register update control bits
        );
end ALU_ctrl;

architecture behavioral of ALU_ctrl is

-- SIGNAL DEFINITIONS HERE IF NEEDED
     type state_type is (s_0, s_1, s_2, s_3,s_4,s_5,s_6,s_7);
     signal current_state,next_state : state_type;
    -- signal edge_found1,edge_found2 : std_logic;
    -- signal sign_next,enter_next : std_logic;
    

begin
-- fsm------------------------------------
    alu_control_seq : process(clk,reset)
        begin
            if reset = '1' then
                current_state <= s_0;
            elsif rising_edge(clk) then
                current_state <= next_state;
            end if;
        end process;
        
    alu_control_com : process(enter,sign,current_state)
        begin
            next_state <= currrent_state;
            case current_state is
                when s_0 =>
                    RegCtrl <= "00";
                    Fn <= "0000";
                    if enter = '1' then
                        next_state <= s_1;
                    else 
                        next_state <= s_0;
                    end if;
                when s_1 =>
                    RegCtrl <= "01";
                    Fn <= "0001";
                    if enter = '1' then
                        next_state <= s_2;
                    else 
                        next_state <= s_1;
                    end if;
                when s_2 =>
                    RegCtrl <= "11";
                    Fn <= "0010";
                    if enter = '1' then
                        next_state <= s_3;
                    else 
                        next_state <= s_2;
                    end if;
                when s_3 =>                          
                    RegCtrl <= "11";                  
                    Fn <= "0011";                     
                    if enter = '1' then         
                        next_state <= s_4;            
                    elsif sign = '1' then
                        next_state <= s_6;
                    else next_state <= s_3;
                    end if;
                when s_4 =>                     
                    RegCtrl <= "11";                                            
                    Fn <= "0100";                                   
                    if enter = '1' then           
                        next_state <= s_2;              
                    elsif sign = '1' then        
                        next_state <= s_7;              
                    else next_state <= s_4;             
                    end if;                             
                when s_5 =>                        
                    RegCtrl <= "11";               
                    Fn <= "1010";                  
                    if enter = '1' then      
                        next_state <= s_6;         
                    elsif sign = '1' then   
                        next_state <= s_2;         
                    else next_state <= s_5;              
                    end if;                              
               when s_6 =>                     
                    RegCtrl <= "11";            
                    Fn <= "1011";                
                    if enter = '1' then   
                        next_state <= s_7;      
                    elsif sign = '1' then
                        next_state <= s_3;      
                    else next_state <= s_6;     
                    end if;                     
               when s_7 =>                       
                    RegCtrl <= "11";             
                    Fn <= "1100";                 
                    if enter = '1' then    
                        next_state <= s_5;       
                    elsif sign = '1' then 
                        next_state <= s_4;       
                    else next_state <= s_7;      
                    end if;                                      
               when others =>
                    next_state <= s_0;
           end case;
       end process;
--edge_detect---------------------------------------------------------
--    edge_detect : process(clk,reset)
--        begin
--            if reset = '1' then
--                edge_found1 <= '0';
--                edge_found2 <= '0';
--            elsif rising_edge(clk) then
--                sign_next <= sign;
--                enter_next <= enter;
--            end if;
--        end process;
--    edge_found1 <= '1' when ((sign = '0') and (sign_next = '1')) else '0';
--    edge_found2 <= '1' when ((enter = '0') and (enter_next = '1')) else '0';   
------------------------------------------------------------------------------                
            
   -- DEVELOPE YOUR CODE HERE

end behavioral;
