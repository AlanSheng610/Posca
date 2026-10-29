# Posca

Posca is a Flutter app for sending photo postcards to strangers around the world.

You take a photo and crop it into a 3:2 postcard. You write a short message, and the
app stamps the card with the city and country you're in. The written side of the card
takes its color from the photo. Sending a public postcard unlocks your inbox, where
you can read the cards people sent you and write back.

## Features

- **Email sign-up and onboarding**: nickname, birthday, spoken languages (fuzzy
  search over 130+ languages), gender, a custom [Fluttermoji](https://pub.dev/packages/fluttermoji)
  avatar, and interests.
- **Postcard composer**: in-app camera, cropping to 3:2, the card color picked from
  the photo's dominant color with [`palette_generator`](https://pub.dev/packages/palette_generator),
  and the location from GPS plus reverse geocoding.
- **Inbox and replies**: received cards appear full screen in a carousel. Tap a card
  to flip it to its details and reply.
- **Gallery**: a grid of every card you've sent or received.
- **Friends**: everyone who has written to you.
- **Collection**: a board where you can drag, pinch-zoom, rotate and flip your
  latest postcard.
- **Profile**: your avatar, bio, details and interests, all editable.

## Tech stack

| Area             | Choice                                                     |
| ---------------- | ---------------------------------------------------------- |
| Framework        | Flutter 3.19, Dart 3                                       |
| State & routing  | [GetX](https://pub.dev/packages/get)                       |
| Backend          | Firebase Auth, Cloud Firestore, Cloud Storage              |
| Camera & media   | camerawesome, image_cropper, cached_network_image          |
| Location         | geolocator, geocoding                                      |

## Architecture

```text
lib/
├── main.dart                 Firebase init and GetMaterialApp
├── app/
│   ├── bindings.dart         App-wide controllers
│   ├── routes.dart           Route names and pages
│   └── theme.dart            Colors, text styles
├── constants/                Language and interest lists
├── data/
│   └── firestore_refs.dart   Every Firestore and Storage path, in one place
├── models/                   Postcard, UserProfile, SendConfig (immutable, map (de)serialization)
├── controllers/              GetX controllers (auth, profile, postcards, compose, onboarding)
├── screens/                  One folder per flow: auth, onboarding, home, compose, postcard, profile
└── widgets/                  Reusable UI: PostcardFace, Avatar, SwipeUp, Transformable…
```

- **Controllers own data, and screens own UI.** Screens read controller state through
  `Obx` and call controller methods. They never talk to Firebase directly.
- **App-wide controllers** (`AuthController`, `ProfileController`, `PostcardController`)
  are registered once in `AppBindings`. Flow-scoped controllers
  (`OnboardingController`, `ComposeController`) are attached to their route's
  binding, so they're cleaned up when the flow ends.
- **`AuthController` decides the first screen.** It listens to Firebase auth state and
  sends the user to login, onboarding (no profile document yet), or home.
- **Sending is atomic.** A postcard is written to every collection it belongs to in a
  single Firestore batch.

### Data model

```text
users/{uid}                     UserProfile
users/{uid}/settings/send       SendConfig
users/{uid}/sent/{id}           Postcard   cards this user sent
users/{uid}/received/{id}       Postcard   every card this user received
users/{uid}/inbox/{id}          Postcard   received cards shown in the inbox
postcards/{id}                  Postcard   every card ever sent
public/{id}                     Postcard   public cards awaiting delivery

Storage: photos/{id}.jpg (full photo), thumbnails/{id}.jpg (3:2 crop)
```

## Getting started

1. Install Flutter 3.19 or newer and the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup).
2. Create a Firebase project with **Email/Password auth**, **Firestore** and
   **Storage** enabled.
3. Generate the Firebase config. This creates `lib/firebase_options.dart` and the
   platform files, which are git-ignored:

   ```sh
   flutterfire configure
   ```

4. Run the app:

   ```sh
   flutter pub get
   flutter run
   ```

The camera, location and image cropping need a real device or an emulator with
camera support.

### Tests

```sh
flutter analyze
flutter test
```

## Roadmap

- Deliver public postcards to matching strangers. Cards are queued in `public/`, but
  the matching (planned as a Cloud Function using the `SendConfig` preferences) isn't
  built yet. Today, only replies reach another user's inbox.
- A screen to edit sending preferences (languages, locations, age range).
- Move cards out of the inbox once they've been read.
- Firestore and Storage security rules.

## Notes

- `packages/fluttermoji` is a vendored copy of
  [fluttermoji 1.0.2](https://pub.dev/packages/fluttermoji/versions/1.0.2) (MIT). Its
  customizer is wrapped in a `SafeArea` so it isn't hidden behind the notch.
- Sample photos on the send screen, from Wikimedia Commons:
  - `assets/beijing.jpg`: [Temple of Heaven](https://commons.wikimedia.org/wiki/File:20200110_Temple_of_Heaven-1.jpg) by Balon Greyjoy, CC0
  - `assets/honolulu.jpg`: [Waikiki Beach](https://commons.wikimedia.org/wiki/File:Waikiki_Beach_Honolulu._(53114898286).jpg) by Bernard Spragg, public domain
  - `assets/bhutan.jpg`: [Bhutan Landscape](https://commons.wikimedia.org/wiki/File:Bhutan_Landscape.jpg) by Mussi Katz, CC0

## License

[MIT](LICENSE)
