# Day 2 — 4:1 Multiplexer

<p align="center">
  <b>Digital VLSI • Verilog RTL • Functional Verification • Cadence Genus</b>
</p>

<p align="center">
  <code>Specification → Architecture → RTL → Testbench → Simulation → Verification → Synthesis → PPA → Documentation</code>
</p>

---

## 1. Project Information

| Item                   | Details                              |
| ---------------------- | ------------------------------------ |
| Project                | Day 2                                |
| Design Title           | `mux_4to1`                           |
| Synthesized Top Module | `mux_4to1_gate_top`                  |
| Domain                 | Digital VLSI / RTL Design            |
| HDL                    | Verilog HDL                          |
| Design Type            | Combinational Data-Path Circuit      |
| Verification           | Directed Self-Checking RTL Testbench |
| Architecture           | 3 × 2:1 MUX hierarchy                |
| Synthesis Tool         | Cadence Genus                        |
| Genus Version          | 21.14-s082_1                         |
| Technology Library     | `tsmc18`                             |
| Operating Condition    | `slow (balanced_tree)`               |
| Wireload Mode          | `enclosed`                           |
| Area Mode              | `timing library`                     |
| Status                 | **Completed**                        |

---

## 2. Project Overview

This project implements a **4:1 multiplexer** using three hierarchical **2:1 multiplexers**.

A 4:1 MUX selects one of four one-bit inputs and forwards it to one output according to the two-bit select input.

| `S[1:0]` | Selected Input | Output   |
| -------- | -------------- | -------- |
| `00`     | `I0`           | `Y = I0` |
| `01`     | `I1`           | `Y = I1` |
| `10`     | `I2`           | `Y = I2` |
| `11`     | `I3`           | `Y = I3` |

---

## 3. Objective

* Understand multiplexer operation.
* Design a 4:1 MUX hierarchically from 2:1 MUXes.
* Write synthesizable structural Verilog.
* Develop a self-checking testbench.
* Verify all four select conditions.
* Understand the hardware inferred by RTL.
* Perform RTL simulation.
* Synthesize the design using Cadence Genus.
* Analyze synthesized hierarchy, area, timing and power.
* Document actual PPA results.
* Build a professional GitHub portfolio project.

---

## 4. Concept

A multiplexer is a combinational data selector.

For `N` data inputs, the number of select lines is:

$$
S=\log_2(N)
$$

For a 4:1 MUX:

$$
S=\log_2(4)=2
$$

Therefore, two select lines are required to select one of four inputs.

---

## 5. Hardware Architecture

```text
                 S[0]
                  │
          ┌───────┴───────┐
          │               │
        I0,I1           I2,I3
          │               │
       ┌──────┐         ┌──────┐
       │ MUX0 │         │ MUX1 │
       └──┬───┘         └──┬───┘
          │                  │
          │ Y0               │ Y1
          └────────┬─────────┘
                   │
                 ┌──────┐
                 │ MUX2 │
                 └──┬───┘
                    │
                    Y
                    ▲
                    │
                   S[1]
```

### Hierarchy

```text
mux_4to1
│
├── MUX0 : mux_2to1
├── MUX1 : mux_2to1
└── MUX2 : mux_2to1
```

The first stage uses `S[0]`.

The second stage uses `S[1]`.

### Synthesized Genus Hierarchy

```text
mux_4to1_gate_top
│
├── MUX0 : mux_2to1_gate
│   ├── A1 : and_gate
│   ├── A2 : and_gate_10
│   └── O1 : or_gate
│
├── MUX1 : mux_2to1_gate_12
│   ├── A1 : and_gate_9
│   ├── A2 : and_gate_8
│   └── O1 : or_gate_14
│
└── MUX2 : mux_2to1_gate_11
    ├── A1 : and_gate_7
    ├── A2 : and_gate_6
    └── O1 : or_gate_13
```

The supplied Genus hierarchy report shows the three 2:1 MUX stages and does not identify an unresolved blackbox.

---

## 6. Boolean Function

$$
Y =
\overline{S_1}\overline{S_0}I_0+
\overline{S_1}S_0I_1+
S_1\overline{S_0}I_2+
S_1S_0I_3
$$

