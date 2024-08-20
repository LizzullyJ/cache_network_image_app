import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeWidget(size: size),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final String image1 =
      'https://img.freepik.com/foto-gratis/pico-montana-nevada-majestuosidad-galaxia-estrellada-ia-generativa_188544-9650.jpg';
  final String image2 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxSDeVA0yaefiC6eao_iS7YZY4pLZfGm5n5SWscJAStKaxD9QEEauG8BDjfSBKsfJcelk&usqp=CAU';

  final CacheManager cacheManager = CacheManager(Config('images_key',
      maxNrOfCacheObjects: 20, stalePeriod: const Duration(days: 3)));
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CachedNetworkImage(
              key: UniqueKey(),
              cacheKey: 'first-image',
              cacheManager: cacheManager,
              imageUrl: image1,
              width: widget.size.width,
              height: 250,
              progressIndicatorBuilder: (context, url, progress) => ColoredBox(
                color: const Color.fromARGB(255, 152, 131, 246),
                child: Center(
                  child: CircularProgressIndicator(value: progress.progress),
                ),
              ),
              // placeholder: (context, url) => ColoredBox(
              //   color: Colors.blueGrey.shade100,
              //   child: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // ),
              fit: BoxFit.cover,
              fadeInCurve: Curves.linear,
              errorWidget: (context, url, error) => ColoredBox(
                color: Colors.black26,
                child: Icon(
                  Icons.error,
                  color: Colors.red.shade700,
                  size: 50,
                ),
              ),
            ),
            // SizedBox(
            //   width: size.width,
            //   height: 250,
            //   child: ColoredBox(color: Colors.lightBlue.shade300),
            // ),
            const SizedBox(height: 15),
            CircleAvatar(
              key: UniqueKey(),
              backgroundColor: Colors.blueGrey.shade100,
              radius: 100,
              backgroundImage: CachedNetworkImageProvider(image2,
                  cacheManager: cacheManager, cacheKey: 'second-image'),
            ),
            const SizedBox(height: 15),
            FilledButton.icon(
                onPressed: clearCache,
                icon: const Icon(Icons.clear_all_sharp),
                label: const Text('Limpiar chache')),
            const SizedBox(height: 15),
            FilledButton.icon(
                onPressed: () => clearCache(index: 0),
                icon: const Icon(Icons.clear_all_sharp),
                label: const Text('Limpiar chache imagen 1')),
            const SizedBox(height: 15),
            FilledButton.icon(
                onPressed: () => clearCache(index: 1),
                icon: const Icon(Icons.clear_all_sharp),
                label: const Text('Limpiar chache imagen 2')),
          ],
        ),
      ),
    ));
  }

  void clearCache({int? index}) {
    imageCache.clear();
    imageCache.clearLiveImages();
    if (index != null) {
      cacheManager.removeFile((index == 0 ? 'first-image' : 'second-image'));
    } else {
      cacheManager.emptyCache();
    }
    // DefaultCacheManager().emptyCache();
    setState(() {});
  }
}
