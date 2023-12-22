/*
===============================================================================
File: FrequencyDivider.v
Author: Eng. Youssef Nasser
Topic: Clock Divider by PI (22/7)
===============================================================================

Description:
This Verilog module implements a clock divider by PI (approximately 22/7) to achieve a target output frequency. The goal is to divide an input clock signal (Fin) by PI, resulting in an average output frequency of 31.83 MHz, given the example where Fin is 100 MHz.

Algorithm:
1. PI is approximated to be between 3 and 4, leaning towards 3, leading to a division process involving specific pulse generation intervals.
2. The value of PI is expressed as 3 + 0.1416, which is further simplified to 3 + 177/1250 or 3 + 177/(177 + 1073).
3. The division process includes cycles of dividing by 3 for 1073 times and by 4 for 177 times.

Counters:
1. pulse_counter: A 2-bit counter generates a pulse when counting to 3 during the division process.
2. pulse_counter2: A 2-bit counter generates a pulse when counting to 4 during the division process.
3. count_divide_by_3: An 11-bit counter counts 1073 cycles during the division by 3.
4. count_divide_by_4: An 8-bit counter counts 177 cycles during the division by 4.

State Machine:
1. The state machine transitions between two states: divide by 3 and divide by 4.
2. In the divide by 3 state, pulses are generated based on pulse_counter, and count_divide_by_3 is incremented.
3. When count_divide_by_3 reaches 1072, the state transitions to divide by 4, and the counters are reset.
4. In the divide by 4 state, pulses are generated based on pulse_counter2, and count_divide_by_4 is incremented.
5. When count_divide_by_4 reaches 176, the state transitions back to divide by 3, and the counters are reset.

Output:
1. div_clk: Output divided clock with an average frequency of 31.83 MHz.
2. done: Output signal indicating the completion of the division process.

Note: The counter values can be adjusted based on specific frequency and cycle count requirements.

===============================================================================
*/

module FrequencyDivider (
    input clk,      // Input clock
    input rst_n,    // Active-low asynchronous reset
    output reg div_clk, // Output divided clock
    output reg done // Output signal indicating completion
);

  // Define state constants
  localparam STATE_DIVIDE_BY_3 = 2'b00;
  localparam STATE_DIVIDE_BY_4 = 2'b01;

  // Define state and counter variables
  reg [10:0] count_divide_by_3;
  reg [7:0] count_divide_by_4;
  reg [1:0] state;
  reg [1:0] pulse_counter;
  reg [1:0] pulse_counter2;

  // Initial state and counter values
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset values on asynchronous reset
      state <= STATE_DIVIDE_BY_3;
      count_divide_by_3 <= 0;
      count_divide_by_4 <= 0;
      pulse_counter <= 2'b00;
      pulse_counter2 <= 2'b00;
    end else begin
      // State machine logic for dividing by 3 and 4
      case (state)
        STATE_DIVIDE_BY_3:
          if (count_divide_by_3 == 1072) begin
            // Switch to divide by 4 state
            state <= STATE_DIVIDE_BY_4;
            pulse_counter <= 2'b00;
            count_divide_by_3 = 0;
          end else begin
            // Increment counters and manage pulse generation
            if (pulse_counter < 3) begin
              pulse_counter <= pulse_counter + 1;
            end else begin
              pulse_counter <= 2'b00;
              if (div_clk) begin
                count_divide_by_3 <= count_divide_by_3 + 1;
              end
            end
          end
        STATE_DIVIDE_BY_4:
          if (count_divide_by_4 == 176) begin
            // Switch back to divide by 3 state when done
            pulse_counter2 <= 0;
            state <= STATE_DIVIDE_BY_3;
            count_divide_by_4 <= 0;
          end else begin
            // Increment counter and manage pulse generation
            if (pulse_counter2 < 4) begin
              pulse_counter2 <= pulse_counter2 + 1;
            end else begin
              pulse_counter2 <= 2'b00;
            end
            if (div_clk) begin
              count_divide_by_4 <= count_divide_by_4 + 1;
            end
          end
      endcase
    end
  end

  // Output logic
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset values on asynchronous reset
      div_clk <= 1'b0;
      done <= 1'b0;
    end else begin
      // Output logic based on current state
      case (state)
        STATE_DIVIDE_BY_3: begin
          done <= 0;
          if (pulse_counter == 2) begin
            div_clk <= 1;
          end else 
            div_clk <= 0;
        end
        STATE_DIVIDE_BY_4:
          if (count_divide_by_4 == 176) begin
            // Set done signal when divide by 4 is complete
            done <= 1'b1;
          end else begin
            // Output logic for divide by 4 state
            if (pulse_counter2 == 3) begin
              div_clk <= 1;
            end else
              div_clk <= 0;
          end
      endcase
    end
  end
endmodule
