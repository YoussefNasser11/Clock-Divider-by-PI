
Clock Divider by PI (22/7)

Objective:
Divide an input clock frequency (Fin) by PI (approximately 3.1416) to achieve a target output frequency (Fout). For example, if Fin is 100 MHz, the desired Fout is approximately 31.83 MHz.

Approach:
1. The value of PI is approximated to be between 3 and 4, closer to 3.
2. By generating pulses at specific intervals during division by 3 and 4, we aim to achieve an average frequency of 31.83 MHz.
3. PI is expressed as 3 + 0.1416, which is further simplified to 3 + 177/1250 or 3 + 177/(177+1073).
4. The division process involves dividing by 3 for 1073 cycles and by 4 for 177 cycles.

Counters:
1. Counter 1 (pulse_counter): 2-bit counter to generate a pulse when counting to 3 during the division process.
2. Counter 2 (pulse_counter2): 2-bit counter to generate a pulse when counting to 4 during the division process.
3. Counter 3 (count_divide_by_3): 11-bit counter to count 1073 pulse during the division by 3.
4. Counter 4 (count_divide_by_4): 8-bit counter to count 177 pulse during the division by 4.

State Machine:
1. The state machine transitions between two states: divide by 3 and divide by 4.
2. In the divide by 3 state, pulses are generated based on pulse_counter, and the counter count_divide_by_3 is incremented.
3. When count_divide_by_3 reaches 1072, the state transitions to divide by 4, and the counters are reset.
4. In the divide by 4 state, pulses are generated based on pulse_counter2, and the counter count_divide_by_4 is incremented.
5. When count_divide_by_4 reaches 176, the state transitions back to divide by 3, and the counters are reset.

Output:
1. div_clk: Output divided clock with an average frequency of 31.83 MHz.
2. done: Output signal indicating the completion of the division process.

Note: Adjustments can be made to the counter values based on the specific requirements of the application.
