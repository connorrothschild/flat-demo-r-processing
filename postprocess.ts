import 'https://deno.land/x/flat@0.0.10/mod.ts'

// Installs necessary packages
const r_install = Deno.run({
    cmd: ['sudo', 'Rscript', '-e', "install.packages(c('dplyr', 'readxl', 'readr', 'lubridate', 'stringr'))"]
});

await r_install.status();

// Forwards the execution to the R script
const r_run = Deno.run({
    cmd: ['Rscript', './clean.R']
});

await r_run.status();
