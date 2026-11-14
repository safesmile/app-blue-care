import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum MedsProduct {
  toothbrush(
    'Cepillo dental suave',
    'Cerdas suaves para el cuidado diario.',
    28,
  ),
  floss('Hilo dental', 'Rollo de hilo dental encerado de 50 m.', 22),
  toothpaste('Pasta dental', 'Tubo de pasta dental de 90 g.', 35);

  const MedsProduct(this.title, this.description, this.price);

  final String title;
  final String description;
  final int price;
}

class DemoMedsOrder {
  const DemoMedsOrder({required this.items, required this.total});

  final List<String> items;
  final int total;

  factory DemoMedsOrder.decode(String order) {
    final data = jsonDecode(order) as Map<String, dynamic>;
    return DemoMedsOrder(
      items: List<String>.from(data['items'] as List),
      total: data['total'] as int,
    );
  }

  String encode() => jsonEncode({'items': items, 'total': total});
}

class DemoMedsStore {
  static const ordersKey = 'meds.demo.orders';

  static Future<List<DemoMedsOrder>> readOrders() async {
    final preferences = await SharedPreferences.getInstance();
    final orders = preferences.getStringList(ordersKey) ?? [];
    return orders.map(DemoMedsOrder.decode).toList();
  }

  static Future<void> createOrder(Map<MedsProduct, int> items) async {
    final preferences = await SharedPreferences.getInstance();
    final orders = preferences.getStringList(ordersKey) ?? [];
    final order = DemoMedsOrder(
      items: [
        for (final item in items.entries) '${item.value} × ${item.key.title}',
      ],
      total: orderTotal(items),
    );
    if (!await preferences.setStringList(ordersKey, [
      order.encode(),
      ...orders,
    ])) {
      // Discard the optimistic preference value after a failed write.
      await preferences.reload();
      throw StateError('Could not save the demo order.');
    }
  }

  static int orderTotal(Map<MedsProduct, int> items) => items.entries.fold(
    0,
    (total, item) => total + item.key.price * item.value,
  );
}
