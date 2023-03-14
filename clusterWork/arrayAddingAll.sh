#!/bin/bash
#SBATCH -J AddingAllCampPairwise
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 6GB
#SBATCH -o outErrFiles/AddingAllCampPairwise%A_%a.out
#SBATCH -e outErrFiles/AddingAllCampPairwise%A_%a.err
command=$(head -${SLURM_ARRAY_TASK_ID} /work/cf189/campLabAlignmentSupport/lastZJobsAddingAll.txt | tail -1)
srun $command
