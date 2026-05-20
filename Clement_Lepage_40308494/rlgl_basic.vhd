library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rlgl_basic is
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;   -- active HIGH (CPU_RESET)
           iterate   : in  STD_LOGIC;
           playerIn  : in  STD_LOGIC_VECTOR(3 downto 0);
           playerLED : out STD_LOGIC_VECTOR(3 downto 0);
           seg       : out STD_LOGIC_VECTOR(6 downto 0);
           an        : out STD_LOGIC_VECTOR(7 downto 0);
           dp        : out STD_LOGIC
         );
end rlgl_basic;

architecture Behavioral of rlgl_basic is
-- display
signal disp_val    : integer range 0 to 1200;     -- value in tenths (0-600 for time, 0-120 for dist)
signal digit_sel   : integer range 0 to 7 := 0;
signal ref_cnt     : integer range 0 to 99999 := 0;
signal tie         : std_logic := '0';


    type state_type is (IDLE, GREEN, RED, DONE);
    signal state : state_type := IDLE;

    signal iteration    : integer range 1 to 10 := 1;
    signal nominal_time : integer range 0 to 600 := 600;
    signal timer        : integer range 0 to 600 := 0;

    signal tick_cnt : integer range 0 to 999999 := 0;
    signal tick     : STD_LOGIC := '0';

    signal elim0, elim1, elim2, elim3 : STD_LOGIC := '0';
    signal dist0, dist1, dist2, dist3 : integer range 0 to 1200 := 0;  -- cm

    signal winner    : integer range 0 to 3 := 0;
    signal game_over : STD_LOGIC := '0';

    -- Edge detection for iterate
    signal iter_sync1, iter_sync2 : STD_LOGIC := '0';
    signal iter_pulse            : STD_LOGIC;

    -- Winner blink
    signal blink_tog : STD_LOGIC := '0';
    signal blink_cnt : integer range 0 to 49999999 := 0;

    function seg7(d : integer range 0 to 9) return STD_LOGIC_VECTOR is
    begin
        case d is
            when 0 => return "1000000";
            when 1 => return "1111001";
            when 2 => return "0100100";
            when 3 => return "0110000";
            when 4 => return "0011001";
            when 5 => return "0010010";
            when 6 => return "0000010";
            when 7 => return "1111000";
            when 8 => return "0000000";
            when 9 => return "0010000";
            when 10 => return "0001000";   -- A --representing 11and so on 
when 11 => return "0000011";   -- b
when others => return "1000110";   -- C default
        end case;
    end function;

