import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:practices/providers/products_provider.dart';
import 'package:practices/utils/constants.dart';
import 'products_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 TOP SEARCH BAR
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search products...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 10),
                  ),

                  // ✅ এইটা যোগ করলেই search কাজ করবে
                  onChanged: (value) {
                    context.read<ProductsProvider>().setSearchQuery(value);
                  },
                ),
              ),
              const SizedBox(width: 10),
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
                padding: const EdgeInsets.all(10),
                children: [
                  _CategoryItem(
                    icon: Icons.class_rounded,
                    label: "All",
                    onTap: () {
                      // ✅ All = category null + (optional) search clear
                      productsProvider.setCategory('');
                      // চাইলে search clear করতে পারো:
                      // _searchController.clear();
                      // productsProvider.setSearchQuery('');
                      productsProvider.fetchProducts();
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.woman,
                    label: AppConstants.categories[0],
                    onTap: () {
                      productsProvider.setCategory(AppConstants.categories[0]);
                      productsProvider.fetchProducts(
                        category: AppConstants.categories[0],
                      );
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.man,
                    label: AppConstants.categories[1],
                    onTap: () {
                      productsProvider.setCategory(AppConstants.categories[1]);
                      productsProvider.fetchProducts(
                        category: AppConstants.categories[1],
                      );
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.child_care,
                    label: AppConstants.categories[2],
                    onTap: () {
                      productsProvider.setCategory(AppConstants.categories[2]);
                      productsProvider.fetchProducts(
                        category: AppConstants.categories[2],
                      );
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.shopping_bag,
                    label: AppConstants.categories[3],
                    onTap: () {
                      productsProvider.setCategory(AppConstants.categories[3]);
                      productsProvider.fetchProducts(
                        category: AppConstants.categories[3],
                      );
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.spa,
                    label: AppConstants.categories[4],
                    onTap: () {
                      productsProvider.setCategory(AppConstants.categories[4]);
                      productsProvider.fetchProducts(
                        category: AppConstants.categories[4],
                      );
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.home,
                    label: AppConstants.categories[5],
                    onTap: () {
                      productsProvider.setCategory(AppConstants.categories[5]);
                      productsProvider.fetchProducts(
                        category: AppConstants.categories[5],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),

        // 🔥 Main Products List Screen
        const Expanded(child: ProductsListScreen()),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryItem({
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
            Text(label),
          ],
        ),
      ),
    );
  }
}
