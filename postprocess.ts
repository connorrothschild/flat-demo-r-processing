import 'https://deno.land/x/flat@0.0.10/mod.ts'

const r_dl = Deno.run({
    cmd: ['wget', 'http://cran.r-project.org/src/contrib/tidyverse_1.3.1.tar.gz']
});

await r_dl.status();

// install requirements with pip
const r_install = Deno.run({
    cmd: ['R', 'CMD', 'INSTALL', 'tidyverse_1.3.1.tar.gz'],
});

await r_install.status();

// Forwards the execution to the python script
const r_run = Deno.run({
    cmd: ['Rscript', './clean-data.R']
});

await r_run.status();
