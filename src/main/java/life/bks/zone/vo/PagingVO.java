package life.bks.zone.vo;

import java.util.List;

public class PagingVO extends CommonVO{

	private int endRow;
	
	private List<?> resultList;

	private int totalCount		= 0; // 페이징에 적용할 전체 데이터 갯수
	private int totalPage		= 0; // 전체 페이지 
	private int pagenum			= 1; // 현재 페이지 번호
	private int pageSize		= 10; // 한페이지에 몇개 표시할지
	private int startPage		= 1; // 현재 페이지 블록의 시작 페이지
	private int endPage			= 9; // 현재 페이지 블럭의 마지막 페이지
	private boolean prev		= true; // 이전 페이지로 가는 화살표
	private boolean next		= true; // 다음 페이지로 가는 화살표
	private int currentblock	= 1; // 현재 페이지 블록
	private int lastblock		= 10; // 마지막 페이지 블록
	private int firstPage		= 1; // 첫번째 페이지
	private int commonPageSize	= 50; // BOS 공통 추천 도서 한페이지에 몇개 표시할지
	private int totalBookCount 	= 0;

	private String deviceType;

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	private String mobileYn	= "N";
	public void prevnext(int pagenum) {
		// 이전 , 다음 페이지 블록
		if (mobileYn.equals("Y")) {
			if (calcpage(totalCount, pageSize) <= 5) {
				setPrev(false);
				setNext(false);
			} else if (pagenum > 0 && pagenum < 6) {
				setPrev(false);
				setNext(true);
			} else if (getLastblock() == getCurrentblock()) {
				setPrev(true);
				setNext(false);
			} else {
				setPrev(true);
				setNext(true);
			}
		} else {
		
			if (calcpage(totalCount, pageSize) <= 10) {
				setPrev(false);
				setNext(false);
			} else if (pagenum > 0 && pagenum < 11) {
				setPrev(false);
				setNext(true);
			} else if (getLastblock() == getCurrentblock()) {
				setPrev(true);
				setNext(false);
			} else {
				setPrev(true);
				setNext(true);
			}
		}
	}
	

	public int getTotalPage() {
		return totalPage;
	}
	public int getFirstPage() {
		return firstPage;
	}

	public int calcpage(int totalcount, int pageSize) { // 전체페이지 수를 계산하는 함수
		// 125 / 10 => 12.5
		// 13페이지
		if (mobileYn.equals("Y")) {
			totalPage = totalcount / pageSize;
			
			if (totalcount % pageSize > 0) {
				totalPage++;
			}
		}else {
			totalPage = totalcount / pageSize;
			if (totalcount % pageSize > 0) {
				totalPage++;
			}
		}
		return totalPage;
	}

	public int getPagenum() {
		return pagenum;
	}

	public void setPagenum(int pagenum) {
		this.pagenum = pagenum;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int currentblock) {
		if ((this.mobileYn).equals("Y")) {
			this.startPage = (currentblock * 5) - 4;
		} else {
			this.startPage = (currentblock * 10) - 9;
		}	
		
		/*
		 * 1 // 1 2 3 4 5 2 // 6 7 8 9 10 3 // 11 12 13
		 */
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int getlastblock, int getcurrentblock) {
		// 마지막 페이지 블록을 구하는 곳
		if ((this.mobileYn).equals("Y")) {
			if (getlastblock == getcurrentblock) {
				this.endPage = calcpage(getTotalCount(), getPageSize()); // 전체페이지 개수가 오는곳
			} else if (getTotalCount() == 0) {
				this.endPage = 0;
			} else {
				this.endPage = getStartPage() + 4;
			}
		} else {
			if (getlastblock == getcurrentblock) {
				this.endPage = calcpage(getTotalCount(), getPageSize()); // 전체페이지 개수가 오는곳
			} else if (getTotalCount() == 0) {
				this.endPage = 0;
			} else {
				this.endPage = getStartPage() + 9;
			}
		}
		
	}

	public boolean isPrev() {
		return prev;
	}

	public void setPrev(boolean prev) {
		this.prev = prev;
	}

	public boolean isNext() {
		return next;
	}

	public void setNext(boolean next) {
		this.next = next;
	}

	public int getCurrentblock() {
		return currentblock;
	}

	public void setCurrentblock(int pagenum) {
		// 현재페이지 블록 구하는 곳 페이지 번호를 통해서 구한다.
		// 페이지 번호 / 페이지 그룹안의 페이지 개수
		// 1p => 1 / 5 => 0.2 + 1 = 현재 페이지블록 1
		// 3p => 3 / 5 => 0.xx + 1 = 현재 페이지 블록 1
		if ((this.mobileYn).equals("Y")) {
			this.currentblock = pagenum / 5;
			if (pagenum % 5 > 0) {
				this.currentblock++;
			}
		} else {
			this.currentblock = pagenum / 10;
			if (pagenum % 10 > 0) {
				this.currentblock++;
			}
		}
	}

	public int getLastblock() {
		return lastblock;
	}

	public void setLastblock(int lastblock) {
		// 10 , 5 = > 10 * 5 => 50
		// 12 5 / 50
		// 3
		if ((this.mobileYn).equals("Y")) {
			this.lastblock = totalCount / (5 * this.pageSize);

			if (totalCount % (5 * this.pageSize) > 0) {
				this.lastblock++;
			}
		} else {
			this.lastblock = totalCount / (10 * this.pageSize);

			if (totalCount % (10 * this.pageSize) > 0) {
				this.lastblock++;
			}
		}
		 
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public List<?> getResultList() {
		return resultList;
	}

	public void setResultList(List<?> resultList) {
		this.resultList = resultList;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		if ((this.mobileYn).equals("Y")) {

			this.totalCount = totalCount;

			totalPage = totalCount / 5;
			if (totalCount % 5 > 0) {
				totalPage++;
			}
		} else {
			this.totalCount = totalCount;
			
			totalPage = totalCount / pageSize;
			if (totalCount % pageSize > 0) {
				totalPage++;
			}
		}
	}

	public int getCommonPageSize() {
		return commonPageSize;
	}

	public void setCommonPageSize(int commonPageSize) {
		this.commonPageSize = commonPageSize;
	}
	public int setTotalBookCount() {
		return totalBookCount;
	}

	public String getMobileYn() {
		return mobileYn;
	}

	public void setMobileYn(String mobileYn) {
		this.mobileYn = mobileYn;
	}
}
