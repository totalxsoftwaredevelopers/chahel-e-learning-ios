import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';

class SquareStackContainer extends StatelessWidget {
  const SquareStackContainer({
    super.key,
    required this.content,
    required this.image,
  });
  final String content;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: 98,
          width: 98,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(10, 5))
            ],
            borderRadius: BorderRadius.circular(24),
            // image: DecorationImage(
            //     image: NetworkImage(image), fit: BoxFit.cover, opacity: 0.7),
          ),
          child: Opacity(
              opacity: 0.7, child: CustomCachedNetworkImage(image: image)),
        ),
        Positioned(
          right: 0,
          child: Center(
            child: Container(
              width: 75,
              height: 30,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(5, 0))
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7.9),
                    topLeft: Radius.circular(7.9),
                  ),
                  color: ConstantColors.syllabusStackColor),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        color: ConstantColors.headingBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
