from collections import OrderedDict
import pandas as pd
from gp15wma.sensitivity import BaseSensitivityAnalysis, OmpaArguments

# Next, define functions for endmember sensitivities using the weightings sensitivity structure

#%% 
def perturb_endmember_df(df, variation_range, rng):
  new_df = OrderedDict([
      ("Params", df["Params"]) #endmember name column
  ])
  params_to_perturb = ["CT", "SA", "Phosphate", "Nitrate", "Silicate", "tCO2"]
  for param_name in params_to_perturb:
    values = list(df[param_name])
    new_values = [rng.uniform(value-variation_range[param_name],
                              value+variation_range[param_name])
                  for value in values]
    new_df[param_name] = new_values

  return pd.DataFrame(new_df)

#%%
def perturb_endmember_df_stoichiometrically(df, stoichiometry, rng,
                                            perturbation_limits=(-1,1)):
  #in Talia's project, pertubation_limits corresponds to phosphate which
  # has ratio 1 wrt to the converted param
  
  new_df = OrderedDict([
      ("Params", df["Params"]), #endmember name column
      ("CT", df["CT"]),
      ("SA", df["SA"]),
  ])

  params_to_perturb = ["Phosphate", "Nitrate", "Silicate", "tCO2"]
  #sample a different perturbation for each row in the data frame
  sampled_perturbations = [rng.uniform(perturbation_limits[0],
                                       perturbation_limits[1])
                           for i in range(len(df))]
  print(sampled_perturbations)
  for param_name in params_to_perturb:
    values = list(df[param_name])
    new_values = [value + sampled_perturbation*stoichiometry[param_name]
                  for sampled_perturbation,value in
                  zip(sampled_perturbations,values)]
    new_df[param_name] = new_values

  return pd.DataFrame(new_df)

variation_range = {
    "CT": 3, "SA": 0.75, "Phosphate": 1.5, "Nitrate": 10,
    "Silicate": 20, "tCO2": 100
}

