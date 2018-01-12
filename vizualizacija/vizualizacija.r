# 3. faza: Vizualizacija podatkov

#Graf 
#graf priseljenih in odseljenih po letih
graf1 <- ggplot(tabela1 %>% group_by(Leto, Vrsta_migrantov) %>% summarise(Stevilo = sum(Stevilo)),
                aes(x = Leto, y = Stevilo, color = Vrsta_migrantov)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle("Število selitev po letih") +
  scale_color_discrete("Vrsta migrantov")

#print(graf1)
#graf priseljenih in odseljenih, ločeno po spolu ter po vrsti migracije
graf2 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = paste(Spol, Vrsta_migrantov))) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij ločenih po spolu ter po vrsti migracije") +
  guides(fill = guide_legend("Spol in vrsta"))
#print(graf2)

#graf priseljenih in odseljenih, ločeno po spolu
graf3 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = Spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij po letih")
#print(graf3)

#graf, ki prikazuje iz katerih držav so se preselili v Slovenijo
graf4 <- ggplot(tabela2 %>% 
                filter(Vrsta_migrantov =="Priseljeni iz tujine", 
                       Drzava_drzavljanstva != "EVROPA", 
                       Drzava_drzavljanstva != "SEVERNA IN SREDNJA AMERIKA"),
                aes(x = Drzava_drzavljanstva, y = Stevilo)) +
  geom_bar(stat = "identity", position = "dodge", fill = "red") +
  xlab("Država državljanstva") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število preselitev iz posameznih držav v Slovenijo")

#print(graf4)
#graf 5 prikazuje število tujih priseljencev po posameznih dejavnostih
graf5 <- ggplot(html2 %>% 
                  filter(Drzavljanstvo =="Tuji državljani"),
                         aes(x = Dejavnost, y = Stevilo, fill = Spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Dejavnost") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število priseljenih po posameznih dejavnostih")

#print(graf5)

# Uvozimo zemljevid.
drzave.eng <- c("EVROPA" = "Europe",
                "Rusija" = "Russia",
                "Albanija"= "Albania",
                "Avstrija"= "Austria",
                "Belgija"= "Belgium",
                "Bolgarija"= "Bulgaria",
                "Bosna in Hercegovina"= "Bosnia and Herzegovina",
                "Češka republika"= "Czechia", 
                "Črna gora"= "Montenegro",
                "Danska"= "Denmark",
                "Francija"= "France",
                "Hrvaška"= "Croatia",
                "Italija"= "Italy",
                "Kosovo"= "Kosovo", 
                "Madžarska"= "Hungary",
                "Makedonija"= "Macedonia", 
                "Nemčija"= "Germany",
                "Nizozemska"= "Netherlands",
                "Poljska"= "Poland",
                "Romunija"= "Romania",
                "Ruska federacija"= "Russia",
                "Slovenija"= "Slovenia",
                "Srbija"= "Republic of Serbia",
                "Švedska"= "Sweden",
                "Švica"= "Switzerland",
                "Ukrajina"= "Ukraine",
                "Združeno kraljestvo"= "United Kingdom",
                "Druge države Evrope"= "Europe",
                "AFRIKA"= "Africa",
                "AZIJA"= "Asia",
                "JUŽNA AMERIKA"= "South America", 
                "SEVERNA IN SREDNJA AMERIKA"=  "North America", 
                "Kanada"= "Canada",
                "Združene države"= "United States of America",
                "Druge države Severne in Srednje Amerike"= "North America",
                "AVSTRALIJA IN OCEANIJA"= "Oceania",
                "Neznana država"="???????????????????????"
) 


evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(lat > -60)

selitve.eng <- tabela2 %>% filter(Vrsta_migrantov == "Priseljeni iz tujine", Stevilo != "NA") %>% 
  group_by(Drzava_drzavljanstva) %>% summarise(Stevilo = sum(Stevilo)) %>%
  mutate(Drzava_drzavljanstva = drzave.eng[Drzava_drzavljanstva])

zemljevid.selitve.celine <- ggplot() + aes(x = long, y = lat, group = group, fill = Stevilo) +
  geom_polygon(data = evropa %>% filter(CONTINENT != "Europe") %>%
                 left_join(selitve.eng, by = c("CONTINENT" = "Drzava_drzavljanstva"))) +
  geom_polygon(data = evropa %>% filter(CONTINENT == "Europe"), fill = "#ADDCFF")
#print(zemljevid.selitve.celine)

zemljevid.selitve.evropa <- ggplot() + aes(x = long, y = lat, group = group, fill = Stevilo) +
  geom_polygon(data = evropa %>% filter(CONTINENT == "Europe" |
                                          SOVEREIGNT %in% c("Canada",
                                                            "United States of America")) %>%
                 left_join(selitve.eng, by = c("SOVEREIGNT" = "Drzava_drzavljanstva"))) +
  coord_cartesian(xlim = c(-25, 35), ylim = c(35, 70))
#print(zemljevid.selitve.evropa)


odselitve.eng <- tabela2 %>% filter(Vrsta_migrantov == "Odseljeni v tujino", Stevilo !="NA") %>% 
  group_by(Drzava_drzavljanstva) %>% summarise(Stevilo = sum(Stevilo)) %>%
  mutate(Drzava_drzavljanstva = drzave.eng[Drzava_drzavljanstva])

zemljevid.odselitve.celine <- ggplot() + aes(x = long, y = lat, group = group, fill = Stevilo) +
  geom_polygon(data = evropa %>% filter(CONTINENT != "Europe") %>%
                 left_join(odselitve.eng, by = c("CONTINENT" = "Drzava_drzavljanstva"))) +
  geom_polygon(data = evropa %>% filter(CONTINENT == "Europe"), fill = "#ADDCFF")
#print(zemljevid.odselitve.celine)

zemljevid.odselitve.evropa <- ggplot() + aes(x = long, y = lat, group = group, fill = Stevilo) +
  geom_polygon(data = evropa %>% filter(CONTINENT == "Europe" |
                                          SOVEREIGNT %in% c("Canada",
                                                            "United States of America")) %>%
                 left_join(odselitve.eng, by = c("SOVEREIGNT" = "Drzava_drzavljanstva"))) +
  coord_cartesian(xlim = c(-25, 35), ylim = c(35, 70)) + 
  ggtitle("Število odselitev")
#print(zemljevid.odselitve.evropa)
 