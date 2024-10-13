"""
    evolve_agents!(agents::Vector{Agent}, side_length::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record_file::String="Timeseries.csv")

Evolve the agents in the simulation by moving, infecting, recovering, and losing immunity.

# Arguments
- `agents::Vector{Agent}`: A vector of `Agent` objects.
- `side_length::Float64`: The size of the simulation area.
- `infection_probability::Float64`: The probability of infection.
- `recovery_probability::Float64`: The probability of recovery.
- `immunity_loss_probability::Float64`: The probability of losing immunity.
- `record_file::String`: The name of the file to record the system state.

# Returns
A tuple `(susceptible, infected, recovered)` representing the number of agents in each health state.

"""
function evolve_agents!(agents::Vector{Agent}, side_length::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record_file::String="Timeseries.csv")
    move_agents!(agents, side_length)
    infect_agents!(agents, infection_probability)
    recover_agents!(agents, recovery_probability)
    lose_immunity!(agents, immunity_loss_probability)

    state = current_system_state(agents)

    open(record_file, "a") do f
        write(f, join(string.(state), ",") * "\n")
    end

    return state

end

"""
    run_simulation(n::Int, total_time::Int, initial_infection_probability::Float64, side_length::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record::Bool=false, record_file::String="Timeseries.csv")

Run the simulation with the specified parameters.

# Arguments
- `n::Int`: The number of agents in the simulation.
- `total_time::Int`: The total time steps for the simulation.
- `initial_infection_probability::Float64`: The probability that an agent is initially infected.
- `side_length::Float64`: The size of the simulation area.
- `contact_radius::Float64`: The maximum distance at which agents can come into contact.
- `mean_speed::Float64`: The mean speed of the agents.
- `std_speed::Float64`: The standard deviation of the speed of the agents.
- `infection_probability::Float64`: The probability of infection.
- `recovery_probability::Float64`: The probability of recovery.
- `immunity_loss_probability::Float64`: The probability of losing immunity.
- `record::Bool`: A boolean indicating whether to record the system state.
- `record_file::String`: The name of the file to record the system state.

# Returns
A dataframe representing the system state at each time step.

"""
function run_simulation(n::Int, total_time::Int, initial_infection_probability::Float64, side_length::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record::Bool=false, record_file::String="Timeseries.csv")


    Settings(n, total_time, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed, infection_probability, recovery_probability, immunity_loss_probability, record, record_file)


    agents = create_agents(n, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed)
    if record
        open(record_file, "w") do f
            write(f, "Susceptible,Infected,Recovered\n")
        end
    end

    states = DataFrame(susceptible=Int[], infected=Int[], recovered=Int[])
    snapshot = DataFrame(time=Int[], agent_id=Int[], x=Float64[], y=Float64[], health=String[])

    for i in 1:total_time
        state = evolve_agents!(agents, side_length, infection_probability, recovery_probability, immunity_loss_probability, record_file)
        states = vcat(states, DataFrame(susceptible=[state[1]], infected=[state[2]], recovered=[state[3]]))

        for a in agents
            push!(snapshot, (i, a.id, a.location[1], a.location[2], a.health))
        end
    end

    return SimulationOutput(states, snapshot)
end


"""
    run_simulation(filename::String)

Run the simulation with the settings specified in a YAML file.

# Arguments
- `filename::String`: The name of the YAML file containing the simulation settings.

# Returns
A dataframe representing the system state at each time step.
"""
function run_simulation(filename::String)
    settings = read_settings(filename)
    states = run_simulation(settings["n"], settings["total_time"], settings["initial_infection_probability"], settings["side_length"], settings["contact_radius"], settings["mean_speed"], settings["std_speed"], settings["infection_probability"], settings["recovery_probability"], settings["immunity_loss_probability"], settings["record"], settings["record_file"])
    return states
end
