$(function () {
  // banner按钮位置
  $('.swiper1 .swiper-button-prev').css('left', '1.355733rem')
  $('.swiper1 .swiper-button-next').css('left', '2.153067rem')

  // 头部进度条
  // 页面总高
  var totalH =
    document.body.scrollHeight || document.documentElement.scrollHeight
  // 可视高
  var clientH = window.innerHeight || document.documentElement.clientHeight
  window.addEventListener('scroll', function (e) {
    // 计算有效高
    var validH = totalH - clientH
    // 滚动条卷去高度
    var scrollH = document.body.scrollTop || document.documentElement.scrollTop
    // 百分比
    var result = ((scrollH / validH) * 100).toFixed(2)
    // console.log(totalH,clientH,validH,scrollH)
    $('.jdt').css('width', result + '%')
  })
  // $('window').scroll(function () {
  //   $('.header').css('width', result)
  // })

  // 引导页
  setTimeout(function () {
    $('body').css('overflow', 'auto')
    $('.qguide').fadeOut()
  }, 500)
})
