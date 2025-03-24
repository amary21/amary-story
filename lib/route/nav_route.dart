enum NavRoute {
  mainRoute("/"),
  registerRoute("/register"),
  homeRoute("/home"),
  detailRoute("/detail"),
  addRoute("/add");

  const NavRoute(this.name);
  final String name;
}
