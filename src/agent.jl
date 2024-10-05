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
