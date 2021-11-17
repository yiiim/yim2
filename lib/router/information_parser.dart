import 'package:flutter/material.dart';
import 'name_page_builder.dart';
import 'router_path.dart';

class YimRouteInformationParser extends RouteInformationParser<YimRouterPath> {
  YimRouteInformationParser(this.namePageBuilder);
  final IAppNamePageBuilder namePageBuilder;
  @override
  Future<YimRouterPath> parseRouteInformation(RouteInformation routeInformation) async {
    return YimUrlRouterPath(routeInformation.location ?? "/", namePageBuilder);
  }
}
