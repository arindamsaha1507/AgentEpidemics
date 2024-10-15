# AgentEpidemics.jl

**AgentEpidemics.jl** is a Julia package for simulating epidemic models using an agent-based approach. It implements the **SIRS (Susceptible-Infectious-Recovered-Susceptible)** model, where agents move within a defined area, come into contact with one another, and transition between different health states based on disease dynamics.

## Features

- **Agent-based SIRS Model**: Simulates the SIRS disease dynamics where agents can move, infect each other, recover, and lose immunity.
- **Dynamic Interactions**: Agents interact based on proximity, enabling contact-based transmission of diseases.
- **Configurable Parameters**: Control various aspects of the simulation such as infection probability, recovery probability, immunity loss probability, agent speed, and more.
- **Visualization**: Visualize the simulation through scatter plots to observe the spread of the disease over time.
- **YAML Integration**: Load simulation settings from YAML configuration files for easy configuration.

## Installation

To install **AgentEpidemics.jl**, follow these steps:

1. Clone the repository or download the package.
    ```bash
    git clone https://github.com/yourusername/AgentEpidemics.jl
    ```

2. Open Julia and navigate to the package directory:
    ```julia
    cd("path/to/AgentEpidemics")
    ```

3. Activate and instantiate the package environment:
    ```julia
    using Pkg
    Pkg.activate(".")
    Pkg.instantiate()
    ```

This will install all necessary dependencies for the package.

## Usage

### Running the Simulation

To run a simulation, you can use the `run_simulation` function, either by passing specific parameters or loading settings from a YAML file.

#### Example: Running with Custom Parameters
```julia
using AgentEpidemics

# Define parameters
n_agents = 100
total_time = 50
initial_infection_probability = 0.05
side_length = 100.0
contact_radius = 10.0
mean_speed = 1.0
std_speed = 0.5
infection_probability = 0.1
recovery_probability = 0.05
immunity_loss_probability = 0.01

# Run the simulation

output = run_simulation(n_agents, total_time, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed, infection_probability, recovery_probability, immunity_loss_probability)

# Visualize the simulation

plot_agents(output, 50, save=true)
plot_states(output, save=true)
```


#### Example: Running with YAML Configuration
```julia
using AgentEpidemics

# Load settings from YAML file
settings = load_settings("settings.yml")

# Run the simulation
output = run_simulation(settings)

# Visualize the simulation
plot_agents(output, 50, save=true)

plot_states(output, save=true)
```

where `settings.yml` is a YAML file containing the simulation parameters.
```yaml
n_agents: 100
total_time: 50
initial_infection_probability: 0.05
side_length: 100.0
contact_radius: 10.0
mean_speed: 1.0
std_speed: 0.5
infection_probability: 0.1
recovery_probability: 0.05
immunity_loss_probability: 0.01
```
