include("src/AgentEpidemics.jl")

using .AgentEpidemics

n = 500
size = 100.0
radius = 10.0
infection_probablity = 0.1

agents = create_agents(n, infection_probablity, size, radius, 1.0, 0.1)

susceptible = sum([a.health == "Susceptible" for a in agents])
infected = sum([a.health == "Infected" for a in agents])

println("Susceptible: $susceptible")
println("Infected: $infected")

plot_agents(agents)