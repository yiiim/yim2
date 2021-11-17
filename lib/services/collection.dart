import 'package:yim2/services/descriptor.dart';

import 'provider.dart';

abstract class IYimServiceCollection {
  List<YimServiceDescriptor> get services;
  void add(YimServiceDescriptor service);
  YimServiceProvider builderProvier();
  YimServiceProvider builderScopeProvier();
}

mixin YimServiceCollectionMixin on IYimServiceCollection {}

class YimDefalutServiceCollection extends IYimServiceCollection with YimServiceCollectionMixin {
  final List<YimServiceDescriptor> _services = [];
  @override
  void add(YimServiceDescriptor service) => _services.add(service);

  @override
  List<YimServiceDescriptor> get services => _services;

  @override
  YimServiceProvider builderProvier() => YimDefaultServiceProvider(this);

  @override
  YimServiceProvider builderScopeProvier() => YimScopedServiceProvider(this);
}
