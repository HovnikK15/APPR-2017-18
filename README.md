# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

Za predmet analize sem si izbral Analizo priseljevanja in izseljevanja prebivalstva v oz. iz Slovenije, od leta 2000 naprej. S pridobljenimi podatki iz spleta bom analiziral selitve po posameznih regijah, finančnem položaju ter  starostnih skupinah.

Podatke sem črpal iz naslednje strani: 

Statistični urad RS: http://pxweb.stat.si/pxweb/Database/Dem_soc/Dem_soc.asp 

Zasnova podatkovnega modela:
* prva tabela – Meddržavne selitve po starostnih skupinah, državljanstvu in spolu, Slovenija, letno
* druga tabela - Meddržavne selitve po državljanstvu, državah prejšnjega, prihodnjega prebivališča in spolu, Slovenija, letno 
* tretja tabela - Selitveno gibanje prebivalstva po občinah, Slovenija, letno 
* četrta tabela - Priseljeni tujci po namenu priselitve in državi državljanstva, Slovenija, letno 
* peta tabela - Priseljeni prebivalci, stari 15 ali več let, po izobrazbi, državljanstvu, starostnih skupinah, spolu, Slovenija, letno 



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
