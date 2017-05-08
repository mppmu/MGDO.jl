# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("MGTWaveform.hh")


export MGTWaveform, MGTWaveformPtr
const MGTWaveform = cxxt"MGTWaveform"
const MGTWaveformPtr = pcpp"MGTWaveform"


export JlMGTWaveforms

type JlMGTWaveforms
    ch::Vector{Int}
    samples::Vector{Vector{Float64}}
    t_0::Vector{Float64}
    delta_t::Vector{Float64}
    measurand::Vector{Int}
end

function JlMGTWaveforms(waveforms::pcpp"MGTClonesArray")
    n = (waveforms == C_NULL) ? zero(Int) : Int(@cxx waveforms->GetEntriesFast())

    ch = Vector{Int}(n)
    samples = Vector{Vector{Float64}}(n)
    t_0 = Vector{Float64}(n)
    delta_t = Vector{Float64}(n)
    measurand = Vector{Int}(n)

    for i in 1:n
        wf = icxx"dynamic_cast<MGTWaveform*>($waveforms->At($i - 1));"
        ch[i] = @cxx wf->GetID()
        samples[i] = Array(@cxx wf->GetVectorData())
        t_0[i] = @cxx wf->GetTOffset()
        delta_t[i] = @cxx wf->GetSamplingPeriod()
        measurand[i] = icxx"int($wf->GetWFType());"
    end

    JlMGTWaveforms(ch, samples, t_0, delta_t, measurand)
end
