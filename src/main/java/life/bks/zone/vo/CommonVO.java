package life.bks.zone.vo;

public class CommonVO {
	
	private String seq_name			= "";
	private int seq_currval			= 0;
	
	
	
	public int getSeq_currval() {
		return seq_currval;
	}
	public void setSeq_currval(int seq_currval) {
		this.seq_currval = seq_currval;
	}
	public String getSeq_name() {
		return seq_name;
	}
	public void setSeq_name(String seq_name) {
		this.seq_name = seq_name;
	}
}
