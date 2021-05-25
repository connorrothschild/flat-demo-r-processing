import 'https://deno.land/x/flat@0.0.10/mod.ts'

// install requirements with pip
// const pip_install = Deno.run({
//     cmd: ['python', '-m', 'pip', 'install', '-r', 'requirements.txt'],
// });

// await pip_install.status();

// Forwards the execution to the python script
const r_run = Deno.run({
    cmd: ['R CMD BATCH', './clean-data.R']
});

await r_run.status();
