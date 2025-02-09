`timescale 1ns / 1ps

module tb_FIR_filter;

    reg clk;                // clock
    reg rst;                // reset
    reg signed [3:0] din;   // 4-bit signed 입력
    wire signed [9:0] dout; // FIR filter의 10-bit signed 출력

    // FIR_filter를 uut로 인스턴스화 후 이름에 의한 연결
    FIR_filter uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout)
    );

    integer i;              // test 입력 생성을 위한 변수 i
    
    initial begin
        clk = 1'b1;         // 초기 clock 신호 설정
        rst = 1'b0;         // 초기 reset 신호 비활성화
        #7 rst = 1'b1;      // 7ns 후 reset 신호 활성화
    end
    always #5 clk = ~clk;   // 10ns 주기의 clock 생성

    initial begin
        din = 4'b0;         // din 초기값을 0으로 설정
        wait(rst == 1'b1);  // reset이 활성화될 때까지 대기

        // step1: i를 -7부터 7까지 증가시키면서 입력 신호 생성
        for (i = -7; i <= 7; i = i + 1)
            repeat (4) @(posedge clk) din = i;

        // step2: i를 7부터 -7까지 감소시키면서 입력 신호 생성
        for (i = 7; i > -7; i = i - 1)
            repeat (4) @(posedge clk) din = i;

        // step3: i가 -7부터 7까지 반복, 양수와 음수를 번갈아가며 입력
        for (i = -7; i <= 7; i = i + 1) begin
            repeat (4) @(posedge clk) din = i;   // 양수 입력
            repeat (4) @(posedge clk) din = -i;  // 음수 입력
        end

        #40 $stop; // 40ns 후 simulation 종료
    end
endmodule
