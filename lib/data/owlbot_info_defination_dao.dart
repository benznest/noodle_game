
class OwlbotInfoDefinitionDao {
  String? type;
  String? definition;
  String? example;
  String? imageUrl;
  String? emoji;

  OwlbotInfoDefinitionDao(
      {this.type, this.definition, this.example, this.imageUrl, this.emoji});

  OwlbotInfoDefinitionDao.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    definition = json['definition'];
    example = json['example'];
    imageUrl = json['image_url'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['definition'] = this.definition;
    data['example'] = this.example;
    data['image_url'] = this.imageUrl;
    data['emoji'] = this.emoji;
    return data;
  }
}