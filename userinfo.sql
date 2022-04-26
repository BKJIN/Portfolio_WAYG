/* userInfo Table */
CREATE TABLE Userinfo( 
 userEmail varchar2(50) primary key,
 userPw varchar2(128) not null,
 userNick varchar2(30) not null,
 userBirth varchar2(10) not null, 
 userAge number(4) not null, 
 userGender varchar2(10) not null, 
 userPst number(10) not null, 
 userAddress1 varchar2(200) not null, 
 userProfileImg varchar2(300), 
 userProfileMsg varchar2(600), 
 userFollower number(10) default 0, 
 userFollowing number(10) default 0, 
 userAuthority varchar2(20), 
 userJoindate date default sysdate not null, 
 userVisitdate date,
 userAddress2 varchar2(200),
 userEnabled varchar2(1) default '1' not null
);

alter table userinfo add constraint user_nick_uk unique(usernick);

commit;
