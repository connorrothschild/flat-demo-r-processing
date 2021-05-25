import 'https://deno.land/x/flat@0.0.10/mod.ts'

const r_install = Deno.run({
    cmd: ['RUN', 'Rscript', '-e', "install.packages('tidyverse')"]
});

await r_install.status();

// Forwards the execution to the python script
const r_run = Deno.run({
    cmd: ['Rscript', './clean-data.R']
});

await r_run.status();
