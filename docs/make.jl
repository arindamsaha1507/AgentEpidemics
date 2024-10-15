using Pkg
Pkg.activate("..")
Pkg.add("Documenter")

using Documenter, AgentEpidemics

makedocs(
    sitename = "AgentEpidemics Package Documentation"
    )

deploydocs(
    repo = "https://github.com/arindamsaha1507/AgentEpidemics",
    branch = "gh-pages"
    )
