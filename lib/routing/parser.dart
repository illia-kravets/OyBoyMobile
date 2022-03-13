import "package:flutter/material.dart";
import "link.dart";

class RouteParser extends RouteInformationParser<AppLink> {
  @override
  Future<AppLink> parseRouteInformation(RouteInformation routeInformarion) async {
    return AppLink.fromLocation(routeInformarion.location);
  }

  @override
  RouteInformation restoreRouteInformation(AppLink configuration) {
    return RouteInformation(location: configuration.toLocation());
  }
}
