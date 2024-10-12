class OptionModel {
  final String title;
  final Function()? handlePressed;
  final bool isDanger;
  OptionModel({
    required this.title,
    this.handlePressed,
    this.isDanger = false,
  });
}
