import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/company.dart';
import '../models/mission.dart';

Future<List<dynamic>> fetchOpenCompanies() async {
  const String baseUrl = 'https://wjfoexnahyuvjnthbany.supabase.co';
  const String anonKey = 'sb_publishable_ngnCf5_uI6NkkeJStJDyqw_E-gpiwg6';

  final Uri url = Uri.parse(
    '$baseUrl/rest/v1/companies'
    '?select=id,name,location_text,business_phone,photo_urls, folio, status,industry:industries(name,slug)'
    '&status=eq.OPEN',
  );

  final response = await http.get(
    url,
    headers: {
      'apikey': anonKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
      'Error al obtener empresas: ${response.statusCode} - ${response.body}',
    );
  }
}

List<BusinessLocation> mapCompaniesToLocations(List<dynamic> data) {
  const baseLat = 17.0602;
  const baseLng = -96.7253;
  final random = Random(42);

  return data.map((item) {
    final name = (item['name'] ?? 'Negocio').toString();
    final id = (item['id'] ?? '').toString();
    final status = (item['status'] ?? 'OPEN').toString().toUpperCase();
    final lat = baseLat + (random.nextDouble() - 0.5) * 0.012;
    final lng = baseLng + (random.nextDouble() - 0.5) * 0.012;
    return BusinessLocation(
      id: id,
      name: name,
      lat: lat,
      lng: lng,
      status: status,
    );
  }).toList();
}

Future<List<BusinessLocation>> fetchOaxacaBreakfastCompanies() async {
  final data = await fetchOpenCompanies();
  return mapCompaniesToLocations(data);
}

Future<List<Industry>> fetchOpenIndustries() async {
  const String baseUrl = 'https://wjfoexnahyuvjnthbany.supabase.co';
  const String anonKey = 'sb_publishable_ngnCf5_uI6NkkeJStJDyqw_E-gpiwg6';

  final Uri url = Uri.parse(
    '$baseUrl/rest/v1/companies'
    '?select=industry:industries(name,slug)'
    '&status=eq.OPEN',
  );

  final response = await http.get(
    url,
    headers: {
      'apikey': anonKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Error al obtener giros: ${response.statusCode} - ${response.body}',
    );
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  final Map<String, Industry> unique = {};
  for (final item in data) {
    final industry = item['industry'];
    if (industry is Map) {
      final name = (industry['name'] ?? '').toString();
      final slug = (industry['slug'] ?? '').toString();
      if (name.isEmpty || slug.isEmpty) continue;
      unique[slug] = Industry(name: name, slug: slug);
    }
  }
  return unique.values.toList();
}

Future<List<Company>> fetchCompaniesByIndustry(String slug) async {
  const String baseUrl = 'https://wjfoexnahyuvjnthbany.supabase.co';
  const String anonKey = 'sb_publishable_ngnCf5_uI6NkkeJStJDyqw_E-gpiwg6';

  final Uri url = Uri.parse(
    '$baseUrl/rest/v1/companies'
    '?select=id,name,location_text,business_phone,status,photo_urls, folio,industry:industries(name,slug)'
    '&status=eq.OPEN'
    '&industry.slug=eq.$slug',
  );

  final response = await http.get(
    url,
    headers: {
      'apikey': anonKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Error al obtener empresas: ${response.statusCode} - ${response.body}',
    );
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  return mapCompanies(data);
}

List<Company> mapCompanies(List<dynamic> data) {
  const baseLat = 17.0602;
  const baseLng = -96.7253;

  return data.map((item) {
    final name = (item['name'] ?? 'Negocio').toString();
    final id = (item['id'] ?? '').toString();
    final status = (item['status'] ?? 'OPEN').toString().toUpperCase();
    final locationText = (item['location_text'] ?? 'Centro de Oaxaca').toString();
    final phone = (item['business_phone'] ?? '').toString();
    final industry = item['industry'] as Map<String, dynamic>? ?? {};
    final industryName = (industry['name'] ?? '').toString();
    final industrySlug = (industry['slug'] ?? '').toString();

    final seed = id.hashCode;
    final rand = Random(seed);
    final lat = baseLat + (rand.nextDouble() - 0.5) * 0.012;
    final lng = baseLng + (rand.nextDouble() - 0.5) * 0.012;

    return Company(
      id: id,
      name: name,
      locationText: locationText,
      phone: phone,
      status: status,
      industryName: industryName,
      industrySlug: industrySlug,
      lat: lat,
      lng: lng,
    );
  }).toList();
}
