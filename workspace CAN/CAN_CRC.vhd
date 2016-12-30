library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

--clk   : input clock signal
--data  : input data bit = sampled bit
--enable: to control the crc generator
--init  : when set initialize the crc number
--crc   : after the data field in the transmission/reception, crc will contain the crc sequence
--        applied on START OF FRAME, ARBITRATION FIELD, CONTROL FIELD, DATA FIELD

entity can_crc is 
    port (
             clk        :  in std_logic;
             data       :  in std_logic;
             enable     :  in std_logic;
             initialize :  in std_logic;
             crc        :  buffer std_logic_vector( 14  downto 0  ) 

         );
end entity; 


architecture arch_can_crc of can_crc is 
    signal crc_next: std_logic;
    signal crc_tmp : std_logic_vector( 14  downto 0  );
begin 
    crc_next <= ( data xor crc(14) ) ;
    crc_tmp <= ( crc(13  downto 0 ) & '0' ); --left shift by one position
    process(clk) 
    begin
        if ( clk'EVENT and ( clk = '1' )  ) then
            if ( initialize='1' ) then 
                crc <= std_logic_vector(to_unsigned(0, 15))  ;
            else 
                if ( enable='1' ) then 
                    if ( crc_next='1' ) then 
                        crc <= ( crc_tmp xor std_logic_vector(to_signed(17817, 15)));
                    else 
                        crc <= crc_tmp ;
                    end if;
                end if;
            end if;
        end if ;
    end process;
    
end arch_can_crc; 
