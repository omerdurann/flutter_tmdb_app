enum NotificationEnum {
  success("success"),
  error("error"),
  warning("warning"),
  info("info");

  const NotificationEnum(this.value);

  final String value;
}
