# RL Tooling

This directory contains the SSF2 research-build instrumentation and command-line tools.

## Layout

- `patches/` — ActionScript replacements used to instrument the research SWF.
- `scripts/` — build automation for the instrumented SWF.
- `config/` — research-build configuration copied into the macOS payload.
- `diagnostics/` — bridge connectivity and input-application checks.
- `integration_tests/` — live-game smoke, replay, validation, and profiling commands.

## Prerequisites

- Java, with enough heap available for FFDec (`-Xmx4g`).
- The bundled `FFDec.app` and the baseline `build/SSF2.swf`.
- Python 3.10 or later. Create the project virtual environment and install the Python package with its `dev` extra for pytest; install the `rl` extra for Gymnasium- and Torch-dependent commands.
- A locally running instrumented game with an active match for bridge diagnostics and live integration commands.

## Build the Research SWF

From the repository root, run:

```sh
bash tools/rl/scripts/build_research_swf.sh
```

The build replaces the four ActionScript classes in a working SWF, then deploys the patched SWF and `config/autostart.json` to `.macos/payload/`.

## Diagnostics

Run either command after starting a match in the research build:

```sh
.venv/bin/python tools/rl/diagnostics/wait_for_bridge.py
.venv/bin/python tools/rl/diagnostics/diagnose_bridge.py
```

Only one bridge client can be connected at a time. `diagnose_bridge.py` disconnects any notebook client while it runs.

## Integration Commands

These commands require the appropriate game state described by each CLI:

```sh
.venv/bin/python tools/rl/integration_tests/smoke_test.py
.venv/bin/python tools/rl/integration_tests/profile_step.py --frames 300
.venv/bin/python tools/rl/integration_tests/test_replay.py
.venv/bin/python tools/rl/integration_tests/validate_research_env.py
```

The replay command uses its configured `.ssfrec` path. The other commands require a live bridge connection.
