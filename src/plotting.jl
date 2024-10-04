using Plots

function plot_agents(agents::Vector{Agent})
    x = [a.location[1] for a in agents]
    y = [a.location[2] for a in agents]
    health = [a.health for a in agents]
    scatter(x, y, group=health, legend=true)
    savefig("agents.png")
end
