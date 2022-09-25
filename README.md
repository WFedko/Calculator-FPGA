# Calculator-FPGA

The calculator was designed in Vivado in Verilog language.
Available operations is addition and subtraction of 10-digit numbers.
The target device is Arty S7-50.

The repository contains below files:
- top_module - the main module with creation of instances of other modules and display controling,
- fsm - state machine,
- alu - arthmetic logic unit,
- keypad - keypad handling,
- lcd_display - display driver,
- debouncer - elimination of contact vibration.
- testbench_fsm - validation of fsm,
- testbench_alu - validation of alu.

An example of working is available to see: https://youtu.be/7b2oaKTJFfQ
