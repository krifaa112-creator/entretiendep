import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'app_storage_stub.dart' if (dart.library.html) 'app_storage_web.dart';
import 'logo_picker_stub.dart' if (dart.library.html) 'logo_picker_web.dart';
import 'pdf_download_stub.dart' if (dart.library.html) 'pdf_download_web.dart';

void main() {
  runApp(const BoilerCareApp());
}

class BoilerCareApp extends StatelessWidget {
  const BoilerCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Entretien chaudiere',
      builder: (context, child) =>
          AnimatedAppFrame(child: child ?? const SizedBox()),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111827)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F5F7),
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
    );
  }
}

class AnimatedAppFrame extends StatefulWidget {
  const AnimatedAppFrame({required this.child, super.key});

  final Widget child;

  @override
  State<AnimatedAppFrame> createState() => _AnimatedAppFrameState();
}

class _AnimatedAppFrameState extends State<AnimatedAppFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF02090C),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4FE3CC),
                Color(0xFF17212E),
                Color(0xFF243247),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              color: const Color(0xFF050A0F),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedContentFrame extends StatefulWidget {
  const AnimatedContentFrame({required this.child, super.key});

  final Widget child;

  @override
  State<AnimatedContentFrame> createState() => _AnimatedContentFrameState();
}

class _AnimatedContentFrameState extends State<AnimatedContentFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF45556A),
            Color(0xFF17212E),
            Color(0xFF0B1118),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.36),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          color: const Color(0xFF0A1017),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ClientRecord {
  ClientRecord({
    this.firstName = '',
    this.lastName = '',
    this.address = '',
    this.floor = '',
    this.phone = '',
    this.email = '',
    this.deviceType = 'Chaudiere gaz',
    this.brand = '',
    this.model = '',
    this.serialNumber = '',
    this.notes = '',
    List<ReportRecord>? history,
  }) : history = history ?? [];

  String firstName;
  String lastName;
  String address;
  String floor;
  String phone;
  String email;
  String deviceType;
  String brand;
  String model;
  String serialNumber;
  String notes;
  final List<ReportRecord> history;

  String get displayName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'Nouveau client' : name;
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'floor': floor,
      'phone': phone,
      'email': email,
      'deviceType': deviceType,
      'brand': brand,
      'model': model,
      'serialNumber': serialNumber,
      'notes': notes,
      'history': history.map((report) => report.toJson()).toList(),
    };
  }

  factory ClientRecord.fromJson(Map<String, dynamic> json) {
    return ClientRecord(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      deviceType: json['deviceType'] as String? ?? 'Chaudiere gaz',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      serialNumber: json['serialNumber'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      history: (json['history'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ReportRecord.fromJson)
          .toList(),
    );
  }
}

class ReportRecord {
  ReportRecord({
    this.type = 'Entretien',
    String? date,
    String? createdAt,
    List<BillingLine>? billingLines,
  }) {
    final now = DateTime.now();
    this.date = date ?? _dateStamp(now);
    this.createdAt = createdAt ?? now.toIso8601String();
    this.billingLines = billingLines ??
        [
          BillingLine(
              description: type == 'Entretien' ? 'Forfait entretien' : '')
        ];
  }

  String type;
  late String date;
  late String createdAt;
  String technician = '';
  String tirage = '';
  String coAmbient = '';
  String coFumees = '';
  String o2 = '';
  String co2 = '';
  String temperatureFumees = '';
  String pressionEau = '';
  String observations = '';
  late List<BillingLine> billingLines;

  ReportRecord copy() {
    return ReportRecord(type: type, date: date, createdAt: createdAt)
      ..technician = technician
      ..tirage = tirage
      ..coAmbient = coAmbient
      ..coFumees = coFumees
      ..o2 = o2
      ..co2 = co2
      ..temperatureFumees = temperatureFumees
      ..pressionEau = pressionEau
      ..observations = observations
      ..billingLines = billingLines.map((line) => line.copy()).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date,
      'createdAt': createdAt,
      'technician': technician,
      'tirage': tirage,
      'coAmbient': coAmbient,
      'coFumees': coFumees,
      'o2': o2,
      'co2': co2,
      'temperatureFumees': temperatureFumees,
      'pressionEau': pressionEau,
      'observations': observations,
      'billingLines': billingLines.map((line) => line.toJson()).toList(),
    };
  }

  factory ReportRecord.fromJson(Map<String, dynamic> json) {
    final date = json['date'] as String?;
    return ReportRecord(
      type: json['type'] as String? ?? 'Entretien',
      date: date,
      createdAt: json['createdAt'] as String? ?? _createdAtFromDate(date),
      billingLines: (json['billingLines'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(BillingLine.fromJson)
          .toList(),
    )
      ..technician = json['technician'] as String? ?? ''
      ..tirage = json['tirage'] as String? ?? ''
      ..coAmbient = json['coAmbient'] as String? ?? ''
      ..coFumees = json['coFumees'] as String? ?? ''
      ..o2 = json['o2'] as String? ?? ''
      ..co2 = json['co2'] as String? ?? ''
      ..temperatureFumees = json['temperatureFumees'] as String? ?? ''
      ..pressionEau = json['pressionEau'] as String? ?? ''
      ..observations = json['observations'] as String? ?? '';
  }
}

class BillingLine {
  BillingLine({
    this.description = '',
    this.amountHt = '',
    this.vatRate = '20',
  });

  String description;
  String amountHt;
  String vatRate;

  BillingLine copy() => BillingLine(
        description: description,
        amountHt: amountHt,
        vatRate: vatRate,
      );

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amountHt': amountHt,
      'vatRate': vatRate,
    };
  }

  factory BillingLine.fromJson(Map<String, dynamic> json) {
    return BillingLine(
      description: json['description'] as String? ?? '',
      amountHt: json['amountHt'] as String? ?? '',
      vatRate: json['vatRate'] as String? ?? '20',
    );
  }

  double get amountValue => _parseEuro(amountHt);
  double get vatValue => amountValue * _parseVat(vatRate) / 100;
  double get totalTtc => amountValue + vatValue;
}

class AppState extends InheritedWidget {
  const AppState({
    required this.client,
    required this.clients,
    required this.company,
    required this.report,
    required this.updateClient,
    required this.updateCompany,
    required this.updateReport,
    required super.child,
    super.key,
  });

  final ClientRecord client;
  final List<ClientRecord> clients;
  final CompanyRecord company;
  final ReportRecord report;
  final VoidCallback updateClient;
  final VoidCallback updateCompany;
  final VoidCallback updateReport;

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>()!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) => true;
}

class CompanyRecord {
  CompanyRecord({
    this.name = 'VOTRE ENTREPRISE',
    this.tagline = 'SERVICES & MAINTENANCE',
    this.activity = 'Entretien - Depannage - Installation',
    this.address = '123 Rue des Artisans',
    this.postalCity = '75000 Paris',
    this.phone = '01 23 45 67 89',
    this.email = 'contact@votreentreprise.fr',
    this.website = 'www.votreentreprise.fr',
    this.siret = '123 456 789 00019',
    this.vat = 'FR12 123456789',
    this.logoPngBase64 = '',
  });

