import 'dart:math';



abstract class ImageUrl{
  static final random =Random();

  static String  randomPictureUrl(){
    final randInt =random.nextInt(20);
    return 'http://picsum.photos/seed/$randInt/80/80';
  }

}