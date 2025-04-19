enum JsonConstants {
  loadingAnim('loading_anim'),
  ;

  final String value;
  const JsonConstants(this.value);

  String get toJson => 'assets/json/$value.json';
}
