LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY CPU_INTERFACE IS 
	PORT (
		clock, rst : IN STD_LOGIC;
		read, write, chipselect : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		byteenable : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY CPU_INTERFACE ;


ARCHITECTURE PARALLAL_16BIT OF CPU_INTERFACE IS
	SIGNAL
		--define signals here
		we_on	:	STD_LOGIC ;
		we_off	:	STD_LOGIC ;
		to_reg	:	STD_LOGIC_VECTOR(15 DOWNTO 0);
		from_reg:	STD_LOGIC_VECTOR(15 DOWNTO 0);

	COMPONENT CAN_MESSAGE IS 
	PORT (
		rx_data_id1_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_id2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_conf_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

		rx_data_1_2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_id1_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_id2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_conf_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_1_2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


		tx_data_id1_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_we	:	IN STD_LOGIC;
		tx_data_id2_we	:	IN STD_LOGIC;

		tx_data_conf_we	:	IN STD_LOGIC;

		tx_data_1_2_we	:	IN STD_LOGIC;
		tx_data_3_4_we	:	IN STD_LOGIC;
		tx_data_5_6_we	:	IN STD_LOGIC;
		tx_data_7_8_we	:	IN STD_LOGIC;

		rx_data_id1_we	:	IN STD_LOGIC;
		rx_data_id2_we	:	IN STD_LOGIC;

		rx_data_conf_we	:	IN STD_LOGIC;

		rx_data_1_2_we	:	IN STD_LOGIC;
		rx_data_3_4_we	:	IN STD_LOGIC;
		rx_data_5_6_we	:	IN STD_LOGIC;
		rx_data_7_8_we	:	IN STD_LOGIC;

		clk 			:	IN STD_LOGIC;
		RST 			: 	IN STD_LOGIC

		);

	END COMPONENT ;

	COMPONENT CAN_CONTROL IS
		PORT (
			time_reg_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
			not_used_in:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

			time_reg_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
			not_used_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

			time_reg_we	:	IN STD_LOGIC ;
			not_used_we	:	IN STD_LOGIC ;

			clk			:	IN STD_LOGIC ;
			RST 		:	IN STD_LOGIC 
		);
	END COMPONENT ;

	BEGIN
		fromreg<=writedata ;
		IF (address="0000") THEN
			TIMINIG: CAN_CONTROL PORT MAP ( time_reg_in=>to_reg , time_reg_we=>we_on , time_reg_out=>from_reg, others=>'0' );
		ELSIF (address/="0001") THEN
			IF (read='1') THEN
				IF (address="0010")	THEN
					BASIC : CAN_MESSAGE PORT MAP (rx_data_id1_in=>to_reg,rx_data_id1_out=>from_reg,rx_data_id1_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0011")	THEN
					BASIC : CAN_MESSAGE PORT MAP (rx_data_id2_in=>to_reg,rx_data_id2_out=>from_reg,rx_data_id2_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0100")	THEN
					BASIC : CAN_MESSAGE PORT MAP (rx_data_conf_in=>to_reg,rx_data_conf_out=>from_reg,rx_data_conf_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0101")	THEN
					BASIC : CAN_MESSAGE PORT MAP (rx_data_1_2_1n=>to_reg,rx_data_1_2_out=>from_reg,rx_data_1_2_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0110")	THEN
					BASIC : CAN_MESSAGE PORT MAP (rx_data_3_4_1n=>to_reg,rx_data_3_4_out=>from_reg,rx_data_3_4_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0111")	THEN
					BASIC : CAN_MESSAGE PORT MAP (rx_data_5_6_in=>to_reg,rx_data_5_6_out=>from_reg,rx_data_5_6_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="1000")	THEN	
					BASIC : CAN_MESSAGE PORT MAP (rx_data_7_8_in=>to_reg,rx_data_7_8_out=>from_reg,rx_data_7_8_we=>we_on,OTHERS=>'0') ;
				END IF ;
			ELSIF (write="1" AND NOT(read='1')) THEN
				IF (address="0010")	THEN
					BASIC : CAN_MESSAGE PORT MAP (tx_data_id1_in=>to_reg,tx_data_id1_out=>from_reg,tx_data_id1_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0011")	THEN
					BASIC : CAN_MESSAGE PORT MAP (tx_data_id2_in=>to_reg,tx_data_id2_out=>from_reg,tx_data_id2_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0100")	THEN
					BASIC : CAN_MESSAGE PORT MAP (tx_data_conf_in=>to_reg,tx_data_conf_out=>from_reg,tx_data_conf_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0101")	THEN
					BASIC : CAN_MESSAGE PORT MAP (tx_data_1_2_1n=>to_reg,tx_data_1_2_out=>from_reg,tx_data_1_2_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0110")	THEN
					BASIC : CAN_MESSAGE PORT MAP (tx_data_3_4_1n=>to_reg,tx_data_3_4_out=>from_reg,tx_data_3_4_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="0111")	THEN
					BASIC : CAN_MESSAGE PORT MAP (tx_data_5_6_in=>to_reg,tx_data_5_6_out=>from_reg,tx_data_5_6_we=>we_on,OTHERS=>'0') ;
				ELSIF (address="1000")	THEN	
					BASIC : CAN_MESSAGE PORT MAP (tx_data_7_8_in=>to_reg,tx_data_7_8_out=>from_reg,tx_data_7_8_we=>we_on,OTHERS=>'0') ;
				END IF ;
			END IF ;
		END IF ;
		




