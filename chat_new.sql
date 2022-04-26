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

CREATE SEQUENCE CHAT_ROOM_SEQ NOCACHE; --roomNum ��ȣ ����

-------------userinfo ���� -------------
alter table userinfo
 modify userNick varchar2(70);

alter table userinfo
 modify userProfileMsg varchar2(900); --�ѱ� 300�ڱ��� �Էµ�
-----------------------------------------
 
alter table chatRoom
 add constraint chatRoom_nick_fk foreign key(pubnick) references userinfo(usernick)ON DELETE CASCADE; --ä�ø���Ʈ�� �������� �г����� userinfo�� �г����� �����ϸ� ���� Ż��� ä�ø���Ʈ���� �ش� ä�÷� �����

alter table chatRoom
 add constraint chatRoom_nick2_fk foreign key(subnick) references userinfo(usernick) ON DELETE CASCADE; --ä�ø���Ʈ�� �������� �г����� userinfo�� �г����� �����ϸ� ���� Ż��� ä�ø���Ʈ���� �ش� ä�÷� �����

-----------ä�ø���Ʈ�� �������� �г����� userinfo�� �г����� �����ϸ� ���� �г��� ������Ʈ�� ä�ø���Ʈ���� �ش� �г��� �ڵ� ������Ʈ------------
--Ʈ���� �ΰ� �ּ� Ǯ�� ���� �巡���ؼ� ctrl+enter �� 
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
 
CREATE SEQUENCE CHAT_MSG_SEQ NOCACHE; --m_num ��ȣ ����

ALTER TABLE chatmessage
ADD CONSTRAINT msg_cascade_chat
  FOREIGN KEY (m_roomId)
  REFERENCES chatRoom(roomId)
  ON DELETE CASCADE; --ä�ù� ������(�Ź����� ������ ��� ����) chatmessage DB�� �ش� �� �޼��� ����� �� ����
  



------------------------------------220426 �߰� �κ�--------------------------------
alter table chatRoom
 add pubExitNum number(20) default 1; --ä�ù� ��������� �ٽ� ����� ���� ������ �޼�����ȣ�鸸 �ҷ����� ����
 
alter table chatRoom
 add subExitNum number(20) default 1; --ä�ù� ��������� �ٽ� ����� ���� ������ �޼�����ȣ�鸸 �ҷ����� ����
 
alter table chatRoom
 add pubExit varchar2(10) default 'f'; --ä�ù� ��������� t(true), �����ִ� ����� f(false)�� ����
 
alter table chatRoom
 add subExit varchar2(10) default 't'; --ä�ù� ��������� t(true), �����ִ� ����� f(false)�� ����

commit;





--������ �̹��� ������������ ���� �ϱ� ����
alter table userinfo
 add constraint user_img_uk unique(userprofileimg);
 
alter table chatRoom
 add constraint chatRoom_img_fk foreign key(pubimg) references userinfo(userprofileimg);

alter table chatRoom
 add constraint chatRoom_img2_fk foreign key(subimg) references userinfo(userprofileimg);

--Ʈ���� �ּ� Ǯ�� ���� �巡���ؼ� ctrl+enter �� 
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





-- ������ �޼��� ����, �ֽ� �޼��� ä�ù� ����Ʈ�� ���̰� �ϱ�����
alter table chatRoom
 add pubUnReadMsg number(10);

alter table chatRoom
 add subUnReadMsg number(10);

alter table chatRoom
 add pubRecentMsg varchar2(2000);

alter table chatRoom
 add subRecentMsg varchar2(2000);






--�����ڰ� ���� ��Ȱ��ȭ�Ҷ�
alter table userinfo
add userEnabled varchar2(1) default '1' not null;