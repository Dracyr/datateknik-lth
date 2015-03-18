Middleman
=========

I Denna branchen befinner sig koden för att generera en kalasnajs statisk sida.

Styling är ganska direkt dragen från github-pages [Architect tema](https://github.com/jasonlong/architect-theme), fritt fram att leka med den.

Master branchen (där all kursinfo finns) inkluderas som en submodul, som helst ska uppdateras när en ny version av sidan genereras så att alla gottigheter kommer med.

## Build & Deploy

För att bygga sidan används [middleman](https://middlemanapp.com/), som är byggt på ruby, så vill man leka med denna sidan får man ladda ner det och middleman. Den byggda sidan läggs i build/ som är ett eget git repo som trackar gh-pages branchen.
För att då bygga en ny version av sidan:

```
git submodule update --remote --merge //Uppdatera submodulen från master

```

Och för att generera sidan gör man antigen
```
middleman deploy
```

eller i två steg

```
middleman build
cd build
git checkout gh-pages // Om man inte redan befinner sig i den branchen.
git push origin
```

FIXME: att göra deploy i ett steg funkar inte just nu för att länken längst ner i EIT070-datorteknik/instuderingsfrågor-med-svar.md innehåller karaktärer som markdown parsern inte tycker är UTF-8 eller gillar.

