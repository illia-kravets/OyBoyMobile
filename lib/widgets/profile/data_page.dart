import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "/constants/export.dart";
import "/widgets/export.dart";
import "/data/export.dart";

class DataPage<T extends FilterCRUDManager> extends StatelessWidget {
  const DataPage({ Key? key, required this.videoType, required this.appBarTitle}) : super(key: key);

  final VideoType videoType;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      appBar: DetailDataAppBar(appBarTitle: appBarTitle,),
      endDrawer: FilterDrawer<T>(),
      body: Column(
        children: [
          FiltersRow<T>(),
          Expanded(
            child: GenericCardList<T>(
              scrollableType: videoType == VideoType.short ? ScrollableType.grid : ScrollableType.list,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailDataAppBar<T extends SearchVideoGeneric> extends StatelessWidget implements PreferredSizeWidget {
  const DetailDataAppBar({ Key? key, required this.appBarTitle }) : super(key: key);
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    
    return AppBar(
      leading: GestureDetector(
        onTap: () => context.read<ProfileManager>().goToPage(),
        child: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      title: Text(
        appBarTitle,
        style: theme.textTheme.headline4,
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () => Scaffold.of(context).openEndDrawer(), 
          child: Icon(Icons.filter_alt, 
          color: theme.primaryColor)
        ),
        const SizedBox(width: 8,)
      ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}