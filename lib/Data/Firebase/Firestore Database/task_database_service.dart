import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/task.dart';

class TaskDatabaseService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection("task");
  final CollectionReference pcProviderCollection =
      FirebaseFirestore.instance.collection("pcProvider");
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection("employee");

  List<Task> _mapQuerSnapToTask(QuerySnapshot querySnapshot) {
    try {
      List<Task> tasks = [];
      for (var docSnap in querySnapshot.docs) {
        Timestamp createdTimeStamp = docSnap.get("createdDate");
        Timestamp feedBackTimeStamp = docSnap.get("feedbackDate");
        DateTime createdDate = createdTimeStamp.toDate();
        DateTime feedbackDate = feedBackTimeStamp.toDate();
        tasks.add(
          Task(
            pcProviderId: docSnap.get("pcProviderId"),
            employeeId: docSnap.get("employeeId"),
            outlierTaskId: docSnap.get("outlierTaskId"),
            taskDocId: docSnap.id,
            payAmount: double.parse(docSnap.get("payAmount").toString()),
            createdDate: createdDate,
            feedbackDate: feedbackDate,
            feedback: int.parse(docSnap.get("feedback").toString()),
          ),
        );
      }
      return tasks;
    } catch (e) {
      debugPrint("MapQuerToTask: $e");
      return [];
    }
  }

  Future<bool?> createTask(Task task) async {
    try {
      Map<String, bool> transactionReturn =
          await FirebaseFirestore.instance.runTransaction((transaction) {
        transaction.set(taskCollection.doc(), {
          "pcProviderId": task.pcProviderId,
          "employeeId": task.employeeId,
          "outlierTaskId": task.outlierTaskId,
          "payAmount": task.payAmount,
          "createdDate": Timestamp.fromDate(task.createdDate),
          "feedbackDate": Timestamp.fromDate(task.feedbackDate),
          "feedback": task.feedback,
        });
        double amountForPc = task.payAmount * 0.4;
        double amountForEmployee = task.payAmount * 0.17;
        transaction.update(pcProviderCollection.doc(task.pcProviderId), {
          "personalAmountEarned": FieldValue.increment(amountForPc),
          "totalAmountEarned": FieldValue.increment(task.payAmount),
        });
        transaction.update(employeeCollection.doc(task.employeeId), {
          "amountReceived": amountForEmployee,
        });
        return Future.value({"val": true});
      });
      return transactionReturn["val"];
    } catch (e) {
      debugPrint("CreateTask error: $e");
      return Future.value(false);
    }
  }

  Future<List<Task>> getTasksForPcProvider(String pcProviderId) {
    try {
      return taskCollection
          .where("pcProviderId", isEqualTo: pcProviderId)
          .get()
          .then(_mapQuerSnapToTask);
    } catch (e) {
      debugPrint("GetTasksForPcProvider: $e");
      return Future.value([]);
    }
  }

  Future<List<Task>> getTasksForEmployee(String employeeId) {
    try {
      return taskCollection
          .where("employeeId", isEqualTo: employeeId)
          .get()
          .then(_mapQuerSnapToTask);
    } catch (e) {
      debugPrint("GetTasksForPcProvider: $e");
      return Future.value([]);
    }
  }

  Future<bool> assignFeedbackToTask(
      String outlierTaskId, String pcProvDocId, int feedback) async {
    try {
      QuerySnapshot findTaskQuerSnap = await taskCollection
          .where("pcProviderId", isEqualTo: pcProvDocId)
          .where("outlierTaskId", isEqualTo: outlierTaskId)
          .get();
      if (findTaskQuerSnap.docs.isNotEmpty) {
        String docId = findTaskQuerSnap.docs.first.id;
        return taskCollection.doc(docId).update({
          "feedback": feedback,
          "feedbackDate": Timestamp.now()
        }).then((value) => true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      debugPrint("AssignFeedbackToTask error: $e");
      return Future.value(false);
    }
  }
}
