package com.project.init.security;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.project.init.dao.UserDao;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

public class CustomUserDetailsService implements UserDetailsService {

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {		
		UserDao udao = Constant.udao;
		UserDto dto = udao.login(username);

		if(dto == null) {
			System.out.println("null");
			
			//스프링 시큐리티에서 예외를 처리하여 로그인 실패 처리
			throw new UsernameNotFoundException("No user found with username");
			
		}
		
		if(!UserDto.isEnabled()) { //계정이 비활성화된 경우 
			throw new DisabledException("Ban User : " + username);
		}
		
		String pw = dto.getUserPw(); // 암호화된 패스워드

		//role값(권한 구분 값, ROLE_USER,ROLE_ADMIN,ROLE_MANAGE 등)을 저장하는 리스트 객체
		Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();

		roles.add(new SimpleGrantedAuthority(dto.getUserAuthority()));

		//얻은 id,pw,roles를 이용하여 UserDetails객체를 만들어 반환해줌
		UserDetails user = new User(username, pw, roles);
		
		//spring에서 pw일치 여부 체크하고 권한 설정 등의 작업 해줌
		return user; 
	}

}