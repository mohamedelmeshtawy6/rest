class Model {
  String? id;
  String? noteTitle;
  String? noteContent;
  String? noteImage;
  String? noteUser;

  Model(
      {this.id,
      this.noteTitle,
      this.noteContent,
      this.noteImage,
      this.noteUser});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteTitle = json['note_title'];
    noteContent = json['note_content'];
    noteImage = json['note_image'];
    noteUser = json['note_user'];
  }
}