  String name;
  String tagline;
  String activity;
  String address;
  String postalCity;
  String phone;
  String email;
  String website;
  String siret;
  String vat;
  String logoPngBase64;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagline': tagline,
      'activity': activity,
      'address': address,
      'postalCity': postalCity,
      'phone': phone,
      'email': email,
      'website': website,
      'siret': siret,
      'vat': vat,
      'logoPngBase64': logoPngBase64,
    };
  }

  factory CompanyRecord.fromJson(Map<String, dynamic> json) {
    return CompanyRecord(
      name: json['name'] as String? ?? 'VOTRE ENTREPRISE',
      tagline: json['tagline'] as String? ?? 'SERVICES & MAINTENANCE',
      activity:
          json['activity'] as String? ?? 'Entretien - Depannage - Installation',
      address: json['address'] as String? ?? '123 Rue des Artisans',
      postalCity: json['postalCity'] as String? ?? '75000 Paris',
      phone: json['phone'] as String? ?? '01 23 45 67 89',
      email: json['email'] as String? ?? 'contact@votreentreprise.fr',
      website: json['website'] as String? ?? 'www.votreentreprise.fr',
      siret: json['siret'] as String? ?? '123 456 789 00019',
      vat: json['vat'] as String? ?? 'FR12 123456789',
      logoPngBase64: json['logoPngBase64'] as String? ?? '',
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ClientRecord> _clients = [
    ClientRecord(
      firstName: 'Jean',
      lastName: 'Martin',
      address: '12 rue des Acacias, 75012 Paris',
      floor: '3e gauche',
      phone: '06 12 34 56 78',
      email: 'jean.martin@email.fr',
      deviceType: 'Chaudiere gaz condensation',
      brand: 'Saunier Duval',
      model: 'ThemaPlus Condens',
    ),
    ClientRecord(
      firstName: 'Claire',
      lastName: 'Moreau',
      address: '8 avenue Victor Hugo, 92100 Boulogne',
      floor: 'RDC',
      phone: '06 45 22 18 90',
      deviceType: 'Chaudiere murale',
      brand: 'Frisquet',
      model: 'Hydroconfort',
    ),
    ClientRecord(
      firstName: 'Karim',
      lastName: 'Benali',
      address: '24 rue Pasteur, 93100 Montreuil',
      floor: '2e porte droite',
      phone: '07 81 40 63 12',
      deviceType: 'Chaudiere basse temperature',
      brand: 'Elm Leblanc',
      model: 'Megalis',
    ),
  ];
  CompanyRecord _company = CompanyRecord();
  final ReportRecord _report = ReportRecord();

  ClientRecord get _activeClient =>
      _clients.isEmpty ? ClientRecord() : _clients.first;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    final rawData = loadAppData();
    if (rawData == null || rawData.isEmpty) {
      return;
    }
    try {
      final decoded = jsonDecode(rawData);
      final clientsJson = decoded is Map<String, dynamic>
          ? decoded['clients'] as List<dynamic>? ?? []
          : decoded as List<dynamic>;
      final loadedClients = clientsJson
          .whereType<Map<String, dynamic>>()
          .map(ClientRecord.fromJson)
          .toList();
      if (decoded is Map<String, dynamic> &&
          decoded['company'] is Map<String, dynamic>) {
        _company =
            CompanyRecord.fromJson(decoded['company'] as Map<String, dynamic>);
      }
      if (loadedClients.isNotEmpty) {
        _clients
          ..clear()
          ..addAll(loadedClients);
      }
    } catch (_) {
      return;
    }
  }

  void _saveClients() {
    saveAppData(jsonEncode({
      'company': _company.toJson(),
      'clients': _clients.map((client) => client.toJson()).toList(),
    }));
  }

  void _notifyDataChanged() {
    _saveClients();
    setState(() {});
  }

  void _open(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AppState(
          client: _activeClient,
          clients: _clients,
          company: _company,
          report: _report,
          updateClient: _notifyDataChanged,
          updateCompany: _notifyDataChanged,
          updateReport: () => setState(() {}),
          child: page,
        ),
      ),
    );
  }

  void _startReport(String type) {
    _open(ClientPickerScreen(reportType: type));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xFF050A0F),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: AnimatedContentFrame(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LogoHeader(),
                        const SizedBox(height: 22),
                        const Text(
                          'Tableau de bord',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            height: 0.95,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Fiches client, interventions et mesures chaudiere au creux de la main.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.68),
                            fontSize: 15,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: height < 680 ? 18 : 28),
                        HomeHeroCard(
                          title: 'Fiche client',
                          subtitle:
                              'Selectionner, ajouter ou modifier une fiche',
                          metric: 'Base clients',
                          icon: Icons.badge_outlined,
                          accent: const Color(0xFF44D7B6),
                          onTap: () => _open(const ClientScreen()),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: HomeActionCard(
                                title: 'Depannage',
                                subtitle: 'Intervention rapide',
                                icon: Icons.build_outlined,
                                accent: const Color(0xFFFFB020),
                                onTap: () => _startReport('Depannage'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: HomeActionCard(
                                title: 'Entretien',
                                subtitle: 'Rapport annuel',
                                icon: Icons.local_fire_department_outlined,
                                accent: const Color(0xFF6EA8FF),
                                onTap: () => _startReport('Entretien'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        HomeSettingsCard(
                            onTap: () => _open(const SettingsScreen())),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeBackdrop extends StatelessWidget {
  const HomeBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF050A0F),
            Color(0xFF0B1118),
            Color(0xFF111827),
          ],
        ),
      ),
    );
  }
}

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF44D7B6), Color(0xFF6EA8FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF44D7B6).withValues(alpha: 0.32),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_fire_department,
            color: Color(0xFF061316),
            size: 34,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Entretien chaudiere',
                style: TextStyle(
                  color: Color(0xFFA8B3BE),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: const Text(
            'V 0.26',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({
    required this.title,
    required this.subtitle,
    required this.metric,
    required this.icon,
    required this.accent,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String metric;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 174),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.96),
                const Color(0xFFEAF5F3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                bottom: -28,
                child: Icon(icon,
                    size: 142, color: accent.withValues(alpha: 0.18)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: const Color(0xFF061316), size: 30),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF081316),
                      fontSize: 31,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF52616D),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    metric,
                    style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 154),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 28),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 31,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSettingsCard extends StatelessWidget {
  const HomeSettingsCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 82),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0xFF101C24).withValues(alpha: 0.92),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 27),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Reglage',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Parametres, import et export',
                      style: TextStyle(
                        color: Color(0xFFA8B3BE),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final query = _query.trim().toLowerCase();
    final clients = state.clients.where((client) {
      final content = [
        client.displayName,
        client.address,
        client.phone,
        client.email,
        client.deviceType,
        client.brand,
        client.model,
      ].join(' ').toLowerCase();
      return query.isEmpty || content.contains(query);
    }).toList();
    return AppPage(
      title: 'Clients',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientSearchField(
              onChanged: (value) => setState(() => _query = value)),
          const SizedBox(height: 14),
          PrimaryAction(
            label: 'Ajouter un client',
            onTap: () {
              final client = ClientRecord();
              state.clients.insert(0, client);
              state.updateClient();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AppState(
                    client: client,
                    clients: state.clients,
                    company: state.company,
                    report: state.report,
                    updateClient: state.updateClient,
                    updateCompany: state.updateCompany,
                    updateReport: state.updateReport,
                    child:
                        ClientDetailScreen(client: client, startEditing: true),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Text(
            '${clients.length} client${clients.length > 1 ? 's' : ''}',
            style: const TextStyle(
              color: Color(0xFF607080),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          if (clients.isEmpty)
            const EmptyClientsCard()
          else
            ...clients.map((client) => ClientListCard(
                  client: client,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AppState(
                        client: client,
                        clients: state.clients,
                        company: state.company,
                        report: state.report,
                        updateClient: state.updateClient,
                        updateCompany: state.updateCompany,
                        updateReport: state.updateReport,
                        child: ClientDetailScreen(client: client),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({
    required this.client,
    this.startEditing = false,
    super.key,
  });

  final ClientRecord client;
  final bool startEditing;

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late bool _isEditing = widget.startEditing;

  @override
  Widget build(BuildContext context) {
    final client = widget.client;
    return AppPage(
      title: 'Fiche client',
      child: Column(
        children: [
          ClientIdentityBanner(client: client),
          SectionCard(
            title: 'Identite',
            children: _isEditing
                ? [
                    AppField(
                        label: 'Nom',
                        value: client.lastName,
                        onChanged: (v) => client.lastName = v),
                    AppField(
                        label: 'Prenom',
                        value: client.firstName,
                        onChanged: (v) => client.firstName = v),
                    AppField(
                        label: 'Adresse',
                        value: client.address,
                        onChanged: (v) => client.address = v),
                    AppField(
                        label: 'Etage / porte',
                        value: client.floor,
                        onChanged: (v) => client.floor = v),
                    AppField(
                        label: 'Telephone',
                        value: client.phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => client.phone = v),
                    AppField(
                        label: 'Email',
                        value: client.email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) => client.email = v),
                  ]
                : [
                    ReadOnlyLine(label: 'Nom', value: client.lastName),
                    ReadOnlyLine(label: 'Prenom', value: client.firstName),
                    ReadOnlyLine(label: 'Adresse', value: client.address),
                    ReadOnlyLine(label: 'Etage / porte', value: client.floor),
                    ReadOnlyLine(label: 'Telephone', value: client.phone),
                    ReadOnlyLine(label: 'Email', value: client.email),
                  ],
          ),
          SectionCard(
            title: 'Appareil',
            children: _isEditing
                ? [
                    AppField(
                        label: 'Type appareil',
                        value: client.deviceType,
                        onChanged: (v) => client.deviceType = v),
                    AppField(
                        label: 'Marque',
                        value: client.brand,
                        onChanged: (v) => client.brand = v),
                    AppField(
                        label: 'Modele',
                        value: client.model,
                        onChanged: (v) => client.model = v),
                    AppField(
                        label: 'Numero de serie',
                        value: client.serialNumber,
                        onChanged: (v) => client.serialNumber = v),
                    AppField(
                        label: 'Notes',
                        value: client.notes,
                        minLines: 3,
                        onChanged: (v) => client.notes = v),
                  ]
                : [
                    ReadOnlyLine(
                        label: 'Type appareil', value: client.deviceType),
                    ReadOnlyLine(label: 'Marque', value: client.brand),
                    ReadOnlyLine(label: 'Modele', value: client.model),
                    ReadOnlyLine(
                        label: 'Numero de serie', value: client.serialNumber),
                    ReadOnlyLine(label: 'Notes', value: client.notes),
                  ],
          ),
          ReportHistorySection(client: client),
          const SizedBox(height: 6),
          PrimaryAction(
            label: _isEditing ? 'Enregistrer la fiche' : 'Modifier la fiche',
            onTap: () {
              if (_isEditing) {
                AppState.of(context).updateClient();
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
    );
  }
}

class ClientPickerScreen extends StatefulWidget {
  const ClientPickerScreen({required this.reportType, super.key});

  final String reportType;

  @override
  State<ClientPickerScreen> createState() => _ClientPickerScreenState();
}

class _ClientPickerScreenState extends State<ClientPickerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final query = _query.trim().toLowerCase();
    final clients = state.clients.where((client) {
      final content = [
        client.displayName,
        client.address,
        client.phone,
        client.email,
        client.deviceType,
        client.brand,
        client.model,
      ].join(' ').toLowerCase();
      return query.isEmpty || content.contains(query);
    }).toList();

    return AppPage(
      title: 'Choisir client',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.reportType == 'Depannage'
                        ? const Color(0xFFFFB020)
                        : const Color(0xFF6EA8FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    widget.reportType == 'Depannage'
                        ? Icons.build_outlined
                        : Icons.local_fire_department_outlined,
                    color: const Color(0xFF061316),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reportType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Selectionne le client avant de saisir le rapport.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.68),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ClientSearchField(
              onChanged: (value) => setState(() => _query = value)),
          const SizedBox(height: 14),
          Text(
            '${clients.length} client${clients.length > 1 ? 's' : ''}',
            style: const TextStyle(
              color: Color(0xFF607080),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          if (clients.isEmpty)
            const EmptyClientsCard()
          else
            ...clients.map((client) => ClientListCard(
                  client: client,
                  onTap: () {
                    final report = ReportRecord(type: widget.reportType);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AppState(
                          client: client,
                          clients: state.clients,
                          company: state.company,
                          report: report,
                          updateClient: state.updateClient,
                          updateCompany: state.updateCompany,
                          updateReport: state.updateReport,
                          child: ReportScreen(type: widget.reportType),
                        ),
                      ),
                    );
                  },
                )),
        ],
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({required this.type, super.key});

  final String type;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final report = state.report;
    final client = state.client;
    return AppPage(
      title: widget.type,
      child: Column(
        children: [
          ClientSummary(client: client),
          SectionCard(
            title: 'Mesures',
            children: [
              TwoColumns(
                children: [
                  AppField(
                      label: 'Tirage (Pa)',
                      value: report.tirage,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => report.tirage = v),
                  AppField(
                      label: 'CO ambiant (ppm)',
                      value: report.coAmbient,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => report.coAmbient = v),
                  AppField(
                      label: 'CO fumees (ppm)',
                      value: report.coFumees,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => report.coFumees = v),
                  AppField(
                      label: 'O2 (%)',
                      value: report.o2,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => report.o2 = v),
                  AppField(
                      label: 'CO2 (%)',
                      value: report.co2,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => report.co2 = v),
                  AppField(
                      label: 'Temp. fumees',
                      value: report.temperatureFumees,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => report.temperatureFumees = v),
                ],
              ),
            ],
          ),
          SectionCard(
            title: 'Facturation',
            children: [
              BillingEditor(
                report: report,
                onChanged: () => setState(() {}),
              ),
            ],
          ),
          SectionCard(
            title: 'Compte rendu',
            children: [
              AppField(
                  label: 'Technicien',
                  value: report.technician,
                  onChanged: (v) => report.technician = v),
              AppField(
                  label: 'Observations',
                  value: report.observations,
                  minLines: 5,
                  onChanged: (v) => report.observations = v),
              PrimaryAction(
                label: 'Enregistrer et generer les PDF',
                onTap: () => _saveReport(context, client, report),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveReport(
      BuildContext context, ClientRecord client, ReportRecord report) async {
    final state = AppState.of(context);
    final savedReport = report.copy();
    final now = DateTime.now();
    savedReport.date = _dateStamp(now);
    savedReport.createdAt = now.toIso8601String();
    client.history.insert(0, savedReport);
    state.updateClient();
    await downloadReportPdf(client, savedReport, state.company);
    await downloadBillingPdf(client, savedReport, state.company);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AppState(
          client: client,
          clients: state.clients,
          company: state.company,
          report: savedReport,
          updateClient: state.updateClient,
          updateCompany: state.updateCompany,
          updateReport: state.updateReport,
          child: ReportSavedScreen(client: client, report: savedReport),
        ),
      ),
    );
  }
}

class BillingEditor extends StatelessWidget {
  const BillingEditor(
      {required this.report, required this.onChanged, super.key});

  final ReportRecord report;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (report.billingLines.isEmpty) {
      report.billingLines.add(
        BillingLine(
            description: report.type == 'Entretien' ? 'Forfait entretien' : ''),
      );
    }
    final totalHt = report.billingLines
        .fold<double>(0, (total, line) => total + line.amountValue);
    final totalVat = report.billingLines
        .fold<double>(0, (total, line) => total + line.vatValue);
    final totalTtc = totalHt + totalVat;

    if (report.type == 'Entretien') {
      final line = report.billingLines.first;
      if (line.description.trim().isEmpty) {
        line.description = 'Forfait entretien';
      }
      if (!const ['5.5', '10'].contains(line.vatRate)) {
        line.vatRate = '10';
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BillingTypeBadge(label: 'Forfait entretien'),
          const SizedBox(height: 10),
          AppField(
            label: 'Montant forfait HT',
            value: line.amountHt,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              line.amountHt = value;
              onChanged();
            },
          ),
          VatSelector(
            label: 'TVA du forfait',
            value: line.vatRate,
            options: const ['5.5', '10'],
            onChanged: (value) {
              line.vatRate = value;
              onChanged();
            },
          ),
          const SizedBox(height: 10),
          BillingTotals(
              totalHt: totalHt, totalVat: totalVat, totalTtc: totalTtc),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...report.billingLines.asMap().entries.map((entry) {
          final index = entry.key;
          final line = entry.value;
          if (!const ['5.5', '10', '20'].contains(line.vatRate)) {
            line.vatRate = '20';
          }
          return BillingLineCard(
            line: line,
            index: index,
            canDelete: report.billingLines.length > 1,
            onChanged: onChanged,
            onDelete: () {
              report.billingLines.removeAt(index);
              onChanged();
            },
          );
        }),
        SecondaryAction(
          label: 'Ajouter une ligne',
          onTap: () {
            report.billingLines.add(BillingLine());
            onChanged();
          },
        ),
        const SizedBox(height: 10),
        BillingTotals(totalHt: totalHt, totalVat: totalVat, totalTtc: totalTtc),
      ],
    );
  }
}

class BillingLineCard extends StatelessWidget {
  const BillingLineCard({
    required this.line,
    required this.index,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
    super.key,
  });

  final BillingLine line;
  final int index;
  final bool canDelete;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ligne ${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (canDelete)
                IconButton(
                  tooltip: 'Supprimer la ligne',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          AppField(
            label: 'Designation',
            value: line.description,
            onChanged: (value) {
              line.description = value;
              onChanged();
            },
          ),
          AppField(
            label: 'Montant HT',
            value: line.amountHt,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              line.amountHt = value;
              onChanged();
            },
          ),
          VatSelector(
            label: 'TVA',
            value: line.vatRate,
            options: const ['5.5', '10', '20'],
            onChanged: (value) {
              line.vatRate = value;
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class BillingTypeBadge extends StatelessWidget {
  const BillingTypeBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF44D7B6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, color: Color(0xFF047857)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF047857),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VatSelector extends StatelessWidget {
  const VatSelector({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF607080),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options
                .map(
                  (option) => ChoiceChip(
                    label: Text('$option %'),
                    selected: value == option,
                    onSelected: (_) => onChanged(option),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class BillingTotals extends StatelessWidget {
  const BillingTotals({
    required this.totalHt,
    required this.totalVat,
    required this.totalTtc,
    super.key,
  });

  final double totalHt;
  final double totalVat;
  final double totalTtc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          BillingTotalRow(label: 'Total HT', value: _formatEuro(totalHt)),
          const SizedBox(height: 6),
          BillingTotalRow(label: 'TVA', value: _formatEuro(totalVat)),
          const Divider(color: Color(0xFF334155), height: 18),
          BillingTotalRow(
              label: 'Total TTC', value: _formatEuro(totalTtc), strong: true),
        ],
      ),
    );
  }
}

class BillingTotalRow extends StatelessWidget {
  const BillingTotalRow({
    required this.label,
    required this.value,
    this.strong = false,
    super.key,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: strong ? 1 : 0.72),
              fontSize: strong ? 16 : 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: strong ? const Color(0xFF44D7B6) : Colors.white,
            fontSize: strong ? 18 : 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class ReportSavedScreen extends StatelessWidget {
  const ReportSavedScreen({
    required this.client,
    required this.report,
    super.key,
  });

  final ClientRecord client;
  final ReportRecord report;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Rapport',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.picture_as_pdf_outlined,
                    color: Color(0xFF44D7B6), size: 36),
                const SizedBox(height: 14),
                const Text(
                  'Rapport enregistre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${report.type} du ${formatReportDateTime(report)} - ${client.displayName}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          ClientSummary(client: client),
          ReportReadOnlyDetails(report: report),
          SectionCard(
            title: 'Document client',
            children: [
              const Text(
                'Le rapport est conserve dans l historique de la fiche client. Le document technique et la facturation sont separes.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              DocumentDownloadCard(
                title: report.type,
                subtitle: 'PDF technique sans facturation',
                icon: Icons.description_outlined,
                accent: const Color(0xFF6EA8FF),
                downloadLabel: 'Telecharger le rapport',
                emailLabel: 'Email rapport',
                onDownload: () => downloadReportPdf(
                  client,
                  report,
                  AppState.of(context).company,
                ),
                onEmail: () => prepareReportEmail(
                  client,
                  report,
                  AppState.of(context).company,
                ),
              ),
              const SizedBox(height: 10),
              DocumentDownloadCard(
                title: 'Facturation',
                subtitle: 'PDF facture separe du rapport',
                icon: Icons.receipt_long_outlined,
                accent: const Color(0xFF44D7B6),
                downloadLabel: 'Telecharger la facture',
                emailLabel: 'Email facture',
                onDownload: () => downloadBillingPdf(
                  client,
                  report,
                  AppState.of(context).company,
                ),
                onEmail: () => prepareBillingEmail(
                  client,
                  report,
                  AppState.of(context).company,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DocumentDownloadCard extends StatelessWidget {
  const DocumentDownloadCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.downloadLabel,
    required this.emailLabel,
    required this.onDownload,
    required this.onEmail,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String downloadLabel;
  final String emailLabel;
  final VoidCallback onDownload;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF111827)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF607080),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryAction(label: downloadLabel, onTap: onDownload),
          const SizedBox(height: 8),
          SecondaryAction(label: emailLabel, onTap: onEmail),
        ],
      ),
    );
  }
}

class ReportReadOnlyDetails extends StatelessWidget {
  const ReportReadOnlyDetails({required this.report, super.key});

  final ReportRecord report;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Objet : ${report.type}',
      children: [
        ReadOnlyLine(
            label: 'Date et heure', value: formatReportDateTime(report)),
        ReadOnlyLine(label: 'Technicien', value: report.technician),
        ReadOnlyLine(label: 'Tirage (Pa)', value: report.tirage),
        ReadOnlyLine(label: 'CO ambiant (ppm)', value: report.coAmbient),
        ReadOnlyLine(label: 'CO fumees (ppm)', value: report.coFumees),
        ReadOnlyLine(label: 'O2 (%)', value: report.o2),
        ReadOnlyLine(label: 'CO2 (%)', value: report.co2),
        ReadOnlyLine(label: 'Temp. fumees', value: report.temperatureFumees),
        ReadOnlyLine(label: 'Observations', value: report.observations),
        const SizedBox(height: 8),
        const Text(
          'Facturation',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        BillingReadOnly(report: report),
      ],
    );
  }
}

class BillingReadOnly extends StatelessWidget {
  const BillingReadOnly({required this.report, super.key});

  final ReportRecord report;

  @override
  Widget build(BuildContext context) {
    final lines = report.billingLines.isEmpty
        ? [
            BillingLine(
                description:
                    report.type == 'Entretien' ? 'Forfait entretien' : '')
          ]
        : report.billingLines;
    final totalHt =
        lines.fold<double>(0, (total, line) => total + line.amountValue);
    final totalVat =
        lines.fold<double>(0, (total, line) => total + line.vatValue);
    final totalTtc = totalHt + totalVat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...lines.map(
          (line) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE3E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.description.trim().isEmpty
                      ? 'Ligne libre'
                      : line.description.trim(),
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatEuro(line.amountValue)} HT - TVA ${line.vatRate} % - ${_formatEuro(line.totalTtc)} TTC',
                  style: const TextStyle(
                    color: Color(0xFF607080),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        BillingTotals(totalHt: totalHt, totalVat: totalVat, totalTtc: totalTtc),
      ],
    );
  }
}

class ReportHistorySection extends StatelessWidget {
  const ReportHistorySection({required this.client, super.key});

  final ClientRecord client;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Historique client',
      children: [
        if (client.history.isEmpty)
          const Text(
            'Aucun rapport enregistre pour ce client.',
            style: TextStyle(
                color: Color(0xFF607080), fontWeight: FontWeight.w700),
          )
        else
          ...client.history.map(
              (report) => ReportHistoryCard(client: client, report: report)),
      ],
    );
  }
}

class ReportHistoryCard extends StatelessWidget {
  const ReportHistoryCard({
    required this.client,
    required this.report,
    super.key,
  });

  final ClientRecord client;
  final ReportRecord report;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AppState(
              client: client,
              clients: state.clients,
              company: state.company,
              report: report,
              updateClient: state.updateClient,
              updateCompany: state.updateCompany,
              updateReport: state.updateReport,
              child: ReportSavedScreen(client: client, report: report),
            ),
          ),
        ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: report.type == 'Depannage'
                      ? const Color(0xFFFFB020)
                      : const Color(0xFF6EA8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_outlined,
                    color: Color(0xFF061316)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatReportDateTime(report),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Objet : ${report.type}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF607080),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Documents : rapport + facturation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF8A96A3),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF8A96A3)),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> downloadReportPdf(
    ClientRecord client, ReportRecord report, CompanyRecord company) async {
  final bytes = await buildReportPdf(client, report, company);
  await savePdfBytes(bytes, reportFileName(client, report));
}

Future<void> downloadBillingPdf(
    ClientRecord client, ReportRecord report, CompanyRecord company) async {
  final bytes = await buildBillingPdf(client, report, company);
  await savePdfBytes(bytes, billingFileName(client, report));
}

Future<void> prepareReportEmail(
    ClientRecord client, ReportRecord report, CompanyRecord company) async {
  await openEmailDraft(
    to: client.email,
    subject: '${report.type} chaudiere - ${formatReportDateTime(report)}',
    body: reportEmailBody(client, report, company),
  );
}

Future<void> prepareBillingEmail(
    ClientRecord client, ReportRecord report, CompanyRecord company) async {
  await openEmailDraft(
    to: client.email,
    subject:
        'Facturation ${report.type.toLowerCase()} chaudiere - ${formatReportDateTime(report)}',
    body: billingEmailBody(client, report, company),
  );
}

Future<List<int>> buildReportPdf(
    ClientRecord client, ReportRecord report, CompanyRecord company) async {
  final document = pw.Document();
  final device = '${client.deviceType} ${client.brand} ${client.model}'.trim();
  final logoBytes = _decodeLogo(company.logoPngBase64);
  const navy = PdfColor.fromInt(0xFF082B63);
  const orange = PdfColor.fromInt(0xFFFF6B1A);
  const softBlue = PdfColor.fromInt(0xFFF5F8FC);

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(24, 22, 24, 22),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _certificateHeader(client, company, logoBytes, navy, orange),
          pw.SizedBox(height: 22),
          pw.Center(
            child: pw.Text(
              "ATTESTATION D'ENTRETIEN",
              style: pw.TextStyle(
                color: navy,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          pw.Container(
              height: 1.2,
              margin: const pw.EdgeInsets.only(top: 6, bottom: 14),
              color: navy),
          pw.Row(
            children: [
              pw.Expanded(
                  child: _dottedValue('Date de l intervention',
                      formatReportDateTime(report), navy)),
              pw.SizedBox(width: 28),
              pw.Expanded(
                  child: _dottedValue('No d intervention',
                      report.createdAt.hashCode.abs().toString(), navy)),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              pw.Expanded(
                  child: _dottedValue(
                      'Type d equipement', client.deviceType, navy)),
              pw.SizedBox(width: 28),
              pw.Expanded(child: _dottedValue('Marque / Modele', device, navy)),
            ],
          ),
          pw.SizedBox(height: 22),
          _pdfTitle('MESURES REALISEES', navy),
          pw.SizedBox(height: 7),
          _measureTable(report, navy),
          pw.SizedBox(height: 20),
          _pdfTitle('COMPTE RENDU', navy),
          pw.SizedBox(height: 7),
          _reportBox(report, navy, softBlue),
          pw.SizedBox(height: 12),
          _footerBoxes(report, navy),
        ],
      ),
    ),
  );

  return document.save();
}

Future<List<int>> buildBillingPdf(
    ClientRecord client, ReportRecord report, CompanyRecord company) async {
  final document = pw.Document();
  final logoBytes = _decodeLogo(company.logoPngBase64);
  const navy = PdfColor.fromInt(0xFF082B63);
  const orange = PdfColor.fromInt(0xFFFF6B1A);
  const softBlue = PdfColor.fromInt(0xFFF5F8FC);

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(24, 22, 24, 22),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _certificateHeader(client, company, logoBytes, navy, orange),
          pw.SizedBox(height: 24),
          pw.Center(
            child: pw.Text(
              'FACTURATION',
              style: pw.TextStyle(
                color: navy,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          pw.Container(
              height: 1.2,
              margin: const pw.EdgeInsets.only(top: 6, bottom: 18),
              color: navy),
          pw.Row(
            children: [
              pw.Expanded(
                  child: _dottedValue('Date de l intervention',
                      formatReportDateTime(report), navy)),
              pw.SizedBox(width: 28),
              pw.Expanded(child: _dottedValue('Objet', report.type, navy)),
            ],
          ),
          pw.SizedBox(height: 20),
          _billingPdfTable(report, navy, softBlue),
          pw.Spacer(),
          _footerBoxes(report, navy),
        ],
      ),
    ),
  );

  return document.save();
}

pw.Widget _certificateHeader(
  ClientRecord client,
  CompanyRecord company,
  Uint8List? logoBytes,
  PdfColor navy,
  PdfColor orange,
) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                _pdfLogo(company, logoBytes, navy, orange),
                pw.SizedBox(width: 12),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      company.name.trim().isEmpty
                          ? 'VOTRE ENTREPRISE'
                          : company.name.trim(),
                      style: pw.TextStyle(
                          color: navy,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      company.tagline.trim().isEmpty
                          ? 'SERVICES & MAINTENANCE'
                          : company.tagline.trim(),
                      style: pw.TextStyle(
                          color: orange,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.6),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                        company.activity.trim().isEmpty
                            ? 'Entretien - Depannage - Installation'
                            : company.activity.trim(),
                        style: pw.TextStyle(color: navy, fontSize: 9)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 14),
            _companyLine(company.address, navy),
            _companyLine(company.postalCity, navy, inset: true),
            _companyLine(company.phone, navy),
            _companyLine(company.email, navy),
            _companyLine(company.website, navy),
            pw.SizedBox(height: 5),
            pw.Text('SIRET : ${company.siret}',
                style: pw.TextStyle(color: navy, fontSize: 9)),
            pw.Text('TVA intracom : ${company.vat}',
                style: pw.TextStyle(color: navy, fontSize: 9)),
          ],
        ),
      ),
      pw.SizedBox(width: 26),
      pw.Container(
        width: 250,
        padding: const pw.EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: navy, width: 1.1),
          borderRadius: pw.BorderRadius.circular(7),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INFORMATIONS CLIENT',
                style: pw.TextStyle(
                    color: navy, fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 9),
            _dottedValue('Nom / Prenom', client.displayName, navy, small: true),
            _dottedValue('Adresse', client.address, navy, small: true),
            _dottedValue('Code postal / Ville', _cityLine(client.address), navy,
                small: true),
            _dottedValue('Telephone', client.phone, navy, small: true),
            _dottedValue('Email', client.email, navy, small: true),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _pdfLogo(CompanyRecord company, Uint8List? logoBytes, PdfColor navy,
    PdfColor orange) {
  if (logoBytes != null) {
    return pw.Container(
      width: 52,
      height: 52,
      child: pw.Image(pw.MemoryImage(logoBytes), fit: pw.BoxFit.contain),
    );
  }
  final initials = company.name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part.substring(0, 1).toUpperCase())
      .join();
  return pw.Container(
    width: 52,
    height: 52,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: navy, width: 2),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Center(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(initials.isEmpty ? 'V' : initials.substring(0, 1),
              style: pw.TextStyle(
                  color: navy, fontSize: 25, fontWeight: pw.FontWeight.bold)),
          pw.Text(initials.length > 1 ? initials.substring(1, 2) : 'E',
              style: pw.TextStyle(
                  color: orange, fontSize: 25, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    ),
  );
}

pw.Widget _companyLine(String value, PdfColor navy, {bool inset = false}) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: inset ? 12 : 0, bottom: 3),
    child: pw.Text(value, style: pw.TextStyle(color: navy, fontSize: 9.5)),
  );
}

pw.Widget _pdfTitle(String title, PdfColor navy) {
  return pw.Text(title,
      style: pw.TextStyle(
          color: navy, fontSize: 13, fontWeight: pw.FontWeight.bold));
}

pw.Widget _dottedValue(String label, String value, PdfColor navy,
    {bool small = false}) {
  final displayed = value.trim().isEmpty
      ? '........................................'
      : value.trim();
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Text('$label : ',
          style:
              pw.TextStyle(fontSize: small ? 8.8 : 10, color: PdfColors.black)),
      pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 1),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.55)),
          ),
          child: pw.Text(displayed,
              style: pw.TextStyle(fontSize: small ? 8.8 : 10, color: navy)),
        ),
      ),
    ],
  );
}

