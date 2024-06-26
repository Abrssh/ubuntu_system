import 'package:cloud_firestore/cloud_firestore.dart';

class AdministratorDatabaseService {
  final CollectionReference administratorCollection =
      FirebaseFirestore.instance.collection("administrator");
}
