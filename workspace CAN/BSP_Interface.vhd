
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY BSP_INTERFACE IS 
	PORT (
			-- Avalon bus in/out -- 

		clk: IN STD_LOGIC;
		read, write : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);


			-- message reg in/out -- 

		rx_data_id1_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_id2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_conf_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;	

		rx_data_1_2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_3_4_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_5_6_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_7_8_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_id1_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_id2_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_conf_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_1_2_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_3_4_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_5_6_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_7_8_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		tx_data_id1_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		tx_data_id2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		tx_data_conf_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		tx_data_1_2_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


		tx_data_id1_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_we	: OUT STD_LOGIC;
		tx_data_id2_we	: OUT STD_LOGIC;

		tx_data_conf_we	: OUT STD_LOGIC;

		tx_data_1_2_we	: OUT STD_LOGIC;
		tx_data_3_4_we	: OUT STD_LOGIC;
		tx_data_5_6_we	: OUT STD_LOGIC;
		tx_data_7_8_we	: OUT STD_LOGIC;

		rx_data_id1_we	: OUT STD_LOGIC;
		rx_data_id2_we	: OUT STD_LOGIC;

		rx_data_conf_we	: OUT STD_LOGIC;

		rx_data_1_2_we	: OUT STD_LOGIC;
		rx_data_3_4_we	: OUT STD_LOGIC;
		rx_data_5_6_we	: OUT STD_LOGIC;
		rx_data_7_8_we	: OUT STD_LOGIC

	);
END ENTITY BSP_INTERFACE ;


