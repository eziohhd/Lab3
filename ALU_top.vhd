library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_components_pack.all;

entity ALU_top is
   port ( clk        : in  std_logic;
          reset      : in  std_logic;
          b_Enter    : in  std_logic;
          b_Sign     : in  std_logic;
          input      : in  std_logic_vector(7 downto 0);
          seven_seg  : out std_logic_vector(6 downto 0);
          anode      : out std_logic_vector(3 downto 0)
        );
end ALU_top;

architecture structural of ALU_top is
    component ALU_ctrl
    port ( clk     : in  std_logic;
          reset   : in  std_logic;
          enter   : in  std_logic;
          sign    : in  std_logic;
          FN      : out std_logic_vector (3 downto 0);   -- ALU functions
          RegCtrl : out std_logic_vector (1 downto 0)   -- Register update control bits
         );
    end component;

    component ALU                                                
    port ( A          : in  std_logic_vector (7 downto 0);   
           B          : in  std_logic_vector (7 downto 0);   
           FN         : in  std_logic_vector (3 downto 0);   
           result 	  : out std_logic_vector (7 downto 0);   
	       overflow   : out std_logic;                       --
	       sign_re       : out std_logic                       -- 
        );                                                  
    end component;     
      
    component regUpdate                                        
    port (clk        : in  std_logic;                     
          reset      : in  std_logic;                     
          RegCtrl    : in  std_logic_vector (1 downto 0); 
          input      : in  std_logic_vector (7 downto 0); 
          A          : out std_logic_vector (7 downto 0); 
          B          : out std_logic_vector (7 downto 0)  
        );                                                
    end component;                                            
    
    component binary2BCD 
    port (binary_in : in  std_logic_vector(7 downto 0);
          BCD_out   : out std_logic_vector(9 downto 0)        
        );
    end component;     
    
    component seven_seg_driver 
    port (clk           : in  std_logic;
          rst           : in  std_logic;
          BCD_digit     : in  std_logic_vector(9 downto 0);          
          sign_re          : in  std_logic;
          overflow      : in  std_logic;
          DIGIT_ANODE   : out std_logic_vector(3 downto 0);
          SEGMENT       : out std_logic_vector(6 downto 0)
        );
    end component;
                                        
                          
   -- SIGNAL DEFINITIONS
   signal Enter      : std_logic;
   signal FN         : std_logic_vector (3 downto 0);
   signal sign       : std_logic;
   signal sign_re       : std_logic;
   signal RegCtrl    : std_logic_vector (1 downto 0); 
   signal   A        : std_logic_vector (7 downto 0);  
   signal   B        : std_logic_vector (7 downto 0); 
   signal  result 	 : std_logic_vector (7 downto 0);  
   signal  overflow  : std_logic;                     
   signal  BCD_out   : std_logic_vector(9 downto 0); 
--   signal DIGIT_ANODE: std_logic_vector(3 downto 0);
--   signal SEGMENT    : std_logic_vector(6 downto 0);
   
begin

   -- to provide a clean signal out of a bouncy one coming from the push button
   -- input(b_Enter) comes from the pushbutton; output(Enter) goes to the FSM 
   debouncer1: debouncer
   port map ( clk          => clk,
              reset        => reset,
              button_in    => b_Enter,
              button_out   => Enter
            );
   debouncer2: debouncer
   port map ( clk          => clk,
              reset        => reset,
              button_in    => b_Sign,
              button_out   => sign
            );
   
   
   ALU_controller:  ALU_ctrl
   port map(
            clk            => clk, 
            reset          => reset,
            enter          => Enter,
            sign           => sign,
            FN             => FN,
            RegCtrl        => RegCtrl
           );
   ALU_COM :   ALU
   port map(
            A              =>   A,       
            B              =>   B,        
            FN             =>   FN,        
            result 	       =>   result, 	  
            overflow       =>   overflow,  
            sign_re           =>   sign_re      
           );
   reg_update :  regUpdate
   port map(
            clk            =>     clk ,   
            reset          =>     reset,  
            RegCtrl        =>    RegCtrl, 
            input          =>    input,   
            A              =>    A,       
            B              =>    B     
            );
   
   binarytoBCD: binary2BCD
   port map(
           binary_in       =>    result,
           BCD_out         =>    BCD_out
            );
   Seven_seg_driver1: seven_seg_driver 
   port map(
           clk             =>    clk,
           rst             =>    reset,
           BCD_digit       =>    BCD_out,
           sign_re            => sign_re,
           overflow        =>    overflow,
           DIGIT_ANODE     =>    anode,
           SEGMENT         =>    seven_seg
            );       
            
end structural;
