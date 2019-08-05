class Launch {
  int _flightNumber;
  String _missionName;
  int _launchDateUnix;
  bool _launchSuccess;
  String _details;
  Rocket _rocket;
  Links _links;

  Launch(){
    this._missionName = '';
    this._details = '';
  }

  int get flightNumber {
    return this._flightNumber;
  }

 String get flightName {
    return this._missionName;
  }

  int get launchDateInUNIX {
    return this._launchDateUnix;
  }

  bool get launchSuccess {
    return this._launchSuccess;
  }

  String get details {
    return this._details;
  }

  Links get links {
    return this._links;
  }

  Rocket get rocket {
    return this._rocket;
  }
  

  Launch.fromJSON(Map<String, dynamic> jsonMap) {
    this._flightNumber = jsonMap['flight_number'];
    this._missionName = jsonMap['mission_name'];
    this._launchDateUnix = jsonMap['launch_date_unix'];
    this._launchSuccess = jsonMap['launch_success'] != null ? jsonMap['launch_success']: false;
    this._details = jsonMap['details'] != null ? jsonMap['details']: 'No Details Available...';
    var rocketJson = jsonMap['rocket'];
    this._rocket = rocketJson != null ? Rocket.fromJSON(rocketJson) : new Rocket();
    var linksJson = jsonMap['links'];
    this._links = linksJson != null ? Links.fromJSON(linksJson) : new Links();
  }
}

class Rocket {
  String _rocketID;
  String _rocketName;

  String get rocketID {
    return this._rocketID;
  }

  String get rocketName {
    return this._rocketName;
  }

  Rocket.fromJSON(Map<String, dynamic> jsonMap) {
    this._rocketID = jsonMap['rocket_id'] as String;
    this._rocketName = jsonMap['rocket_name'] as String;
  }

  Rocket(){
    this._rocketID = '';
    this._rocketName = '';
  }
}

class Links {
  String _missionPatch;
  String _missionPatchSmall;

  String get missionPatch {
    return this._missionPatch;
  }

  String get missionPatchSmall {
    return this._missionPatchSmall;
  }

  Links.fromJSON(Map<String, dynamic> jsonMap) {
    this._missionPatch = jsonMap['mission_patch'] != null ? jsonMap['mission_patch'] : 'https://upload.wikimedia.org/wikipedia/commons/6/64/Poster_not_available.jpg';
    this._missionPatchSmall = jsonMap['mission_patch_small'] != null ? jsonMap['mission_patch_small'] : 'https://upload.wikimedia.org/wikipedia/commons/6/64/Poster_not_available.jpg';
  }

   Links(){
    this._missionPatch = '';
    this._missionPatchSmall = '';
  }
}
