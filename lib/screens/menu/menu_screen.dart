import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/menu_item.dart';
import '../product_detail/product_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<MenuItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchMenuItems();
  }

  Future<List<MenuItem>> _fetchMenuItems() async {
    final response = await Supabase.instance.client
        .from('menu_items')
        .select('id, name, price, image_url, description, is_available')
        .order('name');
    final items = (response as List<dynamic>)
        .map((item) => MenuItem.fromMap(item as Map<String, dynamic>))
        .toList();
    return items;
  }

  Future<void> _refresh() async {
    setState(() {
      _itemsFuture = _fetchMenuItems();
    });
    await _itemsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "MENU",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Color(0xFF4E342E),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<MenuItem>>(
                  future: _itemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load menu: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: 80,
                              color: Colors.brown.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No menu items",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.brown.withOpacity(0.5),
                                fontFamily: 'Serif',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Material(
                            color: const Color(0xFFEADCC6),
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(item: item),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          item.imageUrl == null ||
                                              item.imageUrl!.isEmpty
                                          ? Container(
                                              width: 72,
                                              height: 72,
                                              color: Colors.brown.shade200,
                                              child: const Icon(
                                                Icons.local_cafe,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                            )
                                          : Image.network(
                                              item.imageUrl!,
                                              width: 72,
                                              height: 72,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item.description?.isNotEmpty == true
                                                ? item.description!
                                                : 'No description',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '฿${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.isAvailable
                                              ? 'Available'
                                              : 'Sold out',
                                          style: TextStyle(
                                            color: item.isAvailable
                                                ? Colors.green.shade700
                                                : Colors.red.shade400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
