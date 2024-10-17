module AgentEpidemics

include("utils.jl")
include("agent.jl")
include("simulation.jl")
include("plotting.jl")

export plot_agents, plot_states, run_simulation, Settings, SimulationOutput

end # module AgentEpidemics
