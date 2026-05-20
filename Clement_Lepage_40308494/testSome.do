# -------------------------
# RESET SEQUENCE
# -------------------------
force reset 1
force iterate 0
force playerIn 0000
run 100 ns

force reset 0
run 100 ns

# -------------------------
# ITERATION 1
# -------------------------
# Start game
force iterate 1
run 20 ns
force iterate 0

# Players move during GREEN
force playerIn 1000
run 500 us

force playerIn 1100
run 500 us

force playerIn 0000
run 500 us

# -------------------------
# ITERATION 2
# -------------------------
force iterate 1
run 20 ns
force iterate 0

force playerIn 0011
run 500 us

force playerIn 0000
run 500 us

# -------------------------
# TEST RED LIGHT (movement during RED → elimination)
# -------------------------
force iterate 1
run 20 ns
force iterate 0

# Wait into RED phase
run 2 ms

# Illegal movement (should eliminate players)
force playerIn 1111
run 200 us

force playerIn 0000
run 500 us

# -------------------------
# RESET MID-GAME
# -------------------------
force reset 1
run 100 ns
force reset 0

run 200 ns

# -------------------------
# FAST PLAYER WIN TEST
# -------------------------
force iterate 1
run 20 ns
force iterate 0

# Keep player 0 moving long enough to win
force playerIn 1000
run 5 ms

# -------------------------
# ALL PLAYERS ACTIVE (edge case)
# -------------------------
force iterate 1
run 20 ns
force iterate 0

force playerIn 1111
run 1 ms

force playerIn 0000
run 1 ms

# -------------------------
# FINAL RUN
# -------------------------
run 5 ms
