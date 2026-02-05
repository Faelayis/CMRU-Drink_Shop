import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/menu_item.dart';
import '../product_detail/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MenuItem>> _featuredFuture;

  @override
  void initState() {
    super.initState();
    _featuredFuture = _fetchFeatured();
  }

  Future<List<MenuItem>> _fetchFeatured() async {
    final response = await Supabase.instance.client
        .from('menu_items')
        .select('id, name, price, image_url, description, is_available')
        .order('name')
        .limit(5);
    return (response as List<dynamic>)
        .map((item) => MenuItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user == null ? 'Welcome to Brewly' : 'Welcome back',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Color(0xFF4E342E),
                ),
              ),
              if (user?.email != null) ...[
                const SizedBox(height: 6),
                Text(
                  user!.email!,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Featured drinks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<MenuItem>>(
                  future: _featuredFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load featured items: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No featured items yet.',
                          style: TextStyle(
                            color: Colors.brown.withOpacity(0.6),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                                            width: 64,
                                            height: 64,
                                            color: Colors.brown.shade200,
                                            child: const Icon(
                                              Icons.local_cafe,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Image.network(
                                            item.imageUrl!,
                                            width: 64,
                                            height: 64,
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
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '฿${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Color(0xFF965A28),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
