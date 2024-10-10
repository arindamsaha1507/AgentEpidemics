using YAML


"""
    struct Agent

Represents an agent in the simulation with a unique ID, health state, location, and contacts.

# Fields
- `id`: The unique identifier for the agent.
- `health`: The health state of the agent, which can be `'S'` (Susceptible), `'I'` (Infected), `'E'` (Exposed), or `'R'` (Recovered).
- `location`: A tuple representing the (x, y) coordinates of the agent in the simulation area.
- `contacts`: A vector of agent IDs that this agent has come into contact with.
- `speed`: A floating-point value representing the agent's speed in the simulation.

"""
mutable struct Agent
    id::Int
    health::String
    location::Tuple{Float64,Float64}
    speed::Float64
    contacts::Vector{Int}
end

"""
    distance(a::Agent, b::Agent)

Calculate the Euclidean distance between two agents.

# Arguments
- `a::Agent`: The first agent.
- `b::Agent`: The second agent.

# Returns
The Euclidean distance between the two agents.

"""
function distance(a::Agent, b::Agent)
    return sqrt((a.location[1] - b.location[1])^2 + (a.location[2] - b.location[2])^2)
end

"""
    create_agents(n::Int, initial_infection_probability::Float64, area_size::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64)

Create a vector of agents with the specified parameters.

# Arguments
- `n::Int`: The number of agents to create.
- `initial_infection_probability::Float64`: The probability that an agent is initially infected.
- `area_size::Float64`: The size of the simulation area.
- `contact_radius::Float64`: The maximum distance at which agents can come into contact.
- `mean_speed::Float64`: The mean speed of the agents.
- `std_speed::Float64`: The standard deviation of the speed of the agents.

# Returns
A vector of `Agent` objects.

"""
function create_agents(n::Int, initial_infection_probability::Float64, area_size::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64)

    agents = Vector{Agent}(undef, n)

    for i in 1:n
        health = rand() < initial_infection_probability ? "Infected" : "Susceptible"
        location = (rand() * area_size, rand() * area_size)
        contacts = Int[]
        speed = abs(mean_speed + std_speed * randn())
        agents[i] = Agent(i, health, location, speed, contacts)
    end

    for i in 1:n
        for j in 1:n
            if i != j && distance(agents[i], agents[j]) < contact_radius
                push!(agents[i].contacts, j)
            end
        end
    end

    return agents
end


"""
    move_agents!(agents::Vector{Agent}, area_size::Float64)

Move the agents in the simulation area.

# Arguments
- `agents::Vector{Agent}`: A vector of `Agent` objects.
- `area_size::Float64`: The size of the simulation area.

"""
function move_agents!(agents::Vector{Agent}, area_size::Float64)
    for a in agents
        angle = 2 * π * rand()
        a.location = (a.location[1] + a.speed * cos(angle), a.location[2] + a.speed * sin(angle))
        a.location = (mod(a.location[1], area_size), mod(a.location[2], area_size))
    end
end


"""
    infect_agents!(agents::Vector{Agent}, infection_probability::Float64)

Infect susceptible agents based on the infection probability and their contacts.

# Arguments
- `agents::Vector{Agent}`: A vector of `Agent` objects.
- `infection_probability::Float64`: The probability of infection.

"""
function infect_agents!(agents::Vector{Agent}, infection_probability::Float64)
    for a in agents
        if a.health == "Susceptible"
            for c in a.contacts
                if agents[c].health == "Infected" && rand() < infection_probability
                    a.health = "Infected"
                    break
                end
            end
        end
    end
end


"""
    recover_agents!(agents::Vector{Agent}, recovery_probability::Float64)

Recover infected agents based on the recovery probability.

# Arguments
- `agents::Vector{Agent}`: A vector of `Agent` objects.
- `recovery_probability::Float64`: The probability of recovery.

"""
function recover_agents!(agents::Vector{Agent}, recovery_probability::Float64)
    for a in agents
        if a.health == "Infected" && rand() < recovery_probability
            a.health = "Recovered"
        end
    end
end


"""
    lose_immunity!(agents::Vector{Agent}, immunity_loss_probability::Float64)

Lose immunity for recovered agents based on the immunity loss probability.

# Arguments
- `agents::Vector{Agent}`: A vector of `Agent` objects.
- `immunity_loss_probability::Float64`: The probability of losing immunity.

"""
function lose_immunity!(agents::Vector{Agent}, immunity_loss_probability::Float64)
    for a in agents
        if a.health == "Recovered" && rand() < immunity_loss_probability
            a.health = "Susceptible"
        end
    end
end


