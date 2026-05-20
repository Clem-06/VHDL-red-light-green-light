# COEN 313 – Red Light Green Light (FPGA)

**Author:** Clement Lepage (40308494)

A 4-player *Red Light, Green Light* game implemented in VHDL on a **Nexys A7-100T FPGA**, using a Mealy state machine and 7-segment display output.

## How It Works

The game runs for up to 10 iterations. Each iteration cycles through **Idle → Green → Red → Done** states. Players must stop moving during red — those still moving are eliminated. The last player standing wins.

- **Tie condition:** if no winner after 10 iterations, all four players blink
- **7-segment displays** show all 4 player scores simultaneously (1 digit each), remaining time in `seconds.tenths`, and the current iteration number
- Scores (0–12) and iteration counts above 9 use hex digits (`A`, `B`) to fit one display

## Design

The core is a **Mealy state machine** with four states: `Idle`, `Red`, `Green`, `Done`. A tick generator divides the 100 MHz FPGA clock down to human-readable timing (1 tick per 100,000 cycles in hardware; 1 tick/cycle in simulation).

Display multiplexing uses the anode/cathode method to drive all segments from a single output bus, with an integer-to-7-segment conversion function.

## Resources

- [VHDL 7-segment display – fpga4student](https://www.fpga4student.com/2017/09/vhdl-code-for-seven-segment-display.html)
- [VHDL digital clock on FPGA – fpga4student](https://www.fpga4student.com/2016/11/vhdl-code-for-digital-clock-on-fpga.html)
- [Nexys A7-100T Master XDC – Digilent](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-100T-Master.xdc)

📄 [Full design report](./Clement_Lepage_40308494.pdf)
