import 'package:flutter/material.dart';
import 'package:yim2/services/collection.dart';
import 'package:yim2/services/descriptor.dart';

abstract class YimServiceProvider {
  T? getService<T>();
}

class YimDefaultServiceProvider extends YimServiceProvider {
  YimDefaultServiceProvider(this.serviceCollection);
  final IYimServiceCollection serviceCollection;
  @override
  T? getService<T>() {
    for (var item in serviceCollection.services) {
      if (item.serviceType.runtimeType == YimServiceTypeDescriptor<T>().runtimeType) {
        if (item.lifetime == YimServiceLifetime.singleton || item.lifetime == YimServiceLifetime.scoped) {
          item.instance ??= item.builder!();
          return item.instance;
        } else {
          return item.builder == null ? item.instance : item.builder!();
        }
      }
    }
  }
}

class YimScopedServiceProvider extends YimServiceProvider {
  YimScopedServiceProvider(this.serviceCollection);
  final IYimServiceCollection serviceCollection;
  final Map<YimServiceTypeDescriptor, dynamic> _scopedInstance = {};
  @override
  T? getService<T>() {
    for (var item in serviceCollection.services) {
      if (item.serviceType.runtimeType == YimServiceTypeDescriptor<T>().runtimeType) {
        if (item.lifetime == YimServiceLifetime.singleton) {
          item.instance ??= item.builder!();
          return item.instance;
        } else if (item.lifetime == YimServiceLifetime.scoped) {
          if (_scopedInstance[item.serviceType] == null) {
            _scopedInstance[item.serviceType] = item.builder == null ? item.instance : item.builder!();
          }
          return _scopedInstance[item.serviceType];
        } else {
          return item.builder == null ? item.instance : item.builder!();
        }
      }
    }
  }
}

class YimServiceScopedProviderWidget extends InheritedWidget {
  const YimServiceScopedProviderWidget({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class YimServiceProviderWidget extends InheritedWidget {
  const YimServiceProviderWidget({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
