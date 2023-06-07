class first_auth_model {
  late List<Clients> _clients;
  late String _token;

  first_auth_model( {required List<Clients> clients, required String token}) {
    this._clients = clients;
    this._token = token;
  }

  List<Clients> get clients => _clients;
  set clients(List<Clients> clients) => _clients = clients;
  String get token => _token;
  set token(String token) => _token = token;

  first_auth_model.fromJson(Map<String, dynamic> json) {
    if (json['clients'] != null) {
      _clients = <Clients>[];
      json['clients'].forEach((v) {
        _clients.add(new Clients.fromJson(v));
      });
    }
    _token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._clients != null) {
      data['clients'] = this._clients.map((v) => v.toJson()).toList();
    }
    data['token'] = this._token;
    return data;
  }
}

class Clients {
  late int _id;
  late String _name;

  Clients({required int id, required String name}) {
    this._id = id;
    this._name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  Clients.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    return data;
  }
}