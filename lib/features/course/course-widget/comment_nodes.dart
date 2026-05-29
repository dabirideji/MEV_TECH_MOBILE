// Abstract base class for nodes in our comment tree display
import 'package:mevtech/features/course/data/models/course-content-models/course_content_model.dart';

abstract class CommentTreeNode {}

// Represents a regular comment that will be displayed
class RegularCommentNode extends CommentTreeNode {
  RegularCommentNode(this.comment);
  final CourseContentCommentModel comment;
}

// Represents the "View X replies" button when a parent comment is collapsed
class ViewMoreRepliesNode extends CommentTreeNode {
  ViewMoreRepliesNode(this.count, this.parentCommentId);
  final int count;
  final String parentCommentId;
}
