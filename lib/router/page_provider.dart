import 'package:flutter/material.dart';
import 'name_page_builder.dart';
import 'page_param.dart';
import 'router_page.dart';

abstract class YimRouterPageProvider {
  YimRouterPage<E> page<T, E>(BuildContext context, YimRouterPageParam<T>? params, {LocalKey? key});
}

class YimRouterNamePageProvider extends YimRouterPageProvider {
  YimRouterNamePageProvider(this.name, this.pageBuilder);
  String? name;
  IAppNamePageBuilder pageBuilder;

  @override
  YimRouterPage<E> page<T, E>(BuildContext context, YimRouterPageParam<T>? params, {LocalKey? key}) {
    if (name == null) return YimNotFoundRouterPage();
    var builder = pageBuilder.getNamePageBuilder<T>(name!);
    if (builder == null) return YimNotFoundRouterPage();
    return YimBuilderRouterPage((context) => builder.pageBuilder!(context, params), key: key ?? ValueKey(name));
  }
}
