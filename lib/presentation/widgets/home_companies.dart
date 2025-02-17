import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/app_router.dart';
import '../../data/model/companies.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return ListTile(
          title: Text(company.name),
          leading: Image.asset(company.icon),
          onTap: () {
            context.router.push(CompanyPostRoute(companyId: company.id));
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
