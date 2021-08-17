import 'package:timezone/timezone.dart';

import '../common/error_messages.dart';

/// A task associated with a calendar. EKReminder on iOS.
class Task {
  // The unique identifier for this task. This is auto-generated when a new event is created
  String? taskId;

  /// Read-only. The identifier of the calendar that this event is associated with
  String? calendarId;

  /// the title of this task
  String? title;

  /// the notes of this task
  String? notes;

  /// the priority of this task
  int? priority;

  /// the starting date of this task
  TZDateTime? startDate;

  /// the date when this task should be done / completed
  TZDateTime? dueDate;

  /// whether the task is completed or not
  bool? isCompleted;

  Task({
    this.taskId,
    this.title,
    this.notes,
    this.priority,
    this.startDate,
    this.dueDate,
    this.isCompleted,
  });

  Task.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError(ErrorMessages.fromJsonMapIsNull);
    }

    taskId = json['taskId'];
    calendarId = json['calendarId'];
    title = json['taskTitle'];
    notes = json['taskNotes'];
    priority = json['taskPriority'];
    isCompleted = json['taskCompleted'];

    final int? startTimestamp = json['taskStartDate'];
    final String? taskTimezoneId = json['taskTimezone'];
    var taskTimezone = timeZoneDatabase.locations[taskTimezoneId];
    taskTimezone ??= local;
    startDate = startTimestamp != null
        ? TZDateTime.fromMillisecondsSinceEpoch(taskTimezone, startTimestamp)
        : TZDateTime.now(local);

    final int? dueTimestamp = json['taskDueDate'];
    dueDate = dueTimestamp != null
        ? TZDateTime.fromMillisecondsSinceEpoch(taskTimezone, dueTimestamp)
        : TZDateTime.now(local);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['calendarId'] = calendarId;
    data['taskId'] = taskId;
    data['taskTitle'] = title;
    data['taskNotes'] = notes;
    data['taskPriority'] = priority;
    data['taskCompleted'] = isCompleted;
    data['taskStartDate'] = startDate?.millisecondsSinceEpoch;
    data['taskTimezone'] = startDate?.location.name;
    data['taskDueDate'] = dueDate?.millisecondsSinceEpoch;

    return data;
  }
}
