class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: '   Vô vàng lựa chọn\n Thỏa mãn cơn thèm ',
      image: "images/welcome.jpg",
      title: '  Lựa chọn các món ăn\nTuyệt vời của chúng tôi'),
  UnboardingContent(
      description:
      'Thanh toán bằng tiền mặt khi nhận hàng \n         hoặc có thể thanh toán bằng thẻ',
      image: "images/purchase.png",
      title: 'Dễ dàng khi thanh toán '),
  UnboardingContent(
      description: ' Vận chuyển tận tâm\n Hàng đến tận giường',
      image: "images/pic_delivery.png",
      title: 'Giao hàng nhanh hơn\n cách NYC bạn trở mặt')
];
