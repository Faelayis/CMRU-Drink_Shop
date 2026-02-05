import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/menu_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final MenuItem item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isSubmitting = false;

  Future<void> _placeOrder() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to place an order.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Supabase.instance.client.from('orders').insert({
        'user_id': user.id,
        'status': 'pending',
        'total_amount': widget.item.price,
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order created.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place order: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: const Color(0xFFF3E9D9),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: item.imageUrl == null || item.imageUrl!.isEmpty
                      ? Container(
                          width: 220,
                          height: 220,
                          color: Colors.brown.shade200,
                          child: const Icon(
                            Icons.local_cafe,
                            color: Colors.white,
                            size: 64,
                          ),
                        )
                      : Image.network(
                          item.imageUrl!,
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '฿${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF965A28),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.description?.isNotEmpty == true
                    ? item.description!
                    : 'No description provided.',
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: item.isAvailable && !_isSubmitting
                      ? _placeOrder
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF965A28),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          item.isAvailable ? 'Place Order' : 'Unavailable',
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
