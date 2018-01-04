# 3. faza: Vizualizacija podatkov

#Graf 
top10 <- ggplot(ep.rezultati %>% group_by(DRZAVA) %>% summarise(stevilo = n()) %>%
                  arrange(desc(stevilo)) %>% top_n(10),
                aes(x = reorder(DRZAVA, -stevilo), y = stevilo)) + geom_col() +
  xlab("Država") + ylab("Število uvrstitev") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


#graf1 <- ggplot(tabela1, aes(x = Leto, y = Stevilo, color = Vrsta_migrantov)) +
 # geom_line(size = 1) +
  #geom_point(size = 1.5) +
  #xlab("Leto") + ylab("Stevilo") +
  #theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  #ggtitle("Število dijakov glede na vrsto štipendije po letih")

#print(graf1)

graf2 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = paste(Spol, Vrsta_migrantov))) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij po letih") +
  guides(fill = guide_legend("Spol in vrsta"))

#Graf povprešnjega števila metov na igro najboljših strelceu po letih
graf2 <- ggplot(tabela1, aes(x = factor(Leto), y = Stevilo, fill = Spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Leto") + ylab("Število") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število migracij po letih")

print(graf2)


# Uvozimo zemljevid.
evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(CONTINENT == c("Europe", "Asia") | SOVEREIGNT %in% c("Turkey", "Cyprus", "Russian Federation"),
                                  long > -30)
evropa1 <- ggplot()+geom_polygon(data=evropa, aes(x=long, y= lat, group = group))
print(evropa1)



# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
