// model class for data from database
class Model{
  int id;
  String name;
  int age;

  Model({this.id,this.name,this.age});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'age':age
    };
  }

}