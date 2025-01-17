import 'package:buy_or_bye/model/fng_index_model.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:buy_or_bye/utils/date_utils.dart';
import 'package:buy_or_bye/utils/status_utils.dart';

class PastStat extends StatelessWidget {
  final darkColor;
  final lightColor;
  final fontColor;
  final Rating recentRating = Rating.extremeFear;

  // final Rating recentRating2 = Rating.fear;

  const PastStat({
    super.key,
    required this.darkColor,
    required this.lightColor,
    required this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<Isar>()
            .fngIndexModels
            .filter()
            .ratingEqualTo(recentRating)
            .sortByDateTimeDesc()
            .limit(364)
            .findAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final fngIndexModels = StatusUtils.uniqueDate(
            initialList: snapshot.data!,
          );

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: lightColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: darkColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        '최근 ${recentRating.krName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children:
                          //List.generate(24, (index) =>
                          fngIndexModels
                              .map(
                                (fngIndexModel) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        DateUtils.DateTimeToString(
                                            dateTime: fngIndexModel.dateTime),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '😨',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${fngIndexModel.index.round().toInt()} / 100',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