The RTL implements the same function through hierarchical 2:1 MUX blocks.

---

## 7. Functional Specification

### Inputs

| Signal | Width | Description  |
| ------ | ----: | ------------ |
| `I0`   |     1 | Data input 0 |
| `I1`   |     1 | Data input 1 |
| `I2`   |     1 | Data input 2 |
| `I3`   |     1 | Data input 3 |
| `S`    |     2 | Select input |

### Output

| Signal | Width | Description     |
| ------ | ----: | --------------- |
| `Y`    |     1 | Selected output |

This is a **combinational** circuit. No clock or reset is required.

---

## 8. RTL Design

The design is structurally composed of three 2:1 MUX instances.

```text
Y0 = S[0] ? I1 : I0
Y1 = S[0] ? I3 : I2
Y  = S[1] ? Y1 : Y0
```

### RTL Source

```text
rtl/day2_design.v
```

### 2:1 MUX

```verilog
module mux_2to1 (
    input I0, I1, S,
    output Y
);
    assign Y = S ? I1 : I0;
endmodule
```

### 4:1 MUX

```verilog
module mux_4to1 (
    input I0, I1, I2, I3,
    input [1:0] S,
    output Y
);
    wire Y0, Y1;

    mux_2to1 MUX0 (
        .I0(I0),
        .I1(I1),
        .S(S[0]),
        .Y(Y0)
    );

    mux_2to1 MUX1 (
        .I0(I2),
        .I1(I3),
        .S(S[0]),
        .Y(Y1)
    );

    mux_2to1 MUX2 (
        .I0(Y0),
        .I1(Y1),
        .S(S[1]),
        .Y(Y)
    );
endmodule
```

---

## 9. Verification

The testbench is a directed, self-checking RTL testbench.

It checks:

1. `S=00` selects `I0`.
2. `S=01` selects `I1`.
3. `S=10` selects `I2`.
4. `S=11` selects `I3`.
5. Additional input patterns.
6. Actual DUT output against expected value.
7. PASS/FAIL conditions.

### Testbench Source

```text
tb/day2_tb.v
```

### Verification Method

```text
Apply Inputs
     ↓
Apply Select
     ↓
Calculate Expected Output
     ↓
Compare DUT Output
     ↓
PASS / FAIL
```

### Verification Result

**RTL functional verification completed successfully according to the supplied simulation/testbench result.**

> This project does not claim gate-level simulation, formal verification, UVM, constrained-random verification, or functional coverage.

---

## 10. Test Cases

The Day-2 testbench contains **12 directed test cases**.

| Test | `I3 I2 I1 I0` | `S`  | Expected `Y` |
| ---: | ------------- | ---- | -----------: |
|    1 | `0001`        | `00` |            1 |
|    2 | `0010`        | `01` |            1 |
|    3 | `0100`        | `10` |            1 |
|    4 | `1000`        | `11` |            1 |
|    5 | `1110`        | `00` |            0 |
|    6 | `1110`        | `01` |            1 |
|    7 | `1110`        | `10` |            1 |
|    8 | `1110`        | `11` |            1 |
|    9 | `0001`        | `00` |            1 |
|   10 | `0001`        | `01` |            0 |
|   11 | `0001`        | `10` |            0 |
|   12 | `0001`        | `11` |            0 |

All four select combinations are exercised.

### Simulation Output

Store the actual simulator output at:

```text
simulation/console_output.txt
```

Do not manually fabricate PASS/FAIL output.

---

## 11. Simulation

### Expected Selection

```text
S = 00  →  Y = I0
S = 01  →  Y = I1
S = 10  →  Y = I2
S = 11  →  Y = I3
```

### Simulation Evidence

```text
images/
├── rtl_waveform.png
├── simulation_result.png
└── synthesis_hierarchy.png
```

Use the actual filenames generated by the project.

The waveform should demonstrate:

* `I0`
* `I1`
* `I2`
* `I3`
* `S[1:0]`
* `Y`

---

## 12. Synthesis Flow

```text
Verilog RTL
     ↓
Elaboration
     ↓
Logic Synthesis
     ↓
Technology Mapping
     ↓
Mapped Netlist
     ↓
Area / Timing / Power
```

### Cadence Genus Configuration

