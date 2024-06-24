import 'dart:developer';

import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref().child('Control');
  DatabaseReference databaseRefMor =
      FirebaseDatabase.instance.ref().child('Monitor');
  TextEditingController setDTextFieldController = TextEditingController();
  TextEditingController setITextFieldController = TextEditingController();
  TextEditingController setPTextFieldController = TextEditingController();
  TextEditingController setTTextFieldController = TextEditingController();
  TextEditingController setCO2ExhaustController = TextEditingController();
  TextEditingController setCO2SupplyController = TextEditingController();
  TextEditingController setFreqexhaustFanController = TextEditingController();
  String frequencySupplyFan = '0';
  String frequencyExhaustFan = '0';

  bool isChangeByText = false;
  int isSupplyFan = 0;
  int isExhaustFan = 0;
  int isOnSupplyFan = 0;
  int isONExhaustFan = 1;
  String cO2 = '0';
  @override
  void initState() {
    super.initState();
    databaseRef.child('Set-RemoteSupply').onValue.listen((event) {
      setState(() {
        isSupplyFan = int.parse(event.snapshot.value.toString());
      });
    });
    databaseRef.child('Set-RemoteExhaust').onValue.listen((event) {
      setState(() {
        isExhaustFan = int.parse(event.snapshot.value.toString());
      });
    });
    databaseRef.child('SetOn-supplyFan').onValue.listen((event) {
      setState(() {
        isOnSupplyFan = int.parse(event.snapshot.value.toString());
      });
    });
    databaseRef.child('SetOn-exhaustFan').onValue.listen((event) {
      setState(() {
        isONExhaustFan = int.parse(event.snapshot.value.toString());
      });
    });
    databaseRef.child('SetCO2-Supply').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setCO2SupplyController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRef.child('SetCO2-Exhaust').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setCO2ExhaustController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRef.child('SetFreq-exhaustFan').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setFreqexhaustFanController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRef.child('Set D').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setDTextFieldController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRef.child('Set I').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setITextFieldController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRef.child('Set P').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setPTextFieldController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRef.child('Set T').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          setTTextFieldController.text = event.snapshot.value.toString();
        });
      }
    });
    databaseRefMor
        .child('Freq-SupplyFan')
        .child('data')
        .onValue
        .listen((event) {
      if (!isChangeByText) {
        setState(() {
          frequencySupplyFan = event.snapshot.value.toString();
        });
      }
    });
    databaseRefMor
        .child('Freq-ExhaustFan')
        .child('data')
        .onValue
        .listen((event) {
      if (!isChangeByText) {
        setState(() {
          frequencyExhaustFan = event.snapshot.value.toString();
        });
      }
    });
    databaseRefMor.child('CO2').child('data').onValue.listen((event) {
      if (!isChangeByText) {
        setState(() {
          cO2 = event.snapshot.value.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              Text(
                '${cO2.toString() == 'undefined' ? '0' : cO2.toString()} PPM',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Supply Fan',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: CustomSwitch(
                            onText: 'AUTO',
                            offText: 'REMOTE',
                            selectedIndex: isSupplyFan,
                            onChanged: (value) {
                              databaseRef.child('Set-RemoteSupply').set(value);
                            },
                          )),
                      _renderSpacer(),
                      const Text(
                        'SET CO2 SUPPLY FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: _renderTextField(size, '',
                              unit: 'PPM',
                              controller: setCO2SupplyController,
                              isEnable: isSupplyFan == 0, onChange: (value) {
                            setState(
                              () {
                                isChangeByText = true;
                              },
                            );
                            databaseRef.child('SetCO2-Supply').set(value);
                          })),
                      _renderSpacer(),
                      const Text(
                        'SET ON SUPPLY FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: CustomSwitch(
                            switchColor:
                                isOnSupplyFan != 1 ? Colors.red : Colors.green,
                            onText: 'OFF',
                            offText: 'ON',
                            selectedIndex: isOnSupplyFan,
                            onChanged: (value) {
                              databaseRef.child('SetOn-supplyFan').set(value);
                            },
                          )),
                      _renderSpacer(),
                      const Text(
                        'FREQUENCY SUPPLY FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                frequencySupplyFan == '1' ? '50' : '0',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              const Text(
                                ' HZ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Lottie.asset('assets/images/supply_fan.json',
                              height: 100),
                          const SizedBox(width: 150),
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.green, BlendMode.modulate),
                            child: Lottie.asset(
                              'assets/images/exhaust_fan.json',
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/building.jpg',
                        width: 400,
                      )
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      const Text(
                        'Exhaust Fan',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: CustomSwitch(
                            onText: 'AUTO',
                            offText: 'REMOTE',
                            selectedIndex: isExhaustFan,
                            onChanged: (value) {
                              databaseRef.child('Set-RemoteExhaust').set(value);
                            },
                          )),
                      _renderSpacer(),
                      const Text(
                        'SET CO2 EXHAUST FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: _renderTextField(size, '',
                              unit: 'PPM',
                              controller: setCO2ExhaustController,
                              isEnable: isExhaustFan == 0, onChange: (value) {
                            setState(() {
                              isChangeByText = true;
                            });
                            databaseRef.child('SetCO2-Exhaust').set(value);
                          })),
                      _renderSpacer(),
                      const Text(
                        'SET ON EXHAUST FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: CustomSwitch(
                            switchColor:
                                isONExhaustFan == 1 ? Colors.red : Colors.green,
                            onText: 'OFF',
                            offText: 'ON',
                            selectedIndex: isONExhaustFan == 2 ? 1 : 0,
                            onChanged: (value) {
                              databaseRef
                                  .child('SetOn-exhaustFan')
                                  .set(value == 0 ? 1 : 2);
                            },
                          )),
                      _renderSpacer(),
                      const Text(
                        'SET FREQUENCY EXHAUST FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 300,
                        child: _renderTextField(size, '',
                            unit: 'HZ', controller: setFreqexhaustFanController,
                            onChange: (value) {
                          setState(() {
                            isChangeByText = true;
                          });
                          databaseRef.child('SetFreq-exhaustFan').set(value);
                        }),
                      ),
                      _renderSpacer(),
                      const Text(
                        'FREQUENCY EXHAUST FAN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                frequencyExhaustFan,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              const Text(
                                ' HZ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      _renderSpacer(),
                      SizedBox(
                          width: 300,
                          child: CustomComponent(
                            onChange: () {
                              setState(() {
                                isChangeByText = true;
                              });
                            },
                            onTapOutSide: () {
                              setState(() {
                                isChangeByText = false;
                              });
                            },
                            setDTextFieldController: setDTextFieldController,
                            setITextFieldController: setITextFieldController,
                            setPTextFieldController: setPTextFieldController,
                            setTTextFieldController: setTTextFieldController,
                          ))
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

  SizedBox _renderSpacer() => const SizedBox(height: 30);

  SizedBox _renderTextField(Size size, String title,
      {bool? isEnable,
      VoidCallback? onTap,
      Function(String)? onChange,
      TextEditingController? controller,
      String? unit}) {
    return SizedBox(
      height: 60,
      width: size.width * 0.3,
      child: TextFormField(
        onTapOutside: (event) {
          setState(() {
            isChangeByText = false;
          });
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        controller: controller,
        onChanged: onChange,
        decoration: InputDecoration(
            labelStyle: const TextStyle(fontSize: 25),
            labelText: title,
            fillColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.green,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 1.0,
              ),
            ),
            suffix: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(unit ?? ''),
            )),
        enabled: isEnable,
      ),
    );
  }
}

