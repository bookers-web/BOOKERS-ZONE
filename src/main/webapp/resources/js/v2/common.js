$(function(){

    var $html = $('html'),
        $header = $('#header');

    // gnb
    var $gnbTogg = $header.find('.gnb_toggle button');

    $gnbTogg.on('click',function(){
        var $this = $(this);
        if($html.is('.gnb_open')){
            $html.removeClass('gnb_open');
            $this.text('메뉴 열기');
        }else{
            $html.addClass('gnb_open');
            $this.text('메뉴 닫기');
        }
    })

    // FloatingScl
    FloatingScl();
    $(window).on('resize scroll',function(){
        FloatingScl();
    });

    function FloatingScl(){
        var $floating = $('.floating');
        $floating.css('opacity',0);
        if (window.scrollY > 0) $floating.css('opacity', 1);
    }
});