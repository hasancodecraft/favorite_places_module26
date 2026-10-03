# Requirement mapping and device checks

Implementation is present in the source files below. Device behavior remains to be checked with a valid Maps key and an Android device. An implemented item is not a claim that a device test has passed.

## Assignment requirements

| Requirement from the supplied screenshots | Where it is implemented |
| --- | --- |
| Display Google Map when the app starts | `MapScreen.build()` creates `GoogleMap` immediately. |
| Zoom controls | `zoomControlsEnabled: true`. |
| Current-location button | Visible My Location button; native map location button is enabled and becomes available with location access. |
| At least three predefined favorites | Three entries in `lib/data/favorite_locations.dart`. |
| Model contains ID, name, latitude, longitude | `FavoriteLocation` in `lib/models/favorite_location.dart`. |
| Markers for favorite locations | `_addFavoriteMarkers()` creates a marker with a unique ID for each entry. |
| Use geolocator for current coordinates | `_getCurrentLocation()` calls `Geolocator.getCurrentPosition()`. |
| Move camera to current position | `_moveCamera()` receives coordinates from the returned `Position`. |
| Handle location permission | Handles denied, permanently denied, granted, and disabled location services. |
| Marker tap shows all four fields | `_showLocationDetails()` opens an `AlertDialog`. |
| Button opens a favorite list | `_showFavoriteLocations()` opens a bottom sheet with three entries. |
| Tapping a list item moves map | Selected model supplies the coordinates to `_moveCamera()`. |
| Do not hard-code current location | Current marker uses `Position`; fixed coordinates are limited to favorites and the initial map view. |
| Complete project plus four screenshots | Android source project is included; capture the actual screenshots on your device. |
| Submit using a GitHub repository URL | Upload source and captured screenshots, then submit the repository URL. |

## Manual checks before submission

Leave each box unchecked until you have performed the action on the configured app.

- [ ] `flutter pub get` succeeds and creates `pubspec.lock`.
- [ ] `flutter analyze` completes without errors.
- [ ] `flutter run` successfully builds and launches on Android.
- [ ] Map tiles load rather than a blank/grey map.
- [ ] The opening map shows all three favorite markers.
- [ ] Zoom controls work.
- [ ] Each favorite marker opens details with its own correct ID, name and coordinates.
- [ ] Favorite Locations shows all three entries; each one moves the camera to the selected marker.
- [ ] On a fresh install, pressing My Location requests permission.
- [ ] Granting permission displays device coordinates, shows the current-location marker and moves the camera.
- [ ] Denying permission shows a useful message while favorite markers remain usable.
- [ ] Permanent denial shows Settings; allowing access there and pressing My Location again works.
- [ ] Turning GPS off shows the location-service message and Settings action.
- [ ] A location timeout/failure leaves the buttons available for another attempt.
- [ ] Repeated presses while loading do not trigger overlapping location requests.
- [ ] Four real screenshots have been added under `screenshots/`.
- [ ] GitHub includes the source, Android runner, `pubspec.yaml`, `pubspec.lock`, and screenshot files.
- [ ] The Maps key file is not committed, and the teacher can open the submitted repository.

## Preparation checks and limitations

The Dart flow was reviewed against the assignment. YAML and Android XML were parsed, local Dart import paths were checked, and the archive contents were checked. No Flutter analyzer, package resolution, APK build, Google Map rendering, GPS behavior, or on-device screenshots were available in the preparation environment. Complete those checks locally before marking them as passed.
