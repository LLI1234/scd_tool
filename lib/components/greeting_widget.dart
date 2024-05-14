import "package:flutter/material.dart";

class GreetingWidget extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback openDialogue;

  const GreetingWidget(this.name, this.color, this.openDialogue, {super.key});

  @override
  Widget build(BuildContext context) {
    String greetings() {
      final hour = TimeOfDay.now().hour;

      if (hour <= 12) {
        return 'Morning';
      } else if (hour <= 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    return Container(
        // color: color,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Good ${greetings()}, $name',
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 32.0,
                      height: 1.2,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: openDialogue,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20)),
                    // side: MaterialStateBorderSide.resolveWith((states) {
                    //   if (states.contains(MaterialState.pressed)) {
                    //   return const BorderSide(width: 5, color: Colors.white);
                    // }
                    // return const BorderSide(width: 2, color: Colors.white);
                    // })
                  ),
                  child: const Text('How are you feeling today?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700)))
            ]));
  }
}