| Parameter           | Actual Value           |
| ------------------- | ---------------------- |
| Tool                | Cadence Genus          |
| Version             | 21.14-s082_1           |
| Top Module          | `mux_4to1_gate_top`    |
| Technology Library  | `tsmc18`               |
| Operating Condition | `slow (balanced_tree)` |
| Wireload Mode       | `enclosed`             |
| Area Mode           | `timing library`       |
| Report Date         | Sep 27, 2026           |

---

## 13. Area

The actual Genus hierarchical area report gives:

| Metric             |      Result |
| ------------------ | ----------: |
| Total cell count   |      **12** |
| Cell area          | **139.709** |
| Net area           |   **0.000** |
| Total area         | **139.709** |
| Physical cell area |   **0.000** |

The reported area is in the library/tool area units shown by Genus. It is **not labeled as µm²** in the supplied report, so no unsupported unit conversion is made.

### Hierarchical Area

| Hierarchy           | Cell Count |        Area |
| ------------------- | ---------: | ----------: |
| `mux_4to1_gate_top` |         12 | **139.709** |
| `MUX0`              |          4 |      46.570 |
| `MUX1`              |          4 |      46.570 |
| `MUX2`              |          4 |      46.570 |

The approximately 0.001 difference between rounded child totals and the top-level value is a report-rounding effect.

---

## 14. Cell Area Breakdown

Cadence Genus reported:

| Cell      | Instances |        Area | Library  |
| --------- | --------: | ----------: | -------- |
| `AND2X1`  |         6 |      79.834 | `tsmc18` |
| `INVXL`   |         3 |      19.958 | `tsmc18` |
| `OR2X1`   |         2 |      26.611 | `tsmc18` |
| `OR2XL`   |         1 |      13.306 | `tsmc18` |
| **Total** |    **12** | **139.709** |          |

### Area Distribution

| Type           | Instances |        Area |   Area % |
| -------------- | --------: | ----------: | -------: |
| Inverter       |         3 |      19.958 |    14.3% |
| Logic          |         9 |     119.750 |    85.7% |
| Physical cells |         0 |       0.000 |     0.0% |
| **Total**      |    **12** | **139.709** | **100%** |

### Area Observation

The synthesized design contains:

```text
6 × AND2X1
3 × INVXL
2 × OR2X1
1 × OR2XL
----------------
12 total cells
```

---

## 15. Timing

This is a combinational circuit, so the reported timing path is an input-to-output data path.

### Actual Genus Timing Result

```text
Path 1: UNCONSTRAINED

Startpoint: S0
Endpoint:   Y
Data Path:  835 ps
```

Therefore:

$$
T_{path}=835\ ps
$$

$$
\boxed{T_{path}=0.835\ ns}
$$

### Timing Path

```text
S0
 ↓
AND2X1
 ↓
OR2X1
 ↓
AND2X1
 ↓
OR2XL
 ↓
Y
```

### Path Breakdown

| Timing Point    | Cell     | Incremental Delay |    Arrival |
| --------------- | -------- | ----------------: | ---------: |
| `S0`            | Input    |              0 ps |       0 ps |
| `MUX1/A2/.../Y` | `AND2X1` |            188 ps |     188 ps |
| `MUX1/O1/.../Y` | `OR2X1`  |            244 ps |     432 ps |
| `MUX2/A2/.../Y` | `AND2X1` |            189 ps |     621 ps |
| `MUX2/O1/.../Y` | `OR2XL`  |            214 ps |     835 ps |
| `Y`             | Output   |              0 ps | **835 ps** |

The reported delay is:

$$
835 = 188+244+189+214\ ps
$$

### Timing Status

The Genus report explicitly identifies the path as:

```text
UNCONSTRAINED
```

Therefore, this project does **not** claim:

* setup timing closure
* hold timing closure
* timing slack
* maximum operating frequency
* clock-period compliance
* timing constraint satisfaction

The valid result is:

> **S0 → Y combinational data-path delay = 835 ps = 0.835 ns under the supplied Genus analysis configuration.**

---

## 16. Power

The actual Genus power report was generated for:

```text
Instance: /mux_4to1_gate_top
Power Unit: W
PDB Frame: /stim#0/frame#0
```

