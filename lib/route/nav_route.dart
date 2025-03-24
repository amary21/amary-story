enum NavRoute {
  mainRoute("LoginRoute"),
  registerRoute("RegisterRoute"),
  homeRoute("HomeRoute"),
  detailRoute("DetailRoute"),
  addRoute("AddRoute");

  const NavRoute(this.name);
  final String name;
}
