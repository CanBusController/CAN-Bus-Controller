
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY CPU_INTERFACE IS 
	PORT (
			-- Avalon bus in/out -- 

		clock_avalon, rst_avalon : IN STD_LOGIC;
		read, write : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);


			-- message reg in/out -- 

		rx_data_id1_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_id2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_conf_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

		rx_data_1_2_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_id1_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_id2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_conf_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_1_2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

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
		rx_data_7_8_we	: OUT STD_LOGIC;


			-- timing reg in/out -- 

		time_reg_in	:	OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		time_reg_out:	IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		time_reg_we	:	OUT STD_LOGIC 

	);
END ENTITY CPU_INTERFACE ;


ARCHITECTURE RTL OF CPU_INTERFACE IS
  

		--define SIGNALs here
	SIGNAL to_cpu_bus	:	STD_LOGIC_VECTOR(15 DOWNTO 0) :=(others=>'0');
	SIGNAL from_cpu_bus:	STD_LOGIC_VECTOR(15 DOWNTO 0) :=(others=>'0');

	SIGNAL time_reg_in_sig : STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL time_reg_out_sig : STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL time_reg_we_sig : STD_LOGIC :='0';
	
	SIGNAL rx_data_id1_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL rx_data_id2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');

	SIGNAL rx_data_conf_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');	

	SIGNAL rx_data_1_2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL rx_data_3_4_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL rx_data_5_6_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL rx_data_7_8_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');


	SIGNAL tx_data_id1_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL tx_data_id2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');

	SIGNAL tx_data_conf_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');

	SIGNAL tx_data_1_2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL tx_data_3_4_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL tx_data_5_6_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');
	SIGNAL tx_data_7_8_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) :=(others=>'0');




	SIGNAL tx_data_id1_we_sig	:   STD_LOGIC := '0' ;
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

  SIGNAL DReady	: STD_LOGIC :='0' ;	
	BEGIN

	    
	time_reg_in <= time_reg_in_sig;
	time_reg_we <= time_reg_we_sig ;
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


		from_cpu_bus<=writedata;
		readdata <= to_cpu_bus;

		PROCESS (clock_avalon)
		BEGIN 
		IF (clock_avalon'event and clock_avalon='1') THEN 
			IF (write = '1') THEN
	          if DReady = '0' then
	             DReady <= '1';
	          else
				  time_reg_we_sig 		<= '0';
				  rx_data_id1_we_sig 	<= '0';
				  rx_data_id2_we_sig	  	<= '0';
				  rx_data_conf_we_sig 	<= '0';
				  rx_data_1_2_we_sig 	<= '0';
				  rx_data_3_4_we_sig 	<= '0';
				  rx_data_5_6_we_sig		<= '0';
				  rx_data_7_8_we_sig 	<= '0';
				  tx_data_id1_we_sig 	<= '0';
				  tx_data_id2_we_sig 	<= '0';
				  tx_data_conf_we_sig 	<= '0';
				  tx_data_1_2_we_sig 	<= '0';
				  tx_data_3_4_we_sig 	<= '0';
				  tx_data_5_6_we_sig 	<= '0';
				  tx_data_7_8_we_sig 	<= '0'; 
	           DReady <= '0';
	          end if;
	          
	          
					CASE address IS
						WHEN "000000"	=>  
						    time_reg_we_sig 		  <= '1';
						    time_reg_in_sig<= from_cpu_bus ;
						WHEN "000001"	=>
						    time_reg_we_sig 		  <= '1';  
								time_reg_in_sig (3 DOWNTO 0) 	<= from_cpu_bus(3 DOWNTO 0) ;
								time_reg_in_sig (15 DOWNTO 4) 	<= time_reg_out(15 DOWNTO 4) ;
						WHEN "000010"	=>	
						    time_reg_we_sig 		  <= '1';  
								time_reg_in_sig (6 DOWNTO 4) 	<= from_cpu_bus(2 DOWNTO 0) ;
								time_reg_in_sig (15 DOWNTO 7)	<= time_reg_out(15 DOWNTO 7) ;
								time_reg_in_sig (3 DOWNTO 0) 	<= time_reg_out(3 DOWNTO 0) ;
						WHEN "000011" 	=>	
						    time_reg_we_sig 		  <= '1';  
								time_reg_in_sig (12 DOWNTO 8) 	<= from_cpu_bus(4 DOWNTO 0) ;
								time_reg_in_sig (15 DOWNTO 13) 	<= time_reg_out(15 DOWNTO 13) ;
								time_reg_in_sig (7 DOWNTO 0) 	<= time_reg_out( 7 DOWNTO 0) ;
						WHEN "000100" 	=>	
						    time_reg_we_sig 		  <= '1';  
								time_reg_in_sig (15 DOWNTO 13) 	<= from_cpu_bus(2 DOWNTO 0) ;
								time_reg_in_sig (12 DOWNTO 0) 	<= time_reg_out(12 DOWNTO 0) ;
						WHEN "001000" | "001001" | "001010" | "001011"	=>	
									tx_data_id1_we_sig <= '1' ;
									CASE address IS
										WHEN  "001000" =>
											tx_data_id1_in_sig 	<= 	from_cpu_bus ;
										WHEN  "001001" =>
											tx_data_id1_in_sig (12 DOWNTO 0) 	<=	 from_cpu_bus(12 DOWNTO 0) ;
											tx_data_id1_in_sig (15 DOWNTO 13) 	<=	 tx_data_id1_out(15 DOWNTO 13) ;
										WHEN  "001010" =>
											tx_data_id1_in_sig (14) 			<=	 from_cpu_bus(0) ;
											tx_data_id1_in_sig (13 DOWNTO 0) 	<=	 tx_data_id1_out(13 DOWNTO 0) ;
											tx_data_id1_in_sig (15) 			<=	 tx_data_id1_out(15) ;
										WHEN  "001011" =>
											tx_data_id1_in_sig (15) 			<=	 from_cpu_bus(0) ;
											tx_data_id1_in_sig (14 DOWNTO 0) 	<=	 tx_data_id1_out(14 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;


						WHEN "010000" =>
							tx_data_id2_we_sig 	<= '1' ;
							tx_data_id2_in_sig	<= 	from_cpu_bus ;
						WHEN "011000" | "011001" | "011010" | "100011" =>	
									tx_data_conf_we_sig <= '1' ;
									CASE address IS
										WHEN  "011000" =>
											tx_data_conf_in_sig 				<= 	from_cpu_bus ;
										WHEN  "011001" =>
											tx_data_conf_in_sig(3 DOWNTO 0) 	<=	from_cpu_bus(3 DOWNTO 0) ;
											tx_data_conf_in_sig(15 DOWNTO 4)	<=	tx_data_conf_out(15 DOWNTO 4) ;
										WHEN  "011010" =>
											tx_data_conf_in_sig(14) 			<=	from_cpu_bus(0) ;
											tx_data_conf_in_sig(15)				<=	tx_data_conf_out(15) ;
											tx_data_conf_in_sig(13 DOWNTO 0)	<=	tx_data_conf_out(13 DOWNTO 0) ;
										WHEN  "011011" =>
											tx_data_conf_in_sig(15) 			<=	from_cpu_bus(0) ;
											tx_data_conf_in_sig(14 DOWNTO 0)	<=	tx_data_conf_out(14 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;



							WHEN "100000" | "100001" | "100010"  =>	
									tx_data_1_2_we_sig <= '1' ;
									CASE address IS
										WHEN  "100000" =>
											tx_data_1_2_in_sig 	<= 	from_cpu_bus ;
										WHEN  "100001" =>
											tx_data_1_2_in_sig (7 DOWNTO 0) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_1_2_in_sig (15 DOWNTO 8)	<=	tx_data_1_2_out(15 DOWNTO 8) ;
										WHEN  "100010" =>
											tx_data_1_2_in_sig(15 DOWNTO 8) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_1_2_in_sig(7 DOWNTO 0)		<=	tx_data_1_2_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
							WHEN "101000" | "101001" | "101010"  =>	
									tx_data_3_4_we_sig <= '1' ;
									CASE address IS
										WHEN  "101000" =>
											tx_data_3_4_in_sig 	<= 	from_cpu_bus ;
										WHEN  "101001" =>
											tx_data_3_4_in_sig (7 DOWNTO 0) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_3_4_in_sig (15 DOWNTO 8)	<=	tx_data_3_4_out(15 DOWNTO 8) ;
										WHEN  "101010" =>
											tx_data_3_4_in_sig(15 DOWNTO 8) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_3_4_in_sig(7 DOWNTO 0)		<=	tx_data_3_4_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
							WHEN "110000" | "110001" | "110010"  =>		
									tx_data_5_6_we_sig <= '1' ;
									CASE address IS
										WHEN  "110000" =>
											tx_data_5_6_in_sig 	<= 	from_cpu_bus ;
										WHEN  "110001" =>
											tx_data_5_6_in_sig (7 DOWNTO 0) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_5_6_in_sig (15 DOWNTO 8)	<=	tx_data_5_6_out(15 DOWNTO 8) ;
										WHEN  "110010" =>
											tx_data_5_6_in_sig(15 DOWNTO 8) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_5_6_in_sig(7 DOWNTO 0)		<=	tx_data_5_6_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
							WHEN "111000" | "111001" | "111010"  =>	
									tx_data_7_8_we_sig <= '1' ;
									CASE address IS
										WHEN  "111000" =>
											tx_data_7_8_in_sig 	<= 	from_cpu_bus ;
										WHEN  "111001" =>
											tx_data_7_8_in_sig (7 DOWNTO 0) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_7_8_in_sig (15 DOWNTO 8)	<=	tx_data_7_8_out(15 DOWNTO 8) ;
										WHEN  "111010" =>
											tx_data_7_8_in_sig(15 DOWNTO 8) 	<=	from_cpu_bus(7 DOWNTO 0) ;
											tx_data_7_8_in_sig(7 DOWNTO 0)		<=	tx_data_7_8_out(7 DOWNTO 0) ;
										WHEN OTHERS => NULL ;
									END CASE ;
					WHEN OTHERS => NULL ;
					END CASE ;
			ELSIF (read = '1') THEN
			  if DReady='1' then
			     time_reg_we_sig 		  <= '0';
				  rx_data_id1_we_sig 	 <= '0';
				  rx_data_id2_we_sig	    <= '0';
				  rx_data_conf_we_sig 	<= '0';
				  rx_data_1_2_we_sig 	<= '0';
				  rx_data_3_4_we_sig 	<= '0';
				  rx_data_5_6_we_sig	   <= '0';
				  rx_data_7_8_we_sig 	<= '0';
				  tx_data_id1_we_sig 	<= '0';
				  tx_data_id2_we_sig 	<= '0';
				  tx_data_conf_we_sig   <= '0';
				  tx_data_1_2_we_sig 	<= '0';
				  tx_data_3_4_we_sig 	<= '0';
				  tx_data_5_6_we_sig 	<= '0';
				  tx_data_7_8_we_sig 	<= '0';
				  DReady<='0' ;
				end if;
				CASE address IS
					WHEN "000000" 	=>	to_cpu_bus 	<=	time_reg_out ;
					WHEN "001000" 	=>	to_cpu_bus 	<=	rx_data_id1_out ;
					WHEN "010000"	=>	to_cpu_bus 	<=	rx_data_id2_out ;
					WHEN "011000"	=>	to_cpu_bus 	<=	rx_data_conf_out ;
					WHEN "100000"	=>	to_cpu_bus 	<=	rx_data_1_2_out;
					WHEN "101000"	=>	to_cpu_bus 	<=	rx_data_3_4_out ;
					WHEN "110000"	=>	to_cpu_bus 	<=	rx_data_5_6_out;
					WHEN "111000"	=>	to_cpu_bus 	<=	rx_data_7_8_out ;
					WHEN "111100"	=>	to_cpu_bus 	<=	tx_data_id1_out;
					WHEN OTHERS => NULL;
				END CASE ;
			END IF;
	END IF;
			END PROCESS ;
		END ARCHITECTURE ;