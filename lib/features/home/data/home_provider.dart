import 'package:cloudease/models/assignment.dart';
import 'package:cloudease/models/comments.dart';
import 'package:cloudease/models/courses.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeProvider extends ChangeNotifier {
  List<Course> _courses = [];
  final SupabaseClient supabase = Supabase.instance.client;
  int _currentTabIndex = 0;
  List<Assignment> _assignment = [];

  // Getter for courses
  List<Course> get courses => _courses;
  int get currentTabIndex => _currentTabIndex;
  List<Assignment> get assignments => _assignment;

  // Fetch courses initially
  Future<void> getCourses() async {
    try {
      final response = await supabase.from('courses').select();


      List<Course> fetchedCourses = (response as List<dynamic>)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList();

      _courses = fetchedCourses;
      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
      _courses = []; // Use empty list in case of error
      notifyListeners();
    }
  }

  Future<List<Assignment>?> getAssignments(String courseId) async {
    final response = await supabase.from('assignments').select().eq('course_id', courseId).select();

    List<Assignment> assignments = response.map((assignment) {
      return Assignment.fromJson(assignment);
    }).toList();
    
    _assignment = assignments;
    notifyListeners();

    return assignments;
  }
  Future<Assignment?> getAssignmentById(String assignmentId) async {
    final response = await supabase.from('assignments').select().eq('id', assignmentId).select();

    Assignment assignment = Assignment.fromJson(response.first);

    notifyListeners();

    return assignment;
  }

  Stream<List<Course>> getCoursesStream() {
    return supabase
        .from('courses')
        .stream(primaryKey: ['id'])
        .map((maps) => maps.map((map) => Course.fromJson(map)).toList());
  }

  Stream<List<Comment>> getCommentStream() {
    return supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .map((maps) => maps.map((map) => Comment.fromJson(map)).toList());
  }

  // Stream<List<Modules>> getModuleStream() {
    
  // }

  setCurrentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    // Unsubscribe when the provider is disposed
    supabase.from('courses').select();
  }
}