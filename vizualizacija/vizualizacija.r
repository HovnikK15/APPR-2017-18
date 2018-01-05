# 3. faza: Vizualizacija podatkov

#Graf 



graf1 <- ggplot(tabela1, aes(x = Leto, y = Stevilo, color = Vrsta_migrantov)) +
   geom_line(size = 1) +
  geom_point(size = 1.5) +
  xlab("Leto") + ylab("Stevilo") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle("Število dijakov glede na vrsto štipendije po letih")



graf2 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = paste(Spol, Vrsta_migrantov))) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij po letih") +
  guides(fill = guide_legend("Spol in vrsta"))

#Graf povprešnjega števila metov na igro najboljših strelceu po letih
graf3 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = Spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij po letih")




# Uvozimo zemljevid.
evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(lat > -60)
evropa1 <- ggplot()+geom_polygon(data=evropa, aes(x=long, y= lat, group = group))
print(evropa1)
drzave.eng <- c("EVROPA" = "Europe",
                "Albanija"= "Albania",
                "Avstrija"= "Austria",
                "Belgija"= 
                "Bolgarija"= 
                "Bosna in Hercegovina"= 
                "Češka republika"= 
                "Črna gora"= 
                "Danska"= 
                "Francija"= 
                "Hrvaška"= 
                "Italija"= 
                "Kosovo"= 
                "Madžarska"= 
                "Makedonija"= 
                "Nemčija"=
                "Nizozemska"= "Netherlands",
                "Poljska"= 
                "Romunija"= 
                "Ruska federacija"= 
                "Slovenija"= 
                "Srbija"= 
                "Švedska"= 
                "Švica"= 
                "Ukrajina"= 
                "Združeno kraljestvo"= "United Kingdom",
                "Druge države Evrope"= 
                "AFRIKA"= 
                "AZIJA"= "Asia"
                "JUŽNA AMERIKA"= 
                "SEVERNA IN SREDNJA AMERIKA"= 
                "Kanada"= 
                "Združene države"= 
                "Druge države Severne in Srednje Amerike"= 
                "AVSTRALIJA IN OCEANIJA"= "Australia",
                "Neznana država"=) 
)
# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
