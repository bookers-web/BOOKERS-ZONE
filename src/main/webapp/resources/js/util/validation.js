function isValidName(name) {
    var regex = /^[가-힣]+$/;
    return regex.test(name);
}

function isValidPhoneNumber(phoneNumber) {
    var cleanedNumber = phoneNumber.replace(/-/g, '');

    // 한국 휴대폰 번호 정규식 (010으로 시작하는 11자리)
    var regex = /^01[0-9]{8,9}$/;

    return regex.test(cleanedNumber);
}