pw.Widget _measureTable(ReportRecord report, PdfColor navy) {
  final headers = [
    'CO ambiant\n(ppm)',
    'CO\n(ppm)',
    'CO2\n(%)',
    'O2\n(%)',
    'Rendement /\nEff. energetique\n(%)',
    'Temperature fumees\n(C)',
    "Exces d'air\n(%)",
    'Tirage\n(Pa)',
  ];
  final values = [
    _pdfValue(report.coAmbient),
    _pdfValue(report.coFumees),
    _pdfValue(report.co2),
    _pdfValue(report.o2),
    '',
    _pdfValue(report.temperatureFumees),
    '',
    _pdfValue(report.tirage),
  ];

  return pw.Table(
    border: pw.TableBorder.all(color: navy, width: 0.8),
    columnWidths: {
      for (var index = 0; index < headers.length; index++)
        index: const pw.FlexColumnWidth(),
    },
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: navy),
        children: headers
            .map(
              (header) => pw.Container(
                height: 38,
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  header,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
            )
            .toList(),
      ),
      pw.TableRow(
        children: values
            .map(
              (value) => pw.Container(
                height: 58,
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(value,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
              ),
            )
            .toList(),
      ),
    ],
  );
}

pw.Widget _reportBox(ReportRecord report, PdfColor navy, PdfColor softBlue) {
  return pw.Container(
    width: double.infinity,
    height: 150,
    padding: const pw.EdgeInsets.all(9),
    decoration: pw.BoxDecoration(
      color: softBlue,
      border: pw.Border.all(color: navy, width: 0.9),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Operations realisees :',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        _dottedParagraph(report.type, 2),
        pw.SizedBox(height: 8),
        pw.Text('Observations :',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        _dottedParagraph(report.observations, 3),
        pw.SizedBox(height: 8),
        pw.Text('Recommandations :',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        _dottedParagraph('', 2),
      ],
    ),
  );
}

pw.Widget _dottedParagraph(String value, int lines) {
  final text = value.trim();
  if (text.isNotEmpty) {
    return pw.Text(text,
        style: const pw.TextStyle(fontSize: 9), maxLines: lines);
  }
  return pw.Column(
    children: List.generate(
      lines,
      (_) => pw.Container(
        height: 14,
        margin: const pw.EdgeInsets.only(bottom: 2),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.5)),
        ),
      ),
    ),
  );
}

