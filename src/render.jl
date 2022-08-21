using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Remark

paths_ignore = [".git", ".github", "javascript", "src", "stylesheets"]
note_paths = setdiff(filter(x -> isdir(x), readdir(".")), paths_ignore)

for path in note_paths
    println(path)
    println("Copying CSS file...")
    cp("style.css", string(path, "/src/style.css"); force=true)
    println("Building slideshow...")
    Remark.slideshow(path, title = titlecase(replace(path, "-" => " ")), options = Dict("ratio" => "16:9", "highlightStyle" => "github", "highlightLanguage" => "julia"))
    println("Moving Built Files...")
    mv(string(path, "/build/index.html"), string(path, "/index.html"); force=true)
    mv(string(path, "/build/style.css"), string(path, "/style.css"); force=true)
    for f in filter(x -> occursin(".svg", x), readdir(string(path, "/build")))
        mv(string(path, "/build/", f), string(path, "/figures/", f); force=true)
    end
    rm(string(path, "/src/style.css"))
end