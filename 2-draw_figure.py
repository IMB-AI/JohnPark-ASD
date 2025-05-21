import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
plt.rcParams["pdf.fonttype"] = 42

path2data = "../result/metabolic_fluxes.xlsx"
path2result = "../result/"
df = pd.read_excel(path2data)
target_df = df.loc[:, ["ex", "rxn.name", "mtf.flux"]]

prod_GABA = target_df.loc[target_df["rxn.name"] == "GABA-e0 Exchange", :]
upt_Glu = target_df.loc[target_df["rxn.name"] == "L-Glutamate-e0 Exchange" ,:]
target_mets = pd.concat([prod_GABA, upt_Glu])

sns.barplot(target_mets, x="rxn.name", y="mtf.flux")
plt.savefig(path2result + "GABA_Glutamate_flux.pdf", format="pdf")
