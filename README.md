# YumQuick: Food Delivery App

A Flutter app (Android, iOS optional) built from the YumQuick Food Delivery UI Kit for the Bictree Flutter Developer task. Users log in, browse food items, view details and manage a cart. All data comes from [DummyJSON](https://dummyjson.com).

> **Status:** work in progress, built in phases. See [Progress](#progress).

## Progress

- [x] Phase 0: project setup, lints, Material 3 theme, README skeleton
- [x] Phase 1: core layer (Dio client, auth interceptor, typed failures, secure storage)
- [x] Phase 2: auth (login with validation, auto-login, log out on 401)
- [x] Phase 3: food list (pagination, debounced search, categories, sort, skeletons, pull-to-refresh, error retry)
- [X] Phase 4: food detail (hero image, details, quantity, Add to Cart)
- [X] Phase 5: cart and Confirm Order (persistence, swipe to delete with undo)
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
├── main.dart                 # DI setup, AuthBloc, runApp
├── app/
│   ├── app.dart              # MaterialApp.router + BlocProvider<AuthBloc>
│   ├── router.dart           # go_router routes and auth redirect
│   ├── router_refresh.dart   # AuthBloc stream → router refresh
│   ├── di.dart               # get_it registrations
│   └── theme/                # colours, text styles, radii from Figma
├── core/
│   ├── bloc/                 # shared event transformers (debounce)
│   ├── error/                # Failure, Result, Dio error mapper, guard()
│   ├── network/              # Dio client, auth interceptor, endpoints
│   ├── session/              # session-expired events (network → auth)
│   ├── storage/              # secure token storage
│   ├── utils/                # price formatting
│   └── widgets/              # header scaffold, text field, empty/error/offline views
└── features/
    ├── auth/
    │   ├── data/             # models, remote + local data sources, repository impl
    │   ├── domain/           # User, AuthRepository
    │   └── presentation/     # AuthBloc, login and splash screens, login form
    ├── food/
    │   ├── data/             # RecipeModel, remote + local (offline cache) data sources, repository impl
    │   ├── domain/           # FoodItem, FoodCategory, FoodQuery, FoodRepository
    │   └── presentation/     # FoodListBloc, FoodDetailCubit, Home and detail screens, screens,widgets
    └── cart/
        ├── data/             # CartItemModel, Hive data source, repository impl
        ├── domain/           # CartItem, Cart (totals), CartRepository
        └── presentation/     # CartCubit, Cart and Confirm Order screens, widgets

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

- **Loading strategy:** the plain list and search paginate on the server (10 per page, `skip`/`limit`). A category merges several API values, so it is filtered on the device after one request for all 50 recipes; with a dataset this small that is cheaper than paging through filtered results.
- **Sort By** offers Top rated, Name and Quickest, all sorted by the API. Price sort is left out because prices are derived on the device.
- **Stale responses:** each new query gets a request id and older responses are dropped, so a slow request never overwrites newer results.

- **Detail without a second request:** the list already returns full recipes, so the card passes its item to the detail screen, which opens instantly. `GET /recipes/{id}` is used only when the screen opens without one (deep link) and for retry.

- **Cart pricing:** tax and fees are 5% of the subtotal and delivery is a flat $2.99 (both $0 for an empty cart), all rounded to cents. The rules live in the pure `Cart` class and are unit tested.
- **Cart storage:** the cart is saved to a Hive box as one JSON string after every change, so no Hive type adapters are needed. Unreadable data starts an empty cart instead of crashing.
- **Undo:** removing a line remembers it and its position, so Undo puts it back in the same place. Quantity changes never remove a line; only the swipe does, so every removal can be undone.
- **Place Order is local:** it confirms, returns to Home and empties the cart. No API call, as the task asks.

- **Offline support:** the first page of the default list is saved to Hive after every successful load. When that page can't be loaded because the network is down, the saved items are shown with an offline banner, and pull-to-refresh replaces them once back online. Only network failures fall back to the cache; a 401 still logs out. Other queries (category, search, next page) need the network and show the error view with retry. Images come from `cached_network_image`'s disk cache, so photos seen before also load offline.
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
