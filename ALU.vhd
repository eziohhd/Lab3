library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
   port ( A          : in  std_logic_vector (7 downto 0);   -- Input A
          B          : in  std_logic_vector (7 downto 0);   -- Input B
          FN         : in  std_logic_vector (3 downto 0);   -- ALU functions provided by the ALU_Controller (see the lab manual)
          result 	   : out std_logic_vector (7 downto 0);   -- ALU output (unsigned binary)
	       overflow   : out std_logic;                       -- '1' if overflow ocurres, '0' otherwise 
	       sign_re       : out std_logic                       -- '1' if the result is a negative value, '0' otherwis
        );
end ALU;

architecture behavioral of ALU is
    signal A_u,A_1,A_2,A_3,A_4,A_5,A_6 : unsigned (7 downto 0 );
    signal A_ext_u,B_ext_u,result_ext_u : unsigned (8 downto 0) := (others => '0');
    signal A_ext_s,B_ext_s,result_ext_s : signed (8 downto 0);
    signal sign_out : std_logic;
    signal overflow_out :std_logic;
    alias sign_a : std_logic is A_ext_s(7) ;
    alias sign_b : std_logic is B_ext_s(7);
    alias sign_s : std_logic is result_ext_s(7) ;
    
begin   
   process ( FN, A, B ,A_u,A_ext_u, B_ext_u,result_ext_u,A_ext_s,B_ext_s,result_ext_s,A_1,A_2,A_3,A_4,A_5,A_6,sign_a,sign_b,sign_s,sign_out,overflow_out)
   begin
       case FN is
       when "0000" =>
           result <= A;
           sign_re <= '0';
           overflow <= '0';
       --input B
       when "0001" =>
           result <= B; 
           sign_re <= '0';
           overflow <= '0';
       --unsigned A+B
       when  "0010" =>
           sign_re <= '0';
           A_ext_u <= unsigned('0' & A);
           B_ext_u <= unsigned('0' & B);
           result_ext_u <= A_ext_u + B_ext_u;
           result <= std_logic_vector(result_ext_u(7 downto 0));
           if result_ext_u(8) = '1' then
               overflow <= '1' ;
           else overflow <= '0';
           end if;
          
        --unsigned A-B
        when "0011" =>
            A_ext_u <= unsigned('0' & A);
            B_ext_u <= unsigned('0' & B);
            if (A_ext_u < B_ext_u ) then
                result_ext_u <= B_ext_u - A_ext_u;
                sign_re <= '1';
                overflow <= '0';
            else 
                result_ext_u <= A_ext_u - B_ext_u;
                sign_re <= '0';
                overflow <= '0';
            end if;
            result <= std_logic_vector(result_ext_u(7 downto 0));
         --unsigned A mod 3
         when "0100" =>
             sign_re <= '0';
             overflow <= '0';
             A_u <= unsigned(A);
             if A_u > 192 then
                A_1 <= A_u - 192;
             else
                A_1 <= A_u;
             end if;
             if A_1 > 96 then   
                A_2 <= A_1 - 96;
             else                
                A_2 <= A_1;      
             end if;             
             if A_2 > 48 then   
                 A_3 <= A_2 - 48;
             else                
                 A_3 <= A_2;      
             end if; 
             if A_3 > 24 then   
                 A_4 <= A_3 - 24;
             else                
                 A_4 <= A_3;      
             end if;
             if A_4 > 12 then    
                 A_5 <= A_4 - 12;
             else                
                 A_5 <= A_4;     
             end if;   
             if A_5 > 6 then    
                 A_6 <= A_5 - 6;
             else                
                 A_6 <= A_5;     
             end if;             
             if (A_6 > 3) or (A_6 = 3) then    
                 result <= std_logic_vector( A_6 - 3);
             else                
                 result <= std_logic_vector( A_6);  
             end if;             
      --signed a+b--              
         when  "1010" =>
            A_ext_s <= signed('0' & A) ;
            B_ext_s <= signed('0' & B);
            result_ext_s <= A_ext_s + B_ext_s;
            overflow_out <= (sign_a and sign_b and (not sign_s)) or
                         (( not sign_a) and (not sign_b) and sign_s);
            overflow <= overflow_out;
            if overflow_out = '0' then
                sign_out <= sign_s;
            else 
                sign_out <=  not sign_s;
            end if;
            sign_re <= sign_out;
            if sign_out = '0' then
                result <= std_logic_vector(result_ext_s(7 downto 0));
            elsif sign_out = '1' then
             result <= std_logic_vector( not result_ext_s(7 downto 0)+ 1) ;
            end if;
         --signed A-b
         when  "1011" =>
            A_ext_s <= signed('1' & A);
            B_ext_s <= signed('1' & B); 
            result_ext_s <= A_ext_s - B_ext_s;
            overflow_out <= (sign_a and (not sign_b) and (not sign_s)) or      
                         (( not sign_a) and sign_b and sign_s);
            overflow <= overflow_out;
            if overflow_out = '0' then
                sign_out <= sign_s;
            else 
                sign_out <=  not sign_s;
            end if;
            sign_re <= sign_out;
            if sign_out = '0' then                                
                result <= std_logic_vector(result_ext_s(7 downto 0));            
            elsif sign_out = '1' then
            result <= std_logic_vector((not result_ext_s(7 downto 0)) + 1);
            end if;
         --signed A mod 3
         when "1100" =>
             sign_re <= '0';
             overflow <= '0';
            if A(7) = '0' then
                A_u <= unsigned(A);
            else
                A_u <= unsigned(A) - 1;
            end if;
            if A_u > 192 then
               A_1 <= A_u - 192;
            else
               A_1 <= A_u;
            end if;
            if A_1 > 96 then   
               A_2 <= A_1 - 96;
            else                
               A_2 <= A_1;      
            end if;             
            if A_2 > 48 then   
                A_3 <= A_2 - 48;
            else                
                A_3 <= A_2;      
            end if; 
            if A_3 > 24 then   
                A_4 <= A_3 - 24;
            else                
                A_4 <= A_3;      
            end if;
            if A_4 > 12 then    
                A_5 <= A_4 - 12;
            else                
                A_5 <= A_4;     
            end if;   
            if A_5 > 6 then    
                A_6 <= A_5 - 6;
            else                
                A_6 <= A_5;     
            end if;             
            if (A_6 > 3) or (A_6 = 3) then    
                result <= std_logic_vector( A_6 - 3);
            else                
                result <= std_logic_vector( A_6);  
            end if;
         --others   
        when others =>
            result <= "00000000";                                 
            overflow <= '0';
            sign_re <= '0'; 
        end case;    
            
   -- DEVELOPE YOUR CODE HERE
   end process;

end behavioral;


