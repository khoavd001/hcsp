import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hcsp/enum/mornitor_enum.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: MonitorEnum.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TabBar(
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                border: Border.all(color: Colors.green),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              splashBorderRadius: BorderRadius.circular(
                10.0,
              ),
              labelColor: Colors.green,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
              tabs: [
                ...MonitorEnum.values
                    .map((e) => _renderTab(e.titleString(), e.iconString()))
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ...MonitorEnum.values.map((e) => e.getChartWidget())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderTab(String title, String icon) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: Colors.grey.withAlpha(150),
        ),
      ),
      width: double.infinity,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
