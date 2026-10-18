import 'package:flutter/material.dart';
import 'models.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});
  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final searchController = TextEditingController();
  String category = 'Semua';
  String query = '';

  @override
  void dispose() { searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final filtered = menuData.where((m) {
      final matchCategory = category == 'Semua' || m.category == category;
      return matchCategory && m.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          CircleAvatar(backgroundColor: Color(0xFFFFE4D4),
            child: Icon(Icons.restaurant, color: Color(0xFFE86F32))),
          SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Kantin Bu Sari', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            Text('Masakan enak, harga bersahabat', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ]),
        ]),
        actions: [
          IconButton(
            tooltip: 'Lihat pesanan',
            onPressed: () => Navigator.pushNamed(context, '/pesan'),
            icon: Badge(label: Text('${cart.count}'), child: const Icon(Icons.shopping_bag_outlined)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(colors: [Color(0xFFE86F32), Color(0xFFF5A05F)]),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('LAPAR? WAKTUNYA MAKAN!', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              SizedBox(height: 8),
              Text('Menu rumahan,\\nrasa juara.', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('Dimasak hangat setiap hari oleh Bu Sari.', style: TextStyle(color: Colors.white, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            onChanged: (v) => setState(() => query = v),
            decoration: const InputDecoration(
              hintText: 'Cari makanan atau minuman...',
              prefixIcon: Icon(Icons.search), suffixIcon: Icon(Icons.tune),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Pilih kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, children: ['Semua', 'Makanan', 'Minuman'].map((c) =>
            ChoiceChip(label: Text(c), selected: category == c,
              onSelected: (_) => setState(() => category = c),
            )).toList()),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Menu favorit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('${filtered.length} menu', style: const TextStyle(color: Colors.grey)),
          ]),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Padding(padding: EdgeInsets.all(28), child: Column(children: [
              Icon(Icons.search_off, size: 42, color: Colors.grey),
              SizedBox(height: 8), Text('Menu tidak ditemukan'),
            ]))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: .64,
              ),
              itemBuilder: (context, index) {
                final menu = filtered[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.pushNamed(context, '/detail', arguments: menu),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFF0E7E0))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Stack(fit: StackFit.expand, children: [
                        Image.network(menu.image, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFE8D9), child: const Icon(Icons.restaurant, size: 42))),
                        Positioned(top: 8, right: 8, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: Row(children: [const Icon(Icons.star, size: 13, color: Colors.amber), Text(' ${menu.rating}')]),
                        )),
                      ])),
                      Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), child: Text(menu.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      Padding(padding: const EdgeInsets.fromLTRB(10, 5, 10, 8), child: Text(rupiah(menu.price),
                        style: const TextStyle(color: Color(0xFFE86F32), fontWeight: FontWeight.w800))),
                      Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 8), child: SizedBox(width: double.infinity,
                        child: FilledButton.tonalIcon(
                          onPressed: () { cart.add(menu); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${menu.name} ditambahkan ke pesanan'))); },
                          icon: const Icon(Icons.add, size: 17), label: const Text('Tambah'),
                        ))),
                    ]),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          Card(color: const Color(0xFFFFF0E6), elevation: 0, child: const ListTile(
            leading: Icon(Icons.access_time, color: Color(0xFFE86F32)),
            title: Text('Jam operasional', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Senin–Sabtu • 07.00–16.00 WIB'),
          )),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) { if (i == 1) Navigator.pushNamed(context, '/pesan'); },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
        ],
      ),
    );
  }
}
