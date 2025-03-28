package com.ssafy.live.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.ssafy.live.model.dto.Address;

public class BasicAddressDao implements AddressDao {

    private static BasicAddressDao dao = new BasicAddressDao();

    public static BasicAddressDao getDao() {
        return dao;
    }

    private BasicAddressDao() {
    }

    @Override
    // TODO: 03-05. 주소 등록을 위한 DAO를 확인하세요.
    public int insert(Connection con, Address address) throws SQLException {
        String sql = "insert into address (mno, title, address, detail_address, x, y) values (?,?,?,?,?,?)";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, address.getMno());
            pstmt.setString(2, address.getTitle());
            pstmt.setString(3, address.getAddress());
            pstmt.setString(4, address.getDetailAddress());
            pstmt.setString(5, address.getX());
            pstmt.setString(6, address.getY());
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int delete(Connection con, int ano) throws SQLException {
        String sql = "delete from address where ano=?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, ano);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int deleteByMno(Connection con, int mno) throws SQLException {
        String sql = "delete from address where mno=?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, mno);
            return pstmt.executeUpdate();
        }
    }

}
