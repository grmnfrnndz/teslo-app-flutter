import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {

          context.push('/product/new');

        },
      ),
    );
  }
}


class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ConsumerState<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<_ProductsView> {

  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    loadNextPage();

    scrollController.addListener(() {

        if (scrollController.position.pixels + 500 >= scrollController.position.maxScrollExtent) {
          loadNextPage();
        }

     });
    

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  loadNextPage() {

   Future(() {
      ref.read(productsProvider.notifier).loadNextPage();
    });

  }


  @override
  Widget build(BuildContext context) {

    final productsState = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 2, 
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];

          return GestureDetector(
            onTap: () {
              context.push('/product/${product.id}');
            },
            child: ProductCard(product: product,)
          );
        },),
    
    );
  }
}