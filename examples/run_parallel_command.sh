#!/bin/bash

# run_parallel_commands.sh

# Example script to demonstrate parallel execution using parallel_lib.sh

# Source the library
source ../parallel_lib.sh

# Set the number of parallel processes
num_parallel_processes=3  # Adjust this number as needed

# Set the tmux session name (optional)
tmux_session_name="my_parallel_session"  # Replace with your desired session name

# Initialize the parallel execution environment
init_parallel_execution "$num_parallel_processes" "$tmux_session_name"

# Start the worker panes and loops
start_workers

# Define your list of commands
commands=(
    "echo 'Running command 1'; sleep 2"
    "echo 'Running command 2'; sleep 5"
    "echo 'Running command 3'; sleep 3"
    "echo 'Running command 4'; sleep 4"
    "echo 'Running command 5'; sleep 2"
    # Add more commands as needed
)

# Run commands in parallel
run_commands_in_parallel "${commands[@]}"

# Stop workers
stop_workers

# Wait for completion
wait_for_completion

# The cleanup function in the library will be called automatically due to 'trap'
