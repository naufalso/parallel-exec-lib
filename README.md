# Parallel Execution Library

A Bash library for running commands in parallel using `tmux`, with output separation and easy management.

## Features

- **Parallel Execution**: Run multiple commands in parallel with a specified number of processes.
- **Output Separation**: Each command's output is displayed in its own `tmux` pane.
- **Automatic Cleanup**: Temporary files and `tmux` sessions are cleaned up automatically.
- **Customizable**: Set custom `tmux` session names and adjust parallelism.
- **Easy Integration**: Simple functions to incorporate into your own scripts.

## Requirements

- **Bash** shell.
- **tmux** (Terminal Multiplexer). Install it via:

  ```bash
  sudo apt-get install tmux   # On Debian/Ubuntu
  sudo yum install tmux       # On CentOS/RHEL
  brew install tmux           # On macOS with Homebrew
  ```

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/parallel-execution-lib.git
```

Navigate to the directory:

```bash
cd parallel-execution-lib
```

Make the scripts executable:

```bash
chmod +x parallel_lib.sh
chmod +x examples/run_parallel_commands.sh
```

## Usage

### Sourcing the Library

In your script, source the `parallel_lib.sh` library:

```bash
source /path/to/parallel_lib.sh
```

### Basic Example

Here's a basic example of how to use the library:

```bash
#!/bin/bash

# Source the library
source ./parallel_lib.sh

# Set the number of parallel processes
num_parallel_processes=3

# Set the tmux session name (optional)
tmux_session_name="my_parallel_session"

# Initialize the parallel execution environment
init_parallel_execution "$num_parallel_processes" "$tmux_session_name"

# Start the worker panes and loops
start_workers

# Define your list of commands
commands=(
    "echo 'Task 1'; sleep 2"
    "echo 'Task 2'; sleep 3"
    "echo 'Task 3'; sleep 1"
    "echo 'Task 4'; sleep 4"
    "echo 'Task 5'; sleep 2"
)

# Run commands in parallel
run_commands_in_parallel "${commands[@]}"

# Stop workers
stop_workers

# Wait for completion
wait_for_completion
```

### Functions

- **`init_parallel_execution <num_processes> [session_name]`**: Initializes the parallel execution environment.
  - `<num_processes>`: Number of parallel processes.
  - `[session_name]`: (Optional) Custom `tmux` session name.
- **`start_workers`**: Starts worker panes and loops.
- **`run_commands_in_parallel <commands>`**: Runs the specified commands in parallel.
- **`stop_workers`**: Signals workers to exit after all commands are sent.
- **`wait_for_completion`**: Waits for all worker processes to finish.

### Customization

- **Session Name**: Provide a custom `tmux` session name when initializing.
- **Temporary Directory**: The library uses a temporary directory for intermediate files, which is automatically cleaned up.

### Monitoring Execution

You can attach to the `tmux` session to monitor the execution in real-time:

```bash
tmux attach-session -t my_parallel_session
```

Detach from the session using `Ctrl+B` followed by `D`.

### Cleaning Up

The library includes a `cleanup` function that automatically removes temporary files and terminates the `tmux` session when the script exits.

## Examples

See the `examples/` directory for sample scripts demonstrating how to use the library.

### Running the Example Script

Navigate to the `examples/` directory and run:

```bash
cd examples
./run_parallel_commands.sh
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the need for simple parallel execution in Bash scripts.
- Utilizes `tmux` for terminal multiplexing and output management.