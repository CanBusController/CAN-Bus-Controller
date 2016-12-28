LIBRARY ieee ;
USE ieee.std_logic_1164.all ;


ENTITY CAN_CONTROL IS 
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
END ENTITY ;

ARCHITECTURE TIMING OF CAN_CONTROLE IS

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

	not_used_we <= 0 ;
	TIMEREG 	:	can_regiter generic map (width => size_16) port map (data_in=>time_reg_in,data_out=>time_reg_out,we =>time_reg_we,clk=> clk,rst=> RST);	
	NOTUSED 	:	can_regiter generic map (width => size_16) port map (data_in=>not_used_in,data_out=>not_used_out,we =>not_used_we,clk=> clk,rst=> RST);

	END ARCHITECTURE ;

	