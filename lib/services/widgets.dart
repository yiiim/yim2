import 'package:flutter/material.dart';
import 'package:yim2/services/collection.dart';

import 'provider.dart';

class YimServiceServiceContext {
  YimServiceServiceContext(this.serviceCollection) : defaultProvider = serviceCollection.builderProvier();
  IYimServiceCollection serviceCollection;
  YimServiceProvider defaultProvider;

  static YimServiceServiceContext? contextOf(BuildContext context) {
    _YimServiceContextInheritedWidget? widget = context.dependOnInheritedWidgetOfExactType<_YimServiceContextInheritedWidget>();
    return widget?.serviceContext;
  }

  T? getService<T>() {}
}

class YimServiceWidget extends StatelessWidget {
  const YimServiceWidget(this.child, this.serviceCollection, {Key? key}) : super(key: key);
  final Widget child;
  final IYimServiceCollection serviceCollection;
  @override
  Widget build(BuildContext context) {
    return _YimServiceContextInheritedWidget(YimServiceServiceContext(serviceCollection), child: child);
  }
}

class YimScopeServiceBuilder extends StatelessWidget {
  const YimScopeServiceBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context, YimServiceProvider? provider) builder;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        _YimScopeInheritedWidget? widget = context.dependOnInheritedWidgetOfExactType<_YimScopeInheritedWidget>();
        return builder(context, widget?.scopeProvider);
      },
    );
  }
}

class YimScopeServiceWidget extends StatelessWidget {
  const YimScopeServiceWidget(this.child, {Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return _YimScopeInheritedWidget(YimServiceServiceContext.contextOf(context)!.serviceCollection.builderScopeProvier(), child: child);
  }
}

class _YimServiceContextInheritedWidget extends InheritedWidget {
  const _YimServiceContextInheritedWidget(this.serviceContext, {Key? key, required Widget child}) : super(key: key, child: child);
  final YimServiceServiceContext serviceContext;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class _YimScopeInheritedWidget extends InheritedWidget {
  const _YimScopeInheritedWidget(this.scopeProvider, {Key? key, required Widget child}) : super(key: key, child: child);
  final YimServiceProvider scopeProvider;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
