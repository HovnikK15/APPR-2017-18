# 2. faza: Uvoz podatkov




uvozihtml <- function() {
  html <- file("podatki/html1.htm") %>% 
    read_html(encoding = "Windows-1250")
  tabhtml <- html %>% html_nodes(xpath="//table") %>% .[[1]] %>% html_table(fill = TRUE) %>%
    apply(1, . %>% { c(.[is.na(.)], .[!is.na(.)]) }) %>% t() %>% data.frame()
  colnames(tabhtml) <-c("Leto", "Drzava_prihodnjega_prebivalisca", "Drzavljanstvo","Spol", "Status", "Stevilo")
  return(tabhtml)
}
html1 <- uvozihtml()
#pretvorba stolpca Stevilo iz "character" v "numeric"- stevilsko vrednost:
html1$Stevilo <- as.numeric(as.character(html1$Stevilo))
#da preverim, če je stolpec res število uporabim funkcijo:lapply(html1, class)



uvozihtml2 <- function() {
  stran <- file("podatki/html2.htm")%>% 
    read_html(encoding = "Windows-1250")
  
  tabela <- stran %>% html_nodes(xpath="//table") %>% .[[1]] %>% html_table(fill = TRUE) %>%
    apply(1, . %>% { c(.[is.na(.)], .[!is.na(.)]) }) %>% t() %>% data.frame()
  colnames(tabela) <- c("Dejavnost", "Leto", "Drzavljanstvo", "Moški", "Ženske")
  tabela <- melt(tabela, measure.vars = c("Moški", "Ženske"),
                 variable.name = "Spol", value.name = "Stevilo") %>%
    mutate(Leto = parse_number(Leto), Stevilo = parse_number(Stevilo))
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  #colnames(tabela) <- c("Dejavnost", "Leto", "Drzavljanstvo", c("Spol"))
  tabela <- tabela %>% filter(Stevilo != "NA")

  return(tabela)
}
html2 <- uvozihtml2()


#pretvorba stolpca Stevilo iz "character" v "numeric"- stevilsko vrednost:
html2$Stevilo <- as.numeric(as.character(html2$Stevilo))

# Funkcija, ki uvozi podatke iz csv datotek v mapi "podatki"

uvozi1 <- function() {
  tab1 <- read_csv2(file="podatki/tabela1.csv",
                    locale = locale(encoding = "Windows-1250"), skip = 2,  n_max = 43)
  stolpci <- data.frame(leto = colnames(tab1) %>% { gsub("X.*", NA, .) } %>% parse_number(),
                        spol = tab1[1, ] %>% unlist()) %>% fill(leto) %>%
    apply(1, paste, collapse = "")
  stolpci[1:2] <- c("Vrsta_migrantov", "Starostna_skupina")
  colnames(tab1) <- stolpci
  tab1 <- tab1[-1, ] %>% fill(Vrsta_migrantov) %>% drop_na(Starostna_skupina) %>%
    filter(!grepl("SKUPAJ", Starostna_skupina)) %>%
    melt(id.vars = 1:2, variable.name = "stolpec", value.name = "Stevilo") %>%
    mutate(stolpec = parse_character(stolpec)) %>%
    transmute(Vrsta_migrantov, Starostna_skupina,
              Leto = stolpec %>% strapplyc("^([0-9]+)") %>% unlist() %>% parse_number(),
              Spol = stolpec %>% strapplyc("([^0-9]+)$") %>% unlist() %>% factor(),
              Stevilo)

  return(tab1)
}
# Zapišimo podatke v razpredelnico tabela1
tabela1 <- uvozi1()
#pretvorba stolpca Stevilo iz "character" v "numeric"- stevilsko vrednost:
tabela1$Stevilo <- as.numeric(as.character(tabela1$Stevilo))
#da preverim, če je stolpec res število uporabim funkcijo:lapply(tabela1, class)


