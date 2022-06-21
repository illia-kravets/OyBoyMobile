// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:oyboy/widgets/export.dart';
import 'package:provider/provider.dart';

import '../../constants/export.dart';
import 'profile_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, this.fromMainPage=false, required this.profileId}) : super(key: key);

  final bool fromMainPage;
  final String profileId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShortDetailManager>(
            create: (context) => ShortDetailManager(profileId: profileId)),
        ChangeNotifierProvider<FavouriteDetailManager>(
            create: (context) => FavouriteDetailManager(profileId: profileId)),
        ChangeNotifierProvider<VideoDetailManager>(
            create: (context) => VideoDetailManager(profileId: profileId)),
      ],
      child: ProfileSkeleton(profileId: profileId, fromMainPage: fromMainPage,),
    );
  }
}

class ProfileSkeleton extends StatefulWidget {
  const ProfileSkeleton({Key? key, required this.profileId, required this.fromMainPage}) : super(key: key);
  final String profileId;
  final bool fromMainPage;

  @override
  State<ProfileSkeleton> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProfileManager manager;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.fromMainPage ? 3 : 2);
    
    super.initState();
    manager = context.read<ProfileManager>();
    manager.initializeProfile(widget.profileId);
    context.read<VideoDetailManager>().initialize();
    context.read<ShortDetailManager>().initialize();
    if (widget.fromMainPage)
      context.read<FavouriteDetailManager>().initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double getHeight() {
    Profile profile = manager.profile;
    double height = 260;
    if (profile.fullName != null && profile.fullName!.isNotEmpty) height += 40;
    if (profile.description != null && profile.description!.isNotEmpty)
      height += 65;
    if (profile.banned) height += 45;
    return height;
  }

  @override
  Widget build(BuildContext context) {
    manager = context.watch<ProfileManager>();
    return DefaultPage(
      extendBody: true,
      body: manager.isLoading
          ? const Loader(
              strokeWidth: 4,
              height: 35,
              width: 35,
            )
          : SafeArea(
              child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, boxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    titleSpacing: 10,
                    backgroundColor: Colors.grey[50],
                    collapsedHeight: getHeight(),
                    expandedHeight: getHeight(),
                    flexibleSpace: ProfileInfo(fromMainPage: widget.fromMainPage),
                  ),
                  SliverPersistentHeader(
                    delegate: PreferedSizeSliverDelegate(
                      color: Colors.grey[50],
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(icon: Icon(AppIcon.video.icon)),
                          Tab(icon: Icon(AppIcon.short.icon)),
                          if(widget.fromMainPage)
                          Tab(icon: Icon(AppIcon.favourite.icon)),
                        ],
                      ),
                    ),
                    floating: true,
                    pinned: true,
                  )
                ];
              },
              body: TabBarView(controller: _tabController, children: [
                VideoCardList<VideoDetailManager>(
                  config: CardConfig(
                      active: !context
                          .select((VideoDetailManager v) => v.isLoading),
                      paginate: false,
                      endText: "",
                      onPageEnd: () => manager.goToPage(
                          page: PageType.detail, videoType: VideoType.video)),
                ),
                VideoCardGrid<ShortDetailManager>(
                  config: CardConfig(
                      active: !context
                          .select((ShortDetailManager v) => v.isLoading),
                      paginate: false,
                      onPageEnd: () => manager.goToPage(
                          page: PageType.detail, videoType: VideoType.short)),
                ),
                if(widget.fromMainPage)
                VideoCardList<FavouriteDetailManager>(
                  config: CardConfig(
                      active: !context
                          .select((FavouriteDetailManager v) => v.isLoading),
                      paginate: false,
                      endText: "",
                      onPageEnd: () => manager.goToPage(
                          page: PageType.detail,
                          videoType: VideoType.favourite)),
                ),
              ]),
            )),
    );
  }
}

class PreferedSizeSliverDelegate extends SliverPersistentHeaderDelegate {
  PreferedSizeSliverDelegate({required this.child, this.color});
  final PreferredSizeWidget child;
  final Color? color;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
