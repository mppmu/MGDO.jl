# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("MGTEvent.hh")


export MGTEvent, MGTEventPtr
const MGTEvent = cxxt"MGTEvent"
const MGTEventPtr = pcpp"MGTEvent"


export JlMGTEvent

type JlMGTEvent
    evtno::Int
    E_total::Float64
    timestamp::Float64
    has_aux_wf::Bool
    waveforms::JlMGTWaveforms
    aux_waveforms::JlMGTWaveforms
    digitizer_data::JlMGVDigitizerData
end

function Base.convert(::Type{JlMGTEvent}, event::MGTEventPtr)
    evtno = @cxx event->GetEventNumber()
    E_total = @cxx event->GetETotal()
    timestamp = @cxx event->GetTime()
    has_aux_wf = @cxx event->GetAuxWaveformArrayStatus()
    waveforms = JlMGTWaveforms(@cxx event->GetWaveforms())
    aux_waveforms = JlMGTWaveforms(@cxx event->GetAuxWaveforms())
    digitizer_data = JlMGVDigitizerData(@cxx event->GetDigitizerData())
    # ch_active = convert(DenseArray{Bool}, icxx"*$(@cxx event->GetIDStatusArray());")

    JlMGTEvent(evtno, E_total, timestamp, has_aux_wf, waveforms, aux_waveforms, digitizer_data)
end
