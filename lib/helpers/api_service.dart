import 'package:dio_client/dio_client.dart';
import 'package:open_university_rsvpu/helpers/dto/dto.dart';
class ApiService {

  Stream<List<NewsDto>> getNews(){
    return DioClient(baseUrl: "https://ouappapi.alexrust.org/")
      .getRequest(path: '/news_api/')
      .asStream()
      .map((event) {
        List<NewsDto> result = [];

        (event.data as List).forEach((element) {
          result.add(NewsDto().fromJson(element));
        });

        return result;
      }
    );
  }

  Stream<List<PersonDto>> getPersons(){
    return DioClient(baseUrl: "https://ouapi.koralex.fun/")
      .getRequest(path: '/persons?order=id')
      .asStream()
      .map((event) {
        List<PersonDto> result = [];

        (event.data as List).forEach((element) {
          result.add(PersonDto().fromJson(element));
        });

        return result;
      }
    );
  }

  Stream<List<VideoDto>> getVideos(String type){
    return DioClient(baseUrl: "https://ouapi.koralex.fun/")
        .getRequest(path: '/$type?order=id')
        .asStream()
        .map((event) {
      List<VideoDto> result = [];

      (event.data as List).forEach((element) {
        result.add(VideoDto().fromJson(element, type: type, dataOfVideo: event.data));
      });

      return result;
    }
    );
  }

}