import 'package:flutter/material.dart';
import 'page.dart';

import 'page_param.dart';

/// 路由角色
abstract class IYimRouterRole {
  /// 是否有获取这个角色的页面
  bool get hasGetRolePage;

  /// 指定角色是否通过
  bool challengeUser(IYimRouterUser user);

  /// 获取角色的页面
  YimPage? toGetRolePage<T>(BuildContext context, IYimRouterUser user, YimRouterPageParam<T?>? params);
}

class YimRouterMultipleRole extends IYimRouterRole {
  YimRouterMultipleRole(this.roles);
  final List<IYimRouterRole> roles;

  @override
  bool challengeUser(IYimRouterUser user) {
    for (var item in roles) {
      if (!item.challengeUser(user)) return false;
    }
    return true;
  }

  @override
  bool get hasGetRolePage => roles.any((element) => element.hasGetRolePage);

  @override
  YimPage? toGetRolePage<T>(BuildContext context, IYimRouterUser user, YimRouterPageParam<T?>? params) {
    for (var item in roles) {
      if (!item.challengeUser(user)) return item.toGetRolePage(context, user, params);
    }
  }
}

/// 匿名角色
class YimRouterRoleAnonymous extends IYimRouterRole {
  @override
  bool challengeUser(IYimRouterUser user) => true;

  @override
  YimPage? toGetRolePage<T>(BuildContext context, IYimRouterUser user, YimRouterPageParam<T?>? params) => null;

  @override
  bool get hasGetRolePage => false;
}

/// 路由用户
abstract class IYimRouterUser<T extends IYimRouterRole> with ChangeNotifier {
  List<T> get roles;
}
