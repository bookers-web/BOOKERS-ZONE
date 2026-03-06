$(function(){

    var $container = $('#container');

    // main_banner
    var $mainBanner = $container.find('#main .main_banner');

    // main_sect1
    var $sect1 = $container.find('#main .sect1'),
        $sect1Slider = $sect1.find('.sect1_slider');

    // 1. 내부 아이템 복제
    $sect1Slider.children().clone().appendTo($sect1Slider);

    // 2. 슬라이드 애니메이션 제어
    let pos = 0;
    let speed = 1.25;
    //let speed = .25;
    let req;

    function animateSlider() {
        pos -= speed;

        // 절반 이상 이동하면 처음으로 리셋 (원본 길이만큼만 루프)
        const resetPoint = $sect1Slider[0].scrollWidth / 2;
        if (Math.abs(pos) >= resetPoint) {
            pos = 0;
        }

        $sect1Slider.css('transform', 'translateX(' + pos + 'px)');
        req = requestAnimationFrame(animateSlider);
    }
    //
    // // 3. hover 시 멈춤
    // $sect1Slider.on('mouseenter', function () {
    //     cancelAnimationFrame(req);
    // });
    //
    // $sect1Slider.on('mouseleave', function () {
    //     animateSlider();
    // });

    // 4. 시작
    animateSlider();


    // totop
    $('#totop button').on('click',function(){
        window.scroll({
            top: 0,
            behavior: 'smooth',
        });
    });

});