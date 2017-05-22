# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

using Cxx


cxxinclude("MGVDigitizerData.hh")

export MGVDigitizerData, MGVDigitizerDataPtr
const MGVDigitizerData = cxxt"MGVDigitizerData"
const MGVDigitizerDataPtr = pcpp"MGVDigitizerData"


export JlMGVDigitizerData

type JlMGVDigitizerData
    ch::Vector{Int}
    timestamp::Vector{UInt64}
    index::Vector{Int}
    energy::Vector{Float64}
    bit_resolution::Vector{Int}
end

JlMGVDigitizerData() = JlMGVDigitizerData(
    Vector{Int}(),
    Vector{UInt64}(),
    Vector{Int}(),
    Vector{Float64}(),
    Vector{Int}()
)


function Base.copy!(jl_digitizer_data::JlMGVDigitizerData, digitizer_data::pcpp"MGTClonesArray")
    n = (digitizer_data == C_NULL) ? zero(Int) : Int(@cxx digitizer_data->GetEntriesFast())

    resize!(jl_digitizer_data.ch, 0)
    resize!(jl_digitizer_data.timestamp, 0)
    resize!(jl_digitizer_data.index, 0)
    resize!(jl_digitizer_data.energy, 0)
    resize!(jl_digitizer_data.bit_resolution, 0)

    for i in 1:n
        data = icxx"dynamic_cast<MGVDigitizerData*>($digitizer_data->At($i - 1));"
        push!(jl_digitizer_data.ch, @cxx data->GetID())
        push!(jl_digitizer_data.timestamp, @cxx data->GetTimeStamp())
        push!(jl_digitizer_data.index, @cxx data->GetIndex())
        push!(jl_digitizer_data.energy, @cxx data->GetEnergy())
        push!(jl_digitizer_data.bit_resolution, @cxx data->GetBitResolution())
    end
    jl_digitizer_data
end


Base.convert(::Type{JlMGVDigitizerData}, digitizer_data::pcpp"MGTClonesArray") =
    copy!(JlMGVDigitizerData(), digitizer_data)
