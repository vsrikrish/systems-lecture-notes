using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Remark

paths_ignore = [".git", ".github", "javascript", "src", "stylesheets"]
note_paths = setdiff(filter(x -> isdir(x), readdir(".")), paths_ignore)

for path in note_paths
    path
    Remark.slideshow(path, title = titlecase(replace(path, "-" => " ")), options = Dict("ratio" => "16:9", "highlightStyle" => "github", "highlightLanguage" => "julia"))
    cd(path)
    mv("build/index.html", "index.html")
    mv("build/fonts", "fonts")
    for f in filter(x -> occursin("js", x), readdir("build"))
        mv(string("build/", f), f)
    end
    for f in filter(x -> occursin("css", x), readdir("build"))
        mv(string("build/", f), f)
    end
    cd("..")
end