package com.sysage.validation;

import javax.validation.constraints.Max;

/**
 *
 * Created by IDEA Template
 *
 * @author wilson.jian
 * @date 2022/10/27
 * @since 1.0
 */
public class DataModel {
    @Max(5)
    private String value;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
