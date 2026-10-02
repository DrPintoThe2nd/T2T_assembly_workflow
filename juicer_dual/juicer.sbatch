#!/bin/bash

source myconda

#sbatch --cpus-per-task=32 --mem=32g --gres=lscratch:900 --mail-type=BEGIN,FAIL,END --time=36:00:00 juicer.sbatch

mamba activate assembly

PREFIX='Tenuidactylus_caspius_Gecko2_9-16-26'
FASTA='Tenuidactylus_caspius_Gecko2_9-16-26.asm.hic.diploid.p_ctg.fasta'
HiC='Tenuidactylus_caspius_Gecko2_HiC.fastq.gz'

bwa index references/${FASTA}

bash juicer.sh -g ${PREFIX} -e -p hg19 -z references/${FASTA} -t 24 -D .

samtools view -h splits/${HiC}\.sam | PretextMap -o ${PREFIX}\.map.pretext --sortby length --mapq 10

#rm -r splits/ aligned/
