enum NavRoute {
  mainRoute("/"),
  registerRoute("/register"),
  homeRoute("/home"),
  detailRoute("/detail");

  const NavRoute(this.name);
  final String name;
}
