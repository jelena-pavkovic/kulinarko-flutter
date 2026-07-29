# Kulinarko

Mobilna aplikacija za porodičnu knjigu recepata i planiranje kupovine, razvijena kao lični/porodični projekat u Flutter-u.

## O projektu

Kulinarko omogućava:

- Čuvanje i pregled recepata (CRUD)
- Praćenje sastojaka kroz tri stanja: imam / treba da kupim / neoznačeno
- Automatsko generisanje liste za kupovinu na osnovu izabranih recepata
- Filtriranje po kategorijama i pretragu recepata

Aplikacija komunicira sa [Kulinarko API](https://github.com/) backendom pisanim u FastAPI-ju.

## Tehnologije

- **Flutter** / **Dart**
- **Riverpod** za state management
- **GoRouter** za navigaciju (`ShellRoute` za trajnu donju navigaciju)
- **flutter_slidable** za swipe akcije
- **image_picker** za izbor fotografija

## Pokretanje projekta

1. Kloniraj repozitorijum i uđi u folder projekta:

   ```bash
   git clone <url-repozitorijuma>
   cd kulinarko
   ```

2. Instaliraj zavisnosti:

   ```bash
   flutter pub get
   ```

3. Podesi adresu backend API-ja (u odgovarajućem servisnom/konfiguracionom fajlu). Za Android emulator lokalni backend se obraća preko:

   ```
   http://10.0.2.2:8000
   ```

4. Pokreni aplikaciju:
   ```bash
   flutter run
   ```

## Struktura projekta

- `screens/` - `home_screen.dart`, `recipe_detail_screen.dart`, `recipe_form_screen.dart`, `shopping_screen.dart`, `settings_screen.dart`
- `widgets/` - `RecipeGrid`, `RecipeCard`, `CategoryChipBar`
- `models/` - modeli podataka
- `services/` - komunikacija sa API-jem
- `providers/` - Riverpod provideri

## Planirane funkcionalnosti

- Zaseban ekran za sastojke/artikle (katalog koji se deli između recepata), dostupan preko podešavanja
- Kategorija "grickalice" - artikli koji se dodaju direktno na listu za kupovinu
- Finansijsko planiranje na osnovu cena sastojaka
- Korisnički nalozi / prijava (planirano za kraj, nakon ostalih funkcionalnosti)

## Napomena

Aplikacija je u fazi lokalnog razvoja - testira se lokalno pre postavljanja na privatno hostovan server (Ubuntu + PostgreSQL).
