class Editor {
  double zoom;
  double radius;
  double shadow;
  int background;

  Editor({
    this.zoom = 1.5,
    this.radius = 0,
    this.background = 0,
    this.shadow = 0,
  });

  Editor copy({double? zoom, double? radius, int? background, double? shadow}) {
    return Editor(
      zoom: zoom ?? this.zoom,
      radius: radius ?? this.radius,
      background: background ?? this.background,
      shadow: shadow ?? this.shadow,
    );
  }
}
