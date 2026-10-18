import 'package:flutter/material.dart';
import 'models.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});
  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int quantity = 1;
  String spicy = 'Sedang';
  final noteController = TextEditingController();

  @override
  void dispose() { noteController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final menu = arg is FoodMenu ? arg : menuData.first;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail menu'), actions: [
        IconButton(onPressed: () => Navigator.pushNamed(context, '/pesan'), icon: Badge(label: Text('${cart.count}'), child: const Icon(Icons.shopping_bag_outlined))),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 0, 18, 24), children: [
        ClipRRect(borderRadius: BorderRadius.circular(24), child: AspectRatio(aspectRatio: 1.25,
          child: Image.network(menu.image, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE8D9), child: const Icon(Icons.restaurant, size: 70))))),
        const SizedBox(height: 18),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(menu.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(menu.category, style: const TextStyle(color: Colors.grey)),
          ])),
          Text(rupiah(menu.price), style: const TextStyle(fontSize: 18, color: Color(0xFFE86F32), fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          Text(' ${menu.rating} • Favorit pelanggan', style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(), const Icon(Icons.check_circle, size: 17, color: Colors.green),
          const Text(' Tersedia', style: TextStyle(color: Colors.green)),
        ]),
        const SizedBox(height: 16),
        const Text('Tentang menu', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(menu.description, style: const TextStyle(height: 1.5, color: Colors.black87)),
        const SizedBox(height: 22),
        const Text('Tingkat pedas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: ['Tidak pedas', 'Sedang', 'Pedas'].map((s) =>
          ChoiceChip(label: Text(s), selected: spicy == s, onSelected: (_) => setState(() => spicy = s))).toList()),
        const SizedBox(height: 18),
        const Text('Catatan untuk penjual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(controller: noteController, maxLines: 2,
          decoration: const InputDecoration(hintText: 'Contoh: sambal dipisah, tidak pakai bawang...')),
        const SizedBox(height: 18),
        Row(children: [
          const Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          IconButton.filledTonal(onPressed: quantity > 1 ? () => setState(() => quantity--) : null, icon: const Icon(Icons.remove)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          IconButton.filledTonal(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add)),
        ]),
        const SizedBox(height: 18),
        FilledButton.icon(
          style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
          onPressed: () {
            cart.add(menu, quantity);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${menu.name} ditambahkan • Pedas: $spicy${noteController.text.isEmpty ? '' : ' • ${noteController.text}'}')));
            Navigator.pushNamed(context, '/pesan');
          },
          icon: const Icon(Icons.shopping_bag_outlined),
          label: Text('Tambah ke pesanan • ${rupiah(menu.price * quantity)}'),
        ),
      ]),
    );
  }
}
