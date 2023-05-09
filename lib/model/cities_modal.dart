import 'dart:convert';

List<Cities> citiesListFromJson(String str) =>
    List<Cities>.from(json.decode(str).map((x) => Cities.fromJson(x)));

class CitiesModal {
  String? status;
  List<Cities>? cities;

  CitiesModal({this.status, this.cities});

  CitiesModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? area;
  Coords? coords;
  String? district;
  String? name;
  String? population;
  String? state;

  Cities(
      {this.area,
      this.coords,
      this.district,
      this.name,
      this.population,
      this.state});

  Cities.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    coords =
        json['coords'] != null ? new Coords.fromJson(json['coords']) : null;
    district = json['district'];
    name = json['name'];
    population = json['population'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    if (this.coords != null) {
      data['coords'] = this.coords!.toJson();
    }
    data['district'] = this.district;
    data['name'] = this.name;
    data['population'] = this.population;
    data['state'] = this.state;
    return data;
  }

  String citiesByName() {
    return this.name.toString();
  }
}

class Coords {
  String? lat;
  String? lon;

  Coords({this.lat, this.lon});

  Coords.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
