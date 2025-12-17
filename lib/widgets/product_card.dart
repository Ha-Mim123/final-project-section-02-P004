// import 'package:flutter/material.dart';
// import '../models/product.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback onCartTap;
//   final VoidCallback onTap;

//   const ProductCard({
//     super.key,
//     required this.product,
//     required this.onCartTap,
//     required this.onTap,
//   });

//   bool get isOutOfStock => product.stock <= 0;

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: isOutOfStock ? 0.55 : 1,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//             )
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: onTap,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Image.network(
//                       product.imageUrl,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       errorBuilder: (ctx, _, __) => Container(
//                         color: Colors.grey[200],
//                         child: const Center(
//                           child: Icon(Icons.image, color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           product.name,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),

//                         const SizedBox(height: 6),

//                         Text(
//                           isOutOfStock
//                               ? 'No product available'
//                               : 'Available: ${product.stock}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: isOutOfStock ? Colors.red : Colors.grey[700],
//                             fontWeight:
//                                 isOutOfStock ? FontWeight.w700 : FontWeight.w500,
//                           ),
//                         ),

//                         const SizedBox(height: 6),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "৳ ${product.price}",
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                               ),
//                             ),

//                             Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(20),
//                                 onTap: isOutOfStock ? null : onCartTap,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[100],
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     Icons.add_shopping_cart,
//                                     size: 20,
//                                     color: isOutOfStock
//                                         ? Colors.grey
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onCartTap;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onCartTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.stock <= 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ IMAGE + STOCK BADGE (Stack)
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, __) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),

                      // ✅ Stock badge (top-left)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Chip(
                          label: Text(
                            isOutOfStock
                                ? 'No product available'
                                : 'Available: ${product.stock}',
                            style: TextStyle(
                              color: isOutOfStock ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor:
                              (isOutOfStock ? Colors.red : Colors.white)
                                  .withOpacity(0.85),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(
                            color: isOutOfStock
                                ? Colors.red.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),

                      // ✅ Optional: out of stock overlay
                      if (isOutOfStock)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.25),
                            alignment: Alignment.center,
                            child: const Text(
                              'OUT OF STOCK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ✅ INFO SECTION
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "৳ ${product.price}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          // ✅ Cart button (disabled if stock 0)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: isOutOfStock ? null : onCartTap,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  size: 20,
                                  color: isOutOfStock
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
