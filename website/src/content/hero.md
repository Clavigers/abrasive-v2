**Abrasive** is an opinionated solution to fast and correct Rust builds, especially for monorepos.

Plain `cargo build` is great, but it has nothing to share between machines. Bazel and Buck2 do, but at the cost of a whole new mental model layered on top of everything Cargo already does well.

Abrasive sits on top of Cargo instead of replacing it. A shared, content-addressed artifact store hydrates your local `target/` from anyone on your team — or CI — who already built the same inputs. The first person to compile a revision pays the cost; everyone else gets it for free.
