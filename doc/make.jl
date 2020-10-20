using Documenter, Fuji

makedocs(
    format = :html,
    sitename = "Chaplin"
)

deploydocs(
    repo = "github.com/timo-cmd/chaplin.jl.git",
    julia = "0.6",
    osname = "windows",
    deps = nothing,
    make = nothing,
    target = "build"
)
