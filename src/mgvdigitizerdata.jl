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

function JlMGVDigitizerData(digitizer_data::pcpp"MGTClonesArray")
    n = (digitizer_data == C_NULL) ? zero(Int) : Int(@cxx digitizer_data->GetEntriesFast())

    ch = Vector{Int}(n)
    timestamp = Vector{UInt64}(n)
    index = Vector{Int}(n)
    energy = Vector{Float64}(n)
    bit_resolution = Vector{Int}(n)

    for i in 1:n
        data = icxx"dynamic_cast<MGVDigitizerData*>($digitizer_data->At($i - 1));"
        ch[i] = @cxx data->GetID()
        timestamp[i] = @cxx data->GetTimeStamp()
        index[i] = @cxx data->GetIndex()
        energy[i] = @cxx data->GetEnergy()
        bit_resolution[i] = @cxx data->GetBitResolution()
    end

    JlMGVDigitizerData(ch, timestamp, index, energy, bit_resolution)
end
