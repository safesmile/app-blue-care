import 'package:flutter/material.dart';

import '../../../core/presentation/page_widgets.dart';
import '../data/demo_meds_store.dart';

class MedsCatalogScreen extends StatefulWidget {
  const MedsCatalogScreen({super.key});

  @override
  State<MedsCatalogScreen> createState() => _MedsCatalogScreenState();
}

class _MedsCatalogScreenState extends State<MedsCatalogScreen> {
  final cart = <MedsProduct, int>{};

  void changeQuantity(MedsProduct product, int change) {
    setState(() {
      final quantity = (cart[product] ?? 0) + change;
      if (quantity <= 0) {
        cart.remove(product);
      } else {
        cart[product] = quantity;
      }
    });
  }

  Future<void> checkout() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CheckoutDialog(items: Map.unmodifiable(cart)),
    );
    if (!mounted || created != true) return;
    setState(cart.clear);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pedido de prueba guardado.')));
  }

  void showOrders() {
    final orders = DemoMedsStore.readOrders();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedidos de prueba'),
        scrollable: true,
        content: FutureBuilder(
          future: orders,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('No pudimos cargar tus pedidos.');
            }
            final savedOrders = snapshot.data;
            if (savedOrders == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (savedOrders.isEmpty) {
              return const Text('Todavía no tienes pedidos de prueba.');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final order in savedOrders) _OrderSummary(order: order),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = cart.values.fold(
      0,
      (total, quantity) => total + quantity,
    );

    return PageFrame(
      children: [
        if (Navigator.of(context).canPop())
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ),
        const PageHeading('Blue Care Meds'),
        const PageBody(
          'Catálogo de demostración. Puedes probar un pedido como invitado.',
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          'Ver carrito ($itemCount) · Q${DemoMedsStore.orderTotal(cart)}',
          cart.isEmpty ? null : checkout,
        ),
        LinkButton('Ver pedidos de prueba', showOrders),
        const SizedBox(height: 12),
        for (final product in MedsProduct.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FeatureCard(
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(product.description),
                const SizedBox(height: 8),
                Text('Q${product.price}'),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    if (cart.containsKey(product)) ...[
                      IconButton(
                        tooltip: 'Quitar ${product.title}',
                        onPressed: () => changeQuantity(product, -1),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${cart[product]} en el carrito'),
                    ],
                    OutlinedButton(
                      key: ValueKey(product),
                      onPressed: () => changeQuantity(product, 1),
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CheckoutDialog extends StatefulWidget {
  const _CheckoutDialog({required this.items});

  final Map<MedsProduct, int> items;

  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  bool saving = false;
  String? error;

  Future<void> createOrder() async {
    if (saving) return;
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await DemoMedsStore.createOrder(widget.items);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        saving = false;
        error = 'No pudimos guardar el pedido. Intenta de nuevo.';
      });
      return;
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !saving,
    child: AlertDialog(
      title: const Text('Revisar carrito'),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in widget.items.entries)
            Text('${item.value} × ${item.key.title}'),
          const SizedBox(height: 12),
          Text('Total de prueba Q${DemoMedsStore.orderTotal(widget.items)}'),
          const SizedBox(height: 12),
          const Text('El pedido se guardará en este dispositivo como prueba.'),
          if (error case final message?)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('Volver al catálogo'),
        ),
        PrimaryButton('Crear pedido de prueba', createOrder, busy: saving),
      ],
    ),
  );
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});

  final DemoMedsOrder order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in order.items) Text(item),
          Text('Total de prueba Q${order.total}'),
        ],
      ),
    );
  }
}
