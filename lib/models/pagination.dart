class Pagination {
  String totalCount;
  int totalPage;
  dynamic previousPage;
  dynamic currentPage;
  dynamic nextPage;
  List<dynamic> datas;
  List<dynamic> data; // added data for new opoink.

  Pagination({
    this.totalCount,
    this.totalPage,
    this.previousPage,
    this.currentPage,
    this.nextPage,
    this.datas,
    this.data,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'].toString();
    totalPage = json['total_page'];
    previousPage = json['previous_page'];
    currentPage = json['current_page'];
    nextPage = json['next_page'];
    datas = json["datas"];
    data = json["data"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['total_page'] = this.totalPage;
    data['previous_page'] = this.previousPage;
    data['current_page'] = this.currentPage;
    data['next_page'] = this.nextPage;
    return data;
  }
}
