import 'owlbot_info_defination_dao.dart';

class OwlbotInfoResponseDao {
  List<OwlbotInfoDefinitionDao>? definitions;
  String? word;
  String? pronunciation;

  OwlbotInfoResponseDao({this.definitions, this.word, this.pronunciation});

  OwlbotInfoResponseDao.fromJson(Map<String, dynamic> json) {
    if (json['definitions'] != null) {
      definitions = <OwlbotInfoDefinitionDao>[];
      json['definitions'].forEach((v) {
        definitions!.add(OwlbotInfoDefinitionDao.fromJson(v));
      });
    }
    word = json['word'];
    pronunciation = json['pronunciation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.definitions != null) {
      data['definitions'] = this.definitions!.map((v) => v.toJson()).toList();
    }
    data['word'] = this.word;
    data['pronunciation'] = this.pronunciation;
    return data;
  }
}
