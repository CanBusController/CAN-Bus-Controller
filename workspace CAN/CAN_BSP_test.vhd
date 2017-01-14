LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity CAN_BSP_test is
end CAN_BSP_test ;

architecture arch_CAN_BSP_test of CAN_BSP_test is

 component can_bsp
	    port(
            clk :        in std_logic;
            rst :        in std_logic;
            process_bit: in std_logic;
            rcv_bit:     in std_logic;
            bit_err:     in std_logic;

            --tx
            tx_rqst:     in std_logic;
            tx_id:       in std_logic_vector(10 downto 0);
            tx_rtr:      in std_logic;
            tx_data:     in std_logic_vector(63 downto 0);
            tx_dlc:      in std_logic_vector(3 downto 0);
            tx_done:     out std_logic;

            --rx
            rx_id:       out std_logic_vector(10 downto 0);
            rx_data:     out std_logic_vector(63 downto 0);
            rx_dlc:      out std_logic_vector(3 downto 0);
            rx_rtr:      out std_logic;
            rx_valid:    out std_logic;

            hard_sync_en:out std_logic;
            bus_drive:   out std_logic

        );
 end component ;

signal clk : std_logic:='0';
signal rst : std_logic:='1';
signal process_bit: std_logic:='1';
signal rcv_bit:  std_logic:='1';
signal  bit_err: std_logic:='0';

            --tx
signal tx_rqst: std_logic:='0';
signal tx_id: std_logic_vector(10 downto 0);
signal tx_rtr: std_logic;
signal tx_data: std_logic_vector(63 downto 0);
signal tx_dlc:   std_logic_vector(3 downto 0);
signal tx_done: std_logic;

            --rx
signal rx_id:std_logic_vector(10 downto 0);
signal rx_data:std_logic_vector(63 downto 0);
signal rx_dlc:std_logic_vector(3 downto 0);
signal rx_rtr: std_logic;
signal rx_valid:std_logic;

signal hard_sync_en:std_logic:='0';
signal bus_drive:std_logic:='1';

signal ko_packet: std_logic_vector( 107 downto 0):="010101010100011000001010101010101010101010101010101010101010101010101010101010101010101010101010111111111111";

signal ok_packet: std_logic_vector( 109 downto 0):="01010101010001100001010101010101010101010101010101010101010101010101010101010101010101010101010111110111110111";

constant clk_period : time := 100 ps;

begin
    can_bsp_t: CAN_BSP port map(clk=>clk, rst=>rst, process_bit=>process_bit, rcv_bit=>rcv_bit, bit_err=>bit_err,
                                tx_rqst=>tx_rqst, tx_id=>tx_id, tx_rtr=>tx_rtr, tx_data=>tx_data, tx_dlc=>tx_dlc, tx_done=>tx_done,
				rx_id=>rx_id, rx_data=>rx_data, rx_dlc=>rx_dlc, rx_rtr=>rx_rtr, rx_valid=>rx_valid,
				hard_sync_en=>hard_sync_en, bus_drive=>bus_drive);
    --generating the clock signal 
    clk_process :process
    begin
	clk <= '0';
	wait for clk_period/2;  
	clk <= '1';
	wait for clk_period/2;
    end process;

    testing_process:process
    variable counter: integer range 0 to 31:=0;
    begin
	--wait for bus idle
	rst<='1';
	tx_rqst<='0';
	wait for 200 ps;
	rst<='0';
	wait for 15*clk_period ;
	tx_rqst<='1';
	wait for 2 * clk_period;
	--transmitting
	tx_rqst<='0';
	process_bit<='1';
	rcv_bit<='1';
	bit_err<='0';
	tx_id<="01010101010";
	tx_rtr<='0';
	tx_data<=X"5555555555555555";
	tx_dlc<="0100";
	wait for 115*clk_period ;
	--idle
	process_bit<='0';
	tx_rqst<='0';
	wait for 50*clk_period;
	--receiving
	process_bit<='1';
	rcv_bit<='0';
	wait for 2*clk_period;
	counter:=0;
	for i in 0 to 109 loop
		counter:=counter+1;
		rcv_bit<=ok_packet(109-i);
		wait for clk_period ;
	end loop ;
	wait for 10*clk_period;
	--receiving
	process_bit<='1';
	rcv_bit<='0';
	wait for 2*clk_period;
	counter:=0;
	for i in 0 to 107 loop
		counter:=counter+1;
		rcv_bit<=ko_packet(107-i);
		wait for clk_period ;
	end loop ;
	wait for 10 * clk_period;
    end process;
end architecture;
	
