
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_fifo IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      wr                      : IN std_logic;   
      data_in                 : IN std_logic_vector(7 DOWNTO 0);   
      addr                    : IN std_logic_vector(5 DOWNTO 0);   
      data_out                : OUT std_logic_vector(7 DOWNTO 0);   
      fifo_selected           : IN std_logic;   
      reset_mode              : IN std_logic;   
      release_buffer          : IN std_logic;  
      overrun                 : OUT std_logic;   
      info_empty              : OUT std_logic;   
      info_cnt                : OUT std_logic_vector(6 DOWNTO 0));   
END ENTITY can_fifo;

ARCHITECTURE RTL OF can_fifo IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

function andv(d : std_logic_vector) return std_ulogic is
variable tmp : std_ulogic;
begin
  tmp := '1';
  for i in d'range loop tmp := tmp and d(i); end loop;
  return(tmp);
end;

 
   SIGNAL rd_pointer               :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL wr_pointer               :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL read_address             :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL wr_info_pointer          :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL rd_info_pointer          :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL wr_q                     :  std_logic;   
   SIGNAL len_cnt                  :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL fifo_cnt                 :  std_logic_vector(6 DOWNTO 0);   
   SIGNAL latch_overrun            :  std_logic;   
   SIGNAL initialize_memories      :  std_logic;   
   SIGNAL length_info              :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL write_length_info        :  std_logic;   
   SIGNAL fifo_empty               :  std_logic;   
   SIGNAL fifo_full                :  std_logic;   
   SIGNAL info_full                :  std_logic;   
   SIGNAL data_out_xhdl1           :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL overrun_xhdl2            :  std_logic;   
   SIGNAL info_empty_xhdl3         :  std_logic;   
   SIGNAL info_cnt_xhdl4           :  std_logic_vector(6 DOWNTO 0);   
  

BEGIN
   data_out <= data_out_xhdl1;
   overrun <= overrun_xhdl2;
   info_empty <= info_empty_xhdl3;
   info_cnt <= info_cnt_xhdl4;
   write_length_info <= (NOT wr) AND wr_q ;


   -- Delayed write signal
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         wr_q <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            wr_q <= '0' ;    
         ELSE
            wr_q <= wr ;    
         END IF;
      END IF;
   END PROCESS;

   -- length counter
   
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         len_cnt <= "0000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR write_length_info) = '1') THEN
            len_cnt <= "0000" ;    
         ELSE
            IF ((wr AND (NOT fifo_full)) = '1') THEN
               len_cnt <= len_cnt + "0001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- wr_info_pointer
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         wr_info_pointer <= "000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((write_length_info AND (NOT info_full)) OR initialize_memories) = '1') THEN
            wr_info_pointer <= wr_info_pointer + "000001" ;    
         ELSE
            IF (reset_mode = '1') THEN
               wr_info_pointer <= rd_info_pointer ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- rd_info_pointer
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rd_info_pointer <= "000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
        IF ((release_buffer AND (NOT info_empty_xhdl3)) = '1') THEN
--      Fix from opencores rev 1.28
--      IF ((release_buffer AND (NOT fifo_empty)) = '1') THEN
            rd_info_pointer <= rd_info_pointer + "000001" ;    
         END IF;
      END IF;
   END PROCESS;

   -- rd_pointer
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rd_pointer <= "000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((release_buffer AND (NOT fifo_empty)) = '1') THEN
            rd_pointer <= rd_pointer + ("00" & length_info) ;    
         END IF;
      END IF;
   END PROCESS;

   -- wr_pointer
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         wr_pointer <= "000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            wr_pointer <= rd_pointer ;    
         ELSE
            IF ((wr AND (NOT fifo_full)) = '1') THEN
               wr_pointer <= wr_pointer + "000001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- latch_overrun
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         latch_overrun <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR write_length_info) = '1') THEN
            latch_overrun <= '0' ;    
         ELSE
            IF ((wr AND fifo_full) = '1') THEN
               latch_overrun <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Counting data in fifo
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         fifo_cnt <= "0000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            fifo_cnt <= "0000000" ;    
         ELSE
            IF (((wr AND (NOT release_buffer)) AND (NOT fifo_full)) = '1') THEN
               fifo_cnt <= fifo_cnt + "0000001" ;    
            ELSE
               IF ((((NOT wr) AND release_buffer) AND (NOT fifo_empty)) = '1') THEN
                  fifo_cnt <= fifo_cnt - ("000" & length_info) ;    
               ELSE
                  IF ((((wr AND release_buffer) AND (NOT fifo_full)) AND (NOT fifo_empty)) = '1') THEN
                     fifo_cnt <= fifo_cnt - ("000" & length_info) + "0000001" ;    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   fifo_full <= CONV_STD_LOGIC(fifo_cnt = "1000000") ;
   fifo_empty <= CONV_STD_LOGIC(fifo_cnt = "0000000") ;

   -- Counting data in length_fifo and overrun_info fifo
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         info_cnt_xhdl4 <= "0000000" ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            info_cnt_xhdl4 <= "0000000" ;    
         ELSE
            IF ((write_length_info XOR release_buffer) = '1') THEN
               IF ((release_buffer AND (NOT info_empty_xhdl3)) = '1') THEN
                  info_cnt_xhdl4 <= info_cnt_xhdl4 - "0000001" ;    
               ELSE
                  IF ((write_length_info AND (NOT info_full)) = '1') THEN
                     info_cnt_xhdl4 <= info_cnt_xhdl4 + "0000001" ;    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   info_full <= CONV_STD_LOGIC(info_cnt_xhdl4 = "1000000") ;
   info_empty_xhdl3 <= CONV_STD_LOGIC(info_cnt_xhdl4 = "0000000") ;
   

   -- Selecting which address will be used for reading data from rx fifo
   
   PROCESS (rd_pointer, addr)
      VARIABLE read_address_xhdl18  : std_logic_vector(5 DOWNTO 0);
   BEGIN
      read_address_xhdl18 := rd_pointer + (addr - "010100");    
      read_address <= read_address_xhdl18;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         initialize_memories <= '1';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (andv(wr_info_pointer) = '1') THEN
            initialize_memories <= '0' ;    
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;
