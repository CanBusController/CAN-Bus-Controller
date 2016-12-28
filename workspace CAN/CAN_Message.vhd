LIBRARY ieee ;
USE ieee.std_logic_1164.all ;


ENTITY CAN_MESSAGE IS 
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
	END ENTITY ;

ARCHITECTURE BASIC OF CAN_MESSAGE IS

	CONSTANT size_16 : integer:=16;
	COMPONENT can_regiter is 
		GENERIC ( WIDTH = size_16);
		PORT (
			data_in 	:	in std_logic(16 downto 0);
			data_out	:	in std_logic(16 downto 0);
			we 			:	in std_logic;
			clk 		:	in std_logic;
			reset 		:	in std_logic 
			) ;
	END COMPONENT ;

	BEGIN

	RXMSGID1	:	can_regiter generic map (width => size_16) port map (data_in=>x_data_id1_in	,data_out=>rx_data_id1_out,we =>rx_data_id1_we,clk=> clk,rst=> RST); 

	RXMSGID2	:	can_regiter generic map (width => size_16) port map (data_in=>rx_data_id2_in,data_out=>rx_data_id2_out,we =>rx_data_id2_we,clk=> clk,rst=> RST);

	RXMSGCONF	:	can_regiter generic map (width => size_16) port map (data_in=>rx_data_conf_in,data_out=>rx_data_conf_out,we =>rx_data_conf_we,clk=> clk,rst=> RST);

	RXMSGD12	:	can_regiter generic map (width => size_16) port map (data_in=>rx_data_1_2_in,data_out=>rx_data_1_2_out,we =>rx_data_1_2_we,clk=> clk,rst=> RST);
	RXMSGD34	:	can_regiter generic map (width => size_16) port map (data_in=>rx_data_3_4_in,data_out=>rx_data_3_4_out,we =>rx_data_3_4_we,clk=> clk,rst=> RST);
	RXMSGD56	:	can_regiter generic map (width => size_16) port map (data_in=>rx_data_5_6_in,data_out=>rx_data_5_6_out,we =>rx_data_5_6_we,clk=> clk,rst=> RST);
	RXMSGD78	:	can_regiter generic map (width => size_16) port map (data_in=>rx_data_7_8_in,data_out=>rx_data_7_8_out,we =>rx_data_7_8_we,clk=> clk,rst=> RST);

	TXMSGID1	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_id1_in,data_out=>tx_data_id1_out,we => tx_data_id1_we,clk=> clk,rst=> RST);
	TXMSGID2	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_id2_in,data_out=>tx_data_id2_out,we =>tx_data_id2_we,clk=> clk,rst=> RST);

	TXMSGCONF	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_conf_in,data_out=>tx_data_conf_out,we =>tx_data_conf_we,clk=> clk,rst=> RST);

	TXMSGD12	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_1_2_in,data_out=>tx_data_1_2_out,we =>tx_data_1_2_we,clk=> clk,rst=> RST);
	TXMSGD34	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_3_4_in,data_out=>tx_data_3_4_out,we =>tx_data_3_4_we,clk=> clk,rst=> RST);
	TXMSGD56	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_5_6_in,data_out=>tx_data_5_6_out,we =>tx_data_5_6_we,clk=> clk,rst=> RST);
	TXMSGD78	:	can_regiter generic map (width => size_16) port map (data_in=>tx_data_7_8_in,data_out=>tx_data_7_8_out,we =>tx_data_7_8_we,clk=> clk,rst=> RST);

	END ;