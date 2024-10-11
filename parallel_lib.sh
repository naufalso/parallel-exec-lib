#!/bin/bash
# parallel_lib.sh

# Parallel Execution Library
# Author: Naufal Suryanto
# Description: A bash library for running commands in parallel using tmux.

# Initialize the parallel execution environment
init_parallel_execution() {
    # Number of parallel processes
    n=$1  # Pass the number of parallel processes as the first argument
    custom_session_name=$2  # Optional session name

    # Ensure 'tmux' is installed
    if ! command -v tmux &> /dev/null; then
        echo "tmux is not installed. Please install tmux to use this script."
        exit 1
    fi

    # Create a unique tmux session name if not provided
    if [ -z "$custom_session_name" ]; then
        session_name="parallel_session_$(date +%s)_$$"
    else
        session_name="$custom_session_name"
    fi

    # Create the tmux session
    tmux new-session -d -s "$session_name"

    # Create a temporary directory for intermediate files
    temp_dir=$(mktemp -d -t parallel_lib_XXXXXX)

    # Function to clean up FIFOs, worker scripts, status files, temporary directory, and tmux session
    cleanup() {
        tmux kill-session -t "$session_name"
        rm -rf "$temp_dir"
    }

    trap cleanup EXIT

    # Export variables for use in other functions
    export n
    export session_name
    export temp_dir
}

# Start worker panes and loops
start_workers() {
    for ((i=0; i<n; i++)); do
        if [ $i -gt 0 ]; then
            tmux split-window -t "$session_name"
            tmux select-layout -t "$session_name" tiled
        fi
        pane_index=$i
        fifo="$temp_dir/fifo_$$_$i"

        # Create FIFOs for communication
        mkfifo "$fifo"

        # Create a temporary worker script
        worker_script="$temp_dir/worker_$$_$i.sh"
        worker_status_file="$temp_dir/worker_$$_$i.status"
        cat > "$worker_script" <<EOF
#!/bin/bash
fifo="$fifo"
pane_index=$pane_index
status_file="$worker_status_file"
touch "\$status_file"
echo "Worker \$pane_index starting"
while true; do
    if read -r cmd < "\$fifo"; then
        echo "Worker \$pane_index received command: \$cmd"
        if [ "\$cmd" == "exit" ]; then
            echo "Worker \$pane_index exiting"
            break
        fi
        eval "\$cmd"
    else
        sleep 1
    fi
done
echo "Worker \$pane_index finished"
rm -f "\$status_file"
exit 0
EOF
        chmod +x "$worker_script"

        # Start the worker script in the tmux pane using exec to replace the shell
        tmux send-keys -t "${session_name}.$pane_index" "exec \"$worker_script\"" C-m
    done
}

# Run commands in parallel
run_commands_in_parallel() {
    commands=("$@")  # Accept the commands as arguments to the function
    total_commands=${#commands[@]}
    command_index=0

    while [ $command_index -lt $total_commands ]; do
        for ((i=0; i<n; i++)); do
            fifo="$temp_dir/fifo_$$_$i"
            if [ $command_index -lt $total_commands ]; then
                echo "Sending command to worker $i: ${commands[$command_index]}"
                echo "${commands[$command_index]}" > "$fifo"
                command_index=$((command_index + 1))
            fi
        done
        sleep 1
    done
}

# Signal workers to exit
stop_workers() {
    # Signal workers to exit after all commands are sent
    for ((i=0; i<n; i++)); do
        fifo="$temp_dir/fifo_$$_$i"
        echo "Sending 'exit' to worker $i"
        echo "exit" > "$fifo"
    done
}

# Wait for all workers to finish
wait_for_completion() {
    # Wait until all worker processes have finished
    while true; do
        all_done=true
        for ((i=0; i<n; i++)); do
            worker_status_file="$temp_dir/worker_$$_$i.status"
            if [ -f "$worker_status_file" ]; then
                echo "Worker $i is still running"
                all_done=false
                break
            else
                echo "Worker $i has finished"
            fi
        done
        if [ "$all_done" = true ]; then
            echo "All workers have finished"
            break
        fi
        sleep 1
    done
}