class CustomComponent extends StatefulWidget {
  TextEditingController? setDTextFieldController;
  TextEditingController? setITextFieldController;
  TextEditingController? setPTextFieldController;
  TextEditingController? setTTextFieldController;
  VoidCallback? onChange;
  VoidCallback? onTapOutSide;
  CustomComponent(
      {super.key,
      this.setDTextFieldController,
      this.setITextFieldController,
      this.setPTextFieldController,
      this.setTTextFieldController,
      required this.onChange,
      this.onTapOutSide});

  @override
  _CustomComponentState createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> {
  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref().child('Control');
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem('P', (value) {
            widget.onChange?.call();

            databaseRef.child('Set P').set(value);
          }, widget.setPTextFieldController),
          _buildItem('I', (value) {
            widget.onChange?.call();

            databaseRef.child('Set I').set(value);
          }, widget.setITextFieldController),
          _buildItem('D', (value) {
            widget.onChange?.call();

            databaseRef.child('Set D').set(value);
          }, widget.setDTextFieldController),
          _buildItem('T', (value) {
            widget.onChange?.call();

            databaseRef.child('Set T').set(value);
          }, widget.setTTextFieldController),
        ],
      ),
    );
  }

  Widget _buildItem(String label, Function(String)? onChange,
      TextEditingController? controller) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
                color: label == 'T' ? Colors.transparent : Colors.green),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label:',
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
            SizedBox(
              width: 38,
              child: TextFormField(
                onTapOutside: (v) {
                  widget.onTapOutSide?.call();
                },
                controller: controller,
                textAlign: TextAlign.center,
                onChanged: onChange,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final String onText;
  final String offText;
  final Color? switchColor;

  CustomSwitch(
      {required this.selectedIndex,
      required this.onChanged,
      required this.onText,
      required this.offText,
      this.switchColor});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for the toggle switch
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(255, 210, 210, 210)),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: widget.selectedIndex == 0
                ? 0
                : 150, // Adjust position based on selected index
            right: widget.selectedIndex == 1 ? 0 : 150,
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: widget.switchColor ?? Colors.green,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Row(
            children: [
              _buildOption(widget.onText, 0),
              _buildOption(widget.offText, 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.onChanged(index);
          });
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color:
                  widget.selectedIndex == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
