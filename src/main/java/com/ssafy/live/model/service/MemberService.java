package com.ssafy.live.model.service;

import java.sql.SQLException;
import java.util.List;

import com.ssafy.live.model.dto.Member;
import com.ssafy.live.model.dto.Page;
import com.ssafy.live.model.dto.SearchCondition;

public interface MemberService {
    int registMember(Member emp) throws SQLException;

    Member login(String email, String password) throws SQLException;

    /**
     * 사용자의 상세 정보를 가져온다고 치자.
     * 
     * @param email
     * @return
     * @throws SQLException
     */
    Member selectDetail(String email) throws SQLException;

    Page<Member> search(SearchCondition condition) throws SQLException;

    List<Member> search() throws SQLException;

    void delete(int mno) throws SQLException;

    void update(Member member) throws SQLException;

}
