module bottle_tb;

  // Testbench signals
  reg CLK_org;
  reg CLK_Music;
  reg isWork;
  reg EN_work;
  reg EN_set;
  reg SET;
  reg conti;
  reg PrintB;
  reg mode_EN;
  reg set_low_D, set_low_C, set_low_B, set_low_A;
  reg set_high_D, set_high_C, set_high_B, set_high_A;
  wire light6_D, light6_C, light6_B, light6_A;
  wire light5_D, light5_C, light5_B, light5_A;
  wire light4_D, light4_C, light4_B, light4_A;
  wire light3_D, light3_C, light3_B, light3_A;
  wire light2_D, light2_C, light2_B, light2_A;
  wire light1_a, light1_b, light1_c, light1_d, light1_e, light1_f, light1_g;
  wire Speaker;

  // Instantiate the design under test (DUT)
  bottle uut (
    .CLK_org(CLK_org),
    .CLK_Music(CLK_Music),
    .isWork(isWork),
    .EN_work(EN_work),
    .EN_set(EN_set),
    .SET(SET),
    .conti(conti),
    .PrintB(PrintB),
    .mode_EN(mode_EN),
    .light6_D(light6_D), .light6_C(light6_C), .light6_B(light6_B), .light6_A(light6_A),
    .light5_D(light5_D), .light5_C(light5_C), .light5_B(light5_B), .light5_A(light5_A),
    .light4_D(light4_D), .light4_C(light4_C), .light4_B(light4_B), .light4_A(light4_A),
    .light3_D(light3_D), .light3_C(light3_C), .light3_B(light3_B), .light3_A(light3_A),
    .light2_D(light2_D), .light2_C(light2_C), .light2_B(light2_B), .light2_A(light2_A),
    .light1_a(light1_a), .light1_b(light1_b), .light1_c(light1_c), .light1_d(light1_d),
    .light1_e(light1_e), .light1_f(light1_f), .light1_g(light1_g),
    .set_low_D(set_low_D), .set_low_C(set_low_C), .set_low_B(set_low_B), .set_low_A(set_low_A),
    .set_high_D(set_high_D), .set_high_C(set_high_C), .set_high_B(set_high_B), .set_high_A(set_high_A),
    .Speaker(Speaker)
  );

  // Clock generation
  initial begin
    CLK_org = 0;
    forever #5 CLK_org = ~CLK_org; // 100 MHz clock
  end

  initial begin
    CLK_Music = 0;
    forever #10 CLK_Music = ~CLK_Music; // 50 MHz clock
  end

  // Test sequence
  initial begin
    // Initialize inputs
    $dumpfile("bottle_wave.vcd");
    $dumpvars(0, bottle_tb);
    isWork = 0;
    EN_work = 0;
    EN_set = 0;
    SET = 0;
    conti = 0;
    PrintB = 0;
    mode_EN = 0;
    set_low_D = 0; set_low_C = 0; set_low_B = 0; set_low_A = 0;
    set_high_D = 0; set_high_C = 0; set_high_B = 0; set_high_A = 0;

    // Wait for global reset
    #100;

    // Apply test vectors
    // Example: Simulate setting the system
    EN_set = 1;
    SET = 1;
    set_low_D = 1;
    set_low_C = 1;
    set_low_B = 1;
    set_low_A = 1;
    #20;
    EN_set = 0;
    SET = 0;
    
    // Add more test sequences here

    // Finish simulation after a certain time
    #1000 $finish;
  end

endmodule
