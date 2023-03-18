class Messages{

  String message = "";
  String type = "";

  Messages({required this.message,required this.type});

  String getMessage(){
    return message;
  }

  String getType(){
    return type;
  }
}