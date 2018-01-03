# 2. faza: Uvoz podatkov

library(rvest)


uvozihtml <- function() {
  html <- file("podatki/html1.htm") %>% 
    read_html(encoding = "Windows-1250")
  tabhtml <- html %>% html_nodes(xpath="//table") %>% .[[1]] %>% html_table(fill = TRUE) %>%
    apply(1, . %>% { c(.[is.na(.)], .[!is.na(.)]) }) %>% t() %>% data.frame()
  colnames(tabhtml) <-c("Leto", "Drzava_prihodnjega_prebivalisca", "Drzavljanstvo","Spol", "Status", "Stevilo")
  return(tabhtml)
}
html1 <- uvozihtml()

# Funkcija, ki uvozi podatke iz csv datotek v mapi "podatki"

library(readr)
library(tidyr)
library(gsubfn)
library(dplyr)
uvozi1 <- function() {
  tab <- read_csv2(file="podatki/tabela1.csv",
                   col_names = c("Vrsta_migrantov", "Starostna_skupina", "Leto", "Spol", "Stevilo"),
                   locale=locale(encoding="Windows-1250"),skip = 4,  n_max = 1865) 
  tab <- tab %>% fill(1:4) %>% drop_na(Stevilo) %>% filter(Starostna_skupina != "SKUPAJ",
                                                           Starostna_skupina != "Starostne skupine - SKUPAJ")
  tab$leta_min <- tab$Starostna_skupina %>% strapplyc("(^[0-9]+)") %>% unlist() %>% parse_number()
  tab$Starostna_skupina <- NULL #da ti namest starostna skupina piše leta min in namest 0-4 0 
  return(tab)
}
# Zapišimo podatke v razpredelnico tabela1
tabela1 <- uvozi1()
#druga tabela
uvozi2 <- function() {
  tab2 <- read_csv2(file="podatki/tabela2.csv",
                    col_names = c("Vrsta_migrantov", "Drzava_drzavljanstva", "Leto", "Spol", "Stevilo"),
                    locale=locale(encoding="Windows-1250"),skip = 5,  n_max = 3336) 
  tab2 <- tab2 %>% fill(1:4) %>% drop_na(Stevilo) %>% filter(Drzava_drzavljanstva != "Država državljanstva - SKUPAJ",
                                                             Drzava_drzavljanstva != "EVROPA")
  return(tab2) 
}
tabela2 <- uvozi2()

uvozi3 <- function() {
  tab3 <- read_csv2(file="podatki/tabela3.csv",
                    col_names = c("Vrsta_migrantov", "Starostna_skupina", "Leto", "Spol","Drzavljanstvo", "Stevilo"),
                    locale=locale(encoding="Windows-1250"),skip = 7,  n_max = 4525) 
  tab3 <- tab3 %>% fill(1:5) %>% drop_na(Stevilo) %>% filter(Starostna_skupina != "Starostne skupine - SKUPAJ")
  tab3$leta_min <- tab3$Starostna_skupina %>% strapplyc("(^[0-9]+)") %>% unlist() %>% parse_number()
  tab3$Starostna_skupina <- NULL
  
  return(tab3)
}
tabela3 <- uvozi3()

uvozi4 <- function() {
  tab4 <- read_csv2(file="podatki/tabela4.csv",
                    col_names = c("Vrsta_migrantov", "Drzavljanstvo", "Leto", "Regija","Stevilo"),
                    locale=locale(encoding="Windows-1250"),skip = 5,  n_max = 840) 
  tab4 <- tab4 %>% fill(1:3) %>% drop_na(Stevilo)
  return(tab4)
}
tabela4 <- uvozi4()

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
