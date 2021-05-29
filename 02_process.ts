import 'https://deno.land/x/flat@0.0.10/mod.ts'

const r_install = Deno.run({
    cmd: ['sudo', 'Rscript', '-e', "install.packages(c('dplyr', 'readxl', 'readr', 'lubridate', 'stringr'))"]
});

await r_install.status();

// Forwards the execution to the python script
const r_run = Deno.run({
    cmd: ['Rscript', './03_postprocess.R']
});

await r_run.status();
