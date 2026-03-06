function setOnlyNumber(e) {
    var cstmTxt = e.value.replace(/[^\d]/g, '');
    if (e.value != cstmTxt) {
        alert('숫자만 입력해주세요');
        e.value = cstmTxt;
    }
}

function setMobileOnlyNumber(e) {
    var cstmTxt = e.value.replace(/[^\d]/g, '');
    if (e.value != cstmTxt) {
        $('#chk_agree').focus();
        $(".popup-wrap").css('display', 'block');
        $("#popup-message").text("숫자만 입력해주세요.");
        e.value = cstmTxt;
    }
}