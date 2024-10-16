# Parallel Execution Library

A Bash library for running commands in parallel using `tmux`, with output separation, GPU management, and easy environment control.

## Features

- **Parallel Execution**: Run multiple commands in parallel with a specified number of processes.
- **GPU Support**: Set `CUDA_VISIBLE_DEVICES` for each worker process, allowing control over GPU allocation for parallel tasks.
- **Conda Environment Activation**: Activate a specified Conda environment for each worker, ensuring all commands run in the same environment.
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

- **Conda** (optional): Required if you need to activate a Conda environment within the workers.
- **CUDA** (optional): Required for GPU support if you want to assign specific GPUs to worker processes.

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
chmod +x examples/*.sh
```

## Usage

### Sourcing the Library

In your script, source the `parallel_lib.sh` library:

```bash
source /path/to/parallel_lib.sh
```

### Basic Example

<details>
<summary>Click to show the basic example</summary>

```bash
#!/bin/bash
# run_parallel_commands.sh
# Example script to demonstrate parallel execution using parallel_lib.sh

# Source the library
source ./parallel_lib.sh

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
```

</details>

### Example with Conda and GPU Support

<details>
<summary>Click to show the example with Conda and GPU support</summary>

```bash
#!/bin/bash
# run_parallel_commands_conda_gpu.sh
# Example script to demonstrate parallel execution with Conda and GPU support using parallel_lib.sh

# Source the library
source ./parallel_lib.sh

# Set the number of parallel processes
num_parallel_processes=4  # Adjust this number as needed

# Set the tmux session name (optional)
tmux_session_name="my_parallel_session"  # Replace with your desired session name

# Define the Conda environment (optional)
conda_env="my_env"  # Replace with your Conda environment name

# Define GPU indexes (optional)
gpu_indexes=(0 1 2)  # List of available GPU indexes

# Export variables so they are accessible in the library functions
export conda_env
export gpu_indexes

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
```

</details>

### Functions

- **`init_parallel_execution <num_processes> [session_name]`**: Initializes the parallel execution environment.
  - `<num_processes>`: Number of parallel processes.
  - `[session_name]`: (Optional) Custom `tmux` session name.
- **`start_workers`**: Starts worker panes and loops.
- **`run_commands_in_parallel <commands>`**: Runs the specified commands in parallel.
- **`stop_workers`**: Signals workers to exit after all commands are sent.
- **`wait_for_completion`**: Waits for all worker processes to finish.

### Additional Features

- **Conda Environment Activation**: To run all workers inside a specified Conda environment, set the `conda_env` variable before calling `start_workers`. This ensures that the environment is activated in each worker's process.
  
  Example:
  ```bash
  export conda_env="my_env"
  ```

- **GPU Allocation with `CUDA_VISIBLE_DEVICES`**: You can assign specific GPUs to each worker by defining the `gpu_indexes` array. The library will automatically cycle through the GPUs for each worker.

  Example:
  ```bash
  export gpu_indexes=(0 1 2)  # GPUs 0, 1, and 2 will be used
  ```

### Monitoring Execution

You can attach to the `tmux` session to monitor the execution in real-time:

```bash
tmux attach-session -t my_parallel_session
```

or simply attach the last created session:

```bash
tmux a
```

Detach from the session using `Ctrl+B` followed by `D`.

### Cleaning Up

The library includes a `cleanup` function that automatically removes temporary files and terminates the `tmux` session when the script exits.

## Examples

See the `examples/` directory for sample scripts demonstrating how to use the library.

### Running the Example Script

```bash
./examples/run_parallel_commands.sh
./examples/run_parallel_commands_conda_gpu.sh
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the need for simple parallel execution in Bash scripts.
- Utilizes `tmux` for terminal multiplexing and output management.
```