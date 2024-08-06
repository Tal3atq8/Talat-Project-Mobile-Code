import 'package:talat/src/theme/image_constants.dart';

class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title;
  }

  String? getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod");
  sliderModel.setTitle("Find Nearby Tent");
  sliderModel.setImageAssetPath(ImageConstant.userGuideSliderFirst);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod");
  sliderModel.setTitle("Find Nearby Activities");
  sliderModel.setImageAssetPath(ImageConstant.userGuideSliderSecond);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod");
  sliderModel.setTitle("Don’t Miss Winter Camping");
  sliderModel.setImageAssetPath(ImageConstant.userGuideSliderThird);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
