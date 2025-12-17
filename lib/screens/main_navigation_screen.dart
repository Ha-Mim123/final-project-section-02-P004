import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_list_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart'; // ✅ তোমার profile_screen.dart থাকলে

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // HOME SCREEN UI HERE 🔥
  Widget get _homeScreen {
    return Column(
      children: [
        // 🔍 SEARCH BAR
        // 🔍 SEARCH BAR
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      context.read<ProductsProvider>().setSearchQuery(value);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.notifications, size: 28),
            ],
          ),
        ),

        // 🟢 CATEGORY SHORTCUTS
        SizedBox(
          height: 100,
          child: Consumer<ProductsProvider>(
            builder: (context, productsProvider, _) {
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, top: 12),
                children: [
                  _Category(
                    icon: Icons.class_rounded,
                    label: "All",
                    onTap: () => productsProvider.fetchProducts(),
                  ),
                  _Category(
                    icon: Icons.woman,
                    label: AppConstants.categories[0],
                    onTap: () => productsProvider.fetchProducts(
                      category: AppConstants.categories[0],
                    ),
                  ),
                  _Category(
                    icon: Icons.man,
                    label: AppConstants.categories[1],
                    onTap: () => productsProvider.fetchProducts(
                      category: AppConstants.categories[1],
                    ),
                  ),
                  _Category(
                    icon: Icons.child_care,
                    label: AppConstants.categories[2],
                    onTap: () => productsProvider.fetchProducts(
                      category: AppConstants.categories[2],
                    ),
                  ),
                  _Category(
                    icon: Icons.shopping_bag,
                    label: AppConstants.categories[3],
                    onTap: () => productsProvider.fetchProducts(
                      category: AppConstants.categories[3],
                    ),
                  ),
                  _Category(
                    icon: Icons.spa,
                    label: AppConstants.categories[4],
                    onTap: () => productsProvider.fetchProducts(
                      category: AppConstants.categories[4],
                    ),
                  ),
                  _Category(
                    icon: Icons.run_circle,
                    label: AppConstants.categories[5],
                    onTap: () => productsProvider.fetchProducts(
                      category: AppConstants.categories[5],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // 🔥 PRODUCT LIST SCREEN
        const Expanded(child: ProductsListScreen()),
      ],
    );
  }

  late final List<Widget> _screens = [
    _homeScreen, // 0 Home
    const CartScreen(), // 1 Cart ✅ add back
    const OrderHistoryScreen(), // 2 Orders
    const ProfileScreen(), // 3 Profile ✅
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddProductsScreens()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// CATEGORY ITEM WIDGET
class _Category extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Category({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade300,
              child: Icon(icon, size: 30, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
