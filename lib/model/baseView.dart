import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

import 'app_model.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final Function(T) onModelReady;
  BaseView({@required this.builder, this.onModelReady});
  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}
class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T model = locator<T>();
  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}


GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(()=>UserModel());
  locator.registerLazySingleton(() => ProjectModel());
  //locator.registerLazySingleton(() => Api());
}