### Total Power

$$
P_{total}=4.15203\times10^{-6}W
$$

$$
\boxed{P_{total}=4.15203\ \mu W}
$$

### Power Breakdown

| Metric    |          Power | Percentage |
| --------- | -------------: | ---------: |
| Internal  |     2.90064 µW |     69.86% |
| Switching |     1.24561 µW |     30.00% |
| Leakage   |  0.00578159 µW |      0.14% |
| **Total** | **4.15203 µW** |   **100%** |

### Power Observation

The majority of the reported power is internal power:

$$
69.86\%
$$

Switching power contributes:

$$
30.00\%
$$

Leakage contributes:

$$
0.14\%
$$

The power result is specific to the reported stimulus frame, library, operating condition and power-analysis configuration.

---

## 17. PPA

PPA represents:

* **Power**
* **Performance**
* **Area**

### Day-2 Actual PPA

| PPA Metric              |                  Actual Result |
| ----------------------- | -----------------------------: |
| **Power**               |                 **4.15203 µW** |
| **Performance / Delay** |                   **0.835 ns** |
| **Area**                | **139.709 library area units** |
| Cell Count              |                         **12** |

### Primary Results

```text
┌───────────────────────────────────┐
│       DAY 2 — PPA RESULTS         │
├───────────────────────────────────┤
│ Area   : 139.709                  │
│ Power  : 4.15203 µW               │
│ Delay  : 0.835 ns                 │
│ Cells  : 12                       │
│ Timing : UNCONSTRAINED            │
└───────────────────────────────────┘
```

These are the actual values reported by Cadence Genus for the supplied run.

No unsupported PPA conclusion is made beyond these measured values.

---

## 18. Optimization Study

A useful future comparison is:

### Structural RTL

```text
3 × 2:1 MUX hierarchy
```

### Behavioral RTL

```verilog
assign Y = I[S];
```

Equivalent behavioral RTL can also be implemented using a `case` statement.

After synthesis, compare:

* synthesized cell count
* area
* timing
* power
* logic depth
* readability

Do not assume that structurally different RTL descriptions necessarily produce different hardware. Synthesis optimization can map equivalent RTL descriptions into similar hardware.

### Current Status

No optimization improvement is claimed because only the current implementation has been synthesized and measured.

---

## 19. Common Mistakes

### Select Mapping

Correct:

```text
00 → I0
01 → I1
10 → I2
11 → I3
```

### Structural Mapping

First stage:

```text
MUX0: I0 / I1 using S[0]
MUX1: I2 / I3 using S[0]
```

Second stage:

```text
MUX2: Y0 / Y1 using S[1]
```

### Other Common Mistakes

* Reversing `S[1]` and `S[0]`.
* Swapping `I2` and `I3`.
* Testing only one select condition.
* Using an incomplete testbench.
* Confusing RTL simulation success with synthesis/PPA results.
* Claiming timing closure from an unconstrained path.
* Treating library area units as `µm²` without confirming the library unit.

---

## 20. Verification Status

| Item                            | Status                              |
| ------------------------------- | ----------------------------------- |
| Specification                   | **Complete**                        |
| Architecture                    | **Complete**                        |
| RTL                             | **Complete**                        |
| Testbench                       | **Complete**                        |
| Directed simulation             | **Complete**                        |
| Four select conditions          | **Covered**                         |
| Self-checking verification      | **Complete**                        |
| Waveform evidence               | **Available / upload actual image** |
| Synthesis                       | **Complete**                        |
| Area                            | **Complete**                        |
| Cell-area analysis              | **Complete**                        |
| Timing                          | **Complete**                        |
| Power                           | **Complete**                        |
| Hierarchy                       | **Complete**                        |
| PPA                             | **Complete**                        |
| Gate-level simulation           | **Not included**                    |
| Formal verification             | **Not performed**                   |
| UVM                             | **Not performed**                   |
| Constrained-random verification | **Not performed**                   |
| Functional coverage             | **Not performed**                   |
| Timing closure                  | **Not claimed**                     |
| Documentation                   | **Complete**                        |

---

## 21. Limitations

This project intentionally does not include:

* parameterization
* pipelining
* registered output
* randomized verification
* SystemVerilog assertions
* functional coverage
* UVM
* gate-level simulation
* formal verification

