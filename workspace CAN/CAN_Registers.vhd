LIBRARY ieee ;
use ieee.std_logic_1164.all ;


ENTITY can_registers IS 
	PORT
	(
		can_ctrlreg_in 	:	in std_logic_vector (15 downto 0);
		can_statusreg_in:	in std_logic_vector (15 downto 0);

		can_ercntreg_in	:	in std_logic_vector (15 downto 0);
		can_btreg_in	:		in std_logic_vector (15 downto 0);
		can_intreg_in 	:		in std_logic_vector (15 downto 0);
		can_brpreg_in 	:		in std_logic_vector (15 downto 0);

		can_if1cmdreq_in:	in std_logic_vector (15 downto 0);
		can_if1cmdm_in	:		in std_logic_vector (15 downto 0);
		can_if1m1_in	:		in std_logic_vector (15 downto 0);
		can_if1m2_in	:		in std_logic_vector (15 downto 0);
		can_if1arbt1_in	:	in std_logic_vector (15 downto 0);
		can_if1arbt2_in	:	in std_logic_vector (15 downto 0);
		can_if1msgctrl_in:	in std_logic_vector (15 downto 0);


		can_if2cmdreq_in:	in std_logic_vector (15 downto 0); 
		can_if2cmdreq_in:	in std_logic_vector (15 downto 0);
		can_if2cmdm_in	:		in std_logic_vector (15 downto 0);
		can_if2m1_in	:		in std_logic_vector (15 downto 0);
		can_if2m2_in	:		in std_logic_vector (15 downto 0);
		can_if2arbt1_in	:	in std_logic_vector (15 downto 0);
		can_if2arbt2_in	:	in std_logic_vector (15 downto 0);
		can_if2msgctrl_in:	in std_logic_vector (15 downto 0);

		can_tx2reqreg_in:	in std_logic_vector (15 downto 0);
		can_tx1reqreg_in:	in std_logic_vector (15 downto 0);

		can_newd1reg_in	:	in std_logic_vector (15 downto 0);
		can_newd2reg_in	:	in std_logic_vector (15 downto 0);

		can_int1pndreg_in:	in std_logic_vector (15 downto 0);
		can_int2pndreg_in:	in std_logic_vector (15 downto 0);



		can_ctrlreg_out :	out std_logic_vector (15 downto 0);
		can_statusreg_out:	out std_logic_vector (15 downto 0);

		can_ercntreg_out:	out std_logic_vector (15 downto 0);
		can_btreg_out	:	out std_logic_vector (15 downto 0);
		can_inttreg_out	:	out std_logic_vector (15 downto 0);
		can_brpreg_out	:	out std_logic_vector (15 downto 0);

		can_if1cmdreq_out:	out std_logic_vector (15 downto 0);
		can_if1cmdm_out	:	out std_logic_vector (15 downto 0);
		can_if1m1_out	:	out std_logic_vector (15 downto 0);
		can_if1m2_out	:	out std_logic_vector (15 downto 0);
		can_if1arbt1_out:	out std_logic_vector (15 downto 0);
		can_if1arbt2_out:	out std_logic_vector (15 downto 0);
		can_if1msgctrl_out:	out std_logic_vector (15 downto 0);


		can_if2cmdreq_out:	out std_logic_vector (15 downto 0); 
		can_if2cmdreq_out:	out std_logic_vector (15 downto 0);
		can_if2cmdm_out	:	out std_logic_vector (15 downto 0);
		can_if2m1_out	:	out std_logic_vector (15 downto 0);
		can_if2m2_out	:	out std_logic_vector (15 downto 0);
		can_if2arbt1_out:	out std_logic_vector (15 downto 0);
		can_if2arbt2_out:	out std_logic_vector (15 downto 0);
		can_if2msgctrl_out:	out std_logic_vector (15 downto 0);

		can_tx2reqreg_out:	out std_logic_vector (15 downto 0);
		can_tx1reqreg_out:	out std_logic_vector (15 downto 0);

		can_newd1reg_out:	out std_logic_vector (15 downto 0);
		can_newd2reg_out:	out std_logic_vector (15 downto 0);

		can_int1pndreg_out:	out std_logic_vector (15 downto 0);
		can_int2pndreg_out:	out std_logic_vector (15 downto 0);




		can_ctrlreg_we 	:	in std_logic;
		can_statusreg_we:	in std_logic;

		can_ercntreg_we	:	in std_logic;
		can_btreg_we	:	in std_logic;
		can_intreg_we 	:	in std_logic;
		can_brpreg_we	:	in std_logic;

		can_if1cmdreq_we:	in std_logic;
		can_if1cmdm_we	:	in std_logic;
		can_if1m1_we	:	in std_logic;
		can_if1m2_we	:	in std_logic;
		can_if1arbt1_we	:	in std_logic;
		can_if1arbt2_we	:	in std_logic;
		can_if1msgctrl_we:	in std_logic;


		can_if2cmdreq_we:	in std_logic; 
		can_if2cmdreq_we:	in std_logic;
		can_if2cmdm_we	:	in std_logic;
		can_if2m1_we	:	in std_logic;
		can_if2m2_we	:	in std_logic;
		can_if2arbt1_we	:	in std_logic;
		can_if2arbt2_we	:	in std_logic;
		can_if2msgctrl_we:	in std_logic;

		can_tx2reqreg_we:	in std_logic;
		can_tx1reqreg_we:	in std_logic;

		can_newd1reg_we	:	in std_logic;
		can_newd2reg_we	:	in std_logic;

		can_int1pndreg_we:	in std_logic;
		can_int2pndreg_we:	in std_logic;

		clk 			:	in std_logic ;
	  	RST 			:	IN STD_LOGIC
	);
