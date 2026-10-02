#!/bin/bash

source myconda

#sbatch --cpus-per-task=64 --mem=400g --gres=lscratch:900 --mail-type=BEGIN,FAIL,END --time=48:00:00 hifiasm.sh

mamba activate assembly

PREFIX="Ctenosaura_palearis_verkko_9-11-26"
HiFi='Ctenosaura_palearis_HiFi.fastq.gz'
SIMPLEX='Ctenosaura_palearis_ONT_50000.fastq.gz'
ecONT='Ctenosaura_palearis_HiFi_UL_9-10-26.asm.ec.fq.gz'
UL='Ctenosaura_palearis_ONT_100000.fastq.gz'
HiC1='Ctenosaura_palearis_HiC_R1.fastq.gz'
HiC2='Ctenosaura_palearis_HiC_R2.fastq.gz'
REF=''
ASM_PATH=''

#HiFi + HiC
#hifiasm -o $PREFIX\.asm -t64 --h1 ${HiC1} --h2 ${HiC2} ${HiFi}

#HiFi + HiC + UL-ONT
hifiasm -o $PREFIX\.asm -t64 --h1 ${HiC1} --h2 ${HiC2} --ul ${UL} ${HiFi}

#ONT + HiC
#hifiasm -o $PREFIX\.asm -t64 --h1 ${HiC1} --h2 ${HiC2} --write-ec --ont ${SIMPLEX}

#ONT + HiC + UL-ONT
#hifiasm -o $PREFIX\.asm -t64 --h1 ${HiC1} --h2 ${HiC2} --ul ${UL} --write-ec --ont ${SIMPLEX}

#HiFi-only
#hifiasm -o $PREFIX\.asm -t64 ${HiFi}
#ONT-only
#hifiasm -o $PREFIX\.asm -t64 --write-ec --ont ${SIMPLEX}

#convert to FASTA
gfatools gfa2fa $PREFIX\.asm.hic.hap1.p_ctg.gfa | seqkit sort -l -r > $PREFIX\.asm.hic.hap1.p_ctg.fa
gfatools gfa2fa $PREFIX\.asm.hic.hap2.p_ctg.gfa | seqkit sort -l -r > $PREFIX\.asm.hic.hap2.p_ctg.fa

#find telomeres
tidk search --string CCCTAA --output $PREFIX\.asm.hic.hap1 --dir . $PREFIX\.asm.hic.hap1.p_ctg.fa
tidk search --string CCCTAA --output $PREFIX\.asm.hic.hap2 --dir . $PREFIX\.asm.hic.hap2.p_ctg.fa
#plot telomeres
tidk plot --tsv $PREFIX\.asm.hic.hap1_telomeric_repeat_windows.tsv --output $PREFIX\.asm.hic.hap1 --height 120 --width 800
tidk plot --tsv $PREFIX\.asm.hic.hap2_telomeric_repeat_windows.tsv --output $PREFIX\.asm.hic.hap2 --height 120 --width 800
#make telomere estimates bed file
seqtk telo $PREFIX\.asm.hic.hap1.p_ctg.fa > $PREFIX\.asm.hic.hap1.p_ctg.telo.bed
seqtk telo $PREFIX\.asm.hic.hap2.p_ctg.fa > $PREFIX\.asm.hic.hap2.p_ctg.telo.bed
