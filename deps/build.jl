using BinDeps

@BinDeps.setup

mgdo_version = "f3b2f109"

libMGDOBase = library_dependency("libMGDOBase", aliases=[])

info(BinDeps._find_library(libMGDOBase))
info(BinDeps.issatisfied(libMGDOBase))

prefix = joinpath(BinDeps.depsdir(libMGDOBase), "usr")
srcdir = BinDeps.srcdir(libMGDOBase)
mgdo_srcdir = joinpath(srcdir, "MGDO")

if is_linux()
    ldflags="-Wl,-rpath,'\$\$ORIGIN' -Wl,-z,origin"
else
    ldflags=""
end


# BSD systems (other than macOS) use BSD Make rather than GNU Make by default
# We need GNU Make, and on such systems GNU make is invoked as `gmake`
make = is_bsd() && !is_apple() ? "gmake" : "make"

provides(SimpleBuild,
    (@build_steps begin
        CreateDirectory(srcdir)

        BinDeps.DirectoryRule(mgdo_srcdir, @build_steps begin
          ChangeDirectory(srcdir)
          `git clone git@github.com:mppmu/MGDO.git`
        end)

        @build_steps begin
            ChangeDirectory(mgdo_srcdir)
            `git fetch`
            `git checkout $mgdo_version`
        end

        @build_steps begin
            ChangeDirectory(mgdo_srcdir)
            `git clean -f -d -x`
            `./configure LDFLAGS=$ldflags --prefix=$prefix --disable-tam --disable-static --enable-streamers --disable-majorana --disable-tabree --disable-mjdb`
            `$make`
            `$make install`
            `git checkout .`
            `git clean -f -d -x`
        end
    end), [libMGDOBase],
    os = :Unix
)

@BinDeps.install Dict(:libMGDOBase => :libMGDOBase)
