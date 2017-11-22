# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

V mojem projektu sem se odločil, da bom analiziral statistiko avtomobilizma v Sloveniji. Pri tem se bom osredotočal na najpogosteje prodajane avtomobilske znamke, število na novo registriranih avtomobilov po letih, starost vozil itd. V analizo bom morda vključil še statistiko iz Evrope ter bom tako primerjal in iskal podobne vzorce. Prav tako bom v projekt vključil še električna vozila, saj so v zadnjih letih popularna tematika in me zanima, kako je prodaja električnih vozil narastla ter če je vplivala na prodajo navadnih avtomobilov. 
Podatke bom imel v obliki html iz spletnih strani ter v obliki .csv datotek.
V tabeli, kjer bom primerjal evropsko prodajo s slovensko, bom imel po vrsticah avtomobilske znamke, po stolpcih pa prodajo v Sloveniji in Evropi. (https://siol.net/avtomoto/novice/prodaja-avtomobilov-v-evropi-in-sloveniji-kraljuje-volkswagen-pri-nas-tudi-renault-432286)
Če mi bo slučajno primanjkovalo podatkovnih struktur, bom v svojo analizo vključil še par najbolj prodajanih avtomobilov ter jih primerjal med seboj ter z življenjskim standardom v državi.



## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
