enum YimServiceLifetime { singleton, scoped, transient }

class YimServiceTypeDescriptor<T> {}

class YimServiceDescriptor<T> {
  YimServiceDescriptor({this.instance, this.type, required this.serviceType, this.builder, this.lifetime = YimServiceLifetime.singleton}) : assert(instance != null || builder != null);
  T? instance;
  final T Function()? builder;
  final YimServiceTypeDescriptor<T>? type;
  final YimServiceTypeDescriptor<T> serviceType;
  final YimServiceLifetime lifetime;
}
