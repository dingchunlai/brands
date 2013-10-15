/* 标签云效果 */
jQuery.fn.tagCloud = function() {
  var i = 0, j = 0, left_init = 8, left = left_init,
      heights = [[14, 10, 5, 8, 15], [65, 60, 67, 63, 74], [125, 128, 117, 119, 132]],
      colors = [[2, 1, 7, 3, 7], [5, 4, 8, 9, 9], [6, 3, 3, 2, 1]];

  this.addClass('tag_cloud').children('div').each(function(index) {
    if (j > 4) {
      ++i;
      if( i > 2 ) return;
      j = 0;
      left = left_init
    }
    $(this).css({left: left + 'px', top: heights[i][j] + 'px'}).addClass('color' + colors[i][j]).show()
    left = $(this).position().left + $(this).width() + 5;
    ++j;
  });
};