END ENTITY can_registers ; 


ARCHITECTURE RTL OF can_registers IS

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

	CANCTRL 	:	can_regiter generic map (width => size_16) port map (data_in=>can_ctrlreg_in,data_out=>can_ctrlreg_out,we =>can_ctrlreg_we,clk=> clk,rst_async=> RST); 
	CANSTAT 	:	can_regiter generic map (width => size_16) port map (data_in=>can_statusreg_in,data_out=>can_statusreg_out,we =>can_statusreg_we,clk=> clk,rst_async=> RST);

	ERRCNT		:	can_regiter generic map (width => size_16) port map (data_in=>can_ercntreg_in,data_out=>can_ercntreg_out,we =>can_ercntreg_we,clk=> clk,rst_async=> RST);
	BITTIM		:	can_regiter generic map (width => size_16) port map (data_in=>can_btreg_in,data_out=>can_btreg_out,we =>can_btreg_we,clk=> clk,rst_async=> RST);
	INTREG		:	can_regiter generic map (width => size_16) port map (data_in=>can_intreg_in,data_out=>can_inttreg_out,we =>can_intreg_we,clk=> clk,rst_async=> RST);
	BRPCONF		:	can_regiter generic map (width => size_16) port map (data_in=>can_brpreg_in,data_out=>can_brpreg_out,we =>,clk=>can_brpreg_we clk,rst_async=> RST);

	IF1CMDREQ 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if1cmdreq_in,data_out=>can_if1cmdreq_out,we =>can_if1cmdreq_we,clk=> clk,rst_async=> RST);
	IF1CMDM		:	can_regiter generic map (width => size_16) port map (data_in=>can_if1cmdm_in,data_out=>can_if1cmdm_out,we =>can_if1cmdm_we,clk=> clk,rst_async=> RST);
	IF1M1		:	can_regiter generic map (width => size_16) port map (data_in=>can_if1m1_in,data_out=>can_if1m1_out,we =>can_if1m1_we,clk=> clk,rst_async=> RST);
	IF1M2		:	can_regiter generic map (width => size_16) port map (data_in=>can_if1m2_in,data_out=>can_if1m2_out,we =>can_if1m2_out,clk=> clk,rst_async=> RST);
	IF1ARBT1 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if1arbt1_in,data_out=>can_if1arbt1_out,we =>can_if1arbt1_we,clk=> clk,rst_async=> RST);
	IF1ARBT2 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if1arbt2_in,data_out=>can_if1arbt2_out,we =>can_if1arbt2_we,clk=> clk,rst_async=> RST);
	IF1MSGCTRL 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if1msgctrl_in,data_out=>can_if1msgctrl_out,we =>can_if1msgctrl_we,clk=> clk,rst_async=> RST);


	IF2CMDREQ 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if2cmdreq_in,data_out=>can_if2cmdreq_out,we =>can_if2cmdreq_we,clk=> clk,rst_async=> RST);
	IF2CMDM		:	can_regiter generic map (width => size_16) port map (data_in=>can_if2cmdm_in,data_out=>can_if2cmdm_out,we =>can_if2cmdm_we,clk=> clk,rst_async=> RST);
	IF2M1		:	can_regiter generic map (width => size_16) port map (data_in=>can_if2m1_in,data_out=>can_if2m1_out,we =>can_if2m1_we,clk=> clk,rst_async=> RST);
	IF2M2		:	can_regiter generic map (width => size_16) port map (data_in=>can_if2m2_in,data_out=>can_if2m2_out,we =>can_if2m2_out,clk=> clk,rst_async=> RST);
	IF2ARBT1 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if2arbt1_in,data_out=>can_if2arbt1_out,we =>can_if2arbt1_we,clk=> clk,rst_async=> RST);
	IF2ARBT2 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if2arbt2_in,data_out=>can_if2arbt2_out,we =>can_if2arbt2_we,clk=> clk,rst_async=> RST);
	IF2MSGCTRL 	:	can_regiter generic map (width => size_16) port map (data_in=>can_if2msgctrl_in,data_out=>can_if2msgctrl_out,we =>can_if2msgctrl_we,clk=> clk,rst_async=> RST);


	TX1REQ 		:	can_regiter generic map (width => size_16) port map (data_in=>can_tx1reqreg_in,data_out=>can_tx1reqreg_out,we =>can_tx1reqreg_we,clk=> clk,rst_async=> RST);
	TX2REQ 		:	can_regiter generic map (width => size_16) port map (data_in=>can_tx2reqreg_in,data_out=>can_tx2reqreg_out,we =>can_tx2reqreg_we,clk=> clk,rst_async=> RST);

	NEWD1 		:	can_regiter generic map (width => size_16) port map (data_in=>can_newd1reg_in,data_out=>can_newd1reg_out,we =>can_newd1reg_we,clk=> clk,rst_async=> RST);
	NEWD2 		:	can_regiter generic map (width => size_16) port map (data_in=>can_newd2reg_in,data_out=>can_newd2reg_in,we =>can_newd2reg_we,clk=> clk,rst_async=> RST);

	INT1PND 	:	can_regiter generic map (width => size_16) port map (data_in=>can_int1pndreg_in,data_out=>can_int1pndreg_out,we =>can_int1pndreg_we,clk=> clk,rst_async=> RST);
	INT2PND 	:	can_regiter generic map (width => size_16) port map (data_in=>can_int2pndreg_in,data_out=>can_int2pndreg_out,we =>can_int2pndreg_we,clk=> clk,rst_async=> RST);






