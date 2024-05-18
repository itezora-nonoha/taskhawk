import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskhawk/data_service.dart';
import 'package:taskhawk/components/update_buttons.dart';
import 'package:taskhawk/repository/config_provider.dart';

final taskIDProvider = StateProvider((ref) => '');
// final choiceIndexProvider = StateProvider((ref) => '');
// final supplierList = ['A社', 'B社', 'C社'];
final supplierListProvider = StateProvider((ref) => ['blank']);
final taskDetailTitleProvider =
    StateProvider((ref) => TextEditingController(text: ''));
final taskDetailBodyProvider =
    StateProvider((ref) => TextEditingController(text: ''));
final taskDetailSupplierProvider = StateProvider((ref) => '');

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ログアウトに必要なメソッドを呼び出す
    // final authController = ref.read(authAsyncNotifierController.notifier);

    final taskID = ref.read(taskIDProvider);
    final taskTitle = ref.watch(taskDetailTitleProvider);
    final taskBody = ref.watch(taskDetailBodyProvider);

    final dataService = ref.read(dataServiceProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.lightBlue,
          actions: [
            IconButton(
                onPressed: () async {
                  // ログアウトするメソッド
                  // authController.signOutAnonymously(context);
                },
                icon: const Icon(Icons.logout))
          ],
          title: _pageTitle(taskID),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: taskTitle,
                  decoration: InputDecoration(labelText: 'Task Name'),
                  enabled: true),
              const SizedBox(height: 20.0),
              TextField(
                controller: taskBody,
                decoration: InputDecoration(labelText: 'Task Detail'),
              ),
              const SizedBox(height: 20.0),
              SupplierChoices(),
              const SizedBox(height: 20.0),
              UpdateButtons(),
              // _buttons(taskID, dataService, taskTitle, taskBody, context, ref),
              // ElevatedButton(
              //     onPressed: () async {
              //       // データを保存するメソッドを使用する。ボタンを押すと実行される
              //       dataService.updateTask(taskID, taskTitle.text, taskBody.text, 'status', 'supplier', context);
              //       // ブログの投稿ページへ画面遷移する
              //       Navigator.of(context).pop();
              //       // Navigator.of(context).push(
              //           // MaterialPageRoute(builder: (context) => const TaskBoard()));
              //     },
              //     child: const Text('更新する')),
              // const SizedBox(height: 20.0),
              // ElevatedButton(
              //     onPressed: () async {
              //       dataService.deleteTask(taskID, context);
              //       Navigator.of(context).pop();
              //     },
              //     child: const Text('削除する')),
            ],
          )),
        ));
  }
}

// void main() => runApp(MyApp());

Widget _pageTitle(String taskID) {
  if (taskID == '') {
    return Text('Add Task');
  } else {
    return Text('Task Detail');
  }
}

class SupplierChoices extends ConsumerWidget {
  const SupplierChoices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // サプライヤリストを取得
    final userConfigData = ref.watch(userConfigStreamProvider);
    List<String> supplierList = ref.watch(supplierListProvider.notifier).state;
    // ref.watch(choiceIndexProvider.notifier).state;
    // print(userConfigData);
    ref.watch(taskDetailSupplierProvider);
    // final taskTitle = ref.watch(choiceIndexProvider);
    return userConfigData.when(
      // データを読み込んでいるとローディングの処理がされる
      loading: () => const CircularProgressIndicator(),
      // エラーが発生するとエラーが表示される
      error: (error, stack) => Text('Error: $error'),
      // Streamで取得したデータが表示される
      data: (userConfigData) {
        supplierList = userConfigData[0].supplierList;
        return Wrap(spacing: 10, children: [
          for (var supplier in supplierList)
            ChoiceChip(
              labelStyle: TextStyle(color: Colors.white),
              label: Text(supplier),
              selected: ref.read(taskDetailSupplierProvider.notifier).state ==
                  supplier,
              selectedColor: Colors.lightBlue,
              backgroundColor: Colors.grey,
              onSelected: (_) {
                ref.watch(taskDetailSupplierProvider.notifier).state = supplier;
              },
              showCheckmark: false,
            )
        ]);
      },
    );
  }
}