"""
    current_system_state(agents::Vector{Agent})

Calculate the current system state based on the number of susceptible, infected, and recovered agents.

# Arguments
- `agents::Vector{Agent}`: A vector of `Agent` objects.

# Returns
A tuple `(susceptible, infected, recovered)` representing the number of agents in each health state.

"""
function current_system_state(agents::Vector{Agent})
    susceptible = sum([a.health == "Susceptible" for a in agents])
    infected = sum([a.health == "Infected" for a in agents])
    recovered = sum([a.health == "Recovered" for a in agents])
    return (susceptible, infected, recovered)
end


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

end


"""
    struct Probability

Represents a probability value between 0 and 1.

# Fields
- `value`: The probability value.

"""
mutable struct Probability
    value::Float64

    function Probability(value::Float64)
        if value < 0 || value > 1
            throw(ArgumentError("Probability value must be between 0 and 1"))
        end
        new(value)
    end

end


"""
    struct PositiveNumber

Represents a positive number.

# Fields
- `value`: The positive number.

"""
mutable struct PositiveNumber
    value::Float64

    function PositiveNumber(value::Float64)
        if value < 0
            throw(ArgumentError("Value must be positive"))
        end
        new(value)
    end

    function PositiveNumber(value::Int)
        if value < 0
            throw(ArgumentError("Value must be positive"))
        end
        new(value)
        
    end

end


"""
    struct Settings

Represents the settings for the simulation.

# Fields
- `n`: The number of agents in the simulation.
- `total_time`: The total time steps for the simulation.
- `initial_infection_probability`: The probability that an agent is initially infected.
- `side_length`: The size of the simulation area.
- `contact_radius`: The maximum distance at which agents can come into contact.
- `mean_speed`: The mean speed of the agents.
- `std_speed`: The standard deviation of the speed of the agents.
- `infection_probability`: The probability of infection.
- `recovery_probability`: The probability of recovery.
- `immunity_loss_probability`: The probability of losing immunity.
- `record`: A boolean indicating whether to record the system state.
- `record_file`: The name of the file to record the system state.

"""
mutable struct Settings
    n::Int
    total_time::Int
    initial_infection_probability::Float64
    side_length::Float64
    contact_radius::Float64
    mean_speed::Float64
    std_speed::Float64
    infection_probability::Float64
    recovery_probability::Float64
    immunity_loss_probability::Float64
    record::Bool
    record_file::String

    function Settings(n::Int, total_time::Int, initial_infection_probability::Float64, side_length::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record::Bool, record_file::String)

        n = PositiveNumber(n).value
        total_time = PositiveNumber(total_time).value
        side_length = PositiveNumber(side_length).value
        contact_radius = PositiveNumber(contact_radius).value
        mean_speed = PositiveNumber(mean_speed).value
        std_speed = PositiveNumber(std_speed).value

        infection_probability = Probability(infection_probability).value
        recovery_probability = Probability(recovery_probability).value
        immunity_loss_probability = Probability(immunity_loss_probability).value

        new(n, total_time, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed, infection_probability, recovery_probability, immunity_loss_probability, record, record_file)
    end
        
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

"""
function run_simulation(n::Int, total_time::Int, initial_infection_probability::Float64, side_length::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64, record::Bool=false, record_file::String="Timeseries.csv")


    Settings(n, total_time, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed, infection_probability, recovery_probability, immunity_loss_probability, record, record_file)


    agents = create_agents(n, initial_infection_probability, side_length, contact_radius, mean_speed, std_speed)
    if record
        open(record_file, "w") do f
            write(f, "Susceptible,Infected,Recovered\n")
        end
    end

    for i in 1:total_time
        evolve_agents!(agents, side_length, infection_probability, recovery_probability, immunity_loss_probability, record_file)
    end
end


"""
    run_simulation(filename::String)

Run the simulation with the settings specified in a YAML file.

# Arguments
- `filename::String`: The name of the YAML file containing the simulation settings.

"""
function run_simulation(filename::String)
    settings = read_settings(filename)
    run_simulation(settings["n"], settings["total_time"], settings["initial_infection_probability"], settings["side_length"], settings["contact_radius"], settings["mean_speed"], settings["std_speed"], settings["infection_probability"], settings["recovery_probability"], settings["immunity_loss_probability"], settings["record"], settings["record_file"])
end


"""
    read_settings(file::String)

Read the simulation settings from a YAML file.

# Arguments
- `file::String`: The name of the YAML file containing the simulation settings.

# Returns
A dictionary of the simulation settings.

"""
function read_settings(file::String)
    settings = YAML.load_file(file)
    return settings
end