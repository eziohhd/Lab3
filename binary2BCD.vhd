library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

library work;
use work.ALU_components_pack.all;

entity binary2BCD is
   generic ( WIDTH : integer := 8   -- 8 bit binary to BCD
           );
   
   port ( binary_in : in  std_logic_vector(WIDTH-1 downto 0);  -- binary input width
          BCD_out   : out std_logic_vector(9 downto 0)        -- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
        );
end binary2BCD;

architecture structural of binary2BCD is 

    signal  bcd_ten, bcd_uni, bcd_hun : std_logic_vector(3 downto 0);
  
begin  
----------------------------------------------------------------------------------------------------------------------
    process (binary_in)
    
    variable hex_src : std_logic_vector (7 downto 0) ;
    variable bcd     : std_logic_vector (11 downto 0) ;
    
    begin
        hex_src := binary_in ;
        bcd     := (others => '0') ;
    
        for i in 0 to 7 loop
            bcd := bcd(11 downto 1) & hex_src(7) ; -- shift bcd + 1 new entry
            hex_src := hex_src(7 downto 1) & '0' ; -- shift src + pad with 0
    
            if bcd(3 downto 0) > "0100" then
                bcd(3 downto 0) := bcd(3 downto 0) + "0011" ;
            end if ;
            if bcd(7 downto 4) > "0100" then
                bcd(7 downto 4) := bcd(7 downto 4) + "0011" ;
            end if ;
            if bcd(11 downto 8) > "0100" then
                bcd(11 downto 8) := bcd(11 downto 8) + "0011" ;
            end if ;
        end loop ;
    
        bcd_hun <= bcd(11 downto 8) ;
        bcd_ten <= bcd(7  downto 4) ;
        bcd_uni <= bcd(3  downto 0) ;

    end process ;
----------------------------------------------------------------------------------------------------------------------
    BCD_out <= bcd_hun(1 downto 0) & bcd_ten & bcd_uni;  
    
end structural;
