# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TChain.h")


export MGTEventTree

type MGTEventTree{T} <: AbstractArray{T,1}
    tchain::pcpp"TChain"
    event::Ref{MGTEventPtr}
end


function Base.open{T}(::Type{MGTEventTree{T}}, filename::AbstractString; treename::AbstractString = "MGTree", branchname::AbstractString = "event")
    tchain = lock(_root_thread_lock) do
        icxx"new TChain($treename);"
    end
    event = Ref(icxx"(MGTEvent*)(nullptr);")
    @cxx tchain->AddFile(pointer(filename))
    @cxx tchain->SetBranchAddress(pointer(branchname), icxx"&$(event);")
    result = MGTEventTree{T}(tchain, event)
    finalizer(result, close)
    result
end

Base.open(::Type{MGTEventTree}, filename::AbstractString; kwargs...) =
    open(MGTEventTree{MGTEventPtr}, filename; kwargs ...)


function Base.isopen(evttree::MGTEventTree)
    if evttree.tchain != C_NULL
        true
    else
        @assert evttree.event.x == C_NULL
        false
    end
end


function Base.close(evttree::MGTEventTree)
    if evttree.tchain != C_NULL
        lock(_root_thread_lock) do
            icxx"delete $(evttree.tchain);"
        end
        evttree.tchain = icxx"(TChain*)(nullptr);"
    end
    if evttree.event.x != C_NULL
        icxx"delete $(evttree.event);"
        evttree.event.x = icxx"(MGTEvent*)(nullptr);"
    end
    nothing
end


Base.size(evttree::MGTEventTree) = ((@cxx evttree.tchain->GetEntries()),)

@inline function Base.getindex{T}(evttree::MGTEventTree{T}, i::Integer)
    @boundscheck checkbounds(evttree, i)
    @cxx evttree.tchain->GetEntry(i - 1)
    convert(T, evttree.event.x)
end
