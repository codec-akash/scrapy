class ScarpBookPhoto {
  late String createdAt;
  late String imageDate;
  late String imageLink;
  late String imageName;
  late String userId;
  late String id;
  late String? title;
  late String? polaroidTitle;

  ScarpBookPhoto({
    required this.createdAt,
    required this.imageDate,
    required this.imageLink,
    required this.imageName,
    required this.userId,
    required this.id,
    this.title,
    this.polaroidTitle,
  });

  ScarpBookPhoto.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    imageDate = json['imageDate'];
    imageLink = json['imageLink'];
    imageName = json['imageName'];
    userId = json['userId'];
    title = json['title'];
    polaroidTitle = json['polaroidTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['imageDate'] = imageDate;
    data['imageLink'] = imageLink;
    data['imageName'] = imageName;
    data['userId'] = userId;
    data['title'] = title;
    return data;
  }
}