#druga tabela
uvozi2 <- function() {
  tab2 <- read_csv2(file="podatki/tabela2.csv",
                    locale = locale(encoding = "Windows-1250"), skip = 2,  n_max = 75)
  stolpci <- data.frame(leto = colnames(tab2) %>% { gsub("X.*", NA, .) } %>% parse_number(),
                        spol = tab2[1, ] %>% unlist()) %>% fill(leto) %>%
    apply(1, paste, collapse = "")
  stolpci[1:2] <- c("Vrsta_migrantov", "Drzava_drzavljanstva")
  colnames(tab2) <- stolpci
  tab2 <- tab2[-1, ] %>% fill(Vrsta_migrantov) %>% drop_na(Drzava_drzavljanstva) %>%
    filter(!grepl("SKUPAJ", Drzava_drzavljanstva)) %>%
    melt(id.vars = 1:2, variable.name = "stolpec", value.name = "Stevilo") %>%
    mutate(stolpec = parse_character(stolpec)) %>%
    transmute(Vrsta_migrantov, Drzava_drzavljanstva,
              Leto = stolpec %>% strapplyc("^([0-9]+)") %>% unlist() %>% parse_number(),
              Spol = stolpec %>% strapplyc("([^0-9]+)$") %>% unlist() %>% factor(),
              Stevilo)
  return(tab2)
}
tabela2 <- uvozi2()
#pretvorba stolpca Stevilo iz "character" v "numeric"- stevilsko vrednost:
tabela2$Stevilo <- as.numeric(as.character(tabela2$Stevilo))

uvozi3 <- function() {
  tab3 <- read_csv2(file="podatki/tabela3.csv",
                    locale = locale(encoding = "Windows-1250"), skip = 3,  n_max = 45)
  stolpci <- data.frame(drzavljanstvo = tab3[1, ] %>% unlist(),
                        leto = colnames(tab3) %>% { gsub("X.*", NA, .) } %>% parse_number(),
                        spol = tab3[2, ] %>% unlist()) %>%
    fill(leto, drzavljanstvo) %>% apply(1, paste, collapse = "")
  stolpci[1:2] <- c("Vrsta_migrantov", "Starostna_skupina")
  colnames(tab3) <- stolpci
  tab3 <- tab3[-c(1:2), ] %>% fill(Vrsta_migrantov) %>% drop_na(Starostna_skupina) %>%
    melt(id.vars = 1:2, variable.name = "stolpec", value.name = "Stevilo") %>%
    mutate(stolpec = parse_character(stolpec)) %>%
    transmute(Vrsta_migrantov, Starostna_skupina,
              Leto = stolpec %>% strapplyc("([0-9]+)") %>% unlist() %>% parse_number(),
              Spol = stolpec %>% strapplyc("([^0-9]+)$") %>% unlist() %>% factor(),
              Drzavljanstvo = stolpec %>% strapplyc("^([^0-9]+)") %>% unlist() %>% factor(),
              Stevilo = parse_number(Stevilo))
  return(tab3)
}
tabela3 <- uvozi3()
#pretvorba stolpca Stevilo iz "character" v "numeric"- stevilsko vrednost:
tabela3$Stevilo <- as.numeric(as.character(tabela3$Stevilo))


uvozi4 <- function() {
  tab2 <- read_csv2(file="podatki/tabela4.csv",
                    locale = locale(encoding = "Windows-1250"), skip = 2,  n_max = 43)
  stolpci <- data.frame(leto = colnames(tab2) %>% { gsub("X.*", NA, .) } %>% parse_number(),
                        Drzavljanstvo = tab2[1, ] %>% unlist()) %>% fill(leto) %>%
    apply(1, paste, collapse = "")
  stolpci[1:2] <- c("Vrsta_migrantov", "Regija")
  colnames(tab2) <- stolpci
  tab2 <- tab2[-1, ] %>% fill(Vrsta_migrantov) %>% drop_na(Regija) %>%
    filter(!grepl("SKUPAJ", Regija)) %>%
    melt(id.vars = 1:2, variable.name = "stolpec", value.name = "Stevilo") %>%
    mutate(stolpec = parse_character(stolpec)) %>%
    transmute(Vrsta_migrantov, Regija,
              Leto = stolpec %>% strapplyc("^([0-9]+)") %>% unlist() %>% parse_number(),
              Drzavljanstvo = stolpec %>% strapplyc("([^0-9]+)$") %>% unlist() %>% factor(),
              Stevilo)
  return(tab2)
}
tabela4 <- uvozi4()
tabela4$Stevilo <- as.numeric(as.character(tabela4$Stevilo))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.

