
$(document).ready(function () {

	// 카테고리 도서 전체보기
	$(".bookAll").on('click', function(){
		$(this).addClass("bookType_focus");
		$(".book_ebook").removeClass("bookType_focus");
		$(".book_audiobook").removeClass("bookType_focus");
		$("#ebook_cate").hide();
		$("#audiobook_cate").hide();
	});
	
	// 카테고리 이펍 보기
	$(".book_ebook").on('click', function(){
		$(this).addClass("bookType_focus");
		$(".bookAll").removeClass("bookType_focus");
		$(".book_audiobook").removeClass("bookType_focus");
		$("#ebook_cate").show();
		$("#audiobook_cate").hide();
	});
	
	// 카테고리 오디오북 보기
	$(".book_audiobook").on('click', function(){
		$(this).addClass("bookType_focus");
		$(".bookAll").removeClass("bookType_focus");
		$(".book_ebook").removeClass("bookType_focus");
		$("#ebook_cate").hide();
		$("#audiobook_cate").show();
	});
	
	// 공지사항, FAQ 열고 닫기
	$(".Qcell_down").on("click",function(){
		$(this).parent().next().children().toggle();
		$(this).toggleClass("Qcell_up");
	});
	
	makeSelectBoxMadeView('make_select');
	document.addEventListener("click", closeAllSelect);

	// Swiper 캐러셀 초기화 (WWW 동일)
	$('.swiper-container').each(function(){
		var clen = $(this).find('.swiper-slide').length;
		if (clen >= 6) {
			new Swiper($(this), {
				pagination: $(this).find('.swiper-pagination'),
				paginationClickable: $(this).find('.swiper-pagination'),
				nextButton: $(this).find('.swiper-button-next'),
				prevButton: $(this).find('.swiper-button-prev'),
				slidesPerView : clen > 6 ? 6 : clen,
				slidesPerGroup : clen > 6 ? 6 : clen,
				loopFillGroupWithBlank: true,
				loop: true
			});
		}
	});
	
	// 도서 상세 정보 펼쳐보기 버튼 — 8줄(256px) 미만이면 감추고, 이상이면 표시
	var H1=$(".book_introduce .infoTxt").height();
	var H2=$(".book_series .cardList_thumbnail").height();
	var H3=$(".book_navi .infoTxt").height();
	var H4=$(".book_author .infoTxt").height();
	var H5=$(".book_publisherReview .infoTxt").height();
	var H6=$(".reportBody_txt").height();
	
	if (H1>256){
		$(".book_introduce .infoTxt").addClass("hidden");
		$(".book_introduce .infoTxt").next().show();
	}
	if (H2>256){
		$(".book_series .cardList_thumbnail").addClass("hidden");
		$(".book_series .cardList_thumbnail").next().show();
	}
	if (H3>256){
		$(".book_navi .infoTxt").addClass("hidden");
		$(".book_navi .infoTxt").next().show();
	}
	if (H4>256){
		$(".book_author .infoTxt").addClass("hidden");
		$(".book_author .infoTxt").next().show();
	}
	if (H5>256){
		$(".book_publisherReview .infoTxt").addClass("hidden");
		$(".book_publisherReview .infoTxt").next().show();
	}
	
	// 도서 감상문 펼쳐보기 버튼
	if (H6>16){
		$(".reportBody_txt").addClass("hidden");
		$(".reportBody_txt").next().show();
	}
	// 도서 상세 정보 펼쳐보기 접기
	$(".Unfold").on("click", function() {
		$(this).prev().toggleClass("fullHeight");
		$(this).text($(this).text()=="펼쳐보기"?"접기":"펼쳐보기").toggleClass("fold");
	});
	
	// 도서 감상문 리스트 더보기 접기
	$(".report_Unfold").on("click", function() {
		$(this).prev().toggleClass("report_fullHeight");
		$(this).text($(this).text()=="더보기"?"닫기":"더보기").toggleClass("report_fold");
	});
	
});
//카테고리 셀렉트 박스 재조합 
function makeSelectBoxMadeView(cssClassName) {
	// 커스텀 셀렉트박스 Start
	var x, i, j, l, ll, selElmnt, a, b, c;
	
	x = document.getElementsByClassName(cssClassName);
	l = x.length;
	
	if(l > 0) {
		oldDivs = x[0].getElementsByTagName("DIV");
		
		while(oldDivs[0]) {
			oldDivs[0].parentNode.removeChild(oldDivs[0]);
		}
	}

	for (i = 0; i < l; i++) {
		selElmnt = x[i].getElementsByTagName("select")[0];
		ll = selElmnt.length;
		
		a = document.createElement("DIV");
		a.setAttribute("class", "select-selected");
		a.innerHTML = selElmnt.options[selElmnt.selectedIndex].innerHTML;
		x[i].appendChild(a);
		
		b = document.createElement("DIV");
		b.setAttribute("class", "select-items select-hide");
		
		for (j = 1; j < ll; j++) {
			
			if(selElmnt.options[j].style.display != "none") {
				c = document.createElement("DIV");
				c.innerHTML = selElmnt.options[j].innerHTML;

				c.addEventListener("click", function(e) {

					var y, i, k, s, h, sl, yl;
					s = this.parentNode.parentNode.getElementsByTagName("select")[0];
					sl = s.length;
					h = this.parentNode.previousSibling;
					for (i = 0; i < sl; i++) {
						if (s.options[i].innerHTML == this.innerHTML) {
							s.selectedIndex = i;
							h.innerHTML = this.innerHTML;
							y = this.parentNode.getElementsByClassName("same-as-selected");
							yl = y.length;
							for (k = 0; k < yl; k++) {
								y[k].removeAttribute("class");
							}
							this.setAttribute("class", "same-as-selected");
							
							var event;
							if(typeof(Event) === 'function') {
								event = new Event('change');
							}else{
								event = document.createEvent('Event');
								event.initEvent('change', true, true);
							}
							
							s.dispatchEvent(event);
							break;
						}
					}
					h.click();
				});
				b.appendChild(c);
			}
		}
		x[i].appendChild(b);
		a.addEventListener("click", function(e) {
			
			e.stopPropagation();
			closeAllSelect(this);
			this.nextSibling.classList.toggle("select-hide");
			this.classList.toggle("select-arrow-active");
		});
	}
}

function closeAllSelect(elmnt) {
	/*a function that will close all select boxes in the document,
	except the current select box:*/
	var x, y, i, xl, yl, arrNo = [];
	x = document.getElementsByClassName("select-items");
	y = document.getElementsByClassName("select-selected");
	xl = x.length;
	yl = y.length;
	
	for (i = 0; i < yl; i++) {
		if (elmnt == y[i]) {
			arrNo.push(i)
		} else {
			y[i].classList.remove("select-arrow-active");
		}
	}
	for (i = 0; i < xl; i++) {
		if (arrNo.indexOf(i)) {
			x[i].classList.add("select-hide");
		}
	}
}
