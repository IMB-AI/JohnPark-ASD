library(sybil)
library(writexl)
library(stringr)
library(data.table)

### configure
path2model = "../data/IMB015.RDS"
path2output = "../result/metabolic_fluxes.xlsx"

### define functions
getMetaboliteProduction <- function(mod) {
  require(sybil)
  require(data.table)
  
  # MTF
  sol.mtf <- optimizeProb(mod, algorithm = "mtf")
  dt.mtf  <- data.table(ex = mod@react_id, mtf.flux = sol.mtf@fluxdist@fluxes[1:mod@react_num])
  dt.mtf.tmp <- copy(dt.mtf[grepl("^EX_cpd[0-9]+_e0", ex)])
  
  # FVA
  sol.fv <- fluxVar(mod, react = mod@react_id[grep("^EX_cpd[0-9]+_e0", mod@react_id)])

  dt <- data.table(ex       = rep(mod@react_id[grep("^EX_cpd[0-9]+_e0", mod@react_id)],2),
                   rxn.name = rep(mod@react_name[grep("^EX_cpd[0-9]+_e0", mod@react_id)],2),
                   dir      = c(rep("l",length(grep("^EX_cpd[0-9]+_e0", mod@react_id))),
                                rep("u",length(grep("^EX_cpd[0-9]+_e0", mod@react_id)))),
                   fv       = sol.fv@lp_obj)

  #dt <- dcast(dt, ex + rxn.name ~ dir, value.var = "fv")[(u>1e-6 & l >= 0)]
  dt <- dcast(dt, ex + rxn.name ~ dir, value.var = "fv")[(abs(u)>1e-6)]
  
  dt <- merge(dt, dt.mtf, by = "ex")
  
  return(dt[order(-mtf.flux)])
}


### get produced & uptaken metabolites
mod = readRDS(path2model)
uptake_products = getMetaboliteProduction(mod)
uptake_products = as.data.frame(uptake_products)
uptake_products$status = ifelse(uptake_products$mtf.flux >= 0, "produce", "uptake")
uptake_products$status[uptake_products$mtf.flux==0] = "-"


### file output
write_xlsx(uptake_products, path2output)



### refer to https://github.com/jotech/gapseq/blob/master/src/gf.suite.R

