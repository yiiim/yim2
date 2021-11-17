import 'package:flutter/material.dart';
import 'page.dart';
import 'name_page_builder.dart';
import 'page_param.dart';
import 'router_page.dart';
import 'router_path.dart';
import 'router_path_item.dart';
import 'user.dart';

class YimRouterDelegatePath extends YimRouterPath {
  List<YimRouterPathItem> _pathPages = [];
  YimRouterDelegatePath(YimRouterPath path) {
    _pathPages = path.items;
  }
  void pushItem(YimRouterPathItem pageItem) => pushMultipleItem([pageItem]);
  void pushMultipleItem(List<YimRouterPathItem> pageItem) => _pathPages.addAll(pageItem);
  void pop() => _pathPages.removeLast();

  @override
  List<YimRouterPathItem> get items => _pathPages;
}

class YimRouterDelegate extends RouterDelegate<YimRouterPath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<YimRouterPath> {
  YimRouterDelegate(this.namePageBuilder, this.routerNavigatorKey, {required this.user}) {
    user.addListener(() => notifyListeners());
  }
  final GlobalKey<NavigatorState> routerNavigatorKey;
  IYimRouterUser user;
  IAppNamePageBuilder namePageBuilder;
  late YimRouterDelegatePath _currentRouterPath;
  @override
  Widget build(BuildContext context) {
    List<YimRouterPathItem> pageItems = [];
    for (var i = 0; i < _currentRouterPath.items.length; i++) {
      var visitsRoles = _currentRouterPath.items[i].page(context).visitsRouterRoles(context);
      if (visitsRoles.any((element) => element.challengeUser(user))) {
        pageItems.add(_currentRouterPath.items[i]);
      } else {
        List<IYimRouterRole> leftRoles = [...visitsRoles];
        for (var item in visitsRoles) {
          leftRoles.remove(item);
          if (item.hasGetRolePage) {
            var originalPath = _currentRouterPath.copy();
            pageItems.add(
              YimGetRoleBuilderRouterPathItem<dynamic>(
                item.toGetRolePage<dynamic>(context, user, null) ?? EmptyYimPage(),
                item,
                leftRoles,
                originalPath,
              ),
            );
            break;
          }
        }
        break;
      }
    }
    _currentRouterPath = YimRouterDelegatePath(YimCopyRouterPath(pageItems));
    List<Page> pages = [];
    for (var item in pageItems) {
      var page = item.page(context);
      page.pageResult.future.then((value) => item.pageResult.complete(value));
      pages.add(page);
    }
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (Route route, result) {
        _currentRouterPath.pop();
        if (route.settings is YimRouterPage) (route.settings as YimRouterPage).pageResult.complete(result);
        if (route.settings is YimRoleGetBuilderRouterPage) {
          YimRoleGetBuilderRouterPage roleGetRouter = route.settings as YimRoleGetBuilderRouterPage;
          if (result == true) {
            _currentRouterPath = YimRouterDelegatePath(roleGetRouter.originalPath);
          } else {
            if (roleGetRouter.leftRoles.isNotEmpty) {
              List<IYimRouterRole> leftRoles = [...roleGetRouter.leftRoles];
              for (var item in roleGetRouter.leftRoles) {
                leftRoles.remove(item);
                if (item.hasGetRolePage) {
                  _currentRouterPath.pushItem(
                    YimGetRoleBuilderRouterPathItem<dynamic>(
                      item.toGetRolePage<dynamic>(context, user, null) ?? EmptyYimPage(),
                      item,
                      leftRoles,
                      roleGetRouter.originalPath,
                    ),
                  );
                  break;
                }
              }
            }
          }
        }
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(YimRouterPath configuration) async {
    _currentRouterPath = YimRouterDelegatePath(configuration);
    notifyListeners();
  }

  @override
  Future<void> setInitialRoutePath(YimRouterPath configuration) async {
    _currentRouterPath = YimRouterDelegatePath(configuration);
  }

  @override
  YimRouterPath? get currentConfiguration => _currentRouterPath;

  Future pushName<T>(String name, {int pop = 0, T? params}) => pushPathItem([YimRouterNamePathItem(name, namePageBuilder)..params = params == null ? null : YimRouterPageParam<T>(params)], pop: pop);
  Future pushMultipleName<T>(List<String> names, {int pop = 0, T? params}) => pushPathItem(names.map((e) => YimRouterNamePathItem(e, namePageBuilder)..params = params == null ? null : YimRouterPageParam<T>(params)).toList(), pop: pop);
  Future pushPage(YimPage Function(BuildContext context) pageBulder) => pushPathItem([YimBuilderRouterPathItem((context, params) => YimBuilderRouterPage(pageBulder))]);
  Future pushPathItem<T>(List<YimRouterPathItem> items, {int pop = 0}) async {
    while (pop-- > 0) {
      _currentRouterPath.pop();
    }
    _currentRouterPath.pushMultipleItem(items);
    notifyListeners();
    return await items.last.pageResult.future;
  }

  void pop() => _currentRouterPath.pop();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => routerNavigatorKey;
}
