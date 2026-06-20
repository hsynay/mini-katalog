class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description; // Ürün detay sayfasında gösterilecek açıklama metni
  //Sepetteki ürünleri hafızada tutan global liste
  static List<Product> cartItems = [];

  Product({
    required this.id, 
    required this.title, 
    required this.price, 
    required this.image,
    required this.description,
  });

  // API'den gelen karmaşık JSON verisini Product nesnesine dönüştüren metod
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(), 
      image: json['image'],
      // Sunucudan açıklama verisinin gelmeme ihtimaline karşı null kontrolü (??) sağlandı
      description: json['description'] ?? 'Bu ürün için henüz bir açıklama girilmemiştir.', 
    );
  }
}