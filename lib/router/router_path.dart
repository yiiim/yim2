import 'package:yim2/yim2.dart';
import 'name_page_builder.dart';
import 'page_param.dart';
import 'router_path_item.dart';

abstract class YimRouterPath extends YimModel {
  List<YimRouterPathItem> get items;
  YimRouterPath copy() => YimCopyRouterPath([...items]);
}

/// 使用一个Url的路径
class YimUrlRouterPath extends YimRouterPath {
  final IAppNamePageBuilder namePageBuilder;
  YimUrlRouterPath(String routerUrl, this.namePageBuilder) {
    _url = routerUrl;
    _pathItems = [];
    if (routerUrl.isNotEmpty) {
      Uri uri = Uri.parse(routerUrl);
      List<String> names = [uri.host, ...uri.pathSegments];
      _pathItems = names.map<YimRouterPathItem>((e) => YimRouterNamePathItem(e, namePageBuilder)..params = YimRouterPageParam<Map>(uri.queryParameters)).toList();
    }
  }

  late List<YimRouterPathItem> _pathItems;
  late String _url;
  String get url => _url;

  @override
  List<YimRouterPathItem> get items => _pathItems;
}

class YimCopyRouterPath extends YimRouterPath {
  YimCopyRouterPath(List<YimRouterPathItem> copyItems) : _items = copyItems;
  final List<YimRouterPathItem> _items;
  @override
  List<YimRouterPathItem> get items => _items;
}
