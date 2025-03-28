package com.ssafy.live.model.dto;

public class Address {
    private int ano;
    private int mno;
    private String title;
    private String address;
    private String detailAddress;
    private String x;
    private String y;

    public Address() {
    }

    public Address(int ano, int mno, String title, String address, String detailAddress, String x, String y) {
        this.ano = ano;
        this.mno = mno;
        this.title = title;
        this.address = address;
        this.detailAddress = detailAddress;
        this.x = x;
        this.y = y;
    }

    public int getAno() {
        return ano;
    }

    public void setAno(int ano) {
        this.ano = ano;
    }

    public int getMno() {
        return mno;
    }

    public void setMno(int mno) {
        this.mno = mno;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDetailAddress() {
        return detailAddress;
    }

    public void setDetailAddress(String detailAddress) {
        this.detailAddress = detailAddress;
    }

    public String getX() {
        return x;
    }

    public void setX(String x) {
        this.x = x;
    }

    public String getY() {
        return y;
    }

    public void setY(String y) {
        this.y = y;
    }

    @Override
    public String toString() {
        return "Address [ano=" + ano + ", mno=" + mno + ", title=" + title + ", address=" + address + ", detailAddress=" + detailAddress + ", x=" + x + ", y=" + y + "]";
    }

}
