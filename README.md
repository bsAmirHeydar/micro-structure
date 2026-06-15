# Micro Structure

**MQL5 market microstructure research tools for imbalance, node behavior, execution hypotheses, and regime-aware trading logic.**

This repository contains an experimental MQL5 research system focused on market microstructure concepts. The project combines node logic, imbalance logic, order handling, portfolio/risk utilities, timing filters, and chart visualization.

The goal is to convert microstructure observations into explicit code modules that can be tested visually and systematically inside MetaTrader 5.

---

## Research Purpose

This repository is designed to explore whether microstructure-level features can improve trading decisions. The focus is not on prediction certainty, but on measuring and structuring market behavior around:

- Imbalance zones
- Structural nodes
- Execution pressure
- Local regime behavior
- Entry/exit conditions
- Risk-controlled execution

---

## Main Files

| File | Purpose |
|---|---|
| `run.mq5` | Main Expert Advisor entry point. |
| `strategy setting.mqh` | Strategy configuration and core research logic. |
| `Node.mqh` | Structural node detection / interpretation module. |
| `imbalance.mqh` | Imbalance-related market microstructure logic. |
| `order.mqh` | Order execution and management utilities. |
| `portfolio.mqh` | Risk and portfolio utilities. |
| `time.mqh` | Timing/session filtering. |
| `draw.mqh` | Visual chart/debugging tools. |

---

## Architecture

```text
run.mq5
 ├── strategy setting.mqh
 │    ├── Node.mqh
 │    ├── imbalance.mqh
 │    ├── order.mqh
 │    └── draw.mqh
 ├── portfolio.mqh
 └── time.mqh
```

---

## Research Questions

This project is useful for studying questions such as:

- Do imbalance regions lead to distinguishable short-term behavior?
- Do structural nodes interact with imbalance zones in a measurable way?
- Can execution pressure be converted into rule-based entry/exit logic?
- Does microstructure behavior change across regimes?
- Can risk be controlled without overfitting local pattern behavior?

---

## How to Use

1. Copy all `.mq5` and `.mqh` files into an MQL5 project folder.
2. Compile `run.mq5` in MetaEditor.
3. Run inside MetaTrader 5 Strategy Tester.
4. Use visual mode to inspect imbalance, node behavior, entries, exits, and chart drawings.

---

## Status

Experimental research-stage project.

---

## Disclaimer

This repository is for research and educational purposes only. It is not financial advice and does not provide trading recommendations.
