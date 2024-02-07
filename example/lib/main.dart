import 'package:easy_purchases/easy_purchases.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  EasyPurchaser.productIds = {'product_id_1', 'product_id_2'};
    
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EasyPurchaser easyPurchases;

  @override
  void initState() {
    super.initState();

    easyPurchases = EasyPurchaser(
      onPurchaseCompleted: (purchase) {
        debugPrint('Purchased: ${purchase.productID}');
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await easyPurchases.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ElevatedButton(
              onPressed: () async {
                await easyPurchases.buyItem('product_id_1');
              },
              child: const Text('Buy product_id_1'),
            ),
            ElevatedButton(
              onPressed: () async {
                await easyPurchases.buyItem('product_id_2');
              },
              child: const Text('Buy product_id_2'),
            ),
            
          ],
        ),
      ),
    );
  }
}
