import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_app_bar.dart';
import '../providers/home_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeProvider>().fetchExams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Exam Jyoti',
        showThemeButton: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.exams.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          Widget content;
          if (controller.error != null && controller.exams.isEmpty) {
            content = Center(child: Text('Error: ${controller.error}'));
          } else if (controller.exams.isEmpty) {
            content = const Center(child: Text('No exams found.'));
          } else {
            content = Padding(
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
                  return GestureDetector(
                    onTap: () {
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
                          Text(
                            exam.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            exam.name,
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
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchExams(),
            child: controller.exams.isEmpty
                ? Stack(
                    children: [
                      ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                      content,
                    ],
                  )
                : content,
          );
        },
      ),
    );
  }
}
