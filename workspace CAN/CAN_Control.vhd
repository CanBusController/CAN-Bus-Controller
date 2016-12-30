library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY CAN_CONTROL IS 
	PORT (
		time_reg_in	:	IN 	STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		time_reg_out:	OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;


		time_reg_we	:	IN STD_LOGIC ;

		clk			:	IN STD_LOGIC ;
		RST 		:	IN STD_LOGIC 
		);
END CAN_CONTROL ;

ARCHITECTURE TIMING OF CAN_CONTROL IS

	CONSTANT size_16 : integer:=16;
	
	COMPONENT can_register is 
		GENERIC ( WIDTH :integer := size_16 );
		PORT (
		data_in 	: IN STD_LOGIC_VECTOR( width - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(width  - 1 DOWNTO 0);
		we 			: IN STD_LOGIC ;
		clk			: IN STD_LOGIC ;
		rst 		: IN STD_LOGIC
			) ;
	END COMPONENT ;

	BEGIN
	
	TIMEREG 	:	can_register generic map (width => size_16) port map (data_in=>time_reg_in,data_out=>time_reg_out,we =>time_reg_we,clk=> clk,rst=> RST);	
	
	END ARCHITECTURE ;

	