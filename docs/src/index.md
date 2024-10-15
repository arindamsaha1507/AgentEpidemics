# A Simple Julia Package for SIRS Epidemiological Model

## Introduction to the SIRS Model

The **SIRS model** is a classic epidemiological model used to describe the spread of infectious diseases within a population. It is a compartmental model that categorizes individuals into three main groups or **compartments**:

1. **Susceptible (S)**: Individuals who are healthy but can become infected if exposed to the disease.
2. **Infected (I)**: Individuals who are currently infected and can spread the disease to susceptible individuals.
3. **Recovered (R)**: Individuals who have recovered from the disease and have temporary immunity.

### Dynamics of the SIRS Model

In the SIRS model, individuals transition between the three compartments over time, following a specific flow:
- **S → I (Infection)**: Susceptible individuals can become infected if they come into contact with an infected person. The rate of infection depends on the contact rate and the infection probability.
- **I → R (Recovery)**: Infected individuals eventually recover from the disease, moving into the recovered category. This transition occurs at a rate determined by the average duration of the infection.
- **R → S (Loss of Immunity)**: Unlike the simpler **SIR model**, where recovered individuals gain permanent immunity, in the SIRS model, individuals lose immunity after a period of time and become susceptible again. This makes the SIRS model particularly useful for studying diseases where immunity is temporary, such as the flu.

### Applications of the SIRS Model

The SIRS model is widely used in epidemiology to study diseases where immunity is not lifelong, such as:
- Influenza (seasonal flu)
- Common cold
- Certain bacterial infections

By adjusting the parameters of the model (such as the infection, recovery, and immunity loss rates), the SIRS model can simulate different disease dynamics and predict the outcome of various public health interventions, such as vaccination campaigns or quarantine measures.

### Limitations

While the SIRS model provides valuable insights into disease dynamics, it is still a simplified model. It assumes that all individuals are equally likely to interact, which may not be realistic for diseases that spread in structured populations or networks. Moreover, it does not account for factors such as age, mobility, or variations in immunity levels, which can also influence the spread of disease.

Nevertheless, the SIRS model serves as a foundational tool in epidemiology, allowing researchers to explore the basic principles of infectious disease modelling.


## Implementation in the package

In the **AgentEpidemics.jl** package, the **SIRS model** is implemented using an **agent-based approach**. Rather than solving differential equations as in the classical compartmental models, this approach simulates the behavior of individual agents who transition between the **Susceptible (S)**, **Infectious (I)**, and **Recovered (R)** states. The following sections explain how different components of the SIRS model are implemented.

### Agents

Each agent in the simulation is represented by an instance of the `Agent` struct. An agent has the following properties:
- `id`: A unique identifier for the agent.
- `health`: The health status of the agent, which can be `'Susceptible'`, `'Infected'`, or `'Recovered'`.
- `location`: A tuple representing the agent's position in a 2D space.
- `speed`: The agent's speed, determining how far they can move in each time step.
- `contacts`: A list of other agents with whom this agent has come into contact.

Here is how the `Agent` struct is defined:

```julia
mutable struct Agent
    id::Int
    health::String
    location::Tuple{Float64, Float64}
    speed::Float64
    contacts::Vector{Int}
end
```

### Agent Movement

Each agent moves randomly in the simulation space during each time step. We handle this behavior by updating the location of each agent based on their speed and a random direction. The agents' movement ensures dynamic interaction between individuals, enabling them to form new contacts during the simulation, which is essential for the spread of infection.

### Disease Transmission

In the SIRS model, disease transmission occurs when a susceptible agent comes into contact with an infected agent. When two agents are within the defined contact radius, and one of them is infected, the susceptible agent has a chance of becoming infected based on the infection probability.


### Recovery and Immunity Loss

After a certain period, infected agents can recover based on a given recovery probability. The infected agents are then moved to the **Recovered (R)** state.

However, immunity in the SIRS model is temporary. After the loss of immunity, the recoved agents become susceptible again, completing the SIRS cycle.

### Simulation Evolution

During each time step, the following processes occur:

1. Agents move within the simulation space.
2. Disease spreads between agents based on their contacts.
3. Infected agents recover and move to the recovered state.
4. Recovered agents lose immunity and become susceptible again.

## API References


### Data Structures

```@docs

Settings

SimulationOutput

```

### Running Simulation

```@docs

run_simulation(n::Int, total_time::Int, initial_infection_probability::Float64, side_length::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record::Bool=false, record_file::String="Timeseries.csv")


run_simulation(filename::String)

run_simulation(settings::Settings)

```

### Plotting

```@docs

plot_agents(sim_output::SimulationOutput, time::Int)

plot_states(sim_output::SimulationOutput)

```