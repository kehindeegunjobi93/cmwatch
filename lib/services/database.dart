import 'package:cloud_firestore/cloud_firestore.dart';

class DbMethods {

  Future<void> createRobberyReport(robberyData) async {

  Firestore.instance.runTransaction((Transaction crudTransaction) async {
    CollectionReference reference = await Firestore.instance.collection('robbery');

    reference.add(robberyData);
  });
  }

  getRobberyReport() async {
    return await Firestore.instance.collection('robbery').snapshots();
  }

  Future<void> createKidnappingReport(kidnappingData) async {

    Firestore.instance.runTransaction((Transaction crudTransaction) async {
      CollectionReference reference = await Firestore.instance.collection('kidnapping');

      reference.add(kidnappingData);
    });
  }

  getKidnappingReport() async {
    return await Firestore.instance.collection('kidnapping').snapshots();
  }

  Future<void> createMissingPersonReport(missingPersonData) async {
    Firestore.instance.collection("missing_person").add(missingPersonData).catchError((e){
      print(e);
    });
  }

  getMissingPersonReport() async {
    return await Firestore.instance.collection('missing_person').snapshots();
  }

  Future<void> createStolenItemsReport(stolenItemsData) async {

    Firestore.instance.runTransaction((Transaction crudTransaction) async {
      CollectionReference reference = await Firestore.instance.collection('stolen_items');

      reference.add(stolenItemsData);
    });
  }

  getStolenItemsReport() async {
    return await Firestore.instance.collection('stolen_items').snapshots();
  }

  Future<void> createReportCase(reportedCaseData) async {

    Firestore.instance.runTransaction((Transaction crudTransaction) async {
      CollectionReference reference = await Firestore.instance.collection('reported_case');

      reference.add(reportedCaseData);
    });
  }

  getReportedCases() async {
    return await Firestore.instance.collection('reported_case').snapshots();
  }
}