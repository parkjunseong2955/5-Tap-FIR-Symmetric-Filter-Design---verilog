`timescale 1ns / 1ps

module FIR_filter (
    input clk,                  // clock
    input rst,                  // reset
    input signed [3:0] din,     // 4-bit signed 입력
    output signed [9:0] dout    // 10-bit signed 출력
);
    // parameter를 이용한 coefficient 설정
    parameter signed [3:0] coeff0 = 4'b0001;  // coeff0 값 (1)
    parameter signed [3:0] coeff1 = 4'b0011;  // coeff1 값 (3)
    parameter signed [3:0] coeff2 = 4'b0110;  // coeff2 값 (6)

    wire signed [3:0] delay1, delay2, delay3, delay4, delay5; // D F/F을 거친 4-bit delay 성분
    
    // D Flip-Flop을 거쳐서 나오는 delay 성분으로 사용
    DFF dff1 (.clk(clk), .rst(rst), .d(din), .q(delay1));      // D F/F 1
    DFF dff2 (.clk(clk), .rst(rst), .d(delay1), .q(delay2));   // D F/F 2
    DFF dff3 (.clk(clk), .rst(rst), .d(delay2), .q(delay3));   // D F/F 3
    DFF dff4 (.clk(clk), .rst(rst), .d(delay3), .q(delay4));   // D F/F 4
    DFF dff5 (.clk(clk), .rst(rst), .d(delay4), .q(delay5));   // D F/F 5
    
    // 곱셈 연산 결과 (4-bit signed 두 개 요소의 곱 -> 7-bit signed)
    wire signed [6:0] mul0 = delay1 * coeff0;
    wire signed [6:0] mul1 = delay2 * coeff1;
    wire signed [6:0] mul2 = delay3 * coeff2;
    wire signed [6:0] mul3 = delay4 * coeff1;
    wire signed [6:0] mul4 = delay5 * coeff0;
    
    wire signed [9:0] sum; //각각의 곱셈 결과를 합하여 sum 생성
    assign sum = mul0 + mul1 + mul2 + mul3 + mul4;
    
    DFF_10bit dff6 (.clk(clk), .rst(rst), .d(sum), .q(dout));  // 최종 D F/F 6
    
endmodule
