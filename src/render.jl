using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Mustache
using Glob

tokens = Dict()

# load template
tpl = Mustache.load("template.html")

lecture_folders = filter(isdir, readdir(glob"lecture*"))
for (index, folder) in enumerate(lecture_folders)
    # load content
    contentfile = open(joinpath(folder, string(folder, ".md")), "r")
    content = read(contentfile, String)

    title = string("Lecture", " ", index) 

    d = Dict("title" => title, "content" => content)

    outfile = open(joinpath(folder, string(folder, "-jl.html")), "w")
    write(outfile, Mustache.render(tpl, d))
    close(outfile)
end