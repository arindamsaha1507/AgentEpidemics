using Plots

function plot_agents(agents::Vector{Agent})
    x = [a.location[1] for a in agents]
    y = [a.location[2] for a in agents]
    health = [a.health for a in agents]
    scatter(x, y, group=health, legend=true)
    savefig("agents.png")
end


function animate_agents!(agents::Vector{Agent}, area_size::Float64, n_steps::Int)
    x = [a.location[1] for a in agents]
    y = [a.location[2] for a in agents]
    health = [a.health for a in agents]
    p = scatter(x, y, group=health, legend=true)

    anim = @animate for i in 1:n_steps

        evolve_agents!(agents, 0.01, 0.01, 0.05)
        move_agents!(agents, area_size)
        x = [a.location[1] for a in agents]
        y = [a.location[2] for a in agents]
        health = [a.health for a in agents]
        scatter(x, y, group=health, legend=true)
    end
    gif(anim, "agents.gif", fps=10)
end