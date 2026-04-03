// Generated Firebase options for this project.
// Re-run `flutterfire configure` to regenerate if you add more platforms.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS is not configured yet. Run `flutterfire configure` to add iOS support.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Android — values from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEf2wd13Xfx8vgsrULw8jzlvyCS5tac74',
    appId: '1:507108324269:android:641cfc3d1d1f789814e724',
    messagingSenderId: '507108324269',
    projectId: 'technova-e4860',
    storageBucket: 'technova-e4860.firebasestorage.app',
  );

  // Web — fill in after enabling Web in Firebase console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCEf2wd13Xfx8vgsrULw8jzlvyCS5tac74',
    appId: '1:507108324269:web:placeholder',
    messagingSenderId: '507108324269',
    projectId: 'technova-e4860',
    storageBucket: 'technova-e4860.firebasestorage.app',
  );
}
