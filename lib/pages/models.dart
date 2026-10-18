import 'package:flutter/foundation.dart';

class FoodMenu {
  final String id, name, category, description, image;
  final int price;
  final double rating;
  const FoodMenu({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    this.rating = 4.8,
  });
}

const menuData = <FoodMenu>[
  FoodMenu(
    id: 'm1',
    name: 'Ayam Geprek',
    category: 'Makanan',
    price: 15000,
    rating: 4.9,
    image: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=900',
    description:
        'Ayam crispy dengan sambal pilihan, nasi hangat, dan lalapan segar. Favorit pelanggan Kantin Bu Sari.',
  ),
  FoodMenu(
    id: 'm2',
    name: 'Nasi Ayam Bakar',
    category: 'Makanan',
    price: 18000,
    image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=900',
    description:
        'Ayam bakar berbumbu meresap disajikan dengan nasi hangat dan sambal khas.',
  ),
  FoodMenu(
    id: 'm3',
    name: 'Mie Goreng Spesial',
    category: 'Makanan',
    price: 13000,
    image: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=900',
    description:
        'Mie goreng gurih dengan sayuran, telur, dan taburan bawang goreng.',
  ),
  FoodMenu(
    id: 'm4',
    name: 'Nasi Telur Crispy',
    category: 'Makanan',
    price: 12000,
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    description: 'Telur renyah dengan nasi pulen dan saus spesial rumahan.',
  ),
  FoodMenu(
    id: 'd1',
    name: 'Es Teh Manis',
    category: 'Minuman',
    price: 5000,
    image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=900',
    description: 'Teh pilihan yang disajikan dingin dan menyegarkan.',
  ),
  FoodMenu(
    id: 'd2',
    name: 'Es Jeruk',
    category: 'Minuman',
    price: 7000,
    image: 'https://images.unsplash.com/photo-1513558161293-cda7650816fd?w=900',
    description: 'Minuman jeruk segar dengan rasa manis dan asam seimbang.',
  ),
];

String rupiah(int value) =>
    'Rp${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

class CartLine {
  final FoodMenu menu;
  int quantity;
  CartLine(this.menu, this.quantity);
}

class CartModel extends ChangeNotifier {
  final Map<String, CartLine> _items = {};
  List<CartLine> get items => _items.values.toList();
  int get count => _items.values.fold(0, (sum, line) => sum + line.quantity);
  int get total => _items.values.fold(
    0,
    (sum, line) => sum + line.menu.price * line.quantity,
  );

  void add(FoodMenu menu, [int quantity = 1]) {
    if (_items.containsKey(menu.id)) {
      _items[menu.id]!.quantity += quantity;
    } else {
      _items[menu.id] = CartLine(menu, quantity);
    }
    notifyListeners();
  }

  void changeQuantity(String id, int delta) {
    final line = _items[id];
    if (line == null) return;
    line.quantity += delta;
    if (line.quantity <= 0) _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final cart = CartModel();
