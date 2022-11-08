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
                                            perturbation_limits_0, 
                                            scale_factor):
  #in Talia's project, pertubation_limits corresponds to phosphate which
  # has ratio 1 wrt to the converted param
  
  new_df = OrderedDict([
      ("Params", df["Params"]), #endmember name column and params that are carried through
      ("CT", df["CT"]),
      ("SA", df["SA"]),
  ])

  params_to_perturb = ["Phosphate", "Nitrate", "Silicate", "tCO2"]

  for param_name in params_to_perturb:
    values = list(df[param_name])

    # sample a different perturbation for each row in the data frame
    sampled_perturbations_0 = [rng.uniform(perturbation_limits_0[0], # remin 1
                                    perturbation_limits_0[1])
                              for i in range(len(df))]
    sampled_perturbations_1 = [rng.uniform(perturbation_limits_0[0]*scale_factor, # remin 2
                                        perturbation_limits_0[1]*scale_factor)
                                for i in range(len(df))]

    new_values = [value + sampled_perturbation0*(stoichiometry[0].conversion_ratios[0][param_name] +
                        stoichiometry[0].conversion_ratios[1][param_name])/2
                        for sampled_perturbation0, value in
                        zip(sampled_perturbations_0, values)]
                  
    new_values2 = [value + sampled_perturbation1*(stoichiometry[1].conversion_ratios[0][param_name] +
                        stoichiometry[1].conversion_ratios[1][param_name])/2
                        for sampled_perturbation1, value in
                        zip(sampled_perturbations_1, new_values)]

    new_df[param_name] = new_values2


  return pd.DataFrame(new_df)

variation_range = {
    "CT": 3, "SA": 0.75, "Phosphate": 1.5, "Nitrate": 10,
    "Silicate": 20, "tCO2": 100
}
