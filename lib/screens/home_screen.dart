import 'package:flutter/material.dart';
import 'dart:convert'; // Sadece yerel JSON simülasyonu için kaldı
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  // Yönergedeki "JSON simülasyonu" kuralı için dışarıdan değil, içeriden veri oluşturduk
  final String _dummyJsonData = '''
  [
    {"id": 1, "title": "AirPods Pro", "price": 5499.00, "image": "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500", "description": "Harika bir kulaklık deneyimi."},
    {"id": 2, "title": "MacBook Pro", "price": 45000.00, "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500", "description": "M3 işlemcili üstün performans."},
    {"id": 3, "title": "Akıllı Saat", "price": 2100.50, "image": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500", "description": "Sağlığınızı her an takip edin."},
    {"id": 4, "title": "Oyuncu Kulaklığı", "price": 1250.00, "image": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500", "description": "Oyunlarda ses kasmak için ideal."}
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _loadSimulatedData();
  }

  // Json metnini Listeye çeviren simülasyon fonksiyonu
  void _loadSimulatedData() {
    List jsonResponse = json.decode(_dummyJsonData);
    _allProducts = jsonResponse.map((data) => Product.fromJson(data)).toList();
    _filteredProducts = _allProducts; // Başlangıçta tüm ürünleri göster
  }

  // Yönergede istenen: Basit arama ve filtreleme mantığı
  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF2F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Good morning 👋', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text('Alex Johnson', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart'), // Named Route Kullanımı
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arama Çubuğu (Artık çalışıyor!)
          Container(
            color: const Color(0xFF2B2D42),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              onChanged: _filterProducts, // Metin değiştikçe filtreyi tetikler
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF3F4259),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // Yönergede istenen: Image.asset Kullanımı
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/banner.jpg', 
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Text('Görsel Bulunamadı!')),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Featured Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          // Filtrelenmiş Liste Gösterimi
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return _buildProductCard(context, _filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        // YÖNERGEDE İSTENEN: Route Arguments Kullanımı (pushNamed ile veri gönderme)
        Navigator.pushNamed(
          context, 
          '/detail', 
          arguments: product, 
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(child: Image.network(product.image, fit: BoxFit.contain)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('\$${product.price}', style: const TextStyle(color: Color(0xFF2B2D42), fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}