
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_vhdl_acf IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      id                      : IN std_logic_vector(28 DOWNTO 0);   
      reset_mode              : IN std_logic;   
      acceptance_filter_mode  : IN std_logic;   
      extended_mode           : IN std_logic;   
      acceptance_code_0       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_code_1       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_code_2       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_code_3       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_0       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_1       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_2       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_3       : IN std_logic_vector(7 DOWNTO 0);   
      go_rx_crc_lim           : IN std_logic;   
      go_rx_inter             : IN std_logic;   
      go_error_frame          : IN std_logic;   
      data0                   : IN std_logic_vector(7 DOWNTO 0);   
      data1                   : IN std_logic_vector(7 DOWNTO 0);   
      rtr1                    : IN std_logic;   
      rtr2                    : IN std_logic;   
      ide                     : IN std_logic;   
      no_byte0                : IN std_logic;   
      no_byte1                : IN std_logic;   
      id_ok                   : OUT std_logic);   
END ENTITY can_vhdl_acf;

ARCHITECTURE RTL OF can_vhdl_acf IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

   SIGNAL match                    :  std_logic;   
   SIGNAL match_sf_std             :  std_logic;   
   SIGNAL match_sf_ext             :  std_logic;   
   SIGNAL match_df_std             :  std_logic;   
   SIGNAL match_df_ext             :  std_logic;   
   SIGNAL id_ok_xhdl1              :  std_logic;   

