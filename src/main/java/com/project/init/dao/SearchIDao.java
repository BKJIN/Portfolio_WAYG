package com.project.init.dao;

import java.util.ArrayList;

import com.project.init.dto.PostDto;
import com.project.init.dto.SearchDto;

public interface SearchIDao {

	public ArrayList<PostDto> search(SearchDto dto);

}
