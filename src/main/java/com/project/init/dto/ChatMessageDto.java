package com.project.init.dto;

public class ChatMessageDto {
	private String m_roomId;
	private String m_pubId;
	private String m_pubNick;
	private String m_subId;
	private String m_subNick;
	private String m_sendTime;
	private String m_pubImg;
	private String m_subImg;
	private int m_num;
	private String m_sendId;
	private String m_pubMsg;
	private String m_subMsg;
	
	public ChatMessageDto() {
		super();
	}

	public ChatMessageDto(String m_roomId, String m_pubId, String m_pubNick, String m_subId, String m_subNick,
			String m_sendTime, String m_pubImg, String m_subImg, int m_num, String m_sendId, String m_pubMsg,
			String m_subMsg) {
		super();
		this.m_roomId = m_roomId;
		this.m_pubId = m_pubId;
		this.m_pubNick = m_pubNick;
		this.m_subId = m_subId;
		this.m_subNick = m_subNick;
		this.m_sendTime = m_sendTime;
		this.m_pubImg = m_pubImg;
		this.m_subImg = m_subImg;
		this.m_num = m_num;
		this.m_sendId = m_sendId;
		this.m_pubMsg = m_pubMsg;
		this.m_subMsg = m_subMsg;
	}

	public String getM_roomId() {
		return m_roomId;
	}

	public void setM_roomId(String m_roomId) {
		this.m_roomId = m_roomId;
	}

	public String getM_pubId() {
		return m_pubId;
	}

	public void setM_pubId(String m_pubId) {
		this.m_pubId = m_pubId;
	}

	public String getM_pubNick() {
		return m_pubNick;
	}

	public void setM_pubNick(String m_pubNick) {
		this.m_pubNick = m_pubNick;
	}

	public String getM_subId() {
		return m_subId;
	}

	public void setM_subId(String m_subId) {
		this.m_subId = m_subId;
	}

	public String getM_subNick() {
		return m_subNick;
	}

	public void setM_subNick(String m_subNick) {
		this.m_subNick = m_subNick;
	}

	public String getM_sendTime() {
		return m_sendTime;
	}

	public void setM_sendTime(String m_sendTime) {
		this.m_sendTime = m_sendTime;
	}

	public String getM_pubImg() {
		return m_pubImg;
	}

	public void setM_pubImg(String m_pubImg) {
		this.m_pubImg = m_pubImg;
	}

	public String getM_subImg() {
		return m_subImg;
	}

	public void setM_subImg(String m_subImg) {
		this.m_subImg = m_subImg;
	}

	public int getM_num() {
		return m_num;
	}

	public void setM_num(int m_num) {
		this.m_num = m_num;
	}

	public String getM_sendId() {
		return m_sendId;
	}

	public void setM_sendId(String m_sendId) {
		this.m_sendId = m_sendId;
	}

	public String getM_pubMsg() {
		return m_pubMsg;
	}

	public void setM_pubMsg(String m_pubMsg) {
		this.m_pubMsg = m_pubMsg;
	}

	public String getM_subMsg() {
		return m_subMsg;
	}

	public void setM_subMsg(String m_subMsg) {
		this.m_subMsg = m_subMsg;
	}
	
}