package com.ssafy.live.model.dao;

import java.sql.Connection;
import java.sql.SQLException;

import com.ssafy.live.model.dto.Address;

public interface AddressDao {
    public int insert(Connection con, Address address) throws SQLException;

    public int delete(Connection con, int ano) throws SQLException;

    public int deleteByMno(Connection con, int mno) throws SQLException;
}
