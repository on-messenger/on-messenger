import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCG5uaQfmU2TodzRe3dQyCczW1Q2ng9zUU',
    appId: '1:1071981934772:web:4cb9e9b3720ebbfe14bfe1',
    messagingSenderId: '1071981934772',
    projectId: 'tcc-on',
    authDomain: 'tcc-on.firebaseapp.com',
    storageBucket: 'tcc-on.appspot.com',
    measurementId: 'G-4LDMF4N2ZL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDk8I48sfMYojtPtkvmqZdzBTt6rnhLzj0',
    appId: '1:1071981934772:android:d5b3ac832612c89014bfe1',
    messagingSenderId: '1071981934772',
    projectId: 'tcc-on',
    storageBucket: 'tcc-on.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7Mc3QZNjo-j0rM0TexgkzWeQgsDsOD7o',
    appId: '1:1071981934772:ios:32de56ca6c714abd14bfe1',
    messagingSenderId: '1071981934772',
    projectId: 'tcc-on',
    storageBucket: 'tcc-on.appspot.com',
    iosClientId:
        '1071981934772-0mu34qmq657u11ksu9l3sl2d4ohmopiv.apps.googleusercontent.com',
    iosBundleId: 'com.enterprise.on_messenger',
  );
}
