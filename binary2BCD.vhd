library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

library work;
use work.ALU_components_pack.all;

entity binary2BCD is
   
   port ( binary_in : in  std_logic_vector(7 downto 0);
          BCD_out   : out std_logic_vector(9 downto 0)        
        );
end binary2BCD;

architecture structural of binary2BCD is 

begin  
----------------------------------------------------------------------------------------------------------------------
    process (binary_in)
    
    variable hex_src : std_logic_vector (7 downto 0) ;
    variable bcd     : std_logic_vector (11 downto 0) ;
    
    begin
        hex_src := binary_in ;
        bcd     := (others => '0') ;
    
        for i in 0 to 6 loop
            bcd := bcd(10 downto 0) & hex_src(7) ; -- shift bcd + 1 new entry
            hex_src := hex_src(6 downto 0) & '0' ; -- shift src + pad with 0
    
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
        
        bcd := bcd(10 downto 0) & hex_src(7) ;
        hex_src := hex_src(6 downto 0) & '0' ; 

        BCD_out <= bcd(9 downto 0);
    end process ;
----------------------------------------------------------------------------------------------------------------------

end structural;