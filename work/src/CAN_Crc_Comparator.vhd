
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_crc_comparator IS
  
     PORT (
      crc_valid                    : IN std_logic_vector(14 downto 0);   
      crc_rx                       : IN std_logic_vector(14 downto 0);
      crc_ok                       : out std_logic);
         
      
END ENTITY can_crc_comparator;


ARCHITECTURE RTL OF can_crc_comparator IS
  function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

begin
     crc_ok <= conv_std_logic(crc_valid = crc_rx);
     
end RTL;
  