# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

__precompile__(false)

module MGDO

include.([
    "load_deps.jl",
    "mgtwaveform.jl",
    "mgvdigitizerdata.jl",
    "mgtevent.jl",
    "mgteventtree.jl",
])

end # module
