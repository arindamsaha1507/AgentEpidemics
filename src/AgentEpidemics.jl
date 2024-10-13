module AgentEpidemics

include("utils.jl")
include("agent.jl")
include("simulation.jl")
include("plotting.jl")

export Agent, create_agents, plot_agents, animate_agents!, run_simulation

end # module AgentEpidemics
