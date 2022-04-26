package com.project.init.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.init.command.ChatRoomListCommand;
import com.project.init.command.ICommand;
import com.project.init.dao.ChatDao;
import com.project.init.dao.UserDao;
import com.project.init.dto.ChatMessageDto;
import com.project.init.dto.ChatRoomDto;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

@Controller
@RequestMapping(value = "/chat")
public class ChatRoomController {
	
	private ChatDao cdao;
	@Autowired
	public void setCdao(ChatDao cdao) {
		this.cdao = cdao;
		Constant.cdao = cdao;
	}
	
	private UserDao udao;
	@Autowired
	public void setUdao(UserDao udao) {
		this.udao = udao;
		Constant.udao = udao;
	}
	
	private ICommand mcom;
	
	@RequestMapping(value="/messages")
	public String messages(HttpServletRequest request, Model model){
		System.out.println("messages");
		mcom = new ChatRoomListCommand();
		mcom.execute(request, model);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		request.setAttribute("uId", uId);
		return "chat/messages";
	}
	
	@ResponseBody
	@RequestMapping(value="/searchNick")
	public UserDto searchNick(HttpServletRequest request) {
		System.out.println("searchNick");
		String nick = request.getParameter("nick");
		System.out.println(nick);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("nick", nick);
		map.put("uId", uId);
		
		UserDto result = udao.searchNick(map);
		return result;
	}
	
	@PostMapping(value="/croom")
	@ResponseBody
	public String create(@RequestParam String subNick, @RequestParam String subImg ) {
		System.out.println("# Create Chat Room, subNick: " + subNick + ", subImg: " + subImg);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		
		String subId = cdao.idFromNick(subNick);
		String pubId = user.getUsername();
		ChatRoomDto chkroom = new ChatRoomDto(0,null,pubId,subId,null,null,null,null,0,0,null,null,0,0,null,null);
		ChatRoomDto dto = cdao.checkChatRoom(chkroom);
		if(dto == null) {
			String pubNick = cdao.nickFromId(pubId);
			String roomId = UUID.randomUUID().toString();
			String pubImg = udao.searchImg(pubId);
			ChatRoomDto crdto = new ChatRoomDto(0,roomId,pubId,subId,pubImg,subImg,pubNick,subNick,0,0,null,null,0,0,null,null);
			cdao.createChatRoom(crdto);
			return "success";
		} 
		else if(dto.getPubExit().equals("t") || dto.getSubExit().equals("t")) {
			cdao.enterRoom(dto.getRoomId());
			return "상대방이 방존재";
		} else {
			return "existRoom";
		}
	}
	
	@PostMapping("/room")
	@ResponseBody
	public HashMap<String, Object> enterRoom(@RequestParam String roomId) {
		System.out.println("# enter Chat Room, roomID : " + roomId);
		ChatRoomDto cdto = cdao.getChatRoomDto(roomId);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		
		if(cdto.getPubId().equals(user.getUsername())) {
			ArrayList<ChatMessageDto> mdtos = cdao.getChatMsgDtoPub(roomId);
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("mdtos", mdtos);
			map.put("cdto", cdto);
			cdao.reSetPUnReadMsg(roomId);
			return map;
		} else {
			ArrayList<ChatMessageDto> mdtos = cdao.getChatMsgDtoSub(roomId);
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("mdtos", mdtos);
			map.put("cdto", cdto);
			cdao.reSetSUnReadMsg(roomId);
			return map;
		}
	}
	
	@PostMapping("/rmvRoomByPub")
	@ResponseBody
	public String rmvRoomByPub(@RequestParam String roomId) {
		System.out.println("rmvRoomByPub");
		ChatRoomDto dto = cdao.otherExitChk(roomId);
		if(dto.getPubExit().equals("t") || dto.getSubExit().equals("t")) {
			cdao.removeChatRoom(roomId);
			System.out.println("채팅방 완전 삭제");
			return "success";
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("roomId", roomId);
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			User user = (User)authentication.getPrincipal();
			map.put("uId", user.getUsername());
			cdao.pubExitRoom(map);
			System.out.println("pub채팅방 나감");
			return "success";
		}
	}

	@PostMapping("/rmvRoomBySub")
	@ResponseBody
	public String rmvRoomBySub(@RequestParam String roomId) {
		System.out.println("rmvRoomBySub");
		ChatRoomDto dto = cdao.otherExitChk(roomId);
		//문자열 비교시는 ==이 아닌 .equals()
		if(dto.getPubExit().equals("t") || dto.getSubExit().equals("t")) {
			cdao.removeChatRoom(roomId);
			System.out.println("채팅방 완전 삭제");
			return "success";
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("roomId", roomId);
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			User user = (User)authentication.getPrincipal();
			map.put("uId", user.getUsername());
			cdao.subExitRoom(map);
			System.out.println("sub채팅방 나감");
			return "success";
		}
	}
	
	@PostMapping("/resetUnreadMsg")
	@ResponseBody
	public String resetUnreadMsg(@RequestParam String roomId, @RequestParam String pubId, @RequestParam String subId) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		if(pubId.equals(user.getUsername())) {
			cdao.reSetPUnReadMsg(roomId);
			return "success";
		} else {
			cdao.reSetSUnReadMsg(roomId);
			return "success";
		}
	}
}