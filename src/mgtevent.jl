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

JlMGTEvent() = JlMGTEvent(
    0,
    0,
    0,
    false,
    JlMGTWaveforms(),
    JlMGTWaveforms(),
    JlMGVDigitizerData(),
)


function Base.copy!(jl_event::JlMGTEvent, event::MGTEventPtr)
    jl_event.evtno = @cxx event->GetEventNumber()
    jl_event.E_total = @cxx event->GetETotal()
    jl_event.timestamp = @cxx event->GetTime()
    jl_event.has_aux_wf = @cxx event->GetAuxWaveformArrayStatus()
    copy!(jl_event.waveforms, @cxx event->GetWaveforms())
    copy!(jl_event.aux_waveforms, @cxx event->GetAuxWaveforms())
    copy!(jl_event.digitizer_data, @cxx event->GetDigitizerData())

    jl_event
end


Base.convert(::Type{JlMGTEvent}, event::MGTEventPtr) = copy!(JlMGTEvent(), event)
