## Clock signal (100 MHz)
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports clk]




## Reset button (CPU_RESET)
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports reset]

## Iterate push button (BTNC)
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports iterate]

##decimal point
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports dp]


## Player slide switches (SW0..SW3)
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {playerIn[0]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {playerIn[1]}]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {playerIn[2]}]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {playerIn[3]}]

## Player status LEDs (LD0..LD3)
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {playerLED[0]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {playerLED[1]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {playerLED[2]}]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {playerLED[3]}]

## 7-Segment Display Anodes (AN0..AN3 - only first 4 digits used)
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {an[0]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {an[1]}]
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {an[2]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {an[3]}]

set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { an[4] }];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { an[5] }];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { an[6] }]; 
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { an[7] }];



## 7-Segment Cathodes (CA..CG)
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {seg[0]}]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports {seg[1]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {seg[2]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {seg[3]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {seg[4]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {seg[5]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {seg[6]}]

# Optional: Unused anodes (AN4..AN7) can be left unconstrained or tied off.
# Since they are outputs, you may add them to prevent errors:
# set_property -dict {PACKAGE_PIN ... } [get_ports {an[4]}] etc.
# But our entity only has an(3 downto 0), so no need.


