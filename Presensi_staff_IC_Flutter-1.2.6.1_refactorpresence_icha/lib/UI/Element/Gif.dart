import 'package:flutter/widgets.dart';

class LoadingIc extends StatelessWidget {
  const LoadingIc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Image.asset("lib/assets/images/anggaran/loading.gif",
          width: 300, height: 300, fit: BoxFit.fitWidth),
    );
  }
}
