import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';

class PCProviderClass extends ChangeNotifier {
  PcProvider? _pcProvider;
  PcProvider? get pcProviderVal => _pcProvider;

  assignPcProvider(PcProvider pcProvider) {
    _pcProvider = pcProvider;
  }
}
