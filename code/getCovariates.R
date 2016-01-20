library(RPostgreSQL)
library(dplyr)
library(tidyr)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv = drv, 
                 user = options("SHEDS_USERNAME"),
                 password = options("SHEDS_PASSWORD"),
                 dbname = "sheds",
                 host = "osensei.cns.umass.edu")
dbListTables(con)

rs <- dbSendQuery(con, "select * from covariates where featureid IN (834183, 833880, 833923, 834122)")
df <- fetch(rs, n = -1)

dbClearResult(rs)
dbDisconnect(con)
dbUnloadDriver(drv=drv)

str(df)
summary(df)

df_covs <- df %>%
  dplyr::filter(zone == "upstream") %>%
  tidyr::spread(variable, value) %>%
  dplyr::mutate(impoundAreaSqKM = AreaSqKM * allonnet / 100) %>%
  dplyr::select(featureid, zone, AreaSqKM, allonnet, impoundAreaSqKM, elevation, slope_pcnt, forest, developed, agriculture) # convert from long to wide by variable
summary(df_covs)

df_id <- data.frame(featureid = c(834183, 833880, 833923, 834122),
                    name = c("OBear", "Jimmy", "Mitchell", "West Brook"),
                    ms_name = c("Isolated", "Open Large", "Open Small", "Mainstem"),
                    stringsAsFactors = FALSE)

df_full <- df_id %>%
  dplyr::left_join(df_covs)

df_full

write.csv(df_full, file = "localData/covariates.csv", row.names = FALSE)