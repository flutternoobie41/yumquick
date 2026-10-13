# YumQuick

Food delivery app for the Bictree Flutter task. Built from the YumQuick Figma kit, data from [DummyJSON](https://dummyjson.com).

You can log in, browse and search dishes, open a dish, add it to the cart and place an order (locally, no API call).

**APK:** https://github.com/<USER>/<REPO>/releases/latest
**Login:** `emilys` / `emilyspass`

## Running it

Flutter `<FLUTTER VERSION>`

```bash
flutter pub get
flutter run
```

Release APK: `flutter build apk --release`

The `*.g.dart` files are committed. If you change a model, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Tests

```bash
flutter test
```

Result: `<paste last line, e.g. +26: All tests passed!>`

- `cart_cubit_test.dart`: cart logic (add/merge, quantity limits, remove + undo, clear) and the totals
- `food_repository_test.dart`: first page gets cached, cache is used when offline, 401 isn't hidden by the cache
- `login_screen_test.dart`: form validation, submit, error message
- `error_mapper_test.dart`: Dio errors → typed failures
- `food_category_test.dart`: category rules
- `widget_test.dart`: app starts on the splash

## Structure

Feature folders, each with `data / domain / presentation`, plus a shared `core`.

```
lib/
  app/        router, theme, app widget
  core/       di, network (Dio + auth interceptor), errors, storage, shared widgets
  features/
    auth/     login, splash, session
    food/     home list, detail, offline cache
    cart/     cart, confirm order
```

- Domain has the entities and repository interfaces, no Flutter/Dio code.
- Data sources throw. Repositories wrap every call in `guard()` and return `Result` (data or a typed `Failure`), so the UI never sees a raw exception.
- On a 401 the interceptor clears the token and AuthBloc sends you back to login. go_router redirects based on AuthBloc's state.

## Why Bloc

I like that every change is an explicit event → state, and Bloc's event transformers handle the debounced search and "don't load the same page twice" without extra code. `bloc_test` also makes the cart tests short. I used Cubits where there's nothing to debounce (cart, detail).

## Prices and categories

The API has no prices, so each recipe gets a fixed one from its id:

```dart
double mockPriceFor(int id) => 4.99 + (id * 37) % 20; // $4.99 – $23.99
```

Same item, same price, every time. Cart tax/fees are 5% of the subtotal and delivery is a flat $2.99.

Categories from the design mapped to the API:

- **Snacks**: mealType Snack, Snacks or Appetizer (the API spells it both ways)
- **Meal**: mealType Breakfast, Lunch or Dinner
- **Vegan**: no ingredient matching an animal-product keyword. The API has no vegan tag, so this is a rough keyword check (e.g. coconut milk still counts as dairy)
- **Dessert**: mealType or tag Dessert
- **Drinks**: mealType Beverage

## Decisions / trade-offs

- Search, categories and sort are all on Home instead of separate Menu and Search screens. Felt better than three half-done screens in the time I had.
- Plain list and search are paginated by the API (10 at a time). Categories combine several API values, so for those I fetch all 50 recipes once and filter on the phone.
- Sort is Top rated / Name / Quickest, all done by the API. No price sort since prices are made up on the phone.
- Detail screen gets the item passed from the list, so it opens instantly. It only calls `/recipes/{id}` when opened without one.
- Data calls go through DummyJSON's `/auth/...` prefix so an expired token actually returns a 401.
- Offline: the first page of the home list is saved in Hive. If that load fails because there's no network, the saved items show with an offline banner. Other queries just show the error screen with retry.
- Cart is saved in Hive as a JSON string on every change. Tokens and the cached user are in flutter_secure_storage.
- Removing from the cart is only by swipe, so it can always be undone. The − button stops at 1.
- Food detail, empty, error and offline screens aren't in the design, so I made them in the same style. Font is League Spartan, bundled in the app.

## Skipped

- Separate Menu and Search & Filter screens (so no price slider or rating chips)
- Best Seller row and the banner on Home
- Token refresh: a 401 just logs you out, as the task asks
- Offline mode for categories and search, only the first page is cached
- App icon (still the default one)
- Didn't test on iOS
- Release APK is signed with the debug key

## With more time

- Build the Menu and Search & Filter screens properly
- Refresh the token before logging out
- Auto-refresh when the network comes back
- Clear or separate the cart per user on logout
- Integration tests for login → cart → order, and CI for analyze + tests

## Time spent

About **_ hours** total.

## Time spent

About **9 hours** total, spread over two days.

| | Hours |
|---|---|
| Setup, theme | 1 |
| Core + auth | 2.5 |
| Home list | 2 |
| Detail | 1 |
| Cart + order | 1 |
| Offline | 0.75 |
| Tests, release, README | 0.75 |