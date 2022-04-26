package com.project.init.command;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.project.init.dao.PostIDao;
import com.project.init.dto.PostDtDto;
import com.project.init.dto.PostDto;
import com.project.init.util.Constant;

public class PostModifyDoCommand implements ICommand {

	private PostIDao postDao = Constant.postDao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		
		MultipartHttpServletRequest multi = (MultipartHttpServletRequest)request;
		
		String titleImage="";
		String tmp="";
		String images = multi.getParameter("images");
		System.out.println(images);
		
		List<MultipartFile> fileList = multi.getFiles("img");

		PostDto dto = null;
		//String path = "C:/Users/310-08/git/projectTest/project_init/src/main/webapp/resources/images/";
		//String path = "C:/Users/310-08/git/projectTest/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/images/";
		
		String path = "C:/ecl/workspace/project_init/src/main/webapp/resources/images/";
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/images/";
		
		if ( fileList.get(0).getOriginalFilename() != ""  ) {
		
			for (MultipartFile mf : fileList) {
				String originalFileName = mf.getOriginalFilename();
				UUID prefix = UUID.randomUUID();
				
				try {
					mf.transferTo(new File(path + prefix + originalFileName));
					mf.transferTo(new File(path1 + prefix + originalFileName));
					
					tmp+=prefix + originalFileName+"/";
				} catch (IllegalStateException | IOException e) {
					e.getMessage(); 
				}
			}
			
			images += tmp;
		}

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		String[] test =  images.split("/");
		titleImage = test[0];
		
		dto = new PostDto(multi.getParameter("postNo"),
								  uId,
				  				  multi.getParameter("content"),
				  				  multi.getParameter("hashtag"),
				  				  titleImage,
				  				  images);
		
		// planDt
		ArrayList<PostDtDto> insertDtDtos = new ArrayList<PostDtDto>();
		ArrayList<PostDtDto> deleteDtDtos = new ArrayList<PostDtDto>();
		
		//postDt modify
		if ( request.getParameterValues("planDtNum") != null ) {
			String[] planDtNum = request.getParameterValues("planDtNum");
			String[] placeName = request.getParameterValues("placeName");
			
			int planNum = Integer.parseInt(multi.getParameter("planNum"));

			for(int i = 0; i < planDtNum.length; i++ ) {
				PostDtDto dtDto = new PostDtDto(Integer.parseInt(multi.getParameter("postNo")),
												planNum,
												Integer.parseInt(planDtNum[i]),
												placeName[i]);
				
				insertDtDtos.add(dtDto);
			}
		}
		
		System.out.println(request.getParameter("delDtNum"));
		
		if ( request.getParameter("delDtNum").equals("false") == false ) {
			String[] delDtNum = request.getParameter("delDtNum").split("/");
			
			for(int i = 0; i < delDtNum.length; i++ ) {
				PostDtDto dtDto = new PostDtDto();
				dtDto.setPostNo(Integer.parseInt(multi.getParameter("postNo")));
				dtDto.setPlanDtNum(Integer.parseInt(delDtNum[i]));
				deleteDtDtos.add(dtDto);
			}
		}
		postDao.modifyExcute(dto, insertDtDtos, deleteDtDtos);

	}

}
