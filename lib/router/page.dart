import 'package:flutter/material.dart';

import 'user.dart';

///页面路由角色
abstract class IYimPageRouterRole {
  ///允许访问页面的角色
  List<IYimRouterRole> visitsRouterRoles(BuildContext context);
}

///页面
abstract class YimPage implements Widget, IYimPageRouterRole {}

class EmptyYimPage extends StatelessWidget implements YimPage {
  @override
  Widget build(BuildContext context) => Container(color: Colors.red);

  @override
  List<IYimRouterRole> visitsRouterRoles(BuildContext context) => [YimRouterRoleAnonymous()];
}
