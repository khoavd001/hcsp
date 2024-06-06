import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Signal input CO2 Sensor',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                '5000 PPM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'ON/OFF Control Supply Fan',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _renderSwtichComp(),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Lottie.asset('assets/images/supply_fan.json', height: 100),
                  const SizedBox(width: 40),
                  ColorFiltered(
                    colorFilter:
                        const ColorFilter.mode(Colors.green, BlendMode.modulate),
                    child: Lottie.asset(
                      'assets/images/exhaust_fan.json',
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      const Text(
                        'ON/OFF Control Supply Fan',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _renderSwtichComp(),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderSwtichComp() {
    return AppinioAnimatedToggleTab(
      callback: (i) {},
      tabTexts: const [
        'make',
        'your',
      ],
      height: 40,
      width: 300,
      boxDecoration: const BoxDecoration(
          color: Color(0xFFc3d2db),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      animatedBoxDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFc3d2db).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
        color: const Color.fromARGB(255, 1, 184, 28),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(
          color: const Color.fromARGB(255, 1, 184, 28),
          width: 1,
        ),
      ),
      activeStyle: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      inactiveStyle: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
