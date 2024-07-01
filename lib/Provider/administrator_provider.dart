import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/administrator.dart';

class AdministratorProvider extends ChangeNotifier {
  Administrator? _administrator;
  Administrator? get administratorVal => _administrator;

  assignAdministrator(Administrator administrator) {
    _administrator = administrator;
  }
}
