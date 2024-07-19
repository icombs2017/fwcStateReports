outplant1 <- read_excel("../data/2024 Seafoundry-Summerland Outplant Data .xlsx", sheet = "Summerland Ex-Situ + In-Situ",na = "")

outplant <- outplant1 %>% 
  select (outplanting_event, date, site, species, genotype, qty) %>% 
  mutate(across(c(outplanting_event, site, species, genotype), factor)) %>% 
  group_by(outplanting_event, species) %>% 
  dplyr::summarise(totalOutplants = sum(qty)) %>% 
  pivot_wider(names_from = species, values_from = totalOutplants)



write.csv(outplant, "../data/outplantBySpecies.csv", row.names = FALSE)
