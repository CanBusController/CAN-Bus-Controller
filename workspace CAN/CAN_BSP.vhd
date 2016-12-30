library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity can_bsp is
    port(
            clk :        in std_logic;
            rst :        in std_logic;
            process_bit :in std_logic ;
            rcv_bit:     in std_logic;
            bit_err:     in std_logic;
            tr_rqst:     in std_logic;
            tr_msg:      in std_logic;

            hard_sync_en:out std_logic;
            bus_drive:   out std_logic;
            tr_rqst_stat:out std_logic;
            rcv_msg:     out std_logic
        );
end entity ;

architecture arch_can_bsp of can_bsp is
    type can_status_type is (BOR, WFBI, I, RCV, TRAN);
    signal ps: can_status_type:=WFBI ;
    signal ns: can_status_type:=WFBI ;
    signal recessive_counter : std_logic_vector(3 downto 0):=X"0";
    signal read_11_recessive_bits : std_logic := '0';
begin

    sync_process:process(clk)
    begin
        if ( rst = '1' ) then
            ps<=WFBI;
        elsif ( clk = '1' ) then
            ps <= ns ;
        end if;
    end process ;

    bsp_engine:process(clk, rst, ns)
    begin
        if ( rst = '1' ) then
            --initialization 
            ns<=WFBI;
            read_11_recessive_bits<='0';
            recessive_counter<=(others=>'0');
        elsif ( clk'event and clk='1') then
            if ( process_bit='1') then
            --stuff assignement
            --error status assignement
                case ps is
                --when BOR =>
                    when WFBI =>
                        hard_sync_en <= '1';
                        if ( rcv_bit ='1' ) then
                            if ( recessive_counter < X"B") then
                                recessive_counter<=std_logic_vector(to_unsigned(to_integer(unsigned( recessive_counter )) + 1, 4));
                            end if ;
                        elsif ( rcv_bit='0' ) then
                            recessive_counter<=(others=>'0');
                        end if;
                        if (recessive_counter = X"B") then    
                            if ( tr_rqst ='1' ) then
                                ns<=TRAN;
                            else
                                ns<=I;
                            end if;
                        end if ;
              --             when I =>
              --               when RCV =>
              --               when TRAN =>
                    when others => 
                        hard_sync_en <= '0';
                end case ;
            --    elsif adjust_error_counters'event and adjust_error_counters='1' then
            --adjustement assignements
            end if;
        end if;
    end process;

end arch_can_bsp;
