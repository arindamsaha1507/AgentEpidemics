mutable struct Agent
    id::Int
    health::String
    location::Tuple{Float64, Float64}
    speed::Float64
    contacts::Vector{Int}
end

function distance(a::Agent, b::Agent)
    return sqrt((a.location[1] - b.location[1])^2 + (a.location[2] - b.location[2])^2)
end

function create_agents(n::Int, infection_probability::Float64, area_size::Float64, contact_radius::Float64, mean_speed::Float64, std_speed::Float64)
    
    agents = Vector{Agent}(undef, n)

    for i in 1:n
        health = rand() < infection_probability ? "Infected" : "Susceptible"
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

function move_agents!(agents::Vector{Agent}, area_size::Float64)
    for a in agents
        angle = 2 * π * rand()
        a.location = (a.location[1] + a.speed * cos(angle), a.location[2] + a.speed * sin(angle))
        a.location = (mod(a.location[1], area_size), mod(a.location[2], area_size))
    end
end


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

function recover_agents!(agents::Vector{Agent}, recovery_probability::Float64)
    for a in agents
        if a.health == "Infected" && rand() < recovery_probability
            a.health = "Recovered"
        end
    end
end

function lose_immunity!(agents::Vector{Agent}, immunity_loss_probability::Float64)
    for a in agents
        if a.health == "Recovered" && rand() < immunity_loss_probability
            a.health = "Susceptible"
        end
    end
end

function evolve_agents!(agents::Vector{Agent}, infection_probability::Float64, recovery_probability::Float64, immunity_loss_probability::Float64)
    move_agents!(agents, 100.0)
    infect_agents!(agents, infection_probability)
    recover_agents!(agents, recovery_probability)
    lose_immunity!(agents, immunity_loss_probability)
end