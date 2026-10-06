//==============================================================
// DAY 2 : COMPLETE VERIFICATION
// File : day2_tb.v
//==============================================================

module day2_tb;


    //==========================================================
    // GATE SIGNALS
    //==========================================================

    reg A;
    reg B;

    wire NOT_Y;
    wire AND_Y;
    wire OR_Y;


    //==========================================================
    // GATE INSTANCES
    //==========================================================

    not_gate NOT1 (
        .A(A),
        .Y(NOT_Y)
    );

    and_gate AND1 (
        .A(A),
        .B(B),
        .Y(AND_Y)
    );

    or_gate OR1 (
        .A(A),
        .B(B),
        .Y(OR_Y)
    );


    //==========================================================
    // 2:1 MUX SIGNALS
    //==========================================================

    reg I0;
    reg I1;
    reg S;

    wire MUX_GATE_Y;
    wire MUX_RTL_Y;


    // Gate-level 2:1 MUX
    mux_2to1_gate MUX_GATE (
        .I0(I0),
        .I1(I1),
        .S(S),
        .Y(MUX_GATE_Y)
    );


    // Behavioral RTL 2:1 MUX
    mux_2to1 MUX_RTL (
        .I0(I0),
        .I1(I1),
        .S(S),
        .Y(MUX_RTL_Y)
    );


    //==========================================================
    // 4:1 MUX SIGNALS
    //==========================================================

    reg I2;
    reg I3;
    reg S1;
    reg S0;

    wire MUX4_Y;
    wire MUX4_GATE_Y;


    // 4:1 MUX using RTL 2:1 MUXes
    mux_4to1 MUX4 (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .S1(S1),
        .S0(S0),
        .Y(MUX4_Y)
    );


    // 4:1 MUX using gate-level 2:1 MUXes
    mux_4to1_gate_top MUX4_GATE (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .S1(S1),
        .S0(S0),
        .Y(MUX4_GATE_Y)
    );


    //==========================================================
    // TEST SEQUENCE
    //==========================================================

    initial begin

        $display("=================================================");
        $display("       DAY 2 : 4:1 MUX VERIFICATION");
        $display("=================================================");


        //======================================================
        // 1. GATE VERIFICATION
        //======================================================

        $display("");
        $display("---- 1. GATE VERIFICATION ----");


        A = 0;
        B = 0;
        #10;

        if (NOT_Y == 1 &&
            AND_Y == 0 &&
            OR_Y  == 0)
            $display("GATE TEST 00 : PASS");
        else
            $display("GATE TEST 00 : FAIL");


        A = 0;
        B = 1;
        #10;

        if (NOT_Y == 1 &&
            AND_Y == 0 &&
            OR_Y  == 1)
            $display("GATE TEST 01 : PASS");
        else
            $display("GATE TEST 01 : FAIL");


        A = 1;
        B = 0;
        #10;

        if (NOT_Y == 0 &&
            AND_Y == 0 &&
            OR_Y  == 1)
            $display("GATE TEST 10 : PASS");
        else
            $display("GATE TEST 10 : FAIL");


        A = 1;
        B = 1;
        #10;

        if (NOT_Y == 0 &&
            AND_Y == 1 &&
            OR_Y  == 1)
            $display("GATE TEST 11 : PASS");
        else
            $display("GATE TEST 11 : FAIL");


        //======================================================
        // 2. 2:1 MUX VERIFICATION
        //======================================================

        $display("");
        $display("---- 2. 2:1 MUX VERIFICATION ----");


        // S = 0 -> I0 selected
        I0 = 0;
        I1 = 1;
        S = 0;
        #10;

        if (MUX_GATE_Y == 0 &&
            MUX_RTL_Y  == 0)
            $display("2:1 MUX TEST 1 : PASS");
        else
            $display("2:1 MUX TEST 1 : FAIL");


        // S = 1 -> I1 selected
        I0 = 0;
        I1 = 1;
        S = 1;
        #10;

        if (MUX_GATE_Y == 1 &&
            MUX_RTL_Y  == 1)
            $display("2:1 MUX TEST 2 : PASS");
        else
            $display("2:1 MUX TEST 2 : FAIL");


        // I0 = 1, I1 = 0, S = 0
        I0 = 1;
        I1 = 0;
        S = 0;
        #10;

        if (MUX_GATE_Y == 1 &&
            MUX_RTL_Y  == 1)
            $display("2:1 MUX TEST 3 : PASS");
        else
            $display("2:1 MUX TEST 3 : FAIL");


        // I0 = 1, I1 = 0, S = 1
        I0 = 1;
        I1 = 0;
        S = 1;
        #10;

        if (MUX_GATE_Y == 0 &&
            MUX_RTL_Y  == 0)
            $display("2:1 MUX TEST 4 : PASS");
        else
            $display("2:1 MUX TEST 4 : FAIL");


        //======================================================
        // 3. 4:1 MUX VERIFICATION
        //======================================================

        $display("");
        $display("---- 3. 4:1 MUX VERIFICATION ----");


        // Inputs = 0 1 0 1
        I0 = 0;
        I1 = 1;
        I2 = 0;
        I3 = 1;


        // S1 S0 = 00 -> I0
        S1 = 0;
        S0 = 0;
        #10;

        if (MUX4_Y == I0 &&
            MUX4_GATE_Y == I0)
            $display("4:1 MUX S1S0=00 : PASS");
        else
            $display("4:1 MUX S1S0=00 : FAIL");


        // S1 S0 = 01 -> I1
        S1 = 0;
        S0 = 1;
        #10;

        if (MUX4_Y == I1 &&
            MUX4_GATE_Y == I1)
            $display("4:1 MUX S1S0=01 : PASS");
        else
            $display("4:1 MUX S1S0=01 : FAIL");


        // S1 S0 = 10 -> I2
        S1 = 1;
        S0 = 0;
        #10;

        if (MUX4_Y == I2 &&
            MUX4_GATE_Y == I2)
            $display("4:1 MUX S1S0=10 : PASS");
        else
            $display("4:1 MUX S1S0=10 : FAIL");


        // S1 S0 = 11 -> I3
        S1 = 1;
        S0 = 1;
        #10;

        if (MUX4_Y == I3 &&
            MUX4_GATE_Y == I3)
            $display("4:1 MUX S1S0=11 : PASS");
        else
            $display("4:1 MUX S1S0=11 : FAIL");


        //======================================================
        // 4. SECOND INPUT PATTERN
        //======================================================

        $display("");
        $display("---- 4:1 MUX SECOND INPUT PATTERN ----");

        I0 = 1;
        I1 = 0;
        I2 = 1;
        I3 = 0;


        S1 = 0;
        S0 = 0;
        #10;

        if (MUX4_Y == 1 &&
            MUX4_GATE_Y == 1)
            $display("PATTERN 2 S=00 : PASS");
        else
            $display("PATTERN 2 S=00 : FAIL");


        S1 = 0;
        S0 = 1;
        #10;

        if (MUX4_Y == 0 &&
            MUX4_GATE_Y == 0)
            $display("PATTERN 2 S=01 : PASS");
        else
            $display("PATTERN 2 S=01 : FAIL");


        S1 = 1;
        S0 = 0;
        #10;

        if (MUX4_Y == 1 &&
            MUX4_GATE_Y == 1)
            $display("PATTERN 2 S=10 : PASS");
        else
            $display("PATTERN 2 S=10 : FAIL");


        S1 = 1;
        S0 = 1;
        #10;

        if (MUX4_Y == 0 &&
            MUX4_GATE_Y == 0)
            $display("PATTERN 2 S=11 : PASS");
        else
            $display("PATTERN 2 S=11 : FAIL");


        //======================================================
        // FINAL
        //======================================================

        $display("");
        $display("=================================================");
        $display("       DAY 2 VERIFICATION COMPLETED");
        $display("=================================================");

        $finish;

    end

endmodule
