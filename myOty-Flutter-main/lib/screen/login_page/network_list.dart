import 'package:flutter/material.dart';
import 'package:myoty/model/networks.dart';
import 'package:myoty/screen/navigation_bar/bottom_navigation_bar_5.dart';
import 'package:myoty/services/shared_pref_manager.dart';

class NetworkListPage extends StatelessWidget {
  const NetworkListPage({required this.networks, super.key});
  final List<Networks> networks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network List"),
      ),
      body: ListView.separated(
        itemCount: networks.length,
        itemBuilder: (_, index) {
          final network = networks[index].network;
          return ListTile(
            title: Text(network.libelle),
            subtitle: Text(network.id),
            onTap: () => onTapNetwork(network, context),
          );
        },
        separatorBuilder: (_, index) => const Divider(),
      ),
    );
  }

  void onTapNetwork(Network network, BuildContext context) {
    SharedPrefs.networkID = network.id;
    SharedPrefs.networkColor = network.primaryColor;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const BotNavBar(),
      ),
    );
  }
}
