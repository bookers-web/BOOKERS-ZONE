/**___________________________________________________________________________________
@author WolfHaru/2012
@link http://wolfharu.tistory.com
@version 0.1
___________________________________________________________________________________**/

$.fn.WolfHaruSlider = function() {
	$(this).each(function(index) {
		var currentPage = 1;
		var SliderId = 'WolfHaruSlider_' + index;
		var SliderDevice = false;
		var $WolfHaruSliderSwipe, $SliderBtnL, $SliderBtnR;
		
		if ( (navigator.userAgent.toLowerCase().indexOf("iphone") != -1) || (navigator.userAgent.toLowerCase().indexOf("ipod") != -1) || (navigator.userAgent.toLowerCase().indexOf("ipad") != -1) || (navigator.userAgent.toLowerCase().indexOf("android") != -1) ) {
			SliderDevice = true;
		}

		var $SliderList = $(this).find('ul.WolfHaruSliderImgList');		
		$SliderList.wrap('<div class="WolfHaruSliderImgContentMove" id="'+SliderId+'"></div>');

		var $SliderBox = $('#'+SliderId);
		var $SliderItem = $SliderList.find('li');
		var SliderItemTotal = $SliderItem.length;
		
		var fnNavImg = function(a) {
			$SliderBtnR.insertAfter($WolfHaruSliderSwipe).unbind('click');
			$SliderBtnL.insertAfter($WolfHaruSliderSwipe).unbind('click');

			$SliderBtnL.click(function() {movePage(a-1,200)});
			$SliderBtnR.click(function() {movePage(a+1,200)});

			$WolfHaruSliderSwipe.find('span').removeClass('on').eq(a).addClass('on');
		}
		
		var moveFlicking = function(c) {
			if(c>0&&currentPage<(SliderItemTotal-1)) {
				currentPage++;
			}else{
				if(c<0&&currentPage>0){
					currentPage--;
				}
			}
			movePage(currentPage,100);
		}		
		
		var movePage=function(a,b){
			currentPage=a;
			moveContainer(a*-100+"%",b);;
		};
		
		var moveContainer = function(b,a) {
			if(!a){a=0}
			$SliderList.animate({'left':b},{duration:a,complete:function() {
				if ( currentPage < 1) {
					currentPage = SliderItemTotal-2;
					$SliderList.css({'left':(-100*currentPage)+'%'})
				} else if ( currentPage >= SliderItemTotal-1 ) {
					currentPage =1;
					$SliderList.css({'left':(-100*currentPage)+'%'})
				}
				fnNavImg(currentPage);
			}});
		}
		
		if ( SliderItemTotal > 0 ) { $SliderItem.eq(0).find('img').clone().insertAfter($SliderList).attr('alt','').addClass('WolfHaruSliderImgDefault'); }
		if ( SliderItemTotal > 1 ) {
			$SliderItem.eq(0).clone().appendTo($SliderList);
			$SliderItem.eq(SliderItemTotal-1).clone().prependTo($SliderList);
			$SliderItem = $SliderList.find('li');
			SliderItemTotal = $SliderItem.length;
			$SliderItem.each(function(index) {
				$(this).css({'left':(index*100)+'%'})
			});
			$SliderList.css({'left':(-100*currentPage)+'%'});
			
			$('<div class="WolfHaruSliderSwipe"></div>').insertAfter($SliderBox);
			$WolfHaruSliderSwipe = $SliderBox.next('.WolfHaruSliderSwipe');
			for ( var i=0; i<SliderItemTotal; i++ ) {
				$('<span><em>'+i+'</em></span>').data('clickNum',i).appendTo($WolfHaruSliderSwipe).click(function(){
					movePage($(this).data('clickNum'),100);
				});
			}
			$WolfHaruSliderSwipe.find('span').filter(':first-child,:last-child').text('').hide()
			$SliderBtnL = $('<span class="WolfHaruSliderBtn WolfHaruSliderBtnPrev">Prev</span>');
			$SliderBtnR = $('<span class="WolfHaruSliderBtn WolfHaruSliderBtnNext">Next</span>');
			fnNavImg(currentPage);
		}
		
		if ( SliderDevice ) {
			var FlickingWrapWidth;
			var isNewTouch = true;
			var isFlicking = false;
			var TouchCT = {};
						
			var WolfHaruSliderTouchStart = function(e) {
				var startTouch = e.touches[0];
				TouchCT.startX = startTouch.screenX;
				TouchCT.startY = startTouch.screenY;
				TouchCT.startTime = Date.now();
			}
			var WolfHaruSliderTouchMove = function(e) {
				FlickingWrapWidth = $SliderBox.width();
				var moveTouch = e.touches[0];
				
				if ( isNewTouch ) {
					if(Math.abs(TouchCT.startX-moveTouch.screenX)>Math.abs(TouchCT.startY-moveTouch.screenY)){
						isFlicking=true;
					}
					isNewTouch = false;
				}
				
				if ( isFlicking ) { 
					event.preventDefault();
					var cWrapMove = ((TouchCT.startX-moveTouch.screenX)/FlickingWrapWidth+currentPage)*-100;
					moveContainer(cWrapMove+'%');
				}
			}
			var WolfHaruSliderTouchEnd = function(e) {
				if( isFlicking ){
			
					var endTouch = e.changedTouches[0];
					var ex = Math.abs(TouchCT.startX-endTouch.screenX);
					var ey = Math.abs(TouchCT.startY-endTouch.screenY);
			
					if(ex>FlickingWrapWidth/2 || (Date.now()-TouchCT.startTime<500&&ex*2>ey&&ex>50)) {
//						alert(1)
						moveFlicking(TouchCT.startX-endTouch.screenX);
					} else {
//						alert(2);
						movePage(currentPage,200);
					}
					
					isFlicking = false;
				}
				isNewTouch = true;
			}
			eval(SliderId + '.addEventListener("touchstart",WolfHaruSliderTouchStart,false)');
			eval(SliderId + '.addEventListener("touchmove",WolfHaruSliderTouchMove,false)');
			eval(SliderId + '.addEventListener("touchend",WolfHaruSliderTouchEnd,false)');
		}
		
	});
	return this;
}