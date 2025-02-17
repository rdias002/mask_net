class Company {
  final String id;
  final String icon;
  final String name;

  const Company({
    required this.id,
    required this.icon,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
    };
  }
}

const channelGeneral = 'general';

const companies = [
  Company(id: 'amazon', icon: 'assets/icon/amazon.png', name: 'Amazon'),
  Company(id: 'facebook', icon: 'assets/icon/facebook.png', name: 'Facebook'),
  Company(id: 'flipkart', icon: 'assets/icon/flipkart.png', name: 'Flipkart'),
  Company(id: 'google', icon: 'assets/icon/google.png', name: 'Google'),
  Company(id: 'netflix', icon: 'assets/icon/netflix.png', name: 'Netflix'),
  Company(id: 'uber', icon: 'assets/icon/uber.png', name: 'Uber'),
  Company(id: 'wipro', icon: 'assets/icon/wipro.png', name: 'Wipro'),
];