begin

    -- 10 ms tick
    process(clk)
    begin
        if rising_edge(clk) then
            tick <= '0';
            if reset = '1' then
                tick_cnt <= 0;
            elsif tick_cnt = 999999 then
                tick_cnt <= 0;
                tick <= '1';
            else
                tick_cnt <= tick_cnt + 1;
            end if;
        end if;
    end process;

    -- Iterate edge detect
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                iter_sync1 <= '0';
                iter_sync2 <= '0';
            else
                iter_sync1 <= iterate;
                iter_sync2 <= iter_sync1;
            end if;
        end if;
    end process;
    iter_pulse <= iter_sync1 and not iter_sync2;

    -- Main FSM
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
                iteration <= 1;
                nominal_time <= 600;
                timer <= 0;
                game_over <= '0';
                winner <= 0;
                elim0 <= '0'; elim1 <= '0'; elim2 <= '0'; elim3 <= '0';
                dist0 <= 0; dist1 <= 0; dist2 <= 0; dist3 <= 0;
            else
                case state is
                    when IDLE =>
                        if iter_pulse = '1' and game_over = '0' then
                            -- ensure at least one player alive
                            if not (elim0='1' and elim1='1' and elim2='1' and elim3='1') then
                                state <= GREEN;
                                timer <= nominal_time;
                            end if;
                        end if;

                    when GREEN =>
                        if tick = '1' then
                            if timer > 0 then
                                timer <= timer - 1;
                            end if;

                            -- Update distances (1 cm per tick)
                            if elim0='0' and playerIn(0)='1' then
                                if dist0 >= 1199 then game_over <= '1'; winner <= 0;
                                else dist0 <= dist0 + 1; end if;
                            end if;
                            if elim1='0' and playerIn(1)='1' then
                                if dist1 >= 1199 then game_over <= '1'; winner <= 1;
                                else dist1 <= dist1 + 1; end if;
                            end if;
                            if elim2='0' and playerIn(2)='1' then
                                if dist2 >= 1199 then game_over <= '1'; winner <= 2;
                                else dist2 <= dist2 + 1; end if;
                            end if;
                            if elim3='0' and playerIn(3)='1' then
                                if dist3 >= 1199 then game_over <= '1'; winner <= 3;
                                else dist3 <= dist3 + 1; end if;
                            end if;
                        end if;

                        if game_over = '1' then
                            state <= DONE;
                        elsif timer = 0 then
                            state <= RED;
                        end if;

                    when RED =>
                        -- Eliminate movers
                        if elim0='0' and playerIn(0)='1' then elim0 <= '1'; end if;
                        if elim1='0' and playerIn(1)='1' then elim1 <= '1'; end if;
                        if elim2='0' and playerIn(2)='1' then elim2 <= '1'; end if;
                        if elim3='0' and playerIn(3)='1' then elim3 <= '1'; end if;

                        if iteration = 10 or (elim0='1' and elim1='1' and elim2='1' and elim3='1') then
                            state <= DONE;
                            game_over <= '1';
                            --tie
                            
                            if dist1< 1200 and dist1< 1200 and dist1< 1200 and dist1< 1200 then
                            tie <= '1';
                            end if; 
                        else
                            iteration <= iteration + 1;
                            nominal_time <= nominal_time * 3 / 4;
                            state <= IDLE;    -- wait for next button press
                        end if;

                    when DONE =>
                        null;
                end case;
            end if;
        end if;
    end process;

    -- Winner blink counter
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                blink_cnt <= 0;
                blink_tog <= '0';
            elsif blink_cnt = 49999999 then
                blink_cnt <= 0;
                blink_tog <= not blink_tog;
            else
                blink_cnt <= blink_cnt + 1;
            end if;
        end if;
    end process;

    -- LED control with winner blink
    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to 3 loop
             if tie = '1' then
             playerLED(i) <= '0';
             
                elsif (game_over = '1' and winner = i )  then
                    playerLED(i) <= blink_tog;
                elsif (i=0 and elim0='1') or (i=1 and elim1='1') or
                      (i=2 and elim2='1') or (i=3 and elim3='1') then
                    playerLED(i) <= '0';
                else
                    playerLED(i) <= '1';
                end if;
            end loop;
        end if;
    end process;

--DISPLAY:
process(clk)
begin
    if rising_edge(clk) then
        if state = GREEN then
            disp_val <= timer / 10;   -- tenths
        else
            disp_val <= 0;            
        end if;
    end if;
end process;

-- 8-digit scanning and segment drive (fully synchronous)
process(clk)
    variable sec, tens_sec : integer range 0 to 9;
    variable meters         : integer range 0 to 12;
begin
    if rising_edge(clk) then
        if reset = '1' then
            ref_cnt   <= 0;
            digit_sel <= 0;
        elsif ref_cnt = 99999 then
            ref_cnt <= 0;
            if digit_sel = 7 then
                digit_sel <= 0;
            else
                digit_sel <= digit_sel + 1;
            end if;
        else
            ref_cnt <= ref_cnt + 1;
        end if;

        -- 2. Select digit value and decimal point based on digit_sel
        an <= (others => '1');     
        an(digit_sel) <= '0';      


        seg   <= (others => '1');
        dp    <= '1';

        case digit_sel is

            when 0 =>
                -- blank
                null;

            when 1 =>
                seg <= seg7(disp_val mod 10);             

            when 2 =>
                -- units of seconds
                sec := disp_val / 10;
                seg <= seg7(sec mod 10);
                dp  <= '0';  --decimal point

            when 3 =>
                seg <= seg7(iteration);

            ----PLAYER metre digits
            when 4 =>
                meters := dist0 / 100;   -- whole metres
                seg <= seg7(meters);
            when 5 =>
                meters := dist1 / 100;
                seg <= seg7(meters);
            when 6 =>
                meters := dist2 / 100;
                seg <= seg7(meters);
            when 7 =>
                meters := dist3 / 100;
                seg <= seg7(meters);
        end case;
    end if;
end process;
end Behavioral;



