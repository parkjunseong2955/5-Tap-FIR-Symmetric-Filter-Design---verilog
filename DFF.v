`timescale 1ns / 1ps

module DFF (
    input clk,                  // clock
    input rst,                  // reset
    input signed [3:0] d,       // 4-bit signed 입력
    output reg signed [3:0] q   // 4-bit signed 출력
);
    // positive clk 또는 rst 신호가 활성화될 때마다 동작
    always @(posedge clk) begin 
        if (rst)               
            q <= d;          // rst=1 일 때, 입력 d 값을 출력 q에 저장
        else
            q <= 0;       // rst=0 일 때, q를 0으로 초기화
    end
endmodule