# Day 2 — 4:1 Multiplexer

<p align="center"><b>Digital VLSI • Verilog RTL • Functional Verification • Synthesis Awareness</b></p>

<p align="center"><code>Specification → Architecture → RTL → Testbench → Simulation → Verification → Synthesis → PPA</code></p>

---

## 1. Project Information

| Item | Details |
|---|---|
| Project | Day 2 |
| Design Title | `mux_4to1` |
| Domain | Digital VLSI / RTL Design |
| HDL | Verilog HDL |
| Design Type | Combinational Data-Path Circuit |
| Verification | Directed Self-Checking RTL Testbench |
| Top Module | `mux_4to1` |
| Architecture | 3 × 2:1 MUX hierarchy |
| Synthesis | Cadence Genus — actual run to be added |
| Library | Actual synthesis library to be added |

## 2. Project Overview

This project implements a **4:1 multiplexer** using three hierarchical **2:1 multiplexers**.

A 4:1 MUX selects one of four one-bit inputs and forwards it to one output according to the two-bit select input.

| `S[1:0]` | Selected Input | Output |
|---|---|---|
| `00` | `I0` | `Y = I0` |
| `01` | `I1` | `Y = I1` |
| `10` | `I2` | `Y = I2` |
| `11` | `I3` | `Y = I3` |

## 3. Objective

- Understand multiplexer operation.
- Design a 4:1 MUX hierarchically from 2:1 MUXes.
- Write synthesizable structural Verilog.
- Develop a self-checking testbench.
- Verify all four select conditions.
- Understand the hardware inferred by RTL.
- Analyze synthesis, timing, area and power using actual tool reports.

## 4. Concept

A multiplexer is a combinational data selector.

For `N` data inputs, the number of select lines is:

\[
S=\log_2(N)
\]

For a 4:1 MUX:

\[
S=\log_2(4)=2
\]

## 5. Hardware Architecture

```text
                 S[0]
                  │
        ┌─────────┴─────────┐
        │                   │
I0 ───► MUX0               MUX1 ◄─── I2
I1 ───►   │                   │ ◄─── I3
        Y0                  Y1
         │                   │
         └────────┐ ┌────────┘
                  │ │
                 MUX2
                  ▲
                  │
                 S[1]
                  │
                  ▼
                  Y
```

Hierarchy:

```text
mux_4to1
├── MUX0 : mux_2to1
├── MUX1 : mux_2to1
└── MUX2 : mux_2to1
```

The first stage uses `S[0]`; the second stage uses `S[1]`.

## 6. Boolean Function

\[
Y =
\overline{S_1}\overline{S_0}I_0+
\overline{S_1}S_0I_1+
S_1\overline{S_0}I_2+
S_1S_0I_3
\]

The RTL implements the same function through hierarchical 2:1 MUX blocks.

## 7. Functional Specification

### Inputs

| Signal | Width | Description |
|---|---:|---|
| `I0` | 1 | Data input 0 |
| `I1` | 1 | Data input 1 |
| `I2` | 1 | Data input 2 |
| `I3` | 1 | Data input 3 |
| `S` | 2 | Select input |

### Output

| Signal | Width | Description |
|---|---:|---|
| `Y` | 1 | Selected output |

This is a **combinational** circuit: no clock or reset is required.

## 8. RTL Design

The design is structurally composed of three 2:1 MUX instances.

```text
Y0 = S[0] ? I1 : I0
Y1 = S[0] ? I3 : I2
Y  = S[1] ? Y1 : Y0
```

Source:

```text
rtl/day2_design.v
```

## 9. Verification

The testbench is a directed, self-checking RTL testbench.

It checks:

1. `S=00` selects `I0`.
2. `S=01` selects `I1`.
3. `S=10` selects `I2`.
4. `S=11` selects `I3`.
5. Additional input patterns.
6. Actual output against an expected value.
7. PASS/FAIL counters.

Source:

