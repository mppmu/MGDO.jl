# This file is a part of MGDO.jl, licensed under the MIT License (MIT).

const deps_jl = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(deps_jl)
    include(deps_jl)
else
    error("MGDO is not properly installed. Run Pkg.build(\"MGDO\").")
end


using ROOT, Cxx


function _init_clhep()
    const cflags = " "*replace((readstring(`clhep-config --include`)), "\n", " ")
    const includedirs = map(s -> replace(s, "\"", "")[4:end], matchall(r""" -I"?([^ ]+)"?""", cflags))
    foreach(d -> addHeaderDir(d, kind=C_System), includedirs)
end
_init_clhep()


const mgdo_libdir = dirname(MGDO.libMGDOBase)
const mgdo_prefix = dirname(mgdo_libdir)
const mgdo_includedir = joinpath(mgdo_prefix, "include", "mgdo")

const mgdo_libpath = joinpath(mgdo_libdir, "libMGDORoot")

for lib in ["libMGDORoot", "libMGDOGerda"]
    libpath = joinpath(mgdo_libdir, lib)
    icxx"gSystem->Load($libpath);"
    # Libdl.dlopen(libpath, Libdl.RTLD_GLOBAL) # necessary if already loaded via TSystem::Load()?
end

addHeaderDir(mgdo_includedir, kind=C_System)
