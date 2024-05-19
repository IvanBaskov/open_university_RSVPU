class PersonDto {
  final int? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? jobTitle;
  final String? academDegree;
  final String? academTitle;
  final String? awards;
  final String? interview;
  final int? imgId;

  PersonDto({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.jobTitle,
    this.academDegree,
    this.academTitle,
    this.awards,
    this.interview,
    this.imgId
  });

  PersonDto fromJson(Map<String,dynamic> json){
    return PersonDto(
      id: int.parse(json['id'].toString()),
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      jobTitle: json['job_title'],
      academDegree: json['academ_degree'],
      academTitle: json['academ_title'],
      awards: json['awards'],
      interview: json['interview'],
      imgId: int.parse(json['img_id'].toString()),
    );
  }
}
