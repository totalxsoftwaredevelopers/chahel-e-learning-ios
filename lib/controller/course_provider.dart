import 'dart:developer' as developer;
import 'dart:math';

import 'package:chahele_project/model/chapter_model.dart';
import 'package:chahele_project/model/exam_model.dart';
import 'package:chahele_project/model/exam_tab_model.dart';
import 'package:chahele_project/model/live_model.dart';
import 'package:chahele_project/model/medium_model.dart';
import 'package:chahele_project/model/section_model.dart';
import 'package:chahele_project/model/standard_model.dart';
import 'package:chahele_project/model/subject_model.dart';
import 'package:chahele_project/model/terms_conditions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CourseProvider with ChangeNotifier {
  final firebase = FirebaseFirestore.instance;
  List<StandardModel> standardsList = [];
  List<MediumModel> mediumList = [];
  List<MediumModel> allMediums = [];
  List<SubjectModel> subjectList = [];
  List<ChapterModel> chapterList = [];
  List<SectionModel> sectionList = [];
  MediumModel? mediumData;
  ListExamModel? examDataList;
  List<StandardModel> planStandardList = [];
  List<MediumModel> planMediumList = [];
  TermsAndConditionsmodel? termsAndConditionsData;
  List<TermsAndConditionsmodel> termsAndConditions = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? sectionLastDoc;
  QueryDocumentSnapshot<Map<String, dynamic>>? subjectLastDocExam;
  QueryDocumentSnapshot<Map<String, dynamic>>? chapterLastDocExam;

  List<SubjectModel> subjectListForExam = [];
  List<ChapterModel> chapterListForExam = [];
  List<StandardModel> standardListForExam = [];
  List<MediumModel> mediumListForExam = [];
  // List<Map<String, dynamic>> sectionListForExam = [];
  List<ExamModel>? randomQuestions = [];
  List<ExamTabModel> examTabDataList = [];
  List<ExamTabModel> searchResult = [];

  bool isLoading = false;
  bool noMoreData = false; // for lazy loading
  LiveModel? liveModel;

  List<ExamTabModel> combinedList() {
    isLoading = true;
    notifyListeners();
    examTabDataList.clear();
    // Combined in single list
    for (var subject in subjectListForExam) {
      List<ChapterModel> chapters = chapterListForExam
          .where((chapter) => chapter.subId == subject.id)
          .toList();
      for (var chapter in chapters) {
        examTabDataList.add(
          ExamTabModel(
              subjectName: subject.subject,
              chapterName: chapter.chapter,
              chapterId: chapter.id ?? "",
              subjectId: subject.id ?? "",
              medId: subject.medId,
              image: subject.image,
              content: chapter.about),
        );
      }
    }
    searchResult = examTabDataList;
    isLoading = false;
    notifyListeners();
    return examTabDataList;
  }

  void onSearchChanged(String value) {
    if (value.isEmpty) {
      searchResult = examTabDataList;
    } else {
      searchResult = examTabDataList
          .where((element) =>
              element.chapterName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

//------FETCH STANDARDS
  Future<void> fetchStandards() async {
    isLoading = true;
    notifyListeners();
    final responce = await firebase
        .collection('standards')
        .orderBy('isCreated', descending: false)
        .get();

    standardsList = responce.docs
        .map((e) => StandardModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();
    isLoading = false;
    notifyListeners();
  }

//------FETCH MEDIUM

  Future<void> fetchMediumData(String id) async {
    isLoading = true;
    mediumList.clear();
    notifyListeners();

    final responce =
        await firebase.collection('medium').where('stdId', isEqualTo: id).get();

    mediumList = responce.docs
        .map((e) => MediumModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  //--------------FETCH ALL MEDIUMS
  Future<void> fetchAllMedium() async {
    isLoading = true;
    allMediums.clear();
    notifyListeners();

    final responce = await firebase.collection('medium').limit(2).get();

    allMediums = responce.docs
        .map((e) => MediumModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  //------FETCH SUBJECTS

  Future<void> fetchSubjects(String id) async {
    isLoading = true;
    subjectList.clear();
    notifyListeners();

    final responce = await firebase
        .collection('subjects')
        .where('medId', isEqualTo: id)
        .get();

    subjectList = responce.docs
        .map((e) => SubjectModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();

    isLoading = false;
    notifyListeners();
  }

//------FETCH CHAPTERS

  // Future<void> fetchChapter(String subId) async {
  //   isLoading = true;
  //   chapterList.clear();
  //   notifyListeners();

  //   final responce = await firebase
  //       .collection('chapter')
  //       .where('subId', isEqualTo: subId)
  //       .get();

  //   chapterList = responce.docs
  //       .map((e) => ChapterModel.fromMap(e.data()).copyWith(id: e.id))
  //       .toList();

  //   isLoading = false;
  //   notifyListeners();
  // }

  //------FETCH SECTIONS WITH OUT LAZY LOADING

  // Future<void> fetchSections(String id) async {
  //   isLoading = true;

  //   notifyListeners();

  //   final responce = await firebase
  //       .collection('section')
  //       .where('chapterId', isEqualTo: id)
  //       .get();

  //   sectionList = responce.docs
  //       .map((e) => SectionModel.fromMap(e.data()).copyWith(id: e.id))
  //       .toList();

  //   isLoading = false;
  //   notifyListeners();
  // }

  //------FETCH EXAM QUESTIONS

  Future<void> fetchExamData(String id) async {
    isLoading = true;
    examDataList = null;
    randomQuestions!.clear();

    notifyListeners();

    final responce = await firebase.collection('exams').doc(id).get();

    examDataList =
        ListExamModel.fromMap(responce.data()!).copyWith(id: responce.id);

    notifyListeners();

    isLoading = false;
    notifyListeners();
  }

  // void getRandomQuestions(int questionLength) {
  // //   if (examDataList != null && examDataList!.examData.isNotEmpty) {
  // //     final random = Random();
  // //     List<ExamModel> shuffledQuestions = List.from(examDataList!.examData);
  // //     shuffledQuestions.shuffle();
  // //     randomQuestions = List.generate(
  // //         questionLength, (index) => examDataList!.examData[index]);
  // //     for (ExamModel element in randomQuestions ?? []) {
  // //       developer.log('Title: ${element.question}');
  // //     }
  // //   } else {}
  // //   notifyListeners();
  // // }

  void getRandomQuestions(int questionLength) {
    if (examDataList != null && examDataList!.examData.isNotEmpty) {
      final random = Random();
      List<ExamModel> availableQuestions = List.from(examDataList!.examData);
      Set<ExamModel> selectedQuestions = {};

      while (selectedQuestions.length < questionLength &&
          availableQuestions.isNotEmpty) {
        // Select a random index
        final randomIndex = random.nextInt(availableQuestions.length);
        // Get the question at that index
        final selectedQuestion = availableQuestions[randomIndex];
        // Add it to the selected questions set
        selectedQuestions.add(selectedQuestion);
        // Remove it from the available questions list
        availableQuestions.removeAt(randomIndex);
      }

      // Now, selectedQuestions contains the desired number of unique random questions
      randomQuestions = List.from(selectedQuestions);

      for (ExamModel element in randomQuestions ?? []) {
        developer.log('Title: ${element.question}');
      }
    } else {}
    notifyListeners();
  }

//------FETCH STANDARDS FOR PLAN SCREEN

  Future<void> fetchPlanStandards() async {
    isLoading = true;
    notifyListeners();
    final responce = await firebase.collection('standards').get();

    planStandardList = responce.docs
        .map((e) => StandardModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();
    isLoading = false;
    notifyListeners();
  }

//------FETCH MEDIUMS FOR PLAN

  Future<void> fetchPlanMediumData(String id) async {
    isLoading = true;
    notifyListeners();
    final responce =
        await firebase.collection('medium').where('stdId', isEqualTo: id).get();

    planMediumList = responce.docs
        .map((e) => MediumModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  //------FETCH CHAPTERS WITH LAZY LOADING

  Future<void> fetchChapter(String subId) async {
    isLoading = true;
    // chapterList.clear();

    final responce = await firebase
        .collection('chapter')
        .where('subId', isEqualTo: subId)
        .get();

    chapterList = responce.docs
        .map((e) => ChapterModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  //------FETCH SECTIONS WITH LAZY LOADING

  Future<void> fetchSections(String id) async {
    isLoading = true;
    notifyListeners();
    // sectionList.clear();

    var responce = (sectionLastDoc == null)
        ? await firebase
            .collection('section')
            .orderBy('sectionNumber', descending: false)
            .where('chapterId', isEqualTo: id)
            .limit(4)
            .get()
        : await firebase
            .collection('section')
            .orderBy('sectionNumber', descending: false)
            .where('chapterId', isEqualTo: id)
            .startAfterDocument(sectionLastDoc!)
            .limit(4)
            .get();

    if (responce.docs.isNotEmpty) {
      sectionLastDoc = responce.docs.last;
    }

    sectionList.addAll(responce.docs
        .map((e) => SectionModel.fromMap(e.data()).copyWith(id: e.id)));

    isLoading = false;
    notifyListeners();
  }

  void clearSectionData() {
    sectionLastDoc = null;
    sectionList = [];
    notifyListeners();
  }

  void clearChapterData() {
    // chapterLastDoc = null;
    chapterList = [];
    notifyListeners();
  }

  //---------------ZOOM LINK LAUNCHER
  Future<void> launchZoomLink(String liveLinkUrl) async {
    String encodedUrl = Uri.encodeFull(liveLinkUrl);

    if (await launchUrlString(encodedUrl)) {
      await launchUrl(Uri.parse(encodedUrl));
    } else {
      throw 'Could not launch $encodedUrl';
    }
    notifyListeners();
  }

////////////////////////////////////////////////--------------- EXAM TAB DATA
  Future<void> fetchSectionForExamTab(List<String?>? planList) async {
    isLoading = true;
    notifyListeners();

    subjectListForExam = [];
    chapterListForExam = [];

    notifyListeners();

    if (planList == null || planList.isEmpty) return;

//subject
    List<Future<QuerySnapshot<Map<String, dynamic>>>> subjectFutures = [];
    for (var medId in planList) {
      if (medId != null) {
        final d = firebase
            .collection('subjects')
            .where('medId', isEqualTo: medId)
            .limit(4)
            .get();
        subjectFutures.add(d);
      }
    }

    //chapter
    List<Future<QuerySnapshot<Map<String, dynamic>>>> chapterFutures = [];
    for (var medId in planList) {
      if (medId != null) {
        final d = firebase
            .collection('chapter')
            .where('medId', isEqualTo: medId)
            .get();
        chapterFutures.add(d);
      }
    }

    final subjectSnapshots = await Future.wait(subjectFutures);
    final chapterSnapshots = await Future.wait(chapterFutures);
//subject
    for (var snapshot in chapterSnapshots) {
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          ChapterModel data =
              ChapterModel.fromMap(doc.data()).copyWith(id: doc.id);
          chapterListForExam.add(data);
        }
      }
    }
    //Chapter
    for (var snapshot in subjectSnapshots) {
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          SubjectModel data =
              SubjectModel.fromMap(doc.data()).copyWith(id: doc.id);
          subjectListForExam.add(data);
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
  /////////////////////////////////////////////////////////////////////////////////

  Future<List<dynamic>> fetchChaptersForExam(String subjectId) async {
    List<dynamic> chapters = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('chapter')
              .where('subjectId', isEqualTo: subjectId)
              .get();

      chapters = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching chapters: $e");
    }
    return chapters;
  }

  //Live Data
  Future<void> getLiveLink() async {
    final responce = await firebase.collection('live').doc('liveDoc').get();

    liveModel = LiveModel.fromMap(responce.data()!);
  }
}
