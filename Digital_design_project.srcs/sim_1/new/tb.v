`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2023 02:46:12 PM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pulse_generator_tb;

reg clk;
reg reset;
reg pulse_width;
wire pulse;
reg button;

//pulse_generator dut (
//    .clk(clk),
//    .reset(reset),
//    .pulse_width(pulse_width),
//    .pulse(pulse)
//);

debouncer dut(
    .clk(clk),
    .button(button),
    .debounced_button(pulse)
);

//initial begin
//    clk = 0;
//    reset = 1;
//    pulse_width = 0;
//    #10 reset = 0;
//    #100 $finish;
//end

always #5 clk=!clk;

initial begin
//    $monitor("Time=%0t: pulse=%d", $time, pulse);
    clk=0;button=0;
    #10 button=1;
    #40 button=0;
    #10 button=1;
    #10 button=0;
    #20
    $stop;
//    #50 pulse_width = 1;
end

endmodule

