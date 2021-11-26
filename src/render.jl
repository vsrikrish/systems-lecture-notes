using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Mustache
using Glob

function create_remark_html(folder)
    # load template
    tpl = Mustache.load("template.html")

    # load content
    contentfile = open(joinpath(folder, "content.md"), "r")
    content = read(contentfile, String)

    title = string("Lecture", " ", last(folder, 2), " ", "Notes") 

    d = Dict("title" => title, "content" => content)

    outfile = open(joinpath(folder, string(folder, ".html")), "w")
    write(outfile, Mustache.render(tpl, d))
    close(outfile)

    return nothing
end

create_remark_html(ARGS[1])