pw.Widget _footerBoxes(ReportRecord report, PdfColor navy) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Expanded(
        flex: 5,
        child: _footerBox(
          'INTERVENANT',
          navy,
          [
            ['Nom', report.technician],
            ['Qualite', 'Technicien maintenance'],
            ['Date', formatReportDateTime(report)],
            ['Signature', ''],
          ],
          height: 76,
        ),
      ),
      pw.SizedBox(width: 12),
      pw.Expanded(
        flex: 4,
        child: _footerBox('CACHET DE L ENTREPRISE', navy, const [], height: 76),
      ),
      pw.SizedBox(width: 12),
      pw.Expanded(
        flex: 4,
        child: _footerBox(
          'Prochain entretien conseille le',
          navy,
          const [
            ['', ''],
          ],
          height: 62,
          titleSize: 9,
        ),
      ),
    ],
  );
}

pw.Widget _footerBox(
  String title,
  PdfColor navy,
  List<List<String>> rows, {
  required double height,
  double titleSize = 9.5,
}) {
  return pw.Container(
    height: height,
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: navy, width: 0.8),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
                color: navy,
                fontSize: titleSize,
                fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        ...rows.map((row) => _dottedValue(row[0], row[1], navy, small: true)),
      ],
    ),
  );
}

String _pdfValue(String value) => value.trim().isEmpty ? '' : value.trim();

