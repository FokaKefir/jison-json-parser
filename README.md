
# JSON-Parser Dokumentáció

## 1. Elemző Generátor Választása
A projekt során a Jison elemző generátort választottuk, amely egy erőteljes eszköz lexikális és szintaktikai elemzők készítéséhez JavaScript környezetben. A Jison egy kontextusfüggetlen nyelvtant fogad bemenetként, és egy olyan JavaScript fájlt generál, amely képes az adott nyelv elemezésére. A generált script segítségével a bemenetek feldolgozhatók, elfogadhatók vagy elutasíthatók, illetve különböző műveletek végezhetők el rajtuk.

A Jison hasonlít a klasszikus Bison vagy Yacc eszközökhöz, de kifejezetten JavaScript-ben való használatra készült. API-ja és működési logikája ismerős lehet azoknak, akik már dolgoztak Bisonnal. Ugyanakkor támogat több speciális funkciót is, amelyek megkönnyítik a modern webfejlesztés igényeinek kielégítését. Ha valaki kezdő a parser generátorok világában, a Jisonhoz hasonló eszközök egy jó kiindulópontot jelentenek.

Összefoglalva, a Jison egy JSON-alapú vagy Bison-stílusú nyelvtant fogad, majd egy olyan JavaScript fájlt hoz létre, amely a nyelv elemzésére alkalmas. Ez a rugalmasság lehetővé teszi különböző típusú nyelvek és formátumok, például JSON vagy HTML, hatékony feldolgozását.

---

## 2. Nyelv Választása
A projekt során egy JSON-formátumú adatleíró nyelvet választottunk, amely széles körben használt a webes API-k és konfigurációs fájlok kezelésében. A JSON szerkezete egyszerű, de elég komplex ahhoz, hogy kihívást jelentsen az elemző implementálásában.

---

## 3. Elemző Tervezése
A JSON szintaktikai szabályainak megfelelően az elemző a következő struktúrákat támogatja:
- **Objektumok**: Kulcs-érték párokat tartalmaznak, ahol a kulcsok mindig string típusúak.
- **Tömbök**: Rendezett értékek listái.
- **Értékek**: Lehetnek stringek, számok, logikai értékek (`true` vagy `false`), null értékek, objektumok vagy tömbök.
- **Szintaktikai hibák**: Az elemző felismeri a hibás szintaxist és megfelelő hibaüzeneteket generál.

A nyelv következő szintaktikai szabályait valósítottuk meg:

### Példák a megvalósított szintaktikai szabályokra

1. **Szekvencia**  
   Az objektumokban és tömbökben az elemek sorrendje meghatározott, például egy JSON objektumban a kulcs-érték párok a `{` és `}` zárójelek között vannak felsorolva.  
   **Példa**:
   ```json
   {
       "id": 1,
       "name": "Laptop",
       "price": 999.99
   }
   ```
   **Elemzés**: Az objektum három kulcs-érték párt tartalmaz, amelyeket sorrendben elemzünk: `id`, `name`, és `price`.

2. **Választás**  
   Az értékek különböző típusokat vehetnek fel, például string, szám vagy boolean.  
   **Példa**:
   ```json
   {
       "name": "Tablet",
       "price": 249.99,
       "available": true
   }
   ```
   **Elemzés**: A `name` string típusú, a `price` szám, az `available` boolean.

3. **Ismétlés**  
   Tömbök és objektumok több elemet tartalmazhatnak, például egy tömbben lévő elemek listáját.  
   **Példa**:
   ```json
   {
       "tags": ["electronics", "computers", "portable"]
   }
   ```
   **Elemzés**: A `tags` kulcs egy tömböt tartalmaz, amely három elemet tartalmaz (`electronics`, `computers`, `portable`).

4. **Opcionális elemek**  
   Az objektumok és tömbök lehetnek üresek, ha nincs szükségük tartalomra.  
   **Példa**:
   ```json
   {
       "optionalField": {},
       "emptyArray": []
   }
   ```
   **Elemzés**: Az `optionalField` üres objektum, az `emptyArray` pedig egy üres tömb.

5. **Aggregáció**  
   Az objektumok egymásba ágyazott szerkezeteket tartalmazhatnak, lehetővé téve az összetett adatok leírását.  
   **Példa**:
   ```json
   {
       "product": {
           "id": 2,
           "name": "Smartphone",
           "specs": {
               "processor": "Snapdragon 888",
               "ram": "8GB",
               "storage": "128GB"
           }
       }
   }
   ```
   **Elemzés**: A `product` kulcs egy objektumot tartalmaz, amely maga is egy másik objektumot (`specs`) tartalmaz, a processzor, RAM és tárhely specifikációival.

---

## 4. Implementáció
Az elemzőt a Jison segítségével készítettük, és a következő lépéseket hajtottuk végre:
- **Lexikai elemző**: A `%lex` szekció szabályai definiálják, hogyan azonosítja az elemző az egyes tokeneket (pl. stringek, számok, zárójelek).
- **Szintaktikai szabályok**: Az értékek, objektumok és tömbök hierarchikus szerkezetét az elemző szabályai határozzák meg.
- **Hibakezelés**: A nem várt tokenek esetén az elemző pontos hibaüzenetet ad, amely megmutatja a hibás token pozícióját.

A megvalósított fájlok:
- **json-parser.jison**: Az elemző nyelvtani szabályait tartalmazza.
- **run.js**: Az elemző futtatását és a JSON fájlok feldolgozását végző script.
- **tests/*.json**: Teszt file-ok a tests folder alatt jelennek meg.

---

## 5. Tesztelés
A tesztelés célja az elemző helyességének és robusztusságának ellenőrzése volt, helyes és helytelen bemenetekkel egyaránt. Példák:
- **Helyes bemenet**:
```json
{
  "id": 123,
  "name": "Gadget",
  "attributes": {
    "color": "red",
    "size": "medium"
  },
  "tags": ["electronics", "devices"]
}
```
Kimenet: A JSON objektum helyesen feldolgozva, strukturált JavaScript objektummá alakítva.

- **Helytelen bemenet**:
```json
{
  "price": 99.99.9
}
```
Kimenet: `Error: Unexpected token '9' at line 1, column 22`. A hibát az extra `.` karakter okozta a szám formátumban.

---

## 6. Fejlesztési Kihívások és Megoldások
**Kihívás**: A JSON szabályok pontos megvalósítása (pl. számformátumok, string idézőjelek kezelése).  
**Megoldás**: A Jison nyelvi specifikáció pontos kidolgozása és iteratív tesztelés.

**Kihívás**: A negatív előjel opciónális behelyezése a számok elé.  
**Megoldás**: `[-]?` módon tudtuk behelyezni.

**Kihívás**: Szintaktikai hibákat helyetelenül fejezte ki.  
**Megoldás**: Saját hiba kezelő kidolgozása, amely megjeleníti a hibás karaktert és a sor/oszlop indexet.

---

## 7. Eredmények
- **Főbb eredmények**: A JSON-elemző képes volt feldolgozni helyes bemeneteket, és pontos hibajelzést adott helytelen szintaxis esetén.

A projekt demonstrálja a Jison használatának hatékonyságát egyszerű nyelvek elemzésében, és alapot nyújt komplexebb elemzők fejlesztéséhez.
