import 'dart:async';

import 'package:flutter/material.dart';
import 'page.dart';
import 'router_path.dart';
import 'user.dart';

abstract class YimRouterPage<T> extends Page<T> {
  YimRouterPage({LocalKey? key}) : super(key: key);
  final Completer pageResult = Completer();
  IYimPageRouterRole createPageVisitsRouterRole(BuildContext context);
  List<IYimRouterRole> visitsRouterRoles(BuildContext context) => createPageVisitsRouterRole(context).visitsRouterRoles(context);
}

///使用builder构造page的RouterPage
class YimBuilderRouterPage<T> extends YimRouterPage<T> {
  YimBuilderRouterPage(this.builder, {LocalKey? key}) : super(key: key);
  final YimPage Function(BuildContext) builder;
  @override
  Route<T> createRoute(BuildContext context) => MaterialPageRoute<T>(settings: this, builder: builder);

  @override
  IYimPageRouterRole createPageVisitsRouterRole(BuildContext context) => builder(context);
}

///在遇到角色权限受限是，需要跳转到指定页面获取角色的RouterPage
///获取角色的页面是指，比如如果页面是需要登录的，就是登录页面
class YimRoleGetBuilderRouterPage extends YimRouterPage<bool?> {
  YimRoleGetBuilderRouterPage(this.page, this.role, this.originalPath, this.leftRoles) : super(key: ValueKey(page));

  /// 获取角色的页面
  final YimPage page;

  /// 当页面可访问角色有多个时，除了当前角色（当前跳转的页面是为了获取该角色） 剩余的角色
  final List<IYimRouterRole> leftRoles;

  /// 当前角色
  final IYimRouterRole role;

  /// 获取角色之前最原始的路径
  final YimRouterPath originalPath;
  @override
  Route<bool?> createRoute(BuildContext context) => MaterialPageRoute<bool?>(settings: this, builder: (context) => page);

  @override
  IYimPageRouterRole createPageVisitsRouterRole(BuildContext context) => page;
}

/// 404
class YimNotFoundRouterPage<T> extends YimRouterPage<T> implements IYimPageRouterRole {
  @override
  Route<T> createRoute(BuildContext context) => MaterialPageRoute<T>(settings: this, builder: (context) => Container());

  @override
  IYimPageRouterRole createPageVisitsRouterRole(BuildContext context) => this;
}

/// 使用Page实例的RouterPage
class YimInstanceRouterPage<T> extends YimRouterPage<T> {
  YimInstanceRouterPage(this.page, {LocalKey? key}) : super(key: key);
  final YimPage page;
  @override
  Route<T> createRoute(BuildContext context) => MaterialPageRoute<T>(settings: this, builder: (BuildContext context) => page);

  @override
  YimPage createPageVisitsRouterRole(BuildContext context) => page;
}
