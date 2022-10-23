// Idea taken from http://docs.mathjax.org/en/latest/web/configuration.html via liminal (https://github.com/jonathanlilly/liminal)

//Call remark.js 
var slideshow = remark.create({
    ratio: "16:9",
    navigation: {
        click: false
    },
    properties: {
        class: "center, middle"
    },
    countIncrementalSlides: false,
    highlightLanguage: "julia",
    highlightStyle: "tomorrow-night-bright"

});

//Call KaTeX with auto-rendering, see https://katex.org/docs/autorender.html
document.addEventListener("DOMContentLoaded", function () {
    renderMathInElement(document.body, {
        delimiters: [
            {left: "$$",right: "$$",display: true},
            {left: "$",right: "$",display: false},
            {left: "\\[",right: "\\]", display: true},
            {left: "\\(",right: "\\)",display: false}
                    ]
    });
});