class Job {
  final String id;
  final String title;
  final String locationNames;
  final String isFeatured;

  Job({
    this.id,
    this.title,
    this.locationNames,
    this.isFeatured,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      locationNames: json['location'] as String,
      isFeatured: json['isFeatured'] as String,
    );
  }
}