```text
tb/day2_tb.v
```

## 10. Test Cases

Representative tests:

| Test | `I3 I2 I1 I0` | `S` | Expected `Y` |
|---:|---|---|---:|
| 1 | `0001` | `00` | 1 |
| 2 | `0010` | `01` | 1 |
| 3 | `0100` | `10` | 1 |
| 4 | `1000` | `11` | 1 |
| 5 | `1110` | `00` | 0 |
| 6 | `1110` | `01` | 1 |
| 7 | `1110` | `10` | 1 |
| 8 | `1110` | `11` | 1 |
| 9 | `0001` | `01` | 0 |
| 10 | `0001` | `10` | 0 |
| 11 | `0001` | `11` | 0 |

The actual simulator output belongs in:

```text
simulation/console_output.txt
```

Do not manually fabricate PASS/FAIL output.

## 11. Simulation

Recommended evidence:

```text
images/
├── rtl_waveform.png
├── simulation_result.png
└── synthesis_hierarchy.png
```

Use your actual screenshot filenames if they differ.

The waveform should show `I0`, `I1`, `I2`, `I3`, `S[1:0]`, and `Y`.

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

Cadence Genus can be used for the synthesis stage.

**Important:** actual tool results must be inserted only after the Genus run.

Do not invent:

- cell count
- area
- power
- delay
- slack
- maximum frequency

## 13. Area

Record actual results after synthesis:

| Metric | Result |
|---|---:|
| Total cell count | To be measured |
| Total area | To be measured |
| Combinational area | To be measured |
| Physical cell area | To be measured |

Save the actual report as:

```text
reports/area_report.txt
```

## 14. Timing

This is a combinational circuit, so timing analysis focuses on input-to-output propagation.

Conceptual path:

```text
Input
 ↓
First MUX level
 ↓
Second MUX level
 ↓
Y
```

Actual delay must be taken from the timing report.

Save:

```text
reports/timing_report.txt
```

Do not claim timing closure unless the design has been properly constrained and analyzed.

## 15. Power

Power depends on the technology library, operating conditions, switching activity and analysis configuration.

Record actual:

| Metric | Result |
|---|---:|
| Internal power | To be measured |
| Switching power | To be measured |
| Leakage power | To be measured |
| Total power | To be measured |

Save:

```text
reports/power_report.txt
```

## 16. PPA

PPA means:

- **Power**
- **Performance**
- **Area**

For Day 2:

- Power → actual power report
- Performance → actual input-to-output timing
- Area → actual synthesized area

No PPA conclusion should be made before the actual tool results exist.

## 17. Optimization Study

A useful follow-up is to compare:

### Structural RTL

```text
3 × 2:1 MUX hierarchy
```

### Behavioral RTL

```verilog
assign Y = I[S];
```

or an equivalent behavioral implementation.

Compare after synthesis:

- synthesized cells
- area
- timing
- power
- logic depth
- readability

Do not assume the two RTL descriptions produce different hardware; synthesis may optimize equivalent logic into similar implementations.

## 18. Common Mistakes

### Select mapping

Correct:

```text
00 → I0
01 → I1
10 → I2
11 → I3
```

### Structural mapping

Correct first-stage mapping:

```text
MUX0: I0/I1 using S[0]
MUX1: I2/I3 using S[0]
```

Second stage:

```text
MUX2: Y0/Y1 using S[1]
```

### Other mistakes

- Reversing `S[1]` and `S[0]`
- Swapping `I2` and `I3`
- Testing only one select condition
- Confusing simulation success with synthesis/PPA results

## 19. Verification Status

| Item | Status |
|---|---|
| Specification | Complete |
| Architecture | Complete |
| RTL | Complete |
| Testbench | Complete |
| Simulation | Run locally |
| Waveform | Add actual evidence |
| Synthesis | Run in Genus |
| Area | Add actual report |
| Timing | Add actual report |
| Power | Add actual report |
| PPA | Analyze after reports |
| Documentation | Complete |
| GitHub | Ready |

