using Plots

"""
    plot_agents(agents::Vector{Agent})

Plots the agents in the simulation. The agents are colored according to their health.

# Arguments
- `agents::Vector{Agent}`: The agents to plot.

"""
function plot_agents(agents::Vector{Agent})
    x = [a.location[1] for a in agents]
    y = [a.location[2] for a in agents]
    health = [a.health for a in agents]
    scatter(x, y, group=health, legend=true)
    savefig("agents.png")
end

"""
    plot_agents(sim_output::SimulationOutput, time::Int)

Plots the agents in the simulation at a specific time. The agents are colored according to their health.

# Arguments
- `sim_output::SimulationOutput`: The simulation output.
- `time::Int`: The time at which to plot the agents.
- `savefig::Bool=false`: A boolean indicating whether to save the plot as a PNG file.

# Returns
The plot object.
"""
function plot_agents(sim_output::SimulationOutput, time::Int, save::Bool=false)
    filtered = sim_output.positions[sim_output.positions.time .== time, :]
    plt = scatter(filtered.x, filtered.y, group=filtered.health, legend=true, title = "Time: $time")

    if save
        savefig("agents.png")
    end

    return plt
end

"""
    plot_states(sim_output::SimulationOutput)

Plots the number of agents in each health state over time.

# Arguments
- `sim_output::SimulationOutput`: The simulation output.
- `savefig::Bool=false`: A boolean indicating whether to save the plot as a PNG file.

# Returns
The plot object.
"""
function plot_states(sim_output::SimulationOutput, save::Bool=false)
    plt = plot(sim_output.states[!, "susceptible"], title="Epidemic Simulation", xlabel="Time", ylabel="Number of Agents", legend=true, label="Susceptible")
    plot!(sim_output.states[!, "infected"], label="Infected")
    plot!(sim_output.states[!, "recovered"], label="Recovered")
    if save
        savefig("states.png")
    end
    return plt
end