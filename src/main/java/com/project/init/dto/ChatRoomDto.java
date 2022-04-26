package com.project.init.dto;


public class ChatRoomDto {	
	private int roomNum;
	private String roomId;
	private String pubId;
	private String subId;
	private String pubImg;
	private String subImg;
	private String pubNick;
	private String subNick;
	private int pubExitNum;
	private int subExitNum;
	private String pubExit;
	private String subExit;
	private int pubUnReadMsg;
	private int subUnReadMsg;
	private String pubRecentMsg;
	private String subRecentMsg;
	
	private String chatRoom;
	private String roomImg;
	private int newMsgNum;
	private String recentMsg;
	
	public ChatRoomDto() {
		super();
	}

	public ChatRoomDto(int roomNum, String roomId, String pubId, String subId, String pubImg, String subImg,
			String pubNick, String subNick, int pubExitNum, int subExitNum, String pubExit, String subExit,
			int pubUnReadMsg, int subUnReadMsg, String pubRecentMsg, String subRecentMsg) {
		super();
		this.roomNum = roomNum;
		this.roomId = roomId;
		this.pubId = pubId;
		this.subId = subId;
		this.pubImg = pubImg;
		this.subImg = subImg;
		this.pubNick = pubNick;
		this.subNick = subNick;
		this.pubExitNum = pubExitNum;
		this.subExitNum = subExitNum;
		this.pubExit = pubExit;
		this.subExit = subExit;
		this.pubUnReadMsg = pubUnReadMsg;
		this.subUnReadMsg = subUnReadMsg;
		this.pubRecentMsg = pubRecentMsg;
		this.subRecentMsg = subRecentMsg;
	}

	public int getRoomNum() {
		return roomNum;
	}

	public void setRoomNum(int roomNum) {
		this.roomNum = roomNum;
	}

	public String getRoomId() {
		return roomId;
	}

	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	public String getPubId() {
		return pubId;
	}

	public void setPubId(String pubId) {
		this.pubId = pubId;
	}

	public String getSubId() {
		return subId;
	}

	public void setSubId(String subId) {
		this.subId = subId;
	}

	public String getPubImg() {
		return pubImg;
	}

	public void setPubImg(String pubImg) {
		this.pubImg = pubImg;
	}

	public String getSubImg() {
		return subImg;
	}

	public void setSubImg(String subImg) {
		this.subImg = subImg;
	}

	public String getPubNick() {
		return pubNick;
	}

	public void setPubNick(String pubNick) {
		this.pubNick = pubNick;
	}

	public String getSubNick() {
		return subNick;
	}

	public void setSubNick(String subNick) {
		this.subNick = subNick;
	}

	public String getChatRoom() {
		return chatRoom;
	}

	public void setChatRoom(String chatRoom) {
		this.chatRoom = chatRoom;
	}

	public String getRoomImg() {
		return roomImg;
	}

	public void setRoomImg(String roomImg) {
		this.roomImg = roomImg;
	}

	public int getPubExitNum() {
		return pubExitNum;
	}

	public void setPubExitNum(int pubExitNum) {
		this.pubExitNum = pubExitNum;
	}

	public int getSubExitNum() {
		return subExitNum;
	}

	public void setSubExitNum(int subExitNum) {
		this.subExitNum = subExitNum;
	}

	public String getPubExit() {
		return pubExit;
	}

	public void setPubExit(String pubExit) {
		this.pubExit = pubExit;
	}

	public String getSubExit() {
		return subExit;
	}

	public void setSubExit(String subExit) {
		this.subExit = subExit;
	}

	public int getPubUnReadMsg() {
		return pubUnReadMsg;
	}

	public void setPubUnReadMsg(int pubUnReadMsg) {
		this.pubUnReadMsg = pubUnReadMsg;
	}

	public int getSubUnReadMsg() {
		return subUnReadMsg;
	}

	public void setSubUnReadMsg(int subUnReadMsg) {
		this.subUnReadMsg = subUnReadMsg;
	}

	public String getPubRecentMsg() {
		return pubRecentMsg;
	}

	public void setPubRecentMsg(String pubRecentMsg) {
		this.pubRecentMsg = pubRecentMsg;
	}

	public String getSubRecentMsg() {
		return subRecentMsg;
	}

	public void setSubRecentMsg(String subRecentMsg) {
		this.subRecentMsg = subRecentMsg;
	}

	public int getNewMsgNum() {
		return newMsgNum;
	}

	public void setNewMsgNum(int newMsgNum) {
		this.newMsgNum = newMsgNum;
	}

	public String getRecentMsg() {
		return recentMsg;
	}

	public void setRecentMsg(String recentMsg) {
		this.recentMsg = recentMsg;
	}
	
}