//==============================================================
// DAY 2 : 4:1 MULTIPLEXER FROM GATE LEVEL
// File    : day2_design.v
// Language: Verilog-2001
//==============================================================


//==============================================================
// 1. NOT GATE
//==============================================================
module not_gate (
    input A,
    output Y
);

    assign Y = ~A;

endmodule


//==============================================================
// 2. AND GATE
//==============================================================
module and_gate (
    input A,
    input B,
    output Y
);

    assign Y = A & B;

endmodule


//==============================================================
// 3. OR GATE
//==============================================================
module or_gate (
    input A,
    input B,
    output Y
);

    assign Y = A | B;

endmodule


//==============================================================
// 4. 2:1 MUX USING BASIC GATES
//
// Y = (~S & I0) | (S & I1)
//
// S = 0 -> I0 selected
// S = 1 -> I1 selected
//==============================================================
module mux_2to1_gate (
    input I0,
    input I1,
    input S,
    output Y
);

    wire S_not;
    wire W0;
    wire W1;

    // NOT S
    not_gate N1 (
        .A(S),
        .Y(S_not)
    );

    // I0 path
    and_gate A1 (
        .A(I0),
        .B(S_not),
        .Y(W0)
    );

    // I1 path
    and_gate A2 (
        .A(I1),
        .B(S),
        .Y(W1)
    );

    // Output
    or_gate O1 (
        .A(W0),
        .B(W1),
        .Y(Y)
    );

endmodule


//==============================================================
// 5. 2:1 MUX BEHAVIORAL RTL
//
// This is a simpler RTL representation.
// Used to understand the difference between
// gate-level construction and RTL description.
//==============================================================
module mux_2to1 (
    input I0,
    input I1,
    input S,
    output Y
);

    assign Y = S ? I1 : I0;

endmodule


//==============================================================
// 6. 4:1 MUX USING THREE 2:1 MUXES
//
// Selection:
//
// S1 S0
//
// 0  0 -> I0
// 0  1 -> I1
// 1  0 -> I2
// 1  1 -> I3
//
// First level:
// MUX0 selects I0/I1
// MUX1 selects I2/I3
//
// Second level:
// MUX2 selects between Y0 and Y1
//==============================================================
module mux_4to1 (
    input I0,
    input I1,
    input I2,
    input I3,
    input S1,
    input S0,
    output Y
);

    wire Y0;
    wire Y1;

    // First 2:1 MUX
    mux_2to1 MUX0 (
        .I0(I0),
        .I1(I1),
        .S(S0),
        .Y(Y0)
    );

    // Second 2:1 MUX
    mux_2to1 MUX1 (
        .I0(I2),
        .I1(I3),
        .S(S0),
        .Y(Y1)
    );

    // Final 2:1 MUX
    mux_2to1 MUX2 (
        .I0(Y0),
        .I1(Y1),
        .S(S1),
        .Y(Y)
    );

endmodule


//==============================================================
// 7. 4:1 MUX USING GATE-LEVEL 2:1 MUX
//
// This top module shows the complete hierarchy:
//
// Gates
//   ↓
// 2:1 MUX
//   ↓
// 4:1 MUX
//==============================================================
module mux_4to1_gate_top (
    input I0,
    input I1,
    input I2,
    input I3,
    input S1,
    input S0,
    output Y
);

    wire Y0;
    wire Y1;

    mux_2to1_gate MUX0 (
        .I0(I0),
        .I1(I1),
        .S(S0),
        .Y(Y0)
    );

    mux_2to1_gate MUX1 (
        .I0(I2),
        .I1(I3),
        .S(S0),
        .Y(Y1)
    );

    mux_2to1_gate MUX2 (
        .I0(Y0),
        .I1(Y1),
        .S(S1),
        .Y(Y)
    );

endmodule
