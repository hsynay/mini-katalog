import 'package:flutter/material.dart';
import '../models/product.dart'; // cartItems listesine ulaşmak için

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

// Sayfa içinde ürün sildiğimizde anında güncellenmesi için StatefulWidget kullandık
class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('< Back', style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      
      // EĞER SEPET BOŞSA BOŞ EKRANI, DOLUYSA LİSTEYİ GÖSTEREN YAPI (State Simülasyonu)
      body: Product.cartItems.isEmpty 
          ? _buildEmptyCart() 
          : _buildCartList(),
          
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              if (Product.cartItems.isNotEmpty) {
                // Checkout (Satın Al) yapıldığında sepeti temizle ve ekranı yenile
                setState(() {
                  Product.cartItems.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sipariş başarıyla oluşturuldu!')),
                );
              } else {
                Navigator.pop(context);
              }
            },
            // Sepet durumuna göre buton yazısını değiştiriyoruz
            child: Text(Product.cartItems.isEmpty ? 'Go back to shopping' : 'Checkout', style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  // BOŞ SEPET TASARIMI
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text('Your cart is empty', style: TextStyle(fontSize: 20, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // DOLU SEPET (LİSTE) TASARIMI
  Widget _buildCartList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: Product.cartItems.length,
      itemBuilder: (context, index) {
        final item = Product.cartItems[index];
        return ListTile(
          leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.contain),
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('\$${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () {
              // Çöp kutusuna basıldığında o ürünü listeden sil ve ekranı anında yenile
              setState(() {
                Product.cartItems.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
}