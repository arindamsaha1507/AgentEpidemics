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

function plot_agents(sim_output::SimulationOutput, time::Int, savefig::Bool=false)
    filtered = sim_output.positions[sim_output.positions.time .== time, :]
    plt = scatter(filtered.x, filtered.y, group=filtered.health, legend=true, title = "Time: $time")

    if savefig
        savefig("agents.png")
    end

    return plt
end