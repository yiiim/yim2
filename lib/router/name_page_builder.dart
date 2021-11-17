import 'package:flutter/material.dart';

import 'page.dart';
import 'page_param.dart';

class YimPageBuilder<T> {
  YimPageBuilder(this.pageBuilder);
  YimPage Function(BuildContext context, YimRouterPageParam<T>? params)? pageBuilder;
}

abstract class IAppNamePageBuilder {
  YimPageBuilder<T>? getNamePageBuilder<T>(String name);
}
