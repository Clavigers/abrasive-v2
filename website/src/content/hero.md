Abrasive is my crack at bringing the good stuff from bazel / buck2 to plain ol' cargo projects. Specifically: remote shared cache, distributed compilation and hermetic builds.

This is not a product! This is an experimental collection of programs. Put together they give me what I want out of bazel for rust-only projects. 

The code is open source. 

There is a server component to abrasive, if you want to check it out without setting up hosting you can join the test instance. I need to limit the number of builds to something reasonable because I don't have infinite money.

AI disclosure: None of the code in abrasive was written by an LLM, but LLMs were used extensively for research and bug finding.