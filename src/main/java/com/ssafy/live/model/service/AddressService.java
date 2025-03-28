package com.ssafy.live.model.service;

import java.sql.SQLException;

import com.ssafy.live.model.dto.Address;

public interface AddressService {
    public void registAddress(Address address) throws SQLException;

    public void deleteAddress(int ano) throws SQLException;
}
