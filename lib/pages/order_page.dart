import 'package:flutter/material.dart';
import 'models.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String payment = 'Tunai';
  String pickup = 'Makan di tempat';
  final nameController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() { nameController.dispose(); noteController.dispose(); super.dispose(); }

  void confirmOrder() {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan masih kosong. Pilih menu terlebih dahulu.')));
      return;
    }
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nama pemesan terlebih dahulu.')));
      return;
    }
    final total = rupiah(cart.total);
    final count = cart.count;
    showDialog(context: context, builder: (context) => AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
      title: const Text('Pesanan berhasil dibuat!'),
      content: Text('Terima kasih, ${nameController.text.trim()}!\\n$count item • $total\\nPembayaran: $payment\\n${pickup}.'),
      actions: [FilledButton(onPressed: () {
        cart.clear();
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }, child: const Text('Selesai'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan saya')),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) => ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 28), children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFFFFE8D9), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.receipt_long, color: Color(0xFFE86F32))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ringkasan pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${cart.count} item dalam pesanan', style: const TextStyle(color: Colors.black54)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('Menu yang dipilih', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (cart.items.isEmpty)
            Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
              const Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 8), const Text('Keranjang masih kosong', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4), const Text('Yuk, pilih menu favoritmu dulu!'),
              const SizedBox(height: 12), FilledButton.tonal(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false), child: const Text('Lihat menu')),
            ])))
          else
            ...cart.items.map((line) => Card(
              elevation: 0, color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFF0E7E0))),
              child: Padding(padding: const EdgeInsets.all(10), child: Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(line.menu.image, width: 72, height: 72, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: const Color(0xFFFFE8D9), child: const Icon(Icons.restaurant)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(line.menu.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4), Text(rupiah(line.menu.price), style: const TextStyle(color: Color(0xFFE86F32))),
                  Row(children: [
                    IconButton(visualDensity: VisualDensity.compact, onPressed: () => cart.changeQuantity(line.menu.id, -1), icon: const Icon(Icons.remove_circle_outline)),
                    Text('${line.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(visualDensity: VisualDensity.compact, onPressed: () => cart.changeQuantity(line.menu.id, 1), icon: const Icon(Icons.add_circle_outline)),
                  ]),
                ])),
                Text(rupiah(line.menu.price * line.quantity), style: const TextStyle(fontWeight: FontWeight.bold)),
              ])),
            )),
          const SizedBox(height: 18),
          const Text('Informasi pemesan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: nameController, textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Nama pemesan', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 12),
          const Text('Metode pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(contentPadding: EdgeInsets.zero, value: 'Tunai', groupValue: payment, title: const Text('Tunai di kasir'), secondary: const Icon(Icons.payments_outlined), onChanged: (v) => setState(() => payment = v!)),
          RadioListTile<String>(contentPadding: EdgeInsets.zero, value: 'QRIS', groupValue: payment, title: const Text('QRIS'), secondary: const Icon(Icons.qr_code_2), onChanged: (v) => setState(() => payment = v!)),
          const SizedBox(height: 8),
          const Text('Cara menikmati pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Makan di tempat', label: Text('Di tempat'), icon: Icon(Icons.restaurant)),
              ButtonSegment(value: 'Bungkus', label: Text('Bungkus'), icon: Icon(Icons.takeout_dining)),
            ],
            selected: {pickup}, onSelectionChanged: (v) => setState(() => pickup = v.first),
          ),
          const SizedBox(height: 12),
          TextField(controller: noteController, maxLines: 2, decoration: const InputDecoration(labelText: 'Catatan pesanan (opsional)', hintText: 'Contoh: tanpa sendok plastik', prefixIcon: Icon(Icons.edit_note))),
          const SizedBox(height: 18),
          Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text(rupiah(cart.total))]),
            const SizedBox(height: 8),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Biaya layanan'), Text('Rp0')]),
            const Divider(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(rupiah(cart.total), style: const TextStyle(color: Color(0xFFE86F32), fontWeight: FontWeight.w900, fontSize: 20)),
            ]),
          ]))),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: confirmOrder,
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Konfirmasi pesanan'),
          ),
          const SizedBox(height: 8),
          const Center(child: Text('Pesanan diproses setelah dikonfirmasi di aplikasi', style: TextStyle(fontSize: 11, color: Colors.grey))),
        ]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) { if (i == 0) Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false); },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
        ],
      ),
    );
  }
}
