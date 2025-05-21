# JohnPark-ASD

In data directory, IMB015.RDS is made by gapseq (Zimmermann, J., Kaleta, C. & Waschina, S. gapseq: informed prediction of bacterial metabolic pathways and reconstruction of accurate metabolic models. Genome Biol 22, 81 (2021). https://doi.org/10.1186/s13059-021-02295-1) with "gut" gap-filling.

in "code" directory, running "Rscript 1-predict_metabolites_production.R" will generate fluxes of metabolites that IMB015 can produce or uptake with their amounts (result/metabolic_fluxes.xlsx).
running "python 2-draw_figure.py" will generate a figures presented in paper (result/GABA_Glutamate_flux.pdf)
