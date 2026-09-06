import 'package:cached_network_image/cached_network_image.dart';
import 'package:exam_jyoti/core/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../core/widgets/banner_ad_widget.dart';
import '../core/widgets/network_refresh_wrapper.dart';
import '../core/widgets/refreshable_data_view.dart';
import '../providers/home_provider.dart';
import '../providers/quiz_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _baseUrl = AppConfig.baseUrl;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeProvider>().fetchExams());
  }

  String? _getImageUrl(String? image) {
    if (image == null || image.isEmpty) {
      return null;
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }

    return '$_baseUrl$image';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppConfig.appName, showThemeButton: true),
      body: NetworkRefreshWrapper(
        onInternetRestored: () async {
          await context.read<HomeProvider>().fetchExams();
        },
        child: Consumer<HomeProvider>(
          builder: (context, controller, child) {
            return RefreshableDataView(
              isLoading: controller.isLoading,
              isEmpty: controller.exams.isEmpty,
              error: controller.error,
              emptyMessage: 'No exams found.',
              onRefresh: () => controller.fetchExams(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: controller.exams.length,
                  itemBuilder: (context, index) {
                    final exam = controller.exams[index];
                    final imageUrl = _getImageUrl(exam.image);

                    return GestureDetector(
                      onTap: () {
                        context.read<QuizProvider>().setExam(exam.id);
                        context.push('/subjects/${exam.id}');
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return const SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return const Icon(
                                      Icons.school_outlined,
                                      size: 60,
                                    );
                                  },
                                ),
                              )
                            else const Icon(Icons.school_outlined, size: 60),
                            const SizedBox(height: 10),
                            Text(
                              exam.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const Material(
        elevation: 8,
        child: SafeArea(child: BannerAdWidget()),
      ),
    );
  }
}