pw.Widget _billingPdfTable(
    ReportRecord report, PdfColor navy, PdfColor softBlue) {
  final lines = report.billingLines.isEmpty
      ? [
          BillingLine(
              description:
                  report.type == 'Entretien' ? 'Forfait entretien' : '')
        ]
      : report.billingLines;
  final totalHt =
      lines.fold<double>(0, (total, line) => total + line.amountValue);
  final totalVat =
      lines.fold<double>(0, (total, line) => total + line.vatValue);
  final totalTtc = totalHt + totalVat;

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Table(
        border: pw.TableBorder.all(color: navy, width: 0.75),
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1.2),
          2: pw.FlexColumnWidth(0.9),
          3: pw.FlexColumnWidth(1.2),
        },
        children: [
          pw.TableRow(
            decoration: pw.BoxDecoration(color: navy),
            children: ['Designation', 'Montant HT', 'TVA', 'Total TTC']
                .map(
                  (header) => pw.Container(
                    height: 30,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      header,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          ...lines.map(
            (line) => pw.TableRow(
              children: [
                _billingPdfCell(line.description.trim().isEmpty
                    ? (report.type == 'Entretien'
                        ? 'Forfait entretien'
                        : 'Ligne libre')
                    : line.description.trim()),
                _billingPdfCell(_formatEuro(line.amountValue),
                    alignRight: true),
                _billingPdfCell('${line.vatRate} %', alignRight: true),
                _billingPdfCell(_formatEuro(line.totalTtc), alignRight: true),
              ],
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 14),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Container(
          width: 230,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: softBlue,
            border: pw.Border.all(color: navy, width: 0.8),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            children: [
              _billingPdfTotal('Total HT', _formatEuro(totalHt), navy),
              _billingPdfTotal('TVA', _formatEuro(totalVat), navy),
              pw.Container(
                  height: 0.8,
                  color: navy,
                  margin: const pw.EdgeInsets.symmetric(vertical: 6)),
              _billingPdfTotal('Total TTC', _formatEuro(totalTtc), navy,
                  strong: true),
            ],
          ),
        ),
      ),
    ],
  );
}

