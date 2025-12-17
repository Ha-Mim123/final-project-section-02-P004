import 'package:e_commerce_mini_shopping_cart/providers/cart_provider.dart';
import 'package:e_commerce_mini_shopping_cart/providers/orders_provider.dart';
import 'package:e_commerce_mini_shopping_cart/providers/products_provider.dart';
import 'package:e_commerce_mini_shopping_cart/providers/auth_provider.dart';
import 'package:e_commerce_mini_shopping_cart/screens/login_screen.dart';
import 'package:e_commerce_mini_shopping_cart/screens/main_navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider(null, [])),

        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(null, []),
          update: (context, auth, previousOrders) =>
              OrdersProvider(auth, previousOrders?.orders ?? []),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/home': (context) => const MainNavigationScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb_auth.User?>(
      stream: fb_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) return const MainNavigationScreen();
        return const LoginScreen();
      },
    );
  }
}