ARCHITECTURE RTL OF BSP_INTERFACE IS
  

		--define SIGNALs here
	SIGNAL to_bsp	:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL from_bsp:	STD_LOGIC_VECTOR(15 DOWNTO 0);

	
	SIGNAL rx_data_id1_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_id2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL rx_data_conf_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

	SIGNAL rx_data_1_2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_3_4_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_5_6_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_7_8_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


	SIGNAL tx_data_id1_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_id2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_conf_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_1_2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_3_4_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_5_6_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_7_8_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;




	SIGNAL tx_data_id1_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_id2_we_sig	:   STD_LOGIC := '0';

	SIGNAL tx_data_conf_we_sig	:   STD_LOGIC := '0';

	SIGNAL tx_data_1_2_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_3_4_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_5_6_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_7_8_we_sig	:   STD_LOGIC := '0';

	SIGNAL rx_data_id1_we_sig	:   STD_LOGIC := '0' ;
	SIGNAL rx_data_id2_we_sig	:   STD_LOGIC := '0';

	SIGNAL rx_data_conf_we_sig	:   STD_LOGIC := '0';

	SIGNAL rx_data_1_2_we_sig	:   STD_LOGIC := '0';
	SIGNAL rx_data_3_4_we_sig	:   STD_LOGIC := '0';
	SIGNAL rx_data_5_6_we_sig	:   STD_LOGIC := '0';
	SIGNAL rx_data_7_8_we_sig	:   STD_LOGIC := '0';


	BEGIN
	  

	rx_data_id1_in <= rx_data_id1_in_sig;
	rx_data_id2_in <= rx_data_id2_in_sig;

	rx_data_conf_in <= rx_data_conf_in_sig;	

	rx_data_1_2_in <= rx_data_1_2_in_sig;
	rx_data_3_4_in <= rx_data_3_4_in_sig;
	rx_data_5_6_in <= rx_data_5_6_in_sig;
	rx_data_7_8_in <= rx_data_7_8_in_sig;


	tx_data_id1_in <= tx_data_id1_in_sig;
	tx_data_id2_in <= tx_data_id2_in_sig;

	tx_data_conf_in <= tx_data_conf_in_sig;

	tx_data_1_2_in <= tx_data_1_2_in_sig;
	tx_data_3_4_in <= tx_data_3_4_in_sig;
	tx_data_5_6_in <= tx_data_5_6_in_sig;
	tx_data_7_8_in <= tx_data_7_8_in_sig;




	tx_data_id1_we <= tx_data_id1_we_sig;
	tx_data_id2_we <= tx_data_id2_we_sig;

	tx_data_conf_we <= tx_data_conf_we_sig;

	tx_data_1_2_we <= tx_data_1_2_we_sig;
	tx_data_3_4_we <= tx_data_3_4_we_sig;
	tx_data_5_6_we <= tx_data_5_6_we_sig;
	tx_data_7_8_we <= tx_data_7_8_we_sig;

	rx_data_id1_we <= rx_data_id1_we_sig;
	rx_data_id2_we <= rx_data_id2_we_sig;

	rx_data_conf_we <= rx_data_conf_we_sig;

	rx_data_1_2_we <= rx_data_1_2_we_sig;
	rx_data_3_4_we <= rx_data_3_4_we_sig;
	rx_data_5_6_we <= rx_data_5_6_we_sig;
	rx_data_7_8_we <= rx_data_7_8_we_sig;


		from_bsp<=writedata;
		readdata <= to_bsp;

		PROCESS (clk)
		BEGIN 
		IF (clk'event and clk='1') THEN 
			
			IF (write = '1') THEN
					CASE address IS
					  WHEN "000000"	=>	
					        tx_data_id1_we_sig <= '1' ;
					        CASE address IS
					          WHEN  "000001" =>
					            tx_data_id1_in_sig (15) 			<=	 from_bsp(15) ;
											tx_data_id1_in_sig (14 DOWNTO 0) 	<=	 rx_data_id1_out(14 DOWNTO 0) ;
										WHEN  "000010" =>
					            tx_data_id1_in_sig (14) 			<=	 from_bsp(14) ;
											tx_data_id1_in_sig (13 DOWNTO 0) 	<=	 rx_data_id1_out(13 DOWNTO 0) ;
											tx_data_id1_in_sig (15) 			<=	 rx_data_id1_out(15) ;
										WHEN OTHERS => NULL ;
										END CASE ;
						WHEN "001000" | "001001" | "001010" | "001011"	=>	
									rx_data_id1_we_sig <= '1' ;
									CASE address IS
										WHEN  "001000" =>
											rx_data_id1_in_sig 	<= 	from_bsp ;
										WHEN  "001001" =>
											rx_data_id1_in_sig (12 DOWNTO 0) 	<=	 from_bsp(12 DOWNTO 0) ;
											rx_data_id1_in_sig (15 DOWNTO 13) 	<=	 rx_data_id1_out(15 DOWNTO 13) ;
										WHEN  "001010" =>
											rx_data_id1_in_sig (14) 			<=	 from_bsp(14) ;
											rx_data_id1_in_sig (13 DOWNTO 0) 	<=	 rx_data_id1_out(13 DOWNTO 0) ;
											rx_data_id1_in_sig (15) 			<=	 rx_data_id1_out(15) ;
										WHEN  "001011" =>
											rx_data_id1_in_sig (15) 			<=	 from_bsp(15) ;
											rx_data_id1_in_sig (14 DOWNTO 0) 	<=	 rx_data_id1_out(14 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;


						WHEN "010000" =>
							rx_data_id2_we_sig 	<= '1' ;
							rx_data_id2_in_sig	<= 	from_bsp ;
						WHEN "011000" | "011001" | "011010" | "100011" =>	
									rx_data_conf_we_sig <= '1' ;
									CASE address IS
										WHEN  "011000" =>
											rx_data_conf_in_sig 				<= 	from_bsp ;
										WHEN  "011001" =>
											rx_data_conf_in_sig(3 DOWNTO 0) 	<=	from_bsp(3 DOWNTO 0) ;
											rx_data_conf_in_sig(15 DOWNTO 4)	<=	rx_data_conf_out(15 DOWNTO 4) ;
										WHEN  "011010" =>
											rx_data_conf_in_sig(14) 			<=	from_bsp(14) ;
											rx_data_conf_in_sig(15)				<=	rx_data_conf_out(15) ;
											rx_data_conf_in_sig(13 DOWNTO 0)	<=	rx_data_conf_out(13 DOWNTO 0) ;
										WHEN  "011011" =>
											rx_data_conf_in_sig(15) 			<=	from_bsp(15) ;
											rx_data_conf_in_sig(14 DOWNTO 0)	<=	rx_data_conf_out(14 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;



							WHEN "100000" | "100001" | "100010"  =>	
									rx_data_1_2_we_sig <= '1' ;
									CASE address IS
										WHEN  "100000" =>
											rx_data_1_2_in_sig 	<= 	from_bsp ;
										WHEN  "100001" =>
											rx_data_1_2_in_sig (7 DOWNTO 0) 	<=	from_bsp(7 DOWNTO 0) ;
											rx_data_1_2_in_sig (15 DOWNTO 8)	<=	rx_data_1_2_out(15 DOWNTO 8) ;
										WHEN  "100010" =>
											rx_data_1_2_in_sig(15 DOWNTO 8) 	<=	from_bsp(15 DOWNTO 8) ;
											rx_data_1_2_in_sig(7 DOWNTO 0)		<=	rx_data_1_2_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
							WHEN "101000" | "101001" | "101010"  =>	
									rx_data_3_4_we_sig <= '1' ;
									CASE address IS
										WHEN  "101000" =>
											rx_data_3_4_in_sig 	<= 	from_bsp ;
										WHEN  "101001" =>
											rx_data_3_4_in_sig (7 DOWNTO 0) 	<=	from_bsp(7 DOWNTO 0) ;
											rx_data_3_4_in_sig (15 DOWNTO 8)	<=	rx_data_3_4_out(15 DOWNTO 8) ;
										WHEN  "101010" =>
											rx_data_3_4_in_sig(15 DOWNTO 8) 	<=	from_bsp(15 DOWNTO 8) ;
											rx_data_3_4_in_sig(7 DOWNTO 0)		<=	rx_data_3_4_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
							WHEN "110000" | "110001" | "110010"  =>		
									rx_data_5_6_we_sig <= '1' ;
									CASE address IS
										WHEN  "110000" =>
											rx_data_5_6_in_sig 	<= 	from_bsp ;
										WHEN  "110001" =>
											rx_data_5_6_in_sig (7 DOWNTO 0) 	<=	from_bsp(7 DOWNTO 0) ;
											rx_data_5_6_in_sig (15 DOWNTO 8)	<=	rx_data_5_6_out(15 DOWNTO 8) ;
										WHEN  "110010" =>
											rx_data_5_6_in_sig(15 DOWNTO 8) 	<=	from_bsp(15 DOWNTO 8) ;
											rx_data_5_6_in_sig(7 DOWNTO 0)		<=	rx_data_5_6_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
							WHEN "111000" | "111001" | "111010"  =>	
									rx_data_7_8_we_sig <= '1' ;
									CASE address IS
										WHEN  "111000" =>
											rx_data_7_8_in_sig 	<= 	from_bsp ;
										WHEN  "111001" =>
											rx_data_7_8_in_sig (7 DOWNTO 0) 	<=	from_bsp(7 DOWNTO 0) ;
											rx_data_7_8_in_sig (15 DOWNTO 8)	<=	rx_data_7_8_out(15 DOWNTO 8) ;
										WHEN  "111010" =>
											rx_data_7_8_in_sig(15 DOWNTO 8) 	<=	from_bsp(15 DOWNTO 8) ;
											rx_data_7_8_in_sig(7 DOWNTO 0)		<=	rx_data_7_8_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
					WHEN OTHERS => NULL ;
					END CASE ;
			ELSIF (read = '1') THEN
				CASE address IS
					WHEN "000000" 	=>	to_bsp 	<=	rx_data_id1_out ;
					WHEN "001000" 	=>	to_bsp 	<=	tx_data_id1_out ;
					WHEN "010000"	=>	to_bsp 	<=	tx_data_id2_out ;
					WHEN "011000"	=>	to_bsp 	<=	tx_data_conf_out ;
					WHEN "100000"	=>	to_bsp 	<=	tx_data_1_2_out;
					WHEN "101000"	=>	to_bsp 	<=	tx_data_3_4_out ;
					WHEN "110000"	=>	to_bsp 	<=	tx_data_5_6_out;
					WHEN "111000"	=>	to_bsp 	<=	tx_data_7_8_out;
					WHEN OTHERS => NULL;
				END CASE ;
			END IF;
				
		ELSIF (clk'event and clk='0') THEN
				  rx_data_id1_we_sig 	 <= '0';
				  rx_data_id2_we_sig	  <= '0';
				  rx_data_conf_we_sig 	<= '0';
				  rx_data_1_2_we_sig 	<= '0';
				  rx_data_3_4_we_sig 	<= '0';
				  rx_data_5_6_we_sig	<= '0';
				  rx_data_7_8_we_sig 	<= '0';
				  tx_data_id1_we_sig 	<= '0';
				  tx_data_id2_we_sig 	<= '0';
				  tx_data_conf_we_sig <= '0';
				  tx_data_1_2_we_sig 	<= '0';
				  tx_data_3_4_we_sig 	<= '0';
				  tx_data_5_6_we_sig 	<= '0';
				  tx_data_7_8_we_sig 	<= '0';
	    END IF;
			END PROCESS ;
		END ARCHITECTURE ;