BEGIN
   id_ok <= id_ok_xhdl1;
   -- Working in basic mode. ID match for standard format (11-bit ID).
   match <= (((((((CONV_STD_LOGIC(id(3) = acceptance_code_0(0)) OR acceptance_mask_0(0)) AND (CONV_STD_LOGIC(id(4) = acceptance_code_0(1)) OR acceptance_mask_0(1))) AND (CONV_STD_LOGIC(id(5) = acceptance_code_0(2)) OR acceptance_mask_0(2))) AND (CONV_STD_LOGIC(id(6) = acceptance_code_0(3)) OR acceptance_mask_0(3))) AND (CONV_STD_LOGIC(id(7) = acceptance_code_0(4)) OR acceptance_mask_0(4))) AND (CONV_STD_LOGIC(id(8) = acceptance_code_0(5)) OR acceptance_mask_0(5))) AND (CONV_STD_LOGIC(id(9) = acceptance_code_0(6)) OR acceptance_mask_0(6))) AND (CONV_STD_LOGIC(id(10) = acceptance_code_0(7)) OR acceptance_mask_0(7)) ;
   -- Working in extended mode. ID match for standard format (11-bit ID). Using single filter.
   match_sf_std <= ((((((((((((((((((((((((   
   (
   ((CONV_STD_LOGIC(id(3) = acceptance_code_0(0)) OR acceptance_mask_0(0)) AND (CONV_STD_LOGIC(id(4) = acceptance_code_0(1)) 
   OR acceptance_mask_0(1))) 
   AND 
   (CONV_STD_LOGIC(id(5) = acceptance_code_0(2)) OR acceptance_mask_0(2)))
    AND (CONV_STD_LOGIC(id(6) = acceptance_code_0(3)) 
	OR acceptance_mask_0(3))) AND (CONV_STD_LOGIC(id(7) = acceptance_code_0(4)) OR acceptance_mask_0(4))) AND (CONV_STD_LOGIC(id(8) = acceptance_code_0(5)) 
	OR acceptance_mask_0(5))) AND (CONV_STD_LOGIC(id(9) = acceptance_code_0(6)) OR acceptance_mask_0(6))) AND (CONV_STD_LOGIC(id(10) = acceptance_code_0(7)) 
	OR acceptance_mask_0(7))) AND (CONV_STD_LOGIC(rtr1 = acceptance_code_1(4)) OR acceptance_mask_1(4))) AND (CONV_STD_LOGIC(id(0) = acceptance_code_1(5)) 
	OR acceptance_mask_1(5))) AND (CONV_STD_LOGIC(id(1) = acceptance_code_1(6)) OR acceptance_mask_1(6))) AND (CONV_STD_LOGIC(id(2) = acceptance_code_1(7)) 
	OR acceptance_mask_1(7))) AND (CONV_STD_LOGIC(data0(0) = acceptance_code_2(0)) OR acceptance_mask_2(0) OR no_byte0)) AND (CONV_STD_LOGIC(data0(1) = acceptance_code_2(1)) 
	OR acceptance_mask_2(1) OR no_byte0)) AND (CONV_STD_LOGIC(data0(2) = acceptance_code_2(2)) OR acceptance_mask_2(2) 
	OR no_byte0)) AND (CONV_STD_LOGIC(data0(3) = acceptance_code_2(3)) OR acceptance_mask_2(3) OR no_byte0)) AND (CONV_STD_LOGIC(data0(4) = acceptance_code_2(4)) 
	OR acceptance_mask_2(4) OR no_byte0)) AND (CONV_STD_LOGIC(data0(5) = acceptance_code_2(5)) OR acceptance_mask_2(5) OR no_byte0)) AND (CONV_STD_LOGIC(data0(6) = acceptance_code_2(6)) 
	OR acceptance_mask_2(6) OR no_byte0)) AND (CONV_STD_LOGIC(data0(7) = acceptance_code_2(7)) OR acceptance_mask_2(7) OR no_byte0)) AND (CONV_STD_LOGIC(data1(0) = acceptance_code_3(0)) 
	OR acceptance_mask_3(0) OR no_byte1)) AND (CONV_STD_LOGIC(data1(1) = acceptance_code_3(1)) OR acceptance_mask_3(1) OR no_byte1)) AND (CONV_STD_LOGIC(data1(2) = acceptance_code_3(2)) 
	OR acceptance_mask_3(2) OR no_byte1)) AND (CONV_STD_LOGIC(data1(3) = acceptance_code_3(3)) OR acceptance_mask_3(3) OR no_byte1)) AND (CONV_STD_LOGIC(data1(4) = acceptance_code_3(4)) 
	OR acceptance_mask_3(4) OR no_byte1)) AND (CONV_STD_LOGIC(data1(5) = acceptance_code_3(5)) OR acceptance_mask_3(5) OR no_byte1)) AND (CONV_STD_LOGIC(data1(6) = acceptance_code_3(6)) 
	OR acceptance_mask_3(6) OR no_byte1)) AND (CONV_STD_LOGIC(data1(7) = acceptance_code_3(7)) OR acceptance_mask_3(7) OR no_byte1) ;
   -- Working in extended mode. ID match for extended format (29-bit ID). Using single filter.
   match_sf_ext <= (((((((((((((((((((((((((((((CONV_STD_LOGIC(id(21) = acceptance_code_0(0)) OR acceptance_mask_0(0)) AND (CONV_STD_LOGIC(id(22) = acceptance_code_0(1)) 
	OR acceptance_mask_0(1))) AND (CONV_STD_LOGIC(id(23) = acceptance_code_0(2)) OR acceptance_mask_0(2))) AND (CONV_STD_LOGIC(id(24) = acceptance_code_0(3)) 
	OR acceptance_mask_0(3))) AND (CONV_STD_LOGIC(id(25) = acceptance_code_0(4)) OR acceptance_mask_0(4))) AND (CONV_STD_LOGIC(id(26) = acceptance_code_0(5)) 
	OR acceptance_mask_0(5))) AND (CONV_STD_LOGIC(id(27) = acceptance_code_0(6)) OR acceptance_mask_0(6))) AND (CONV_STD_LOGIC(id(28) = acceptance_code_0(7)) 
	OR acceptance_mask_0(7))) AND (CONV_STD_LOGIC(id(13) = acceptance_code_1(0)) OR acceptance_mask_1(0))) AND (CONV_STD_LOGIC(id(14) = acceptance_code_1(1)) 
	OR acceptance_mask_1(1))) AND (CONV_STD_LOGIC(id(15) = acceptance_code_1(2)) OR acceptance_mask_1(2))) AND (CONV_STD_LOGIC(id(16) = acceptance_code_1(3)) 
	OR acceptance_mask_1(3))) AND (CONV_STD_LOGIC(id(17) = acceptance_code_1(4)) OR acceptance_mask_1(4))) AND (CONV_STD_LOGIC(id(18) = acceptance_code_1(5)) 
	OR acceptance_mask_1(5))) AND (CONV_STD_LOGIC(id(19) = acceptance_code_1(6)) OR acceptance_mask_1(6))) AND (CONV_STD_LOGIC(id(20) = acceptance_code_1(7)) 
	OR acceptance_mask_1(7))) AND (CONV_STD_LOGIC(id(5) = acceptance_code_2(0)) OR acceptance_mask_2(0))) AND (CONV_STD_LOGIC(id(6) = acceptance_code_2(1)) 
	OR acceptance_mask_2(1))) AND (CONV_STD_LOGIC(id(7) = acceptance_code_2(2)) OR acceptance_mask_2(2))) AND (CONV_STD_LOGIC(id(8) = acceptance_code_2(3)) 
	OR acceptance_mask_2(3))) AND (CONV_STD_LOGIC(id(9) = acceptance_code_2(4)) OR acceptance_mask_2(4))) AND (CONV_STD_LOGIC(id(10) = acceptance_code_2(5)) 
	OR acceptance_mask_2(5))) AND (CONV_STD_LOGIC(id(11) = acceptance_code_2(6)) OR acceptance_mask_2(6))) AND (CONV_STD_LOGIC(id(12) = acceptance_code_2(7)) 
	OR acceptance_mask_2(7))) AND (CONV_STD_LOGIC(rtr2 = acceptance_code_3(2)) OR acceptance_mask_3(2))) AND (CONV_STD_LOGIC(id(0) = acceptance_code_3(3))
	 OR acceptance_mask_3(3))) AND (CONV_STD_LOGIC(id(1) = acceptance_code_3(4)) OR acceptance_mask_3(4))) AND (CONV_STD_LOGIC(id(2) = acceptance_code_3(5)) 
	OR acceptance_mask_3(5))) AND (CONV_STD_LOGIC(id(3) = acceptance_code_3(6)) OR acceptance_mask_3(6))) AND (CONV_STD_LOGIC(id(4) = acceptance_code_3(7)) 
	OR acceptance_mask_3(7)) ;
   -- Working in extended mode. ID match for standard format (11-bit ID). Using double filter.
   match_df_std <= ((((((((((((((((((((CONV_STD_LOGIC(id(3) = acceptance_code_0(0)) OR acceptance_mask_0(0)) AND (CONV_STD_LOGIC(id(4) = acceptance_code_0(1)) 
	OR acceptance_mask_0(1))) AND (CONV_STD_LOGIC(id(5) = acceptance_code_0(2)) OR acceptance_mask_0(2))) AND (CONV_STD_LOGIC(id(6) = acceptance_code_0(3)) 
	OR acceptance_mask_0(3))) AND (CONV_STD_LOGIC(id(7) = acceptance_code_0(4)) OR acceptance_mask_0(4))) AND (CONV_STD_LOGIC(id(8) = acceptance_code_0(5)) 
	OR acceptance_mask_0(5))) AND (CONV_STD_LOGIC(id(9) = acceptance_code_0(6)) OR acceptance_mask_0(6))) AND (CONV_STD_LOGIC(id(10) = acceptance_code_0(7)) 
	OR acceptance_mask_0(7))) AND (CONV_STD_LOGIC(rtr1 = acceptance_code_1(4)) OR acceptance_mask_1(4))) AND (CONV_STD_LOGIC(id(0) = acceptance_code_1(5)) 
	OR acceptance_mask_1(5))) AND (CONV_STD_LOGIC(id(1) = acceptance_code_1(6)) OR acceptance_mask_1(6))) AND (CONV_STD_LOGIC(id(2) = acceptance_code_1(7))
                                                                                                                   
	OR acceptance_mask_1(7))) AND (CONV_STD_LOGIC(data0(0) = acceptance_code_3(0)) OR acceptance_mask_3(0) 
	OR no_byte0)) AND (CONV_STD_LOGIC(data0(1) = acceptance_code_3(1)) OR acceptance_mask_3(1) OR no_byte0)) AND (CONV_STD_LOGIC(data0(2) = acceptance_code_3(2)) 
	OR acceptance_mask_3(2) OR no_byte0)) AND (CONV_STD_LOGIC(data0(3) = acceptance_code_3(3)) OR acceptance_mask_3(3) 
	OR no_byte0)) AND (CONV_STD_LOGIC(data0(4) = acceptance_code_1(0)) OR acceptance_mask_1(0) OR no_byte0)) AND (CONV_STD_LOGIC(data0(5) = acceptance_code_1(1)) 
	OR acceptance_mask_1(1) OR no_byte0)) AND (CONV_STD_LOGIC(data0(6) = acceptance_code_1(2)) 
	OR acceptance_mask_1(2) OR no_byte0)) AND (CONV_STD_LOGIC(data0(7) = acceptance_code_1(3)) OR acceptance_mask_1(3) OR no_byte0))
                   
	OR ((((((((((((CONV_STD_LOGIC(id(3) = acceptance_code_2(0)) OR acceptance_mask_2(0)) AND (CONV_STD_LOGIC(id(4) = acceptance_code_2(1)) 
	OR acceptance_mask_2(1))) AND (CONV_STD_LOGIC(id(5) = acceptance_code_2(2)) OR acceptance_mask_2(2))) AND (CONV_STD_LOGIC(id(6) = acceptance_code_2(3)) 
	OR acceptance_mask_2(3))) AND (CONV_STD_LOGIC(id(7) = acceptance_code_2(4)) OR acceptance_mask_2(4))) AND (CONV_STD_LOGIC(id(8) = acceptance_code_2(5)) 
	OR acceptance_mask_2(5))) AND (CONV_STD_LOGIC(id(9) = acceptance_code_2(6)) OR acceptance_mask_2(6))) AND (CONV_STD_LOGIC(id(10) = acceptance_code_2(7)) 
	OR acceptance_mask_2(7))) AND (CONV_STD_LOGIC(rtr1 = acceptance_code_3(4)) OR acceptance_mask_3(4))) AND (CONV_STD_LOGIC(id(0) = acceptance_code_3(5)) 
	OR acceptance_mask_3(5))) AND (CONV_STD_LOGIC(id(1) = acceptance_code_3(6)) OR acceptance_mask_3(6))) AND (CONV_STD_LOGIC(id(2) = acceptance_code_3(7)) 
	OR acceptance_mask_3(7))) ;
   -- Working in extended mode. ID match for extended format (29-bit ID). Using double filter.
   match_df_ext <= ((((((((((((((((CONV_STD_LOGIC(id(21) = acceptance_code_0(0)) OR acceptance_mask_0(0)) AND (CONV_STD_LOGIC(id(22) = acceptance_code_0(1)) 
	OR acceptance_mask_0(1))) AND (CONV_STD_LOGIC(id(23) = acceptance_code_0(2)) OR acceptance_mask_0(2))) AND (CONV_STD_LOGIC(id(24) = acceptance_code_0(3)) 
	OR acceptance_mask_0(3))) AND (CONV_STD_LOGIC(id(25) = acceptance_code_0(4)) OR acceptance_mask_0(4))) AND (CONV_STD_LOGIC(id(26) = acceptance_code_0(5)) 
	OR acceptance_mask_0(5))) AND (CONV_STD_LOGIC(id(27) = acceptance_code_0(6)) OR acceptance_mask_0(6))) AND (CONV_STD_LOGIC(id(28) = acceptance_code_0(7)) 
	OR acceptance_mask_0(7))) AND (CONV_STD_LOGIC(id(13) = acceptance_code_1(0)) OR acceptance_mask_1(0))) AND (CONV_STD_LOGIC(id(14) = acceptance_code_1(1)) 
	OR acceptance_mask_1(1))) AND (CONV_STD_LOGIC(id(15) = acceptance_code_1(2)) OR acceptance_mask_1(2))) AND (CONV_STD_LOGIC(id(16) = acceptance_code_1(3)) 
	OR acceptance_mask_1(3))) AND (CONV_STD_LOGIC(id(17) = acceptance_code_1(4)) OR acceptance_mask_1(4))) AND (CONV_STD_LOGIC(id(18) = acceptance_code_1(5)) 
	OR acceptance_mask_1(5))) AND (CONV_STD_LOGIC(id(19) = acceptance_code_1(6)) OR acceptance_mask_1(6))) AND (CONV_STD_LOGIC(id(20) = acceptance_code_1(7)) 
	OR acceptance_mask_1(7))) OR ((((((((((((((((CONV_STD_LOGIC(id(21) = acceptance_code_2(0)) OR acceptance_mask_2(0)) AND (CONV_STD_LOGIC(id(22) = acceptance_code_2(1)) 
	OR acceptance_mask_2(1))) AND (CONV_STD_LOGIC(id(23) = acceptance_code_2(2)) OR acceptance_mask_2(2))) AND (CONV_STD_LOGIC(id(24) = acceptance_code_2(3)) 
	OR acceptance_mask_2(3))) AND (CONV_STD_LOGIC(id(25) = acceptance_code_2(4)) OR acceptance_mask_2(4))) AND (CONV_STD_LOGIC(id(26) = acceptance_code_2(5)) 
	OR acceptance_mask_2(5))) AND (CONV_STD_LOGIC(id(27) = acceptance_code_2(6)) OR acceptance_mask_2(6))) AND (CONV_STD_LOGIC(id(28) = acceptance_code_2(7)) 
	OR acceptance_mask_2(7))) AND (CONV_STD_LOGIC(id(13) = acceptance_code_3(0)) OR acceptance_mask_3(0))) AND (CONV_STD_LOGIC(id(14) = acceptance_code_3(1)) 
	OR acceptance_mask_3(1))) AND (CONV_STD_LOGIC(id(15) = acceptance_code_3(2)) OR acceptance_mask_3(2))) AND (CONV_STD_LOGIC(id(16) = acceptance_code_3(3)) 
	OR acceptance_mask_3(3))) AND (CONV_STD_LOGIC(id(17) = acceptance_code_3(4)) OR acceptance_mask_3(4))) AND (CONV_STD_LOGIC(id(18) = acceptance_code_3(5)) 
	OR acceptance_mask_3(5))) AND (CONV_STD_LOGIC(id(19) = acceptance_code_3(6)) OR acceptance_mask_3(6))) AND (CONV_STD_LOGIC(id(20) = acceptance_code_3(7)) 
	OR acceptance_mask_3(7))) ;

   -- ID ok signal generation
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         id_ok_xhdl1 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (go_rx_crc_lim = '1') THEN
            -- sample_point is already included in go_rx_crc_lim
            
            IF (extended_mode = '1') THEN
               IF (NOT acceptance_filter_mode = '1') THEN
                  -- dual filter
                  
                  IF (ide = '1') THEN
                     -- extended frame message
                     
                     id_ok_xhdl1 <= match_df_ext ;    
                  ELSE
                     -- standard frame message
                     
                     id_ok_xhdl1 <= match_df_std ;    
                  END IF;
               ELSE
                  -- single filter
                  
                  IF (ide = '1') THEN
                     -- extended frame message
                     
                     id_ok_xhdl1 <= match_sf_ext ;    
                  ELSE
                     -- standard frame message
                     
                     id_ok_xhdl1 <= match_sf_std ;    
                  END IF;
               END IF;
            ELSE
               id_ok_xhdl1 <= match ;    
            END IF;
         ELSE
            IF ((reset_mode OR go_rx_inter OR go_error_frame) = '1') THEN
               -- sample_point is already included in go_rx_inter
               
               id_ok_xhdl1 <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;