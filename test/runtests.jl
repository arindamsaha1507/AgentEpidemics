using Test
using AgentEpidemics

# Example test
@testset "Utils Tests" begin

    @testset "Probability Tests" begin
        p = AgentEpidemics.Probability(0.5)
        @test p.value == 0.5
        @test_throws ArgumentError AgentEpidemics.Probability(-0.5)
        @test_throws ArgumentError AgentEpidemics.Probability(1.5)
    end

    @testset "PositiveNumber Tests" begin
        n = AgentEpidemics.PositiveNumber(5)
        @test n.value == 5
        @test_throws ArgumentError AgentEpidemics.PositiveNumber(-5)
    end

    @testset "Settings Tests" begin
        n = 100
        side_length = 100.0
        contact_radius = 10.0
        initial_infection_probability = 0.1
        
        infection_probability = 0.1
        recovery_probability = 0.1
        immunity_loss_probability = 0.1 
    
        mean_speed = 1.0
        std_speed = 0.1
    
        total_time = 1000

        record = true
        record_file = "Timeseries.csv"

        settings = AgentEpidemics.Settings(n, total_time, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed, infection_probability, recovery_probability, immunity_loss_probability, record, record_file)

        @test settings.n == n
        @test settings.total_time == total_time
        @test settings.initial_infection_probability == initial_infection_probability
        @test settings.side_length == side_length
        @test settings.contact_radius == contact_radius
        @test settings.mean_speed == mean_speed
        @test settings.std_speed == std_speed
        @test settings.infection_probability == infection_probability
        @test settings.recovery_probability == recovery_probability
        @test settings.immunity_loss_probability == immunity_loss_probability
        @test settings.record == record
        @test settings.record_file == record_file

        end

end


@testset "Agent Tests" begin
    
    @testset "Agent Creation Tests" begin
        n = 1
        side_length = 100.0
        contact_radius = 10.0
        initial_infection_probability = 0.1
        
        mean_speed = 1.0
        std_speed = 0.1
    
        agents = AgentEpidemics.create_agents(n, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed)

        @test length(agents) == n

        for a in agents
            @test a.health == "Susceptible" || a.health == "Infected"
            @test a.location[1] >= 0 && a.location[1] <= side_length
            @test a.location[2] >= 0 && a.location[2] <= side_length
            @test a.speed >= 0
            @test length(a.contacts) <= n
        end
    end

end

@testset "Simulation Tests" begin

    @testset "Simulation Output Tests" begin
        n = 100
        side_length = 100.0
        contact_radius = 10.0
        initial_infection_probability = 0.1
        
        infection_probability = 0.1
        recovery_probability = 0.1
        immunity_loss_probability = 0.1 
    
        mean_speed = 1.0
        std_speed = 0.1
    
        total_time = 1000

        record = true
        record_file = "Timeseries.csv"

        settings = AgentEpidemics.Settings(n, total_time, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed, infection_probability, recovery_probability, immunity_loss_probability, record, record_file)

        results = AgentEpidemics.run_simulation(settings)

        @test size(results.states, 1) == total_time
        @test size(results.states, 2) == 3

        @test size(results.positions, 1) == n * total_time
        @test size(results.positions, 2) == 5

        @test all(results.states.susceptible .>= 0)
        @test all(results.states.infected .>= 0)
        @test all(results.states.recovered .>= 0)

        @test all(results.states.susceptible .+ results.states.infected .+ results.states.recovered .== n)

        @test all(results.positions.time .>= 1)
        @test all(results.positions.time .<= total_time)
        @test all(results.positions.agent_id .>= 1)
        @test all(results.positions.agent_id .<= n)
        @test all(results.positions.x .>= 0)
        @test all(results.positions.x .<= side_length)
        @test all(results.positions.y .>= 0)
        @test all(results.positions.y .<= side_length)
        @test(Set(results.positions.health) == Set(["Susceptible", "Infected", "Recovered"]))

    end

end