
// run this code when working on mobile app


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:profolio/firebase_options.dart';
import 'package:profolio/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform
  ); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff121212),
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: const Color(0xff2c2c2c),
          surface: const Color(0xff1e1e1e),
          background: const Color(0xff121212),
          onPrimary: Colors.black,
          onSecondary: Colors.white70,
          onSurface: Colors.white,
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xff2c2c2c),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
      ),

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}



//
// //this is code is working perfectly and correct (final code for flutter web app)
// //
// import 'dart:async';
// import 'package:app_links/app_links.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:profolio/pages/splash_screen.dart';
// import 'package:profolio/pages/portfoliodetailloader.dart';
//
// const kWindowsScheme = 'sample';
//
// void main() async {
//   // Uncomment if you want to register a custom protocol on Windows.
//   // registerProtocolHandler(kWindowsScheme);
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   StreamSubscription<Uri>? _linkSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     initDeepLinks();
//   }
//
//   @override
//   void dispose() {
//     _linkSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> initDeepLinks() async {
//     // Listen for incoming deep links.
//     _linkSubscription = AppLinks().uriLinkStream.listen((Uri? uri) {
//       if (uri != null) {
//         debugPrint('onAppLink: $uri');
//         openAppLink(uri);
//       }
//     });
//   }
//
//   void openAppLink(Uri uri) {
//     // Here we assume that the deep link is in the form:
//     // sample://foo/#/portfolio/PortFolio000017
//     // We use the URL fragment (i.e. the part after the '#') for routing.
//     final String? fragment = uri.fragment;
//     if (fragment != null && fragment.startsWith('/portfolio/')) {
//       // Extract the portfolio ID from the route.
//       final String portfolioId = fragment.substring('/portfolio/'.length);
//       _navigatorKey.currentState?.pushNamed(fragment);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: _navigatorKey,
//       initialRoute: "/",
//       onGenerateRoute: (RouteSettings settings) {
//         Widget routeWidget = defaultScreen();
//
//         // Mimic web routing
//         final String? routeName = settings.name;
//         if (routeName != null) {
//           if (routeName.startsWith('/portfolio/')) {
//             // Extract portfolio ID and return PortfolioDetailLoader
//             final String portfolioId =
//             routeName.substring('/portfolio/'.length);
//             routeWidget = PortfolioDetailLoader(portfolioId: portfolioId);
//           }
//         }
//
//         return MaterialPageRoute(
//           builder: (context) => routeWidget,
//           settings: settings,
//           fullscreenDialog: true,
//         );
//       },
//     );
//   }
//
//   Widget defaultScreen() {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       appBar: AppBar(title: const Text('Default Screen')),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Hello User",style: TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//             ),),
//             const SizedBox(height: 20),
//             buildWindowsUnregisterBtn(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildWindowsUnregisterBtn() {
//     if (defaultTargetPlatform == TargetPlatform.windows) {
//       return TextButton(
//         onPressed: () {
//           // Your unregister code here if needed.
//         },
//         child: const Text('Remove Windows protocol registration'),
//       );
//     }
//     return const SizedBox.shrink();
//   }
// }
//
//


//
//
//
//











































// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:go_router/go_router.dart';
// import 'package:profolio/pages/portfoliodetailloader.dart';
// import 'package:profolio/pages/portfoliolist.dart';
// import 'package:profolio/pages/splash_screen.dart';
//
// import 'firebase_options.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase with your configuration.
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);
//
//   // Define your GoRouter configuration
//   final GoRouter _router = GoRouter(
//     routes: [
//       // SplashScreen route
//       GoRoute(
//         path: '/',
//         builder: (context, state) => SplashScreen(),
//       ),
//       // Portfolio list route (for logged-in users)
//       GoRoute(
//         path: '/portfolios',
//         builder: (context, state) => PortfolioListPage(),
//       ),
//       // Deep link route for a specific portfolio by ID
//       GoRoute(
//         path: '/portfolio/:id',
//         builder: (context, state) {
//           final portfolioId = state.pathParameters['id']!;
//           return PortfolioDetailLoader(portfolioId: portfolioId);
//         },
//       ),
//     ],
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(child: Text('Page not found: ${state.error}')),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Portfolio App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.teal,
//           brightness: Brightness.dark,
//         ),
//       ),
//       routerDelegate: _router.routerDelegate,
//       routeInformationParser: _router.routeInformationParser,
//     );
//   }
// }
//

//
//


//this is i am working on
// import 'package:app_links/app_links.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:profolio/pages/portfoliodetailloader.dart';
// import 'package:profolio/pages/splash_screen.dart';
//
// import 'firebase_options.dart';
//
//
// void main() async {
//
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(); // Initialize Firebase
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // options: DefaultFirebaseOptions.currentPlatform,
//   ); // Initialize Firebase
//
//   runApp(const MyApp());
//
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
//   //
//   //
//   // runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
//
// class _MyAppState extends State<MyApp> {
//
//   final AppLinks _appLinks = AppLinks();
//
//   @override
//   void initState() {
//     super.initState();
//     _appLinks.uriLinkStream.listen((Uri? uri) {
//       if(uri!=null){
//         final portfolioid = uri.pathSegments.last;
//
//         Navigator.push(context, MaterialPageRoute(builder:  (context) => Demo(portfolioid: portfolioid),));
//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PortfolioDetailLoader(portfolioId: portfolioid,),));
//       }
//
//     },);
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.teal,
//           brightness: Brightness.dark,
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }
//
//
//
// class Demo extends StatefulWidget {
//   const Demo({super.key,required this.portfolioid});
//   final String portfolioid;
//
//   @override
//   State<Demo> createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(widget.portfolioid),
//       ),
//     );
//   }
// }



