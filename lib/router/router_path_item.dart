import 'dart:async';

import 'package:flutter/material.dart';
import 'page.dart';
import 'name_page_builder.dart';
import 'router_path.dart';

import 'page_param.dart';
import 'page_provider.dart';
import 'router_page.dart';
import 'user.dart';

abstract class YimRouterPathItem<T, E> {
  final Completer pageResult = Completer();
  YimRouterPageParam<T>? params;
  YimRouterPage<E> page(BuildContext context);
}

/// 使用builder构造页面的路径项
class YimBuilderRouterPathItem<T, E> extends YimRouterPathItem<T, E> {
  YimBuilderRouterPathItem(this.builder);
  YimRouterPage<E> Function(BuildContext context, YimRouterPageParam<T?>? params) builder;

  @override
  YimRouterPage<E> page(BuildContext context) => builder(context, params);
}

class YimGetRoleBuilderRouterPathItem<T> extends YimRouterPathItem<T, bool?> {
  YimGetRoleBuilderRouterPathItem(this.getRolePage, this.role, this.leftRoles, this.originalPath);

  final YimPage getRolePage;

  final IYimRouterRole role;

  /// 当页面可访问角色有多个时，除了当前角色（当前跳转的页面是为了获取该角色） 剩余的角色
  final List<IYimRouterRole> leftRoles;

  /// 获取角色之前最原始的路径
  final YimRouterPath originalPath;

  @override
  YimRouterPage<bool?> page(BuildContext context) => YimRoleGetBuilderRouterPage(getRolePage, role, originalPath, leftRoles);
}

/// 使用Name构造页面的路径项
class YimRouterNamePathItem<T, E> extends YimRouterPathItem<T, E> {
  YimRouterNamePathItem(this.routerName, this.pageBuilder);
  final String routerName;
  final IAppNamePageBuilder pageBuilder;
  @override
  bool operator ==(Object other) {
    return other is YimRouterNamePathItem<T, E> && other.routerName == routerName && params == params;
  }

  @override
  YimRouterPage<E> page(BuildContext context) {
    return YimRouterNamePageProvider(routerName, pageBuilder).page<T, E>(context, params, key: ValueKey(this));
  }

  @override
  int get hashCode => super.hashCode;
}
