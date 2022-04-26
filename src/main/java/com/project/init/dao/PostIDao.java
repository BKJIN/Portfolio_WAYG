package com.project.init.dao;

import java.util.ArrayList;

import org.springframework.ui.Model;

import com.project.init.dto.CommentsDto;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PostDtDto;
import com.project.init.dto.PostDto;
import com.project.init.dto.PostLikeDto;
import com.project.init.dto.PostViewDto;

public interface PostIDao {

	public void write(PostDto dto, ArrayList<PostDtDto> dtDtos);
	
	public ArrayList<PostDto> mylist(String email, Model model);
	
	public ArrayList<PostDto> list(String email);

	public String addView(PostViewDto dto);
	
	public ArrayList<CommentsDto> getcomments(String postNo);
	
	public void addReplyComments(CommentsDto dto);
	
	public void deleteReplyComments(String commentNo);
	
	public void addcomments(CommentsDto dto);
	
	public String addLike(PostLikeDto dto);
	
	public PostDto getlist(PostDto tmp);
	
	public void modifyExcute(PostDto dto, ArrayList<PostDtDto> insertDtDtos, ArrayList<PostDtDto> deleteDtDtos);

	public void deletePost(String postNo);
	
	public ArrayList<PostDto> likeList(String email);
	
	public ArrayList<PostDto> viewList(String email);
	
	public ArrayList<PostDtDto> getMapPost(ArrayList<PlanDtDto> dtDtos);
	
	public int countPost (String email);
	
	
	/* unset

	public ArrayList<PostDto> search(String keyword,String searchVal);

	 */
}