Additional limitations of the current synthesis analysis:

* Timing path is explicitly unconstrained.
* No setup/hold slack is available from the supplied timing report.
* No maximum frequency is claimed.
* PPA values are specific to the supplied Genus configuration.
* Area is reported in the tool/library area units provided by Genus.
* No second RTL implementation has been synthesized for a measured optimization comparison.

---

## 22. Future Work

1. Parameterized MUX.
2. 8:1 and 16:1 MUX.
3. Structural versus behavioral synthesis comparison.
4. Area/timing/power comparison.
5. SystemVerilog assertions.
6. Functional coverage.
7. Reusable verification component.
8. Constrained timing analysis.
9. Larger datapath integration.
10. Comparison of alternative MUX architectures.

---

## 23. Industry Connection

Multiplexers are fundamental combinational building blocks used in:

* digital datapaths
* ALUs
* control logic
* bus selection
* register-input selection
* processor datapaths
* communication systems
* DSP hardware

### Skills Demonstrated

* combinational RTL
* structural modeling
* hierarchical design
* Verilog module instantiation
* testbench development
* functional verification
* synthesis
* standard-cell mapping
* timing awareness
* area analysis
* power analysis
* PPA documentation

### Relevant Industry Areas

* RTL Design
* ASIC Design
* FPGA Design
* Design Verification
* Digital VLSI

---

## 24. GATE Relevance

Important concepts:

* MUX truth table
* Boolean realization using MUX
* select-line interpretation
* combinational circuit analysis
* logic implementation using multiplexers
* propagation delay
* logic depth

Key relation:

$$
S=\log_2(N)
$$

For four inputs:

$$
S=2
$$

### Key Boolean Function

$$
Y =
\overline{S_1}\overline{S_0}I_0+
\overline{S_1}S_0I_1+
S_1\overline{S_0}I_2+
S_1S_0I_3
$$

---

## 25. Interview Questions

### Basic

**Q1. What is a multiplexer?**

A multiplexer is a combinational circuit that selects one input from multiple inputs and forwards it to a single output.

**Q2. Why does a 4:1 MUX require two select lines?**

Because:

$$
2^2=4
$$

Two select lines provide four possible selection combinations.

**Q3. What is the difference between a MUX and decoder?**

A MUX selects one of several data inputs and forwards it to an output. A decoder activates one output corresponding to a binary input code.

### RTL

**Q4. How would you code a 4:1 MUX using `case`?**

Use a combinational `case(S)` statement with cases `2'b00`, `2'b01`, `2'b10`, and `2'b11`.

**Q5. What is structural RTL?**

Structural RTL describes a design by explicitly instantiating and connecting lower-level modules.

**Q6. What hardware does this RTL create?**

A combinational 4:1 selection network implemented hierarchically using three 2:1 MUXes.

### Debugging

**Q7. If `S=10` selects `I3`, what should be inspected?**

Inspect the select-bit mapping and first-stage connections, particularly the relationship between `S[1:0]`, `MUX1`, `MUX2`, `I2`, and `I3`.

**Q8. What happens if `S[1]` and `S[0]` are exchanged?**

The selection hierarchy changes and the output can select the wrong input for a given select code.

### Hardware

**Q9. How many 2:1 MUXes are required for a 4:1 MUX?**

Three.

**Q10. What is the reported Day-2 input-to-output delay?**

The reported `S0 → Y` data-path delay is:

$$
835\ ps=0.835\ ns
$$

### Advanced

**Q11. How would you compare structural and behavioral MUXes after synthesis?**

Synthesize both implementations using the same technology library and constraints, then compare cell count, area, timing, power, and logic depth.

**Q12. What factors determine the critical input-to-output delay?**

The delay depends on the mapped standard cells, cell delays, load, fanout, interconnect/wireload assumptions, operating condition, and synthesis/timing configuration.

---

## 26. Tiny Memory

```text
4:1 MUX
│
├── 4 inputs
├── 2 select lines
└── 1 output
```

```text
00 → I0
01 → I1
10 → I2
11 → I3
```

```text
4:1 MUX
   =
3 × 2:1 MUX
```

```text
S[0] → First Stage
S[1] → Second Stage
```

