import 'package:flutter/material.dart';
import 'package:bicrew/app.dart';
import 'package:bicrew/colors.dart';

import 'package:bicrew/tabs/speedometer.dart';
import 'package:bicrew/tabs/map.dart';
import 'package:bicrew/tabs/crew.dart';
import 'package:bicrew/tabs/msg.dart';
import 'package:bicrew/tabs/settings.dart';

class RidingPage extends StatefulWidget {
  const RidingPage({super.key});

  @override
  State<RidingPage> createState() => _RidingPageState();
}

const int tabCount = 5;

// SingleTickerProviderStateMixin : 애니메이션을 위함
class _RidingPageState extends State<RidingPage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'riding_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_RallyTab] widgets get updated when changing tabs.
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        // For desktop layout we do not want to have SafeArea at the top and
        // bottom to display 100% height content on the accounts view.
        top: true,
        bottom: true,
        child: Theme(
          // This theme effectively removes the default visual touch
          // feedback for tapping a tab, which is replaced with a custom
          // animation.
          data: theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Column(
              children: [
                _BicrewTabBar(
                  tabs: _buildTabs(context: context, theme: theme),
                  tabController: _tabController,
                ),
                Expanded(
                  // 여기서 선택된 탭을 보여줌
                  child: TabBarView(
                    controller: _tabController,
                    children: _buildTabViews(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(
      {required BuildContext context, required ThemeData theme}) {
    return [
      _BicrewTab(
        theme: theme,
        iconData: Icons.speed,
        title: "속도계",
        tabIndex: 0,
        tabController: _tabController,
      ),
      _BicrewTab(
        theme: theme,
        iconData: Icons.map_outlined,
        title: "지도",
        tabIndex: 1,
        tabController: _tabController,
      ),
      _BicrewTab(
        theme: theme,
        iconData: Icons.message,
        title: "메시지",
        tabIndex: 2,
        tabController: _tabController,
      ),
      _BicrewTab(
        theme: theme,
        iconData: Icons.group,
        title: "크루",
        tabIndex: 3,
        tabController: _tabController,
      ),
      _BicrewTab(
        theme: theme,
        iconData: Icons.settings,
        title: "설정",
        tabIndex: 4,
        tabController: _tabController,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return [
      SpeedometerView(),
      MapView(),
      OverviewView(),
      CrewView(),
      SettingsView(),
    ];
  }
}

// 텝들을 받아서 탭바만 보여줌
class _BicrewTabBar extends StatelessWidget {
  const _BicrewTabBar({
    required this.tabs,
    this.tabController,
  });

  final List<Widget> tabs;
  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: const NumericFocusOrder(0),
      child: TabBar(
        // Setting isScrollable to true prevents the tabs from being
        // wrapped in [Expanded] widgets, which allows for more
        // flexible sizes and size animations among tabs.
        isScrollable: true,
        labelPadding: EdgeInsets.zero,
        tabs: tabs,
        controller: tabController,
        // This hides the tab indicator.
        indicatorColor: Colors.transparent,
      ),
    );
  }
}

// State 데이터
class _BicrewTab extends StatefulWidget {
  _BicrewTab({
    required ThemeData theme,
    IconData? iconData,
    required String title,
    int? tabIndex,
    required TabController tabController,
  })  : titleText = Text(title, style: theme.textTheme.labelLarge),
        isExpanded = tabController.index == tabIndex,
        icon = Icon(iconData, semanticLabel: title);

  final Text titleText;
  final Icon icon;
  final bool isExpanded;

  @override
  _BicrewTabState createState() => _BicrewTabState();
}

// 탭 선택 애니메이션 등
class _BicrewTabState extends State<_BicrewTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> _titleSizeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _iconFadeAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(_BicrewTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the width of each unexpanded tab by counting the number of
    // units and dividing it into the screen width. Each unexpanded tab is 1
    // unit, and there is always 1 expanded tab which is 1 unit + any extra
    // space determined by the multiplier.
    final width = MediaQuery.of(context).size.width;
    const expandedTitleWidthMultiplier = 2;
    final unitWidth = width / (tabCount + expandedTitleWidthMultiplier);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          FadeTransition(
            opacity: _iconFadeAnimation,
            child: SizedBox(
              width: unitWidth,
              child: widget.icon,
            ),
          ),
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
              child: SizedBox(
                width: unitWidth * expandedTitleWidthMultiplier,
                child: Center(
                  child: ExcludeSemantics(child: widget.titleText),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
