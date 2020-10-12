library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_driver is
   port ( clk           : in  std_logic;
          rst           : in  std_logic;
          BCD_digit     : in  std_logic_vector(9 downto 0);          
          sign_re          : in  std_logic;
          overflow      : in  std_logic;
          DIGIT_ANODE   : out std_logic_vector(3 downto 0);
          SEGMENT       : out std_logic_vector(6 downto 0)
        );
end seven_seg_driver;

architecture behavioral of seven_seg_driver is

    type state_type_1 is (s_1, s_2, s_3, s_4);    
    --signal
    signal current_state_1, next_state_1 : state_type_1;
    signal counter_out, counter_out_next : unsigned(17 downto 0);
    signal counter_en: std_logic;        
    signal unit, ten, hun, thousand : std_logic_vector(6 downto 0); 
     
begin
-------------------------------------------------------------------------------------------------
    counter: process(clk, rst)   --this counter is used to control the 7 seg;
    begin
        if rst = '1' then
            counter_out <= (others => '0');        
        elsif rising_edge(clk) then
            counter_out <= counter_out_next;
        end if;   
    end process;
    
    counter_out_next <= counter_out + 1 ;
    
    counter_en <= '1' when counter_out = "111111111111111111" else '0';    
-------------------------------------------------------------------------------------------------
    seg_FSM: process(clk, rst)
    begin      
        if rst = '1' then
            current_state_1 <= s_1;
        elsif rising_edge(clk) then 
            current_state_1 <= next_state_1;
        end if;         
    end process;

    seg_FSM_comb: process(counter_en, current_state_1)
    begin
        next_state_1 <= current_state_1;        
        case current_state_1 is
        
        when s_1 =>
            if counter_en = '1' then
                next_state_1 <= s_2;  
            else
                next_state_1 <= s_1;
            end if;                   
            DIGIT_ANODE <= "1110";
            SEGMENT <= unit;
        
        when s_2 =>
            if counter_en = '1' then
                next_state_1 <= s_3;  
            else
                next_state_1 <= s_2;
            end if;                   
            DIGIT_ANODE <= "1101";
            SEGMENT <= ten;
        
        when s_3 =>
            if counter_en = '1' then
                next_state_1 <= s_4;  
            else
                next_state_1 <= s_3;
            end if;                   
            DIGIT_ANODE <= "1011";
            SEGMENT <= hun;
        
        when s_4 =>
            if counter_en = '1' then
                next_state_1 <= s_1;  
            else
                next_state_1 <= s_4;
            end if;                   
            DIGIT_ANODE <= "0111";
            SEGMENT <= thousand;
        
        when others =>
           DIGIT_ANODE <= "1111";
           SEGMENT <= (others => '0');
            
    end case;   
end process; 
-------------------------------------------------------------------------------------------------     
    BCD_to_display: process(BCD_digit)
    begin
        case BCD_digit(3 downto 0) is
          when "0000" => unit <= "1000000";  --0
          when "0001" => unit <= "1111001";  --1
          when "0010" => unit <= "0100100";  --2   
          when "0011" => unit <= "0110000";  --3
          when "0100" => unit <= "0011001";  --4 
          when "0101" => unit <= "0010010";  --5 
          when "0110" => unit <= "0000010";  --6 
          when "0111" => unit <= "1111000";  --7 
          when "1000" => unit <= "0000000";  --8
          when "1001" => unit <= "0010000";  --9   
          when others => unit <= "1111111";  
        end case;
    end process;
    
    process(BCD_digit)
    begin
        case BCD_digit(7 downto 4) is
          when "0000" => ten <= "1000000";  --0
          when "0001" => ten <= "1111001";  --1
          when "0010" => ten <= "0100100";  --2   
          when "0011" => ten <= "0110000";  --3
          when "0100" => ten <= "0011001";  --4 
          when "0101" => ten <= "0010010";  --5 
          when "0110" => ten <= "0000010";  --6 
          when "0111" => ten <= "1111000";  --7 
          when "1000" => ten <= "0000000";  --8
          when "1001" => ten <= "0010000";  --9   
          when others => ten <= "1111111";  
        end case;
    end process; 
    
    process(BCD_digit)
    begin
        case BCD_digit(9 downto 8) is
          when "00" => hun <= "1000000";  --0
          when "01" => hun <= "1111001";  --1
          when "10" => hun <= "0100100";  --2   
          when others => hun <= "1111111";  
        end case;                  
    end process; 
-------------------------------------------------------------------------------------------------
  
    process(sign_re,overflow)
    begin
       
        if overflow = '1' then
            thousand <= "0001110";
        elsif sign_re = '1' then
            thousand <= "0111111";
        else
            thousand <= "1111111";
        end if;    
    end process;
    
  
    
      
   
-------------------------------------------------------------------------------------------------    
    
end behavioral;
