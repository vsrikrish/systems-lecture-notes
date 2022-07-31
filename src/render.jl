using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Remark

paths_ignore = [".git", ".github", "javascript", "src", "stylesheets"]
note_paths = setdiff(filter(x -> isdir(x), readdir(".")), paths_ignore)

for path in note_paths
    path
    Remark.slideshow(path, title = titlecase(replace(path, "-" => " ")), options = Dict("ratio" => "16:9", "highlightStyle" => "github", "highlightLanguage" => "julia"))
    mv(string(path, "/build/index.html"), string(path, "/index.html"); force=true)
end