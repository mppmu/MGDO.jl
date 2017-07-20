# MGDO.jl

## Non-Julia dependencies

During `Pkg.build("MGDO")` MGDO.jl will automatically download and install a
compatible version of MGDO internally. To do so, it will run
`git clone git@github.com:mppmu/MGDO.git`. You must have the necessary
privileges to access the MGDO repository and your SSH keys must be set up
correctly.

ROOT and CLHEP must be installed - in particular, `root-config` and
`clhep-config` must be on your `$PATH`, and the dynamic linker must be able
to load the ROOT and CLHEP dynamic libraries (e.g. via `$LD_LIBRARY_PATH`).


## Installation

To install MGDO.jl, run

```julia
Pkg.clone("https://github.com/mppmu/MGDO.jl.git")
Pkg.build("MGDO")
```

If you need to use a specific branch (e.g. "dev"), run

```julia
Pkg.clone("https://github.com/mppmu/MGDO.jl.git")
Pkg.checkout("MGDO", "dev")
Pkg.build("MGDO")
```
