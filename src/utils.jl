using DataFrames
using YAML

"""
    struct SimulationOutput

Represents the output of the simulation.

# Fields
- `states`: A dataframe representing the number of agents in each health state at each time step.
- `positions`: A dataframe representing the position and health of each agent at each time step.

"""
mutable struct SimulationOutput
    states::DataFrame
    positions::DataFrame
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
