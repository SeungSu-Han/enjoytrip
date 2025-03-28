package com.ssafy.live.model.service;

import java.sql.Connection;
import java.sql.SQLException;

import com.ssafy.live.model.dao.AddressDao;
import com.ssafy.live.model.dao.BasicAddressDao;
import com.ssafy.live.model.dto.Address;
import com.ssafy.live.util.DBUtil;

public class BasicAddressService implements AddressService {

    private AddressDao dao = BasicAddressDao.getDao();
    private DBUtil util = DBUtil.getUtil();
    private static BasicAddressService service = new BasicAddressService();

    private BasicAddressService() {
    }

    public static BasicAddressService getService() {
        return service;
    }

    @Override
    // TODO: 03-04. 주소 등록을 위한 서비스를 확인하세요.
    public void registAddress(Address address) throws SQLException {
        Connection con = util.getConnection();
        try {
            con.setAutoCommit(false);
            dao.insert(con, address);
            con.commit();
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            util.close(con);
        }
    }

    @Override
    public void deleteAddress(int ano) throws SQLException {
        Connection con = util.getConnection();
        try {
            con.setAutoCommit(false);
            dao.delete(con, ano);
            con.commit();
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            util.close(con);
        }
    }

}
