import 'dart:convert';

//T参数类型，E页面结果类型
class YimRouterPageParam<T> {
  YimRouterPageParam(this.value);
  final T value;

  @override
  bool operator ==(Object other) {
    if (other is YimRouterPageParam<T>) {
      if (value == other.value) return true;
      if (value is String) return value == other.value;
      try {
        return jsonEncode(value) == jsonEncode(other.value);
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  @override
  int get hashCode => identityHashCode(value);
}
