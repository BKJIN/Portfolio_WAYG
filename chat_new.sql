CREATE TABLE chatRoom(
 roomNum    number(10),
 roomId     varchar2(200) primary key,
 pubId      varchar2(50) not null,
 subId      varchar2(50) not null,
 pubImg     varchar2(300),
 subImg     varchar2(300),
 pubNick    varchar2(70),
 subNick    varchar2(70) 
);

CREATE SEQUENCE CHAT_ROOM_SEQ NOCACHE; --roomNum 번호 증가

-------------userinfo 수정 -------------
alter table userinfo
 modify userNick varchar2(70);

alter table userinfo
 modify userProfileMsg varchar2(900); --한글 300자까지 입력됨
-----------------------------------------
 
alter table chatRoom
 add constraint chatRoom_nick_fk foreign key(pubnick) references userinfo(usernick)ON DELETE CASCADE; --채팅리스트에 보여지는 닉네임이 userinfo의 닉네임을 참조하며 유저 탈퇴시 채팅리스트에서 해당 채팅룸 사라짐

alter table chatRoom
 add constraint chatRoom_nick2_fk foreign key(subnick) references userinfo(usernick) ON DELETE CASCADE; --채팅리스트에 보여지는 닉네임이 userinfo의 닉네임을 참조하며 유저 탈퇴시 채팅리스트에서 해당 채팅룸 사라짐

-----------채팅리스트에 보여지는 닉네임이 userinfo의 닉네임을 참조하며 유저 닉네임 업데이트시 채팅리스트에서 해당 닉네임 자동 업데이트------------
--트리거 두개 주석 풀고 각각 드래그해서 ctrl+enter 해 
/*create or replace TRIGGER chatRoom_nick_update 
 after UPDATE OF usernick ON userinfo FOR EACH ROW 
 BEGIN UPDATE chatroom 
 SET pubnick = :NEW.usernick 
 WHERE pubnick = :OLD.usernick;
end;*/

/*create or replace TRIGGER chatRoom_nick2_update 
 after UPDATE OF usernick ON userinfo FOR EACH ROW 
 BEGIN UPDATE chatroom 
 SET subnick = :NEW.usernick 
 WHERE subnick = :OLD.usernick;
end;*/
---------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE chatMessage(
 m_roomId     varchar2(200) not null,
 m_pubId      varchar2(50) not null,
 m_pubNick    varchar2(70) not null,
 m_subId      varchar2(50) not null,
 m_subNick    varchar2(70) not null,
 m_sendTime   varchar2(70) default null,
 m_pubImg     varchar2(300),
 m_subImg     varchar2(300),
 m_num        number(20) primary key,
 m_sendId     varchar2(50),
 m_pubMsg     varchar2(2000),
 m_subMsg     varchar2(2000) 
);
 
CREATE SEQUENCE CHAT_MSG_SEQ NOCACHE; --m_num 번호 증가

ALTER TABLE chatmessage
ADD CONSTRAINT msg_cascade_chat
  FOREIGN KEY (m_roomId)
  REFERENCES chatRoom(roomId)
  ON DELETE CASCADE; --채팅방 나가면(신버전에 나가기 기능 포함) chatmessage DB의 해당 방 메세지 내용들 다 삭제
  



------------------------------------220426 추가 부분--------------------------------
alter table chatRoom
 add pubExitNum number(20) default 1; --채팅방 나간사람이 다시 입장시 입장 이후의 메세지번호들만 불러오기 위해
 
alter table chatRoom
 add subExitNum number(20) default 1; --채팅방 나간사람이 다시 입장시 입장 이후의 메세지번호들만 불러오기 위해
 
alter table chatRoom
 add pubExit varchar2(10) default 'f'; --채팅방 나간사람은 t(true), 들어와있는 사람은 f(false)로 구분
 
alter table chatRoom
 add subExit varchar2(10) default 't'; --채팅방 나간사람은 t(true), 들어와있는 사람은 f(false)로 구분

commit;





--프로필 이미지 유저인포에서 참조 하기 위해
alter table userinfo
 add constraint user_img_uk unique(userprofileimg);
 
alter table chatRoom
 add constraint chatRoom_img_fk foreign key(pubimg) references userinfo(userprofileimg);

alter table chatRoom
 add constraint chatRoom_img2_fk foreign key(subimg) references userinfo(userprofileimg);

--트리거 주석 풀고 각각 드래그해서 ctrl+enter 해 
/*create or replace TRIGGER chatRoom_img_update 
 after UPDATE OF userprofileimg ON userinfo FOR EACH ROW 
 BEGIN UPDATE chatroom 
 SET pubimg = :NEW.userprofileimg 
 WHERE pubimg = :OLD.userprofileimg;
end;*/

/*create or replace TRIGGER chatRoom_img2_update 
 after UPDATE OF userprofileimg ON userinfo FOR EACH ROW 
 BEGIN UPDATE chatroom 
 SET subimg = :NEW.userprofileimg 
 WHERE subimg = :OLD.userprofileimg;
end;*/

/*create or replace TRIGGER chatMsg_img_update 
 after UPDATE OF pubimg ON chatroom FOR EACH ROW 
 BEGIN UPDATE chatmessage 
 SET m_pubimg = :NEW.pubimg 
 WHERE m_pubimg = :OLD.pubimg;
end;*/

/*create or replace TRIGGER chatMsg_img2_update 
 after UPDATE OF subimg ON chatroom FOR EACH ROW 
 BEGIN UPDATE chatmessage 
 SET m_subimg = :NEW.subimg 
 WHERE m_subimg = :OLD.subimg;
end;*/





-- 안읽은 메세지 갯수, 최신 메세지 채팅방 리스트에 보이게 하기위해
alter table chatRoom
 add pubUnReadMsg number(10);

alter table chatRoom
 add subUnReadMsg number(10);

alter table chatRoom
 add pubRecentMsg varchar2(2000);

alter table chatRoom
 add subRecentMsg varchar2(2000);






--관리자가 계정 비활성화할때
alter table userinfo
add userEnabled varchar2(1) default '1' not null;