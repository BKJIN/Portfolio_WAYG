package com.project.init.dao;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.init.dto.ChatMessageDto;
import com.project.init.dto.ChatRoomDto;
import com.project.init.util.Constant;

@Component
public class ChatDao implements ChatIDao {
	@Autowired
	private SqlSession sqlSession;
	
	
	public ChatDao(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
		Constant.cdao = this;
	}
	
	@Override
	public String idFromNick(String subNick) {
		String subId = sqlSession.selectOne("idFromNick",subNick);
		return subId;
	}
	
	@Override
	public String nickFromId(String pubId) {
		String pubNick =sqlSession.selectOne("nickFromId",pubId);
		return pubNick;
	}
	
	@Override
	public ChatRoomDto checkChatRoom(ChatRoomDto chkroom) {
		ChatRoomDto dto = sqlSession.selectOne("checkChatRoom",chkroom);
		return dto;
	}
	
	@Override
	public void createChatRoom(ChatRoomDto crdto) {
		sqlSession.insert("createChatRoom",crdto);
	}

	@Override
	public ArrayList<ChatRoomDto> chatRoomList(String id) {
		ArrayList<ChatRoomDto> result = (ArrayList)sqlSession.selectList("chatRoomList",id);
		return result;
	}

	@Override
	public ChatRoomDto getChatRoomDto(String roomId) {
		ChatRoomDto result = sqlSession.selectOne("getChatRoomDto",roomId);
		return result;
	}

	@Override
	public ArrayList<ChatMessageDto> getChatMsgDtoPub(String roomId) {
		ArrayList<ChatMessageDto> result = (ArrayList)sqlSession.selectList("getChatMsgDtoPub",roomId);
		return result;
	}

	@Override
	public ArrayList<ChatMessageDto> getChatMsgDtoSub(String roomId) {
		ArrayList<ChatMessageDto> result = (ArrayList)sqlSession.selectList("getChatMsgDtoSub",roomId);
		return result;
	}

	@Override
	public void saveMsg(ChatMessageDto message) {
		sqlSession.insert("saveMsg",message);
	}

	@Override
	public ChatRoomDto otherExitChk(String roomId) {
		ChatRoomDto dto = sqlSession.selectOne("otherExitChk",roomId);
		return dto;
	}

	@Override
	public void removeChatRoom(String roomId) {
		sqlSession.delete("removeChatRoom",roomId);
	}

	@Override
	public void pubExitRoom(Map<String, Object> map) {
		sqlSession.update("pubExitRoom",map);
	}

	@Override
	public void subExitRoom(Map<String, Object> map) {
		sqlSession.update("subExitRoom",map);
	}

	@Override
	public void enterRoom(String roomId) {
		sqlSession.update("enterRoom",roomId);
	}

	@Override
	public void addUnReadMsg(ChatMessageDto message) {
		sqlSession.update("addUnReadMsg",message);
	}

	@Override
	public void reSetPUnReadMsg(String roomId) {
		sqlSession.update("reSetPUnReadMsg",roomId);
	}

	@Override
	public void reSetSUnReadMsg(String roomId) {
		sqlSession.update("reSetSUnReadMsg",roomId);
	}

	@Override
	public void saveRecentMsg(ChatMessageDto message) {
		sqlSession.update("saveRecentMsg",message);
	}

}