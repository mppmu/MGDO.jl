# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

using Cxx
import CxxStd

cxxinclude("MGTWaveform.hh")


export MGTWaveform, MGTWaveformPtr
const MGTWaveform = cxxt"MGTWaveform"
const MGTWaveformPtr = pcpp"MGTWaveform"


const WrappedSamplesVector = CxxStd.WrappedCppPrimArray{Float64}


export JlMGTWaveforms

type JlMGTWaveforms
    ch::Vector{Int}
    samples::Vector{WrappedSamplesVector}
    t_0::Vector{Float64}
    delta_t::Vector{Float64}
    measurand::Vector{Int}
end

JlMGTWaveforms() = JlMGTWaveforms(
    Vector{Int}(),
    Vector{WrappedSamplesVector}(),
    Vector{Float64}(),
    Vector{Float64}(),
    Vector{Int}(),
)


function Base.copy!(jl_waveforms::JlMGTWaveforms, waveforms::pcpp"MGTClonesArray")
    n = (waveforms == C_NULL) ? zero(Int) : Int(@cxx waveforms->GetEntriesFast())

    resize!(jl_waveforms.ch, 0)
    resize!(jl_waveforms.samples, 0)
    resize!(jl_waveforms.t_0, 0)
    resize!(jl_waveforms.delta_t, 0)
    resize!(jl_waveforms.measurand, 0)

    for i in 1:n
        wf = icxx"dynamic_cast<MGTWaveform*>($waveforms->At($i - 1));"
        push!(jl_waveforms.ch, @cxx wf->GetID())
        push!(jl_waveforms.samples, unsafe_wrap(DenseArray, @cxx wf->GetVectorData()))
        push!(jl_waveforms.t_0, @cxx wf->GetTOffset())
        push!(jl_waveforms.delta_t, @cxx wf->GetSamplingPeriod())
        push!(jl_waveforms.measurand, icxx"int($wf->GetWFType());")
    end
    jl_waveforms
end


Base.convert(::Type{JlMGTWaveforms}, waveforms::pcpp"MGTClonesArray") =
    copy!(JlMGTWaveforms(), waveforms)
