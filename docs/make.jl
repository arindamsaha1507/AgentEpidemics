using Pkg
Pkg.activate("..")
Pkg.add("Documenter")

using Documenter, AgentEpidemics

makedocs(
    sitename = "AgentEpidemics Package Documentation"
    )