pw.Widget _billingPdfCell(String value, {bool alignRight = false}) {
  return pw.Container(
    height: 30,
    alignment: alignRight ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
  );
}

pw.Widget _billingPdfTotal(String label, String value, PdfColor navy,
    {bool strong = false}) {
  return pw.Row(
    children: [
      pw.Expanded(
        child: pw.Text(
          label,
          style: pw.TextStyle(
            color: navy,
            fontSize: strong ? 11 : 9.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      pw.Text(
        value,
        style: pw.TextStyle(
          color: navy,
          fontSize: strong ? 12 : 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ],
  );
}

String _cityLine(String address) {
  final parts = address.split(',');
  return parts.length > 1 ? parts.last.trim() : '';
}

String reportFileName(ClientRecord client, ReportRecord report) {
  final name = client.displayName
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  final stamp = formatReportDateTime(report)
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  return 'rapport-${report.type.toLowerCase()}-${name.isEmpty ? 'client' : name}-$stamp.pdf';
}

String billingFileName(ClientRecord client, ReportRecord report) {
  final name = client.displayName
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  final stamp = formatReportDateTime(report)
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  return 'facturation-${report.type.toLowerCase()}-${name.isEmpty ? 'client' : name}-$stamp.pdf';
}

String reportEmailBody(
    ClientRecord client, ReportRecord report, CompanyRecord company) {
  return [
    'Bonjour ${client.displayName},',
    '',
    'Veuillez trouver ci-joint le compte rendu de ${report.type.toLowerCase()} de votre chaudiere du ${formatReportDateTime(report)}.',
    '',
    'Resume des mesures :',
    '- Tirage : ${_unit(report.tirage, 'Pa')}',
    '- CO ambiant : ${_unit(report.coAmbient, 'ppm')}',
    '- CO fumees : ${_unit(report.coFumees, 'ppm')}',
    '- O2 : ${_unit(report.o2, '%')}',
    '- CO2 : ${_unit(report.co2, '%')}',
    '',
    'Observations :',
    report.observations.trim().isEmpty
        ? 'Aucune observation particuliere.'
        : report.observations,
    '',
    'Cordialement,',
    report.technician.trim().isEmpty ? 'Votre technicien' : report.technician,
    company.name.trim().isEmpty ? '' : company.name.trim(),
  ].join('\n');
}

String billingEmailBody(
    ClientRecord client, ReportRecord report, CompanyRecord company) {
  return [
    'Bonjour ${client.displayName},',
    '',
    'Veuillez trouver ci-joint la facturation liee a ${report.type.toLowerCase()} de votre chaudiere du ${formatReportDateTime(report)}.',
    '',
    'Detail :',
    ...billingEmailLines(report),
    '',
    'Cordialement,',
    report.technician.trim().isEmpty ? 'Votre technicien' : report.technician,
    company.name.trim().isEmpty ? '' : company.name.trim(),
  ].join('\n');
}

Uint8List? _decodeLogo(String logoPngBase64) {
  if (logoPngBase64.trim().isEmpty) {
    return null;
  }
  try {
    return base64Decode(logoPngBase64);
  } catch (_) {
    return null;
  }
}

String formatReportDateTime(ReportRecord report) {
  final parsed = DateTime.tryParse(report.createdAt);
  if (parsed == null) {
    return '${report.date} - --:--';
  }
  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  final year = parsed.year.toString();
  final hour = parsed.hour.toString().padLeft(2, '0');
  final minute = parsed.minute.toString().padLeft(2, '0');
  return '$day/$month/$year - $hour:$minute';
}

String _dateStamp(DateTime value) {
  final year = value.year.toString();
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String? _createdAtFromDate(String? date) {
  if (date == null || date.trim().isEmpty) {
    return null;
  }
  return '${date.trim()}T00:00:00';
}

String _unit(String value, String unit) {
  return value.trim().isEmpty ? 'Non renseigne' : '${value.trim()} $unit';
}

List<String> billingEmailLines(ReportRecord report) {
  final lines = report.billingLines.isEmpty
      ? [
          BillingLine(
              description:
                  report.type == 'Entretien' ? 'Forfait entretien' : '')
        ]
      : report.billingLines;
  final totalHt =
      lines.fold<double>(0, (total, line) => total + line.amountValue);
  final totalVat =
      lines.fold<double>(0, (total, line) => total + line.vatValue);
  final totalTtc = totalHt + totalVat;
  return [
    ...lines.map((line) {
      final label = line.description.trim().isEmpty
          ? (report.type == 'Entretien' ? 'Forfait entretien' : 'Ligne libre')
          : line.description.trim();
      return '- $label : ${_formatEuro(line.amountValue)} HT, TVA ${line.vatRate} %, ${_formatEuro(line.totalTtc)} TTC';
    }),
    '- Total HT : ${_formatEuro(totalHt)}',
    '- TVA : ${_formatEuro(totalVat)}',
    '- Total TTC : ${_formatEuro(totalTtc)}',
  ];
}

double _parseEuro(String value) {
  final normalized = value
      .trim()
      .replaceAll(' ', '')
      .replaceAll(',', '.')
      .replaceAll(RegExp(r'[^0-9.\-]'), '');
  return double.tryParse(normalized) ?? 0;
}

double _parseVat(String value) =>
    double.tryParse(value.replaceAll(',', '.')) ?? 0;

String _formatEuro(double value) =>
    '${value.toStringAsFixed(2).replaceAll('.', ',')} EUR';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final company = state.company;
    return AppPage(
      title: 'Reglage',
      child: Column(
        children: [
          SectionCard(
            title: 'Entreprise',
            children: [
              AppField(
                  label: 'Nom entreprise',
                  value: company.name,
                  onChanged: (v) => company.name = v),
              AppField(
                  label: 'Slogan / activite courte',
                  value: company.tagline,
                  onChanged: (v) => company.tagline = v),
              AppField(
                  label: 'Services',
                  value: company.activity,
                  onChanged: (v) => company.activity = v),
              AppField(
                  label: 'Adresse',
                  value: company.address,
                  onChanged: (v) => company.address = v),
              AppField(
                  label: 'Code postal / Ville',
                  value: company.postalCity,
                  onChanged: (v) => company.postalCity = v),
              AppField(
                  label: 'Telephone',
                  value: company.phone,
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => company.phone = v),
              AppField(
                  label: 'Email entreprise',
                  value: company.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => company.email = v),
              AppField(
                  label: 'Site web',
                  value: company.website,
                  onChanged: (v) => company.website = v),
              AppField(
                  label: 'SIRET',
                  value: company.siret,
                  onChanged: (v) => company.siret = v),
              AppField(
                  label: 'TVA intracom',
                  value: company.vat,
                  onChanged: (v) => company.vat = v),
              PrimaryAction(
                label: 'Enregistrer entreprise',
                onTap: state.updateCompany,
              ),
            ],
          ),
          SectionCard(
            title: 'Logo entreprise',
            children: [
              CompanyLogoPreview(company: company),
              const SizedBox(height: 10),
              SecondaryAction(
                label: 'Importer logo PNG transparent',
                onTap: () async {
                  final logo = await pickTransparentPngLogo();
                  if (!context.mounted) {
                    return;
                  }
                  if (logo == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Logo non importe : choisis un vrai fichier PNG, idealement depuis Fichiers sur iPhone.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => company.logoPngBase64 = logo);
                  state.updateCompany();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logo PNG importe.')),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Format accepte : PNG avec fond transparent. Sur iPhone, importe le logo depuis Fichiers si possible. Une image choisie depuis Photos peut etre convertie en JPG et sera refusee.',
                style: TextStyle(
                    color: Color(0xFF607080), fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SectionCard(
            title: 'Donnees',
            children: [
              SecondaryAction(label: 'Importer fichier client', onTap: () {}),
              const SizedBox(height: 10),
              PrimaryAction(label: 'Exporter donnees', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class CompanyLogoPreview extends StatelessWidget {
  const CompanyLogoPreview({required this.company, super.key});

  final CompanyRecord company;

  @override
  Widget build(BuildContext context) {
    final logoBytes = _decodeLogo(company.logoPngBase64);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE3E7EB)),
            ),
            child: logoBytes == null
                ? const Icon(Icons.image_outlined,
                    color: Color(0xFF8A96A3), size: 32)
                : Image.memory(logoBytes, fit: BoxFit.contain),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.logoPngBase64.isEmpty
                      ? 'Aucun logo importe'
                      : 'Logo PNG importe',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Le logo sera utilise dans les attestations PDF.',
                  style: TextStyle(
                    color: Color(0xFF607080),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClientSearchField extends StatelessWidget {
  const ClientSearchField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Rechercher un client',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF111827), width: 2),
        ),
      ),
    );
  }
}

class ClientListCard extends StatelessWidget {
  const ClientListCard({required this.client, required this.onTap, super.key});

  final ClientRecord client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final device =
        '${client.deviceType} ${client.brand} ${client.model}'.trim();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  client.displayName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 2.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      client.address.isEmpty
                          ? 'Adresse non renseignee'
                          : client.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF607080),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.isEmpty ? 'Appareil non renseigne' : device,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF8A96A3),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF8A96A3)),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyClientsCard extends StatelessWidget {
  const EmptyClientsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E7EB)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, size: 34, color: Color(0xFF8A96A3)),
          SizedBox(height: 10),
          Text(
            'Aucun client trouve',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 4),
          Text(
            'Essaie un autre nom, une adresse ou une marque.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF607080), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class ClientIdentityBanner extends StatelessWidget {
  const ClientIdentityBanner({required this.client, super.key});

  final ClientRecord client;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF17454C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.badge_outlined, color: Color(0xFF44D7B6), size: 32),
          const SizedBox(height: 16),
          Text(
            client.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            client.address.isEmpty ? 'Adresse non renseignee' : client.address,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ReadOnlyLine extends StatelessWidget {
  const ReadOnlyLine({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayed = value.trim().isEmpty ? 'Non renseigne' : value.trim();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8A96A3),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayed,
            style: TextStyle(
              color: value.trim().isEmpty
                  ? const Color(0xFF8A96A3)
                  : const Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'V 0.26',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: AnimatedContentFrame(child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType,
    this.minLines = 1,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: minLines == 1 ? 1 : 8,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class TwoColumns extends StatelessWidget {
  const TwoColumns({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(children: children);
        }
        return Wrap(
          spacing: 10,
          children: children
              .map((child) => SizedBox(
                  width: (constraints.maxWidth - 10) / 2, child: child))
              .toList(),
        );
      },
    );
  }
}

class ClientSummary extends StatelessWidget {
  const ClientSummary({required this.client, super.key});

  final ClientRecord client;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: client.displayName,
      children: [
        Text(
            client.address.isEmpty ? 'Adresse non renseignee' : client.address),
        const SizedBox(height: 4),
        Text('${client.deviceType} ${client.brand} ${client.model}'.trim()),
      ],
    );
  }
}

class PrimaryAction extends StatelessWidget {
  const PrimaryAction({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FilledButton(onPressed: onTap, child: Text(label)),
    );
  }
}

class SecondaryAction extends StatelessWidget {
  const SecondaryAction({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(onPressed: onTap, child: Text(label)),
    );
  }
}

class DangerAction extends StatelessWidget {
  const DangerAction({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFFEEF0),
          foregroundColor: const Color(0xFFB42335),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
