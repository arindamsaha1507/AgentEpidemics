mutable struct Agent
    id::Int
    health::String
    location::Tuple{Float64, Float64}
    contacts::Vector{Int}
end

function distance(a::Agent, b::Agent)
    return sqrt((a.location[1] - b.location[1])^2 + (a.location[2] - b.location[2])^2)
end

function create_agents(n::Int, infection_probability::Float64, area_size::Float64, contact_radius::Float64)
    
    agents = Vector{Agent}(undef, n)

    for i in 1:n
        health = rand() < infection_probability ? "Infected" : "Susceptible"
        location = (rand() * area_size, rand() * area_size)
        contacts = Int[]
        agents[i] = Agent(i, health, location, contacts)
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