//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:profolio/pages/portfoliodetailloader.dart';
// import 'package:profolio/pages/portfoliolist.dart';
// import 'firebase_options.dart';
// import 'package:profolio/pages/splash_screen.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Portfolio App',
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       onGenerateRoute: (RouteSettings settings) {
//         // Parse the incoming URL
//         final Uri uri = Uri.parse(settings.name ?? '');
//
//         // If no path segments, load the splash screen
//         if (uri.pathSegments.isEmpty) {
//           return MaterialPageRoute(builder: (context) => SplashScreen());
//         }
//
//         // If the path is like /portfolio/PortFolio000017
//         if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'portfolio') {
//           String portfolioId = uri.pathSegments[1];
//           return MaterialPageRoute(
//             builder: (context) => PortfolioDetailLoader(portfolioId: portfolioId),
//           );
//         }
//
//         // Fallback route (for example, PortfolioListPage)
//         return MaterialPageRoute(builder: (context) => PortfolioListPage());
//       },
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//       ),
//     );
//   }
// }


//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:profolio/pages/portfoliodetailloader.dart';
// import 'package:profolio/pages/portfoliolist.dart';
// import 'firebase_options.dart';
// import 'package:go_router/go_router.dart';
// import 'package:profolio/pages/splash_screen.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);
//
//   final GoRouter _router = GoRouter(
//     initialLocation: '/', // Set initial location to avoid null state.
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (context, state) => SplashScreen(),
//       ),
//       GoRoute(
//         path: '/portfolios',
//         builder: (context, state) => PortfolioListPage(),
//       ),
//       GoRoute(
//         path: '/portfolio/:id',
//         builder: (context, state) {
//           final portfolioId = state.pathParameters['id']!;
//           return PortfolioDetailLoader(portfolioId: portfolioId);
//         },
//       ),
//     ],
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(child: Text('Page not found: ${state.error}')),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Portfolio App',
//       debugShowCheckedModeBanner: false,
//       routerDelegate: _router.routerDelegate,
//       routeInformationParser: _router.routeInformationParser,
//       routeInformationProvider: _router.routeInformationProvider, // Use provider from go_router.
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.teal,
//       ),
//     );
//   }
// }




//
// import 'dart:async';
//
// import 'package:app_links/app_links.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'firebase_options.dart';
//
//
// ///////////////////////////////////////////////////////////////////////////////
// /// Please make sure to follow the setup instructions below
// ///
// /// Please take a look at:
// /// - example/android/app/main/AndroidManifest.xml for Android.
// ///
// /// - example/ios/Runner/Runner.entitlements for Universal Link sample.
// /// - example/ios/Runner/Info.plist for Custom URL scheme sample.
// ///
// /// Android launch:
// ///    adb shell am start -a android.intent.action.VIEW \
// ///     -d "sample://open.my.app/#/book/hello-world"
// ///
// /// iOS launch:
// ///    /usr/bin/xcrun simctl openurl booted "app://www.example.com/#/book/hello-world"
// ///
// ///
// /// Windows & macOS launch:
// ///   The simplest way to test it is by
// ///   opening your browser and type: sample://foo/#/book/hello-world2
// ///
// /// On windows:
// /// Outside of a browser, in a email for example, you can use:
// /// https://example.com/#/book/hello-world2
// ///////////////////////////////////////////////////////////////////////////////
//
//
//
//
// const kWindowsScheme = 'sample';
//
// void main() async{
//   // Register our protocol only on Windows platform
//   // registerProtocolHandler(kWindowsScheme);
//
//
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   StreamSubscription<Uri>? _linkSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     initDeepLinks();
//   }
//
//   @override
//   void dispose() {
//     _linkSubscription?.cancel();
//
//     super.dispose();
//   }
//
//   Future<void> initDeepLinks() async {
//     // Handle links
//     _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
//       debugPrint('onAppLink: $uri');
//       openAppLink(uri);
//     });
//   }
//
//   void openAppLink(Uri uri) {
//     _navigatorKey.currentState?.pushNamed(uri.fragment);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: _navigatorKey,
//       initialRoute: "/",
//       onGenerateRoute: (RouteSettings settings) {
//         Widget routeWidget = defaultScreen();
//
//         // Mimic web routing
//         final routeName = settings.name;
//         if (routeName != null) {
//           if (routeName.startsWith('/book/')) {
//             // Navigated to /book/:id
//             routeWidget = customScreen(
//               routeName.substring(routeName.indexOf('/book/')),
//             );
//           } else if (routeName == '/book') {
//             // Navigated to /book without other parameters
//             routeWidget = customScreen("None");
//           }
//         }
//
//         return MaterialPageRoute(
//           builder: (context) => routeWidget,
//           settings: settings,
//           fullscreenDialog: true,
//         );
//       },
//     );
//   }
//
//   Widget defaultScreen() {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Default Screen')),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SelectableText('''
//             Launch an intent to get to the second screen.
//
//             On web:
//             http://localhost:<port>/#/book/1 for example.
//
//             On windows & macOS, open your browser:
//             sample://foo/#/book/hello-deep-linking
//
//             This example code triggers new page from URL fragment.
//             '''),
//             const SizedBox(height: 20),
//             buildWindowsUnregisterBtn(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget customScreen(String bookId) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Second Screen')),
//       body: Center(child: Text('Opened with parameter: $bookId')),
//     );
//   }
//
//   Widget buildWindowsUnregisterBtn() {
//     if (defaultTargetPlatform == TargetPlatform.windows) {
//       return TextButton(
//           onPressed: () => (){},
//           child: const Text('Remove Windows protocol registration'));
//     }
//
//     return const SizedBox.shrink();
//   }
// }



