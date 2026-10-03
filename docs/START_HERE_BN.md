# শুরু করার নিয়ম

এটি Module 26-এর Google Maps & Location assignment-এর Android project। কোডে সাধারণ `StatefulWidget`, `setState()`, একটি model class, একটি list এবং দুটি package ব্যবহার করা হয়েছে।

## ১. ফোল্ডার খোলো

ZIP extract করে `favorite_places` ফোল্ডারটি VS Code বা Android Studio-তে খোলো। এই ফোল্ডারের ভেতরেই `pubspec.yaml`, `lib` এবং `android` আছে। Terminal-ও এই ফোল্ডারে খুলতে হবে।

PowerShell-এ চালাও:

```powershell
flutter --version
flutter doctor
flutter pub get
```

`flutter` command না পেলে আগে তোমার Flutter SDK-এর `bin` folder PATH-এ যুক্ত করতে হবে। Dart version 3.6-এর নিচে হলে package resolve হবে না। Version error এলে error-এর পুরো লেখা দেখে version মিলাতে হবে; package-এর নাম বা code এলোমেলোভাবে বদলানোর প্রয়োজন নেই।

Android Studio-এর SDK Manager থেকে Android SDK Platform 36 এবং Android SDK Command-line Tools রাখো। Build চাইলে NDK `27.0.12077973`-ও install করো। Build configuration-এ এগুলোর version দেওয়া আছে।

## ২. Google Maps API key বসাও

আগে থেকেই Android Maps key থাকলে সেটি ব্যবহার করতে পারো। না থাকলে:

