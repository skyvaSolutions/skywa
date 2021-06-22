class Person{
  String PersonID;
  String PersonType;
  String RecordOwnerDeviceID;
  String FirstName;
  String MiddleName;
  String LastName;
  String Suffix;
  String Birthday;
  String Sex;
  String Address;
  String City;
  List<dynamic> Relatives;
  String PersonImage;
  String PersonPhoneNumber;
  String PersonEmail;
  List<dynamic> PersonLog;
  String CreatedTimeStamp;
  String UpdatedTimeStamp;
  String _id;
  String DeviceID;



  Person(
      this.PersonID,
      this.PersonType,
      this.RecordOwnerDeviceID,
      this.FirstName,
      this.MiddleName,
      this.LastName,
      this.Suffix,
      this.Birthday,
      this.Sex,
      this.Address,
      this.City,
      this.Relatives,
      this.PersonImage,
      this.PersonPhoneNumber,
      this.PersonEmail,
      this.PersonLog,
      this.CreatedTimeStamp,
      this.UpdatedTimeStamp,
      this._id,
      this.DeviceID);



  factory Person.fromMap(Map json) {
    return Person(json['PersonID'], json['PersonType'], json['RecordOwnerDeviceID'], json['FirstName'] , json['MiddleName'], json['LastName'], json['Suffix'], json['Birthday'] , json['Sex'] , json['Address'] , json['City'] , json['Relatives'] , json['PersonImage'] , json['PersonPhoneNumber'] , json['PersonEmail'] , json['PersonLog'] , json['CreatedTimeStamp'] , json['UpdatedTimeStamp'] , json['_id'] , json['DeviceID']);

  }
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json['PersonID'], json['PersonType'], json['RecordOwnerDeviceID'], json['FirstName'] , json['MiddleName'], json['LastName'], json['Suffix'], json['Birthday'] , json['Sex'] , json['Address'] , json['City'] , json['Relatives'] , json['PersonImage'] , json['PersonPhoneNumber'] , json['PersonEmail'] , json['PersonLog'] , json['CreatedTimeStamp'] , json['UpdatedTimeStamp'] , json['_id'] , json['DeviceID']);
  }

}