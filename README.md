# YumQuick: Food Delivery App

A Flutter app (Android, iOS optional) built from the YumQuick Food Delivery UI Kit for the Bictree Flutter Developer task. Users log in, browse food items, view details and manage a cart. All data comes from [DummyJSON](https://dummyjson.com).

> **Status:** work in progress, built in phases. See [Progress](#progress).

## Progress

- [x] Phase 0: project setup, lints, Material 3 theme, README skeleton
- [ ] Phase 1: core layer (Dio client, auth interceptor, typed failures, secure storage)
- [ ] Phase 2: auth (login with validation, auto-login, log out on 401)
- [ ] Phase 3: food list (pagination, debounced search, categories, sort, skeletons, pull-to-refresh, error retry)
- [ ] Phase 4: food detail (hero image, details, quantity, Add to Cart)
- [ ] Phase 5: cart and Confirm Order (persistence, swipe to delete with undo)
- [ ] Phase 6: offline support (cached first page, offline banner)
- [ ] Phase 7: remaining tests, README, release APK

## Download

APK: _added with the first release._

## Setup and run

**Flutter version used:** _to be filled from `flutter --version`._

```bash
flutter pub get
flutter run
```

Test account: `emilys` / `emilyspass` (DummyJSON test user).

Release build:

```bash
flutter build apk --release
```

## Tests

```bash
flutter test
```

_Test results are added in Phase 7._

## Architecture

Feature-first folders, each split into data, domain and presentation layers, with the repository pattern between data and domain.

```
lib/
├── main.dart
├── app/              # app widget, theme, router, dependency injection
├── core/             # network, error model, storage, shared widgets
└── features/
    ├── auth/         # data / domain / presentation
    ├── food/
    └── cart/
```

- **data:** DTOs, remote and local data sources, repository implementations.
- **domain:** entities and repository contracts, with no Flutter or Dio imports.
- **presentation:** Blocs/Cubits, screens and widgets.

_A fuller breakdown is added as each layer lands._

## State management: Bloc

Bloc gives an explicit, traceable event-to-state flow, and its event transformers handle debounced search and duplicate page loads natively. `bloc_test` makes state sequences easy to assert. Cubits are used where there are no event streams to control (cart, detail).

## Mock prices

The recipes API has no price field. Each item gets a stable price derived from its id:

```dart
double priceFor(int id) => 4.99 + (id * 37) % 20; // $4.99 to $23.99
```

The same item always shows the same price, across sessions and devices.

## Category mapping

The design's categories map to the API's `mealType` and `tags` values (50 recipes in total):

| Design  | Rule |
|---------|------|
| Snacks  | `mealType` contains `Snack`, `Snacks` or `Appetizer` (the API uses both spellings) |
| Meal    | `mealType` contains `Breakfast`, `Lunch` or `Dinner` |
| Vegan   | No ingredient matches an animal-product keyword (meat, seafood, dairy, egg, honey). The API has no vegan tag, and only one recipe is tagged `Vegetarian`. |
| Dessert | `mealType` contains `Dessert`, or `tags` contains `Dessert` |
| Drinks  | `mealType` contains `Beverage` |

An item can appear in more than one category. _Final rules are confirmed in Phase 3._

## Design

- Colours, text styles and radii come from the Figma file's variables (`lib/app/theme/`).
- Font: **League Spartan** (Light, Regular, Medium, Bold), bundled in `assets/fonts` under the SIL Open Font License, so text renders correctly on a first launch without network.
- Screens the design doesn't cover (food detail, empty, error and offline states) are designed in the same style.

## Decisions and trade-offs

- **Hand-written JSON parsing**, no code generation, to keep the build simple within the time limit.
- **Tokens** in `flutter_secure_storage`; **cart and offline cache** in Hive (`hive_ce`, the maintained fork).
- **Theme scope:** only component themes with stable `*ThemeData` types are set globally; inputs and headers are dedicated widgets.

_More added as the build progresses._

## Skipped

_Filled in at submission._

## What I would improve with more time

_Filled in at submission._

## Time spent

| Phase | Hours |
|-------|-------|
| 0. Setup | _ |
| 1. Core | _ |
| 2. Auth | _ |
| 3. Food list | _ |
| 4. Detail | _ |
| 5. Cart and order | _ |
| 6. Offline | _ |
| 7. Tests and release | _ |
| **Total** | _ |
