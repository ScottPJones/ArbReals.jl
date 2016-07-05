
function protogenerate(metatypeFile::String)
    prototypes = typePrototypes()

    if isfile(metatypeFile)
        rm(metatypeFile, force=true)
    end

    # check that directory exists, if not .. make it (use @__FILE__) source_path

    open(metatypeFile, "w") do filehandle
       for line in eachline(prototypes)
            write( filehandle, line )
        end
    end

    return true
end
