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