1. [Google Cloud Console](https://console.cloud.google.com/)-এ নিজের project তৈরি বা select করো।
2. ওই project-এর billing setup সম্পন্ন করো।
3. APIs & Services থেকে **Maps SDK for Android** enable করো।
4. Credentials থেকে API key তৈরি করো।
5. API restrictions-এ **Maps SDK for Android** বেছে নাও। Application restrictions-এর জন্য **Android apps**, package name `com.example.favorite_places`, এবং নিজের debug certificate-এর SHA-1 ব্যবহার করো।

Project terminal-এ:

```powershell
Copy-Item android/maps.properties.example android/maps.properties
```

এবার `android/maps.properties` খুলে এই লাইনটিতে নিজের key বসাও:

```properties
MAPS_API_KEY=YOUR_ANDROID_MAPS_API_KEY
```

`YOUR_ANDROID_MAPS_API_KEY`-এর জায়গায় আসল key থাকবে। quotation mark দেবে না। আগে থেকে `maps.properties` থাকলে আবার copy না করে সেটাই edit করো। এই ফাইল `.gitignore`-এ আছে; GitHub-এ আপলোড করবে না।

### Debug SHA-1 পাওয়ার নিয়ম

আগে Flutter Android app চালিয়ে থাকলে সাধারণত debug keystore তৈরি আছে। PowerShell-এ:

```powershell
keytool -list -v -alias androiddebugkey -keystore "$env:USERPROFILE\.android\debug.keystore" -storepass android -keypass android
```

`SHA1:` লাইনের value ব্যবহার করো। এটি certificate fingerprint; API key নয়।

`keytool` command না পেলে Android Studio-এর Terminal/JDK ব্যবহার করো। Default install location হলে PowerShell-এ এইভাবে চালানো যায়:

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -alias androiddebugkey -keystore "$env:USERPROFILE\.android\debug.keystore" -storepass android -keypass android
```

Keystore না থাকলে key বসানোর পর project terminal-এ `flutter build apk --debug` চালাও। Debug build keystore তৈরি করবে; এরপর উপরের command আবার চালিয়ে SHA-1 দিয়ে key restriction সম্পূর্ণ করো। Cloud-এর key restriction বদলালে কার্যকর হতে কিছু সময় লাগতে পারে।

## ৩. Android ফোনে চালাও

1. ফোনে Developer options এবং USB debugging চালু করো।
2. USB cable দিয়ে ফোন connect করো এবং ফোনে debugging permission allow করো।
3. ফোনের internet ও Location/GPS চালু রাখো।
4. Terminal-এ নিচের command দাও:

```powershell
flutter devices
flutter analyze
flutter run
```

Device বেছে নিতে বললে Android ফোনটি বেছে নেবে। `Windows` desktop বেছে নেবে না। এই ZIP-এ Android runner দেওয়া আছে।

Emulator হলে Android Studio-তে Google Play/Google APIs system image ব্যবহার করো। Emulator-এর location emulator-provided হতে পারে; নিজের আসল অবস্থানের screenshot-এর জন্য Android ফোন ব্যবহার করাই সহজ।

প্রথম build-এ Gradle, Android dependency এবং Flutter plugin download হতে সময় লাগতে পারে।

## ৪. অ্যাপ কীভাবে ব্যবহার করবে

অ্যাপ খুললে Dhaka এলাকার map এবং তিনটি লাল favorite marker থাকবে। নিচে **My Location** ও **Favorite Locations** button থাকবে।

- **My Location:** প্রথমবার permission চাইলে Allow while using the app দাও। অ্যাপ `geolocator` দিয়ে latitude ও longitude নিয়ে map camera সরাবে। নীল current-location marker এবং নিচে coordinate দেখা যাবে।
- **Marker tap:** লাল marker-এ tap করলে Favorite Location dialog খুলবে। এখানে ID, name, latitude এবং longitude দেখা যাবে।
- **Favorite Locations:** button চাপলে তিনটি জায়গার list খুলবে। কোনো জায়গায় tap করলে list বন্ধ হবে এবং map সেই জায়গায় যাবে।
- **Zoom:** map-এর `+` ও `−` control ব্যবহার করতে পারবে। Permission পাওয়ার পর Google Map-এর নিজস্ব current-location control-ও পাওয়া যাবে।

Location বন্ধ থাকলে বা permission না থাকলে app message দেখাবে। Settings খুলে ঠিক করার পর app-এ ফিরে আবার **My Location** চাপবে।

## ৫. চারটি screenshot নাও

| ফাইলের নাম | কী থাকবে |
| --- | --- |
| `01_google_map.png` | অ্যাপ খোলার পর loaded Google Map ও controls। |
| `02_current_location.png` | My Location চাপার পর তোমার device থেকে পাওয়া অবস্থান, নীল marker এবং coordinate। |
| `03_favorite_markers.png` | তিনটি লাল favorite marker একসঙ্গে দেখা যাচ্ছে। |
| `04_favorite_details.png` | একটি favorite marker চাপার পর ID, name, latitude, longitude-সহ dialog। |

ছবিগুলো project-এর `screenshots` ফোল্ডারে রাখবে। Current location-এ যাওয়ার পর favorite marker দূরে চলে গেলে app আবার খুলে initial map থেকে তিনটি marker-এর screenshot নিতে পারো।

চাইলে Favorite Locations list-এর আরেকটি screenshot `05_favorite_list.png` নামে রাখতে পারো। এটি বাড়তি evidence; নির্দেশনায় চারটি screenshot চাওয়া হয়েছে।

এই ZIP-এ আসল screenshot দেওয়া হয়নি, কারণ সেগুলো তোমার configured app ও device থেকে তুলতে হবে।

## ৬. GitHub-এ project ও screenshot রাখো

প্রথমে GitHub-এ `favorite-places-module26` নামে একটি empty repository তৈরি করো। Empty রাখলে প্রথম push সহজ হবে; আগে থেকেই আলাদা README যোগ করতে হবে না।

Project terminal-এ:

```powershell
git init
git add .
git status
git commit -m "Add Module 26 maps assignment"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/favorite-places-module26.git
git push -u origin main
```

`YOUR_USERNAME`-এর জায়গায় নিজের GitHub username দেবে। Git login চাইলে নিজের account দিয়ে login করবে। `git status`-এ `android/maps.properties` যেন না থাকে। `pubspec.lock` এবং চারটি screenshot যেন থাকে।

GitHub-এ গিয়ে নিশ্চিত করো: `lib`, `android`, `pubspec.yaml`, `pubspec.lock`, README এবং screenshots upload হয়েছে। শুধু ZIP বা শুধু `main.dart` upload করলে complete project দেখা যাবে না।

এরপর Ostad-এর Add URL ঘরে **repository link** জমা দেবে। তোমার ছবিতে deadline দেওয়া আছে **3 October 2026, 11:59 PM**। Repository শিক্ষক যেন খুলতে পারেন, সেটিও নিশ্চিত করবে।

## ৭. কোড বোঝার ছোট নোট

`main.dart` থেকে app শুরু হয়। `MapScreen` হলো মূল screen। `initState()`-এ favorite list থেকে marker বানানো হয়। প্রতিটি marker-এর আলাদা `MarkerId` আছে।

`GoogleMapController` দিয়ে `animateCamera()` call করলে map-এর view বদলায়। `CameraPosition`-এ target coordinate এবং zoom level দেওয়া হয়।

`_getCurrentLocation()` প্রথমে GPS চালু আছে কি না ও permission পরীক্ষা করে। তারপর `Geolocator.getCurrentPosition()` থেকে `Position` নেয়। ওই `Position`-এর latitude ও longitude দিয়েই current marker ও camera target তৈরি হয়। `setState()` UI-তে loading, marker ও coordinate-এর পরিবর্তন দেখায়।

`FavoriteLocation` model-এর data শুধু favorite list-এর জন্য। Current location-এর জন্য কোনো fixed coordinate বা fallback location দেওয়া নেই। শুরুতে map-এ Dhaka দেখা মানেই user Dhaka-তে আছেন, এমন নয়।

`mounted` পরীক্ষা করা হয়, কারণ location পাওয়ার অপেক্ষার সময় screen বন্ধ হয়ে যেতে পারে। Screen বন্ধ হলে আর `setState()` করা উচিত নয়। `dispose()`-এ map controller release করা হয়।

## সমস্যা হলে

| সমস্যা | কী পরীক্ষা করবে |
| --- | --- |
| শুধু ধূসর map | Internet, Maps SDK for Android, billing, API key, package name ও SHA-1 restriction। |
| Key missing build error | `android/maps.properties` আছে এবং placeholder-এর জায়গায় আসল key বসানো আছে কি না। |
| Location আসে না | GPS, app permission, 20-second timeout message; খোলা জায়গায় গিয়ে আবার My Location চাপো। |
| Permission permanently denied | Settings থেকে location permission দিয়ে app-এ ফিরে আবার button চাপো। |
| Package version error | `flutter --version` এবং error-এর পুরো লেখা সংগ্রহ করো। |
| SDK/NDK error | Android Studio SDK Manager-এ Platform 36 ও চাওয়া NDK install করো। |

Source/configuration পরীক্ষা করা হয়েছে। এই পরিবেশে Flutter SDK, Android build বা actual GPS run করা যায়নি। নিজের কম্পিউটারে `flutter analyze` এবং Android run-এর ফল দেখে তারপর screenshot ও submission সম্পন্ন করো।
