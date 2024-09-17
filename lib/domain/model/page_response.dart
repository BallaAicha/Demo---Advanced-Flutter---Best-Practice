class PageResponse<T> {
  final List<T> content;
  final int number;
  final int totalPages;
  final int size;
  final int totalElements;

  PageResponse({
    required this.content,
    required this.number,
    required this.totalPages,
    required this.size,
    required this.totalElements,
  });

  factory PageResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final embedded = json['_embedded'];
    final courseList = embedded != null && embedded.containsKey('courseDtoList')
        ? embedded['courseDtoList'] as List
        : [];

    return PageResponse(
      content: courseList.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      number: json['page']['number'],
      totalPages: json['page']['totalPages'],
      size: json['page']['size'],
      totalElements: json['page']['totalElements'],
    );
  }

}



class PageResponsee<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int size;


  PageResponsee({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
  });

  factory PageResponsee.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    var contentJson = json['content'] as List;
    List<T> contentList = contentJson.map((item) => fromJsonT(item)).toList();

    return PageResponsee(
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      size: json['size'],
      content: contentList,
    );
  }
}