### Day-2 Measured Results

```text
Area  = 139.709 library area units
Power = 4.15203 µW
Delay = 0.835 ns
Cells = 12
```

**Important:** Simulation success establishes functional behavior; it does not by itself establish PPA.

---

## 27. Repository Structure

```text
Day-2/
│
├── README.md
│
├── rtl/
│   └── day2_design.v
│
├── tb/
│   └── day2_tb.v
│
├── simulation/
│   └── console_output.txt
│
├── reports/
│   ├── area_report.txt
│   ├── power_report.txt
│   ├── timing_report.txt
│   ├── hierarchy_report.txt
│   └── cell_area_report.txt
│
├── images/
│   ├── rtl_waveform.png
│   ├── simulation_result.png
│   └── synthesis_hierarchy.png
│
└── docs/
    └── project_report.pdf
```

---

## 28. GitHub Commit Sequence

```text
1. Add Day 2 RTL design
2. Add Day 2 testbench
3. Add RTL simulation output
4. Add waveform and simulation evidence
5. Add Genus synthesis reports
6. Add project documentation
7. Update Day 2 README
```

### Suggested Repository Description

```text
4:1 Multiplexer RTL Design & Verification using Verilog HDL and Cadence Genus.
```

---

## 29. Project Status

```text
Specification        ✓ COMPLETE
Architecture         ✓ COMPLETE
RTL                  ✓ COMPLETE
Testbench            ✓ COMPLETE
Simulation           ✓ COMPLETE
Verification         ✓ COMPLETE
Waveform Evidence    ✓ AVAILABLE
Synthesis            ✓ COMPLETE
Hierarchy            ✓ COMPLETE
Area                 ✓ COMPLETE
Cell Mapping         ✓ COMPLETE
Timing               ✓ COMPLETE
Power                ✓ COMPLETE
PPA                  ✓ COMPLETE
Documentation        ✓ COMPLETE
```

### Final Day-2 Results

```text
Design       : 4:1 Multiplexer
Top Module   : mux_4to1_gate_top
Technology   : tsmc18
Cells        : 12
Area         : 139.709 library area units
Power        : 4.15203 µW
Delay        : 0.835 ns
Timing       : UNCONSTRAINED
Status       : COMPLETE
```

---

## 30. Learning Outcome

```text
MUX Concept
     ↓
Architecture
     ↓
Structural Verilog
     ↓
Self-Checking Testbench
     ↓
Simulation
     ↓
Verification
     ↓
Cadence Genus Synthesis
     ↓
Hierarchy Analysis
     ↓
Area / Power / Timing
     ↓
PPA Analysis
     ↓
Portfolio Documentation
     ↓
GitHub
     ↓
Interview Preparation
```

### Key Engineering Question

> **What hardware does this RTL create?**

### Answer

> A combinational 4:1 selection network implemented hierarchically using three 2:1 multiplexers and mapped by Genus into technology-library standard cells.

---

# Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering
SDM Institute of Technology, Ujire, Karnataka

### Focus

* Digital VLSI
* RTL Design
* Verilog / SystemVerilog
* ASIC Design
* Design Verification
* Physical Design Awareness

---

## Evidence Rule

Only upload evidence actually generated from the RTL, simulation, and synthesis flow.

**Do not fabricate screenshots, simulation results, PPA values, timing closure, or verification claims.**

All Day-2 synthesis values documented above correspond to the supplied Cadence Genus reports for `mux_4to1_gate_top`.

---

## Training Flow

```text
Specification
     ↓
Architecture
     ↓
RTL
     ↓
Testbench
     ↓
Simulation
     ↓
Verification
     ↓
Debug
     ↓
Synthesis
     ↓
Timing
     ↓
PPA
     ↓
Optimization
     ↓
Documentation
     ↓
GitHub
     ↓
Interview
```

---

# Day 2 Complete

**4:1 Multiplexer — RTL → Simulation → Verification → Genus Synthesis → PPA Analysis → Documentation**

### Final Measured Results

```text
Area  : 139.709 library area units
Power : 4.15203 µW
Delay : 0.835 ns
Cells : 12
```

**Next Project: 2-to-4 DECODER WITH ENABLE**