## 20. Limitations

This project intentionally does not include:

- parameterization
- pipelining
- registered output
- randomized verification
- SystemVerilog assertions
- functional coverage
- UVM
- gate-level simulation

These are outside the basic Day-2 objective.

## 21. Future Work

1. Parameterized MUX.
2. 8:1 and 16:1 MUX.
3. Structural vs behavioral synthesis comparison.
4. Area/timing/power comparison.
5. SystemVerilog assertions.
6. Functional coverage.
7. Reusable verification component.

## 22. Industry Connection

Multiplexers are fundamental combinational building blocks used in digital datapaths and control/data-selection logic.

Skills demonstrated:

- combinational RTL
- structural modeling
- hierarchical design
- testbench development
- functional verification
- synthesis awareness
- timing awareness

Relevant areas include RTL Design, ASIC Design, FPGA Design and Design Verification.

## 23. GATE Relevance

Important concepts:

- MUX truth table
- Boolean realization using MUX
- select-line interpretation
- combinational circuit analysis
- logic implementation using multiplexers

Key relation:

\[
S=\log_2(N)
\]

For 4 inputs:

\[
S=2
\]

## 24. Interview Questions

### Basic
1. What is a multiplexer?
2. Why does a 4:1 MUX require two select lines?
3. What is the difference between a MUX and decoder?

### RTL
1. How would you code a 4:1 MUX using `case`?
2. What is structural versus behavioral MUX RTL?
3. What hardware does this RTL create?

### Debugging
1. If `S=10` selects `I3`, what would you inspect?
2. What happens if `S[1]` and `S[0]` are exchanged?

### Hardware
1. How many 2:1 MUXes are required for a 4:1 MUX?
2. What is the logic depth from an input to `Y`?

### Advanced
1. How would you compare structural and behavioral MUXes after synthesis?
2. What factors determine the critical input-to-output delay?

## 25. Tiny Memory

- 4:1 MUX = 4 inputs + 2 select lines + 1 output.
- `00 → I0`
- `01 → I1`
- `10 → I2`
- `11 → I3`
- 4:1 MUX can be built using 3 × 2:1 MUXes.
- `S[0]` controls the first stage.
- `S[1]` controls the second stage.
- Simulation success does not establish PPA.

## 26. Repository Structure

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

## 27. GitHub Commit Sequence

```text
1. Add Day 2 RTL design
2. Add Day 2 testbench
3. Add RTL simulation output
4. Add waveform and simulation evidence
5. Add Genus synthesis reports
6. Add project documentation
7. Update Day 2 README
```

## 28. Project Status

```text
Specification      ✓
Architecture       ✓
RTL                ✓
Testbench          ✓
Simulation         → Run
Waveform           → Capture
Synthesis          → Run
Area               → Measure
Timing             → Measure
Power              → Measure
PPA                → Analyze
Documentation      ✓
GitHub             → Upload
```

## 29. Learning Outcome

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
Synthesis Awareness
   ↓
Timing / Area / Power
   ↓
Portfolio Documentation
```

### Key engineering question

> **What hardware does this RTL create?**

Answer:

> A combinational 4:1 selection network implemented hierarchically using three 2:1 multiplexers.

## 30. Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering  
SDM Institute of Technology, Ujire, Karnataka

Focus:

- Digital VLSI
- RTL Design
- Verilog/SystemVerilog
- ASIC Design
- Design Verification
- Physical Design Awareness

---

### Evidence Rule

Only upload evidence actually generated from the RTL/simulation/synthesis flow. Do not fabricate screenshots or PPA values.

### Training Flow

```text
Specification
→ Architecture
→ RTL
→ Testbench
→ Simulation
→ Verification
→ Debug
→ Synthesis
→ Timing
→ PPA
→ Optimization
→ Documentation
→ GitHub
→ Interview
```
