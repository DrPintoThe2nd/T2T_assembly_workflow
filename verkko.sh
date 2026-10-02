#!/bin/bash
source myconda

#sbatch --cpus-per-task=20 --mem=150g --gres=lscratch:750 --mail-type=BEGIN,FAIL,END --time=72:00:00 verkko_final.sbatch

mamba activate verkko

PREFIX="Ctenosaura_palearis_verkko_9-11-26"
HiFi='Ctenosaura_palearis_HiFi.fastq.gz'
SIMPLEX='Ctenosaura_palearis_ONT_50000.fastq.gz'
ecONT='Ctenosaura_palearis_HiFi_UL_9-10-26.asm.ec.fq.gz'
UL='Ctenosaura_palearis_ONT_100000.fastq.gz'
HiC1='Ctenosaura_palearis_HiC_R1.fastq.gz'
HiC2='Ctenosaura_palearis_HiC_R2.fastq.gz'
REF=''
ASM_PATH=''

verkko -d ${PREFIX} --local-memory 24 --grid --snakeopts "--cores 24 --nolock --rerun-incomplete" --hifi ${HiFi} ${ecONT} --hic1 ${HiC1} --hic2 ${HiC2} --nano ${UL} #--ref ${REF}

#verkko -d ${PREFIX} --local-memory 4 --snakeopts "--dry-run --unlock" --hifi ${HiFi} ${ecONT}

#re-run verkko consensus
#verkko -d ${PREFIX} --local-memory 24 --grid --snakeopts "--cores 20" --paths ${ASM+PATH}\.gaf --assembly ${PREFIX} --hifi ${HiFi} ${ecONT} --hic1 ${HiC1} --hic2 ${HiC2} --nano ${UL} #--ref ${REF}

#verkko -d ${PREFIX} --local-memory 4 --snakeopts "--dry-run --unlock" --hifi ${HiFi} ${ecONT}
