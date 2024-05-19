class VideoDto {
  final int? id;
  final List? dataOfVideo;
  final List? resolutions;
  final String? name;
  final String? duration;
  final String? videoLink;
  final String? desc;
  final String? imgLink;
  final String? typeOfVideo;

  VideoDto({
    this.id,
    this.dataOfVideo,
    this.resolutions,
    this.name,
    this.videoLink,
    this.duration,
    this.desc,
    this.imgLink,
    this.typeOfVideo
  });

  VideoDto fromJson(Map<String,dynamic> json, {String? type, List? dataOfVideo}){
    return VideoDto(
      id: int.parse(json['id'].toString()),
      dataOfVideo: dataOfVideo,
      resolutions: json['resolutions'],
      name: json['title'],
      videoLink: json['path'],
      duration: json['duration'],
      desc: json['description'],
      imgLink: "https://ouimg.koralex.fun/${json['img_id']}.png",
      typeOfVideo: type
    );
  }
}
