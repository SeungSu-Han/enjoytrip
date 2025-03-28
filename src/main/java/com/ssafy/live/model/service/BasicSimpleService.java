package com.ssafy.live.model.service;

import java.util.Map;
import java.util.TreeMap;

public class BasicSimpleService implements SimpleService {
    private static BasicSimpleService service = new BasicSimpleService();

    public static BasicSimpleService getService() {
        return service;
    }

    private BasicSimpleService() {
    }

    @Override
    public Map<String, Integer> getGugu(int dan) {
       if(dan <1 || dan >10) {
           throw new RuntimeException("1~9까지만 처리 가능: "+dan);
       }
        Map<String, Integer> map = new TreeMap<>();
        for (int i = 1; i < 10; i++) {
            map.put(dan + " * " + i + " = ", dan * i);
        }
        return map;
    }
}
