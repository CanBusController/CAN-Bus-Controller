LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;


ENTITY CAN_CRC_test IS
    END CAN_CRC_test ; 

architecture  arch_CAN_CRC_TEST of CAN_CRC_test is

    COMPONENT can_crc 
    port (
             clk        :  in std_logic;
             data       :  in std_logic;
             enable     :  in std_logic;
             initialize :  in std_logic;
             crc        :  buffer std_logic_vector(14 downto 0) 
         );
    end COMPONENT; 

    signal clk : std_logic := '0';
    signal data : std_logic := '0' ;
    signal enable : std_logic := '0';
    signal initialize : std_logic := '1' ;
    signal crc : std_logic_vector(14 downto 0)  ;

    constant clk_period : time := 100 ns;

begin
    can_crc_t: CAN_CRC PORT MAP ( clk => clk, data=>data, enable=>enable, initialize=>initialize, crc=>crc) ;
    --generating the clock signal 
    clk_process :process
    begin
	clk <= '0';
	wait for clk_period/2;  
	clk <= '1';
	wait for clk_period/2;
    end process;

    testing_process: process 
    begin 
	initialize<='1';
	wait for 200 ns; 
	initialize <= '0' ;
	enable<='0';
	data<='1';
	wait for 200 ns ;
	data<='0';
	wait for 200 ns ;
	enable<='1';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
	wait for 100 ns ;
	data<='1';
	wait for 100 ns ;
        data<='0';
        wait for 100 ns ;
    end process ;
end architecture ;
