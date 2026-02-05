import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/login/login_screen.dart';
import '../../models/order_record.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<OrderRecord>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<OrderRecord>> _fetchOrders() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return [];
    }

    final response = await Supabase.instance.client
        .from('orders')
        .select('id, status, total_amount, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return (response as List<dynamic>)
        .map((item) => OrderRecord.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
    await _ordersFuture;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Text(
                "ORDER",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Color(0xFF4E342E),
                ),
              ),
            ),
            Expanded(
              child: user == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 72,
                              color: Colors.brown.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Please sign in to see your orders.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF965A28),
                              ),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : FutureBuilder<List<OrderRecord>>(
                      future: _ordersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to load orders: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final orders = snapshot.data ?? [];
                        if (orders.isEmpty) {
                          return ListView(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.inbox,
                                        size: 72,
                                        color: Colors.brown.withOpacity(0.2),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "No orders yet",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEADCC6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.receipt_long,
                                      color: Color(0xFF965A28),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order #${order.id}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Status: ${order.status}',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '฿${order.totalAmount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (order.createdAt != null)
                                          Text(
                                            '${order.createdAt!.toLocal()}'
                                                .split('.')
                                                .first,
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
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
    );
  }
}
