// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:bicrew/formatters.dart';

/// Calculates the sum of the primary amounts of a list of [AccountData].
double sumAccountDataPrimaryAmount(List<AccountData> items) =>
    sumOf<AccountData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the primary amounts of a list of [BillData].
double sumBillDataPrimaryAmount(List<BillData> items) =>
    sumOf<BillData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the primary amounts of a list of [BillData].
double sumBillDataPaidAmount(List<BillData> items) => sumOf<BillData>(
      items.where((item) => item.isPaid).toList(),
      (item) => item.primaryAmount,
    );

/// Calculates the sum of the primary amounts of a list of [BudgetData].
double sumBudgetDataPrimaryAmount(List<BudgetData> items) =>
    sumOf<BudgetData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the amounts used of a list of [BudgetData].
double sumBudgetDataAmountUsed(List<BudgetData> items) =>
    sumOf<BudgetData>(items, (item) => item.amountUsed);

/// Utility function to sum up values in a list.
double sumOf<T>(List<T> list, double Function(T elt) getValue) {
  var sum = 0.0;
  for (var elt in list) {
    sum += getValue(elt);
  }
  return sum;
}

/// A data model for an account.
///
/// The [primaryAmount] is the balance of the account in USD.
class AccountData {
  const AccountData({
    required this.name,
    required this.primaryAmount,
    required this.accountNumber,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The full displayable account number.
  final String accountNumber;
}

/// A data model for a bill.
///
/// The [primaryAmount] is the amount due in USD.
class BillData {
  const BillData({
    required this.name,
    required this.primaryAmount,
    required this.dueDate,
    this.isPaid = false,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The due date of this bill.
  final String dueDate;

  /// If this bill has been paid.
  final bool isPaid;
}

/// A data model for a budget.
///
/// The [primaryAmount] is the budget cap in USD.
class BudgetData {
  const BudgetData({
    required this.name,
    required this.primaryAmount,
    required this.amountUsed,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// Amount of the budget that is consumed or used.
  final double amountUsed;
}

/// A data model for an alert.
class AlertData {
  AlertData({this.message, this.iconData});

  /// The alert message to display.
  final String? message;

  /// The icon to display with the alert.
  final IconData? iconData;
}

class DetailedEventData {
  const DetailedEventData({
    required this.title,
    required this.date,
    required this.amount,
  });

  final String title;
  final DateTime date;
  final double amount;
}

/// A data model for data displayed to the user.
class UserDetailData {
  UserDetailData({
    required this.title,
    required this.value,
  });

  /// The display name of this entity.
  final String title;

  /// The value of this entity.
  final String value;
}

/// Class to return dummy data lists.
///
/// In a real app, this might be replaced with some asynchronous service.
class DummyDataService {
  static List<AccountData> getAccountDataList(BuildContext context) {
    return <AccountData>[
      const AccountData(
        name: "자유 입출금",
        primaryAmount: 2215.13,
        accountNumber: '1234561234',
      ),
      const AccountData(
        name: "주택마련 저축",
        primaryAmount: 8678.88,
        accountNumber: '8888885678',
      ),
      const AccountData(
        name: "자동차 구매 저축",
        primaryAmount: 987.48,
        accountNumber: '8888889012',
      ),
      const AccountData(
        name: "휴가 대비 저축",
        primaryAmount: 253,
        accountNumber: '1231233456',
      ),
    ];
  }

  static List<UserDetailData> getAccountDetailList(BuildContext context) {
    return <UserDetailData>[
      UserDetailData(
        title: "연이율",
        value: percentFormat(context).format(0.001),
      ),
      UserDetailData(
        title: "이율",
        value: usdWithSignFormat(context).format(1676.14),
      ),
      UserDetailData(
        title: "연간 발생 이자",
        value: usdWithSignFormat(context).format(81.45),
      ),
      UserDetailData(
        title: "작년 지급 이자",
        value: usdWithSignFormat(context).format(987.12),
      ),
      UserDetailData(
        title: "다음명세서",
        value: shortDateFormat(context).format(DateTime.utc(2019, 12, 25)),
      ),
      UserDetailData(
        title: "계정 소유자",
        value: 'Philip Cao',
      ),
    ];
  }

  static List<DetailedEventData> getDetailedEventItems() {
    // The following titles are not localized as they're product/brand names.
    return <DetailedEventData>[
      DetailedEventData(
        title: 'Genoe',
        date: DateTime.utc(2019, 1, 24),
        amount: -16.54,
      ),
      DetailedEventData(
        title: 'Fortnightly Subscribe',
        date: DateTime.utc(2019, 1, 5),
        amount: -12.54,
      ),
      DetailedEventData(
        title: 'Circle Cash',
        date: DateTime.utc(2019, 1, 5),
        amount: 365.65,
      ),
      DetailedEventData(
        title: 'Crane Hospitality',
        date: DateTime.utc(2019, 1, 4),
        amount: -705.13,
      ),
      DetailedEventData(
        title: 'ABC Payroll',
        date: DateTime.utc(2018, 12, 15),
        amount: 1141.43,
      ),
      DetailedEventData(
        title: 'Shrine',
        date: DateTime.utc(2018, 12, 15),
        amount: -88.88,
      ),
      DetailedEventData(
        title: 'Foodmates',
        date: DateTime.utc(2018, 12, 4),
        amount: -11.69,
      ),
    ];
  }

  static List<BillData> getBillDataList(BuildContext context) {
    // The following names are not localized as they're product/brand names.
    return <BillData>[
      BillData(
        name: 'RedPay Credit',
        primaryAmount: 45.36,
        dueDate: dateFormatAbbreviatedMonthDay(context)
            .format(DateTime.utc(2019, 1, 29)),
      ),
      BillData(
        name: 'Rent',
        primaryAmount: 1200,
        dueDate: dateFormatAbbreviatedMonthDay(context)
            .format(DateTime.utc(2019, 2, 9)),
        isPaid: true,
      ),
      BillData(
        name: 'TabFine Credit',
        primaryAmount: 87.33,
        dueDate: dateFormatAbbreviatedMonthDay(context)
            .format(DateTime.utc(2019, 2, 22)),
      ),
      BillData(
        name: 'ABC Loans',
        primaryAmount: 400,
        dueDate: dateFormatAbbreviatedMonthDay(context)
            .format(DateTime.utc(2019, 2, 29)),
      ),
    ];
  }

  static List<UserDetailData> getBillDetailList(BuildContext context,
      {required double dueTotal, required double paidTotal}) {
    return <UserDetailData>[
      UserDetailData(
        title: "총액",
        value: usdWithSignFormat(context).format(paidTotal + dueTotal),
      ),
      UserDetailData(
        title: "세부 금엑",
        value: usdWithSignFormat(context).format(paidTotal),
      ),
      UserDetailData(
        title: "미결제 금액",
        value: usdWithSignFormat(context).format(dueTotal),
      ),
    ];
  }

  static List<BudgetData> getBudgetDataList(BuildContext context) {
    return <BudgetData>[
      const BudgetData(
        name: "커피숍",
        primaryAmount: 70,
        amountUsed: 45.49,
      ),
      const BudgetData(
        name: "식료품",
        primaryAmount: 170,
        amountUsed: 16.45,
      ),
      const BudgetData(
        name: "식당",
        primaryAmount: 170,
        amountUsed: 123.25,
      ),
      const BudgetData(
        name: "의류",
        primaryAmount: 70,
        amountUsed: 19.45,
      ),
    ];
  }

  static List<UserDetailData> getBudgetDetailList(BuildContext context,
      {required double capTotal, required double usedTotal}) {
    return <UserDetailData>[
      UserDetailData(
        title: "총 한도",
        value: usdWithSignFormat(context).format(capTotal),
      ),
      UserDetailData(
        title: "사용 금액",
        value: usdWithSignFormat(context).format(usedTotal),
      ),
      UserDetailData(
        title: "남은 금액",
        value: usdWithSignFormat(context).format(capTotal - usedTotal),
      ),
    ];
  }

  static List<String> getSettingsTitles(BuildContext context) {
    return <String>[
      "계정 관리",
      "세무 서류",
      "비밀번호 및 Touch ID",
      "알림",
      "로그아웃",
    ];
  }

  static List<AlertData> getAlerts(BuildContext context) {
    return <AlertData>[
      AlertData(
        message:
            '알림: 이번 달 쇼핑 예산의 ${percentFormat(context, decimalDigits: 0).format(0.9)}를 사용했습니다.',
        iconData: Icons.sort,
      ),
      AlertData(
        message:
            '이번 주에 음식점에서 ${usdWithSignFormat(context, decimalDigits: 0).format(120)}을(를) 사용했습니다.',
        iconData: Icons.sort,
      ),
      AlertData(
        message:
            '이번 달에 ATM 수수료로 ${usdWithSignFormat(context, decimalDigits: 0).format(24)}을(를) 사용했습니다.',
        iconData: Icons.credit_card,
      ),
      AlertData(
        message:
            '잘하고 계십니다. 입출금계좌 잔고가 지난달에 비해 ${percentFormat(context, decimalDigits: 0).format(0.04)} 많습니다.',
        iconData: Icons.attach_money,
      ),
      AlertData(
        message: '세금 공제 가능액을 늘릴 수 있습니다. 1개의 미할당 거래에 카테고리를 지정하세요.',
        iconData: Icons.not_interested,
      ),
    ];
  }
}
