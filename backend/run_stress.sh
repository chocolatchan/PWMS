#!/bin/bash
ulimit -n 65535
cargo test --test stress_bench -- --nocapture > stress_actual_result.txt 2>&1
cat stress_actual_result.txt
