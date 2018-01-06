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

print(graf1)
#graf priseljenih in odseljenih, ločeno po spolu ter po vrsti migracije
graf2 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = paste(Spol, Vrsta_migrantov))) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij ločenih po spolu ter po vrsti migracije") +
  guides(fill = guide_legend("Spol in vrsta"))
print(graf2)

#graf priseljenih in odseljenih, ločeno po spolu
graf3 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = Spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij po letih")
print(graf3)

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

print(graf4)


# Uvozimo zemljevid.
evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(lat > -60)
evropa1 <- ggplot()+geom_polygon(data=evropa, aes(x=long, y= lat, group = group))
print(evropa1)

stevilo.selitev <- tabela2 %>% filter(Drzava_drzavljanstva == "EVROPA",  Drzava_drzavljanstva == "Azija",
                                      Drzava_drzavljanstva == "AFRIKA",
                                      Drzava_drzavljanstva == "JUŽNA AMERIKA",
                                      Drzava_drzavljanstva == "SEVERNA IN SREDNJA AMERIKA",
                                      Drzava_drzavljanstva == "AVSTRALIJA IN OCEANIJA") %>%
  group_by(Drzava_drzavljanstva) %>%
  summarise(Stevilo = n()) %>% arrange(desc(Stevilo)) 
#ne vem kako naj naredim, da bi v zemljevidu prikazal število selitev za posamezne kontinente (Evropa, Azija, Amerika itd.)

drzave.eng <- c("EVROPA" = "Europe",
                "Rusija" = "Russia",
                "Albanija"= "Albania",
                "Avstrija"= "Austria",
                "Belgija"= "Belgium",
                "Bolgarija"= "Bulgaria",
                "Bosna in Hercegovina"= "Bosnia and Herzegovina ",
                "Češka republika"= "Czech Republc", 
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
                "Druge države Evrope"= "?????????????????????",
                "AFRIKA"= "Africa",
                "AZIJA"= "Asia",
                "JUŽNA AMERIKA"= "South America", 
                "SEVERNA IN SREDNJA AMERIKA"=  "North America", 
                "Kanada"= "Canada",
                "Združene države"= "United States of America",
                "Druge države Severne in Srednje Amerike"= "???????????????????????????",
                "AVSTRALIJA IN OCEANIJA"= "Australia",
                "Neznana država"="???????????????????????"
                ) 
#kaj naj napišem namesto vprašajev? da bo ali pobarvalo vse dele, ki so v zamljevidu označeni posamezno 
# oz. da določenih podatkov (druge neznane države) ne bi prikazovalo
zemljevid.selitve <- ggplot() +
  geom_polygon(data = stevilo.selitev, #dodat morš da sploh bere še zemljevid
               aes(x=long, y= lat, group = group, fill = Stevilo))
print(zemljevid.selitve)
