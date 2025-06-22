import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';
import 'package:dr_fit/features/recipe/presentation/widgets/ingridient_tile.dart';
import 'package:dr_fit/features/recipe/presentation/widgets/step_tile.dart';
import 'package:dr_fit/features/recipe/presentation/screen/full_screen_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/component.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe data;

  const RecipeDetailPage({
    super.key,
    required this.data,
  });

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;
  Color appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController?.addListener(() {
      changeAppBarColor(_scrollController!);
    });
  }

  void changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 4.0) {
        setState(() {
          appBarColor =
              PrimaryColor(context); // Change this to your desired appBar color
        });
      } else {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AnimatedContainer(
          color: appBarColor,
          duration: Duration(milliseconds: 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                context.read<RecipeCubit>().fetchHealthyRecipes();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              BlocBuilder<RecipeCubit, RecipeState>(
                builder: (context, state) {
                  final user = _auth.currentUser;
                  if (user == null) return SizedBox();

                  return StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('favoritesRecipes') // ✅ بدل 'favorites'
                        .doc(user.uid)
                        .collection('recipe') // ✅ بدل 'exercises'
                        .doc(widget.data.id.toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      final isFavorite = snapshot.data?.exists ?? false;
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context
                              .read<RecipeCubit>()
                              .toggleFavorite(widget.data);
                          showToast(
                              text: isFavorite
                                  ? 'تمت الإزالة بنجاح'
                                  : 'تمت الاضافه بنجاح',
                              state: ToastStates.SUCCESS);
                        },
                      );
                    },
                  );
                },
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1: Recipe Image
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    image: Image.network(widget.data.image),
                  ),
                ),
              );
            },
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.data.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2: Recipe Info (Calories, Time, Title, Description)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            color: buttonPrimaryColor(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calories and Time
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.deepOrange,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        'Calories: ${widget.data.caloriesPerServing}',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.alarm,
                      size: 14,
                      color: Colors.green,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        '${widget.data.cookTimeMinutes + (widget.data.prepTimeMinutes)} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Recipe Title
                Container(
                  margin: EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    widget.data.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TabBar (Ingredients, Tutorial)
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: PrimaryColor(context),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController?.index = index;
                });
              },
              labelColor:  textColor(context),
              unselectedLabelColor:  textColor(context).withOpacity(0.6),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              indicatorColor: textColor(context),
              tabs: [
                Tab(text: 'طريقة التحضير'),
                Tab(text: 'المكونات'),
              ],
            ),
          ),
          // IndexedStack to show content based on active tab
          IndexedStack(
            textDirection: TextDirection.rtl,
            index: _tabController?.index,
            children: [
              // Tutorial (Steps) List
              StepTile(
                data: widget.data.instructions,
              ),
              // Ingredients List
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.data.ingredients.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return IngridientTile(
                    data: widget.data.ingredients[index],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
