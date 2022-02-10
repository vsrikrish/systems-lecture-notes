using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Remark

paths_ignore = [".git", ".github", "javascript", "src", "stylesheets"]
note_paths = setdiff(filter(x -> isdir(x), readdir(".")), paths_ignore)

for path in note_paths
    Remark.slideshow("overview", options = Dict("ratio" => "16:9", "highlightStyle" => "github", "highlightLanguage" => "julia"))
end