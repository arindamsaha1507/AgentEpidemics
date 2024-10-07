using Test
using AgentEpidemics

# Example test
@testset "AgentEpidemics Tests" begin
    agents = create_agents(10, 0.1, 100.0, 10.0, 1.0, 0.1)
    @test length(agents) == 10
    @test agents[1].health in ["Susceptible", "Infected"]
end
