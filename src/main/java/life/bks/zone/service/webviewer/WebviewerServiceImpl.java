package life.bks.zone.service.webviewer;

import life.bks.zone.domain.WebviewerBook;
import life.bks.zone.dto.WebviewerResponse;
import life.bks.zone.mapper.bookers.WebviewerMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class WebviewerServiceImpl implements WebviewerService {

    private final WebviewerMapper webviewerMapper;
    private final DrmTokenService drmTokenService;

    @Override
    @Transactional(transactionManager = "bookersTransactionManager")
    public WebviewerResponse processWebviewer(String ucmCode, String umeCode, String umCode, String uisCode) {
        WebviewerBook requestBook = new WebviewerBook();
        requestBook.setUcmCode(ucmCode);
        requestBook.setUcmCode2(ucmCode);
        requestBook.setUmeCode(umeCode);
        requestBook.setUmCode(umCode);
        requestBook.setUisCode(uisCode);

        try {
            WebviewerBook bookDetail = webviewerMapper.selectBookDetail(ucmCode);
            if (bookDetail == null) {
                return WebviewerResponse.builder().count(0).resultMsg("해당 도서를 불러오지 못했습니다. 부커스에 문의 주세요.(0)").build();
            }

            int libraryResult = syncMemberLibrary(requestBook);
            if (libraryResult != 1) {
                return WebviewerResponse.builder().count(0).resultMsg("서재를 조회할 수 없습니다.").build();
            }

            WebviewerBook statusBook = webviewerMapper.selectMemberLibraryBook(umCode, ucmCode);

            HashMap<String, Object> param = new HashMap<>();
            param.put("I_UIS_CODE", uisCode);
            param.put("I_UCM_CODE", bookDetail.getUcmCode());
            param.put("I_UM_CODE", umCode);
            param.put("I_UMD_CODE", "UMD0000000002");
            param.put("I_ORDER_TYPE", 'T');
            param.put("O_ORDER_CODE", "");
            param.put("O_PRODUCT_CODE", "");
            param.put("O_STARTDATE", "");
            param.put("O_ENDDATE", "");
            param.put("O_DRMTYPE", "");
            param.put("RESULT", 0);

            webviewerMapper.callGetLicense(param);
            int result = Integer.parseInt(param.get("RESULT").toString());

            if (result == 1) {
                DrmTokenService.BookInfo bookInfo = DrmTokenService.BookInfo.builder()
                        .bcode(bookDetail.getUcmCode())
                        .sbcode("WEB" + bookDetail.getUcpCode())
                        .title(bookDetail.getTitle())
                        .writer(bookDetail.getWriter())
                        .publisher(bookDetail.getPublisher())
                        .cover(bookDetail.getCoverUrl())
                        .ft(bookDetail.getFileType())
                        .lcd(uisCode)
                        .ot("T")
                        .build();

                String viewerUrl = drmTokenService.generateViewerUrl(bookInfo, umCode);
                String resolvedUmeCode = statusBook != null ? statusBook.getUmeCode() : requestBook.getUmeCode();
                return WebviewerResponse.builder().count(1).resultMsg(viewerUrl).umeCode(resolvedUmeCode).build();
            }

            return mapLicenseFailResult(result, statusBook);
        } catch (NullPointerException e) {
            log.error("webviewer processing null pointer", e);
            return WebviewerResponse.builder().count(0).resultMsg("해당 도서를 불러오지 못했습니다. 부커스에 문의 주세요.(0)").build();
        } catch (UnsupportedEncodingException e) {
            log.error("webviewer token encoding failed", e);
            return WebviewerResponse.builder().count(0).resultMsg("주문 처리 중 오류가 발생하였습니다.(908)").build();
        } catch (Exception e) {
            log.error("webviewer processing failed", e);
            return WebviewerResponse.builder().count(0).resultMsg("알 수 없는 오류가 발생하였습니다. 부커스에 문의 주세요.").build();
        }
    }

    private int syncMemberLibrary(WebviewerBook requestBook) {
        int resultCount = 0;

        if (requestBook.getUmeCode() == null || requestBook.getUmeCode().isEmpty()) {
            int libraryExist = webviewerMapper.countMemberLibrary(requestBook.getUmCode());
            if (libraryExist == 0) {
                requestBook.setSeqName("MEMBER_LIBRARY_SEQ");
                webviewerMapper.getSequence(requestBook);
                requestBook.setUmlCode(Integer.toString(requestBook.getSeqCurrval()));

                resultCount = webviewerMapper.insertLibrary(requestBook);
                if (resultCount == 1) {
                    requestBook.setSeqName("MEMBER_LIBRARY_BOOK_SEQ");
                    webviewerMapper.getSequence(requestBook);
                    requestBook.setUmeCode(Integer.toString(requestBook.getSeqCurrval()));
                    resultCount = webviewerMapper.insertLibraryBook(requestBook);
                    if (resultCount == 1) {
                        resultCount = webviewerMapper.updateReadCount(requestBook.getUcmCode());
                    }
                }
            } else {
                WebviewerBook memberLibrary = webviewerMapper.selectMemberLibrary(requestBook.getUmCode());
                if (memberLibrary == null) {
                    return 0;
                }
                requestBook.setUmlCode(memberLibrary.getUmlCode());

                int libraryBookExist = webviewerMapper.countMemberLibraryBook(requestBook.getUmlCode(), requestBook.getUcmCode());
                if (libraryBookExist == 0) {
                    requestBook.setSeqName("MEMBER_LIBRARY_BOOK_SEQ");
                    webviewerMapper.getSequence(requestBook);
                    requestBook.setUmeCode(Integer.toString(requestBook.getSeqCurrval()));
                    requestBook.setUmeUmlCode(requestBook.getUmlCode());
                    resultCount = webviewerMapper.insertOnlyLibraryBook(requestBook);
                    if (resultCount == 1) {
                        resultCount = webviewerMapper.updateReadCount(requestBook.getUcmCode());
                    }
                } else {
                    WebviewerBook statusBook = webviewerMapper.selectMemberLibraryBook(requestBook.getUmCode(), requestBook.getUcmCode());
                    if (statusBook == null) {
                        return 0;
                    }
                    requestBook.setUmeStatus("A");
                    requestBook.setUmeCode(statusBook.getUmeCode());
                    resultCount = webviewerMapper.updateLibraryBookStatus(requestBook);
                }
            }
        } else {
            WebviewerBook statusBook = webviewerMapper.selectMemberLibraryBook(requestBook.getUmCode(), requestBook.getUcmCode());
            if (statusBook == null) {
                return 0;
            }
            requestBook.setLastStatus(statusBook.getLastStatus());
            requestBook.setUmeStatus("A");
            resultCount = webviewerMapper.updateLibraryBookStatus(requestBook);
        }

        return resultCount;
    }

    private WebviewerResponse mapLicenseFailResult(int result, WebviewerBook statusBook) {
        if (result == -1) {
            return WebviewerResponse.builder().count(0).resultMsg("판매중지된 도서이거나 해당 도서가 존재하지 않습니다.(900)").build();
        }
        if (result == -2) {
            return WebviewerResponse.builder().count(0).resultMsg("이용 기관의 이용이 일시 정지된 상태입니다.(901)").build();
        }
        if (result == -3) {
            return WebviewerResponse.builder().count(0).resultMsg("이용 기관의 계약이 만료된 상태입니다. 이용 기관의 담당자에게 문의 바랍니다.(902)").build();
        }
        if (result == -4) {
            return WebviewerResponse.builder().count(0).resultMsg("이용자의 월간 대여 횟수가 초과되었습니다. 다음 달에 이용 바랍니다.(903)").build();
        }
        if (result == -5) {
            return WebviewerResponse.builder().count(0).resultMsg("이용 기관의 월간 대여 횟수가 초과되었습니다. 다음 달에 이용 바랍니다.(904)").build();
        }
        if (result == -6) {
            return WebviewerResponse.builder()
                    .count(0)
                    .resultMsg("해당 도서는 일시적으로 다운로드가 중단되었습니다.(909)")
                    .umeCode(statusBook != null ? statusBook.getUmeCode() : null)
                    .build();
        }
        if (result == -7) {
            return WebviewerResponse.builder().count(0).resultMsg("해당 도서는 가격정책에 위배 되는 콘텐츠 입니다.(912)").build();
        }
        if (result == -8) {
            return WebviewerResponse.builder().count(0).resultMsg("해당 도서는 금일 대출 권수를 초과 하였습니다. 내일 다시 이용 바랍니다.(913)").build();
        }
        if (result == -9) {
            return WebviewerResponse.builder().count(0).resultMsg("대출가능한 전자책 대출 권수를 초과 하였습니다. 다음달에 다시 이용해 주세요.(915)").build();
        }
        if (result == -10) {
            return WebviewerResponse.builder().count(0).resultMsg("대출가능한 오디오북 대출 권수를 초과 하였습니다. 다음달에 다시 이용해 주세요.(914)").build();
        }
        if (result == -11) {
            return WebviewerResponse.builder().count(0).resultMsg("금일 대출가능한 권수를 초과 하였습니다. 내일 다시 이용해 주세요.(917)").build();
        }
        if (result == -98) {
            return WebviewerResponse.builder().count(0).resultMsg("이용자가 이용이 일시 정지된 상태입니다.(905)").build();
        }
        if (result == -99) {
            return WebviewerResponse.builder().count(0).resultMsg("이용자의 기기가 등록된 기기가 아닙니다.(906)").build();
        }
        if (result == -100) {
            return WebviewerResponse.builder().count(0).resultMsg("주문 처리 중 오류가 발생하였습니다.(907)").build();
        }
        return WebviewerResponse.builder().count(0).resultMsg("주문 처리 중 오류가 발생하였습니다.(908)").build();
    }
}
