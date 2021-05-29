import 'https://deno.land/x/flat@0.0.10/mod.ts'

// const r_dl = Deno.run({
//     cmd: ['wget', 'http://cran.r-project.org/src/contrib/renv_0.13.2.tar.gz']
// });

// await r_dl.status();

const r_install = Deno.run({
    cmd: ['sudo', 'Rscript', '-e', "install.packages(c('dplyr', 'readxl', 'readr', 'lubridate', 'stringr'))"]
    // cmd: ['sudo', 'Rscript', '-e', "install.packages('renv')"]
    // cmd: ['sudo', 'R', 'CMD', 'INSTALL', "./renv_0.13.2.tar.gz"]
});

await r_install.status();

// Forwards the execution to the python script
const r_run = Deno.run({
    cmd: ['Rscript', './clean-data.R']
});

await r_run